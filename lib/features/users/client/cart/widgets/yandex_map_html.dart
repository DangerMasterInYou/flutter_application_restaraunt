import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/widgets.dart';

class YandexMapWidget extends StatefulWidget {
  final TextEditingController streetController;
  final TextEditingController houseController;
  final TextEditingController apartmentController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController commentController;
  final GlobalKey<FormState> formKey;
  final Function() onAddressValidated;

  const YandexMapWidget({
    Key? key,
    required this.streetController,
    required this.houseController,
    required this.apartmentController,
    required this.entranceController,
    required this.floorController,
    required this.commentController,
    required this.formKey,
    required this.onAddressValidated,
  }) : super(key: key);

  @override
  State<YandexMapWidget> createState() => _YandexMapWidgetState();
}

class _YandexMapWidgetState extends State<YandexMapWidget> {
  double? _latitude;
  double? _longitude;
  String _fullAddress = '';
  bool _addressValidated = false;
  bool _isMapInputActive = true;
  
  final _apiKey = dotenv.env['API_YANDEX_HTML_KEY'];
  final String _defaultCity = 'Ханты-Мансийск';
  final double _defaultLat = 61.0042;
  final double _defaultLng = 69.0019;
  
  final String _mapElementId = 'yandex-map';
  bool _mapInitialized = false;
  
  List<String> _suggestedAddresses = [];
  bool _isLoadingSuggestions = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerYandexMapElement();
    });
    
    widget.streetController.addListener(_onStreetChanged);
  }
  
  void _onStreetChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (widget.streetController.text.length > 2) {
        _getSuggestions(widget.streetController.text);
      } else {
        setState(() {
          _suggestedAddresses = [];
        });
      }
    });
  }

  @override
  void dispose() {
    widget.streetController.removeListener(_onStreetChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }
  
  void _registerYandexMapElement() {
    if (kIsWeb) {
      platformViewRegistry.registerViewFactory(_mapElementId, (int viewId) {
        final mapElement = html.DivElement()
          ..id = _mapElementId
          ..style.width = '100%'
          ..style.height = '300px'
          ..style.border = '1px solid #ccc'
          ..style.borderRadius = '4px';
        
        _initYandexMap(mapElement);
        
        return mapElement;
      });
      
      setState(() {
        _mapInitialized = true;
      });
    }
  }
  
  void _initYandexMap(html.Element mapElement) {
    try {
      if (html.document.querySelector('script[src*="api-maps.yandex.ru"]') == null) {
        final script = html.ScriptElement()
          ..src = 'https://api-maps.yandex.ru/2.1/?apikey=$_apiKey&lang=ru_RU';
        html.document.head!.append(script);
        
        script.onLoad.listen((_) {
          _createMap();
        });
        
        script.onError.listen((event) {
          print('Ошибка загрузки API Яндекс.Карт: $event');
          setState(() {
            _mapInitialized = false;
          });
        });
      } else {
        _createMap();
      }
    } catch (e) {
      print('Ошибка при инициализации карты: $e');
      setState(() {
        _mapInitialized = false;
      });
    }
  }
  
  void _createMap() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      final jsCode = '''
        try {
          ymaps.ready(function() {
            if (document.getElementById('$_mapElementId')) {
              window.myMap = new ymaps.Map('$_mapElementId', {
                center: [$_defaultLat, $_defaultLng],
                zoom: 12,
                controls: ['zoomControl', 'searchControl', 'typeSelector']
              });
              
              var searchControl = myMap.controls.get('searchControl');
              searchControl.options.set('provider', 'yandex#search');
              searchControl.options.set('size', 'large');
              
              window.myPlacemark = new ymaps.Placemark([$_defaultLat, $_defaultLng], {
                iconCaption: 'Перетащите метку для выбора адреса'
              }, {
                draggable: true
              });
              
              myMap.geoObjects.add(window.myPlacemark);
              
              window.myPlacemark.events.add('dragend', function() {
                var coords = window.myPlacemark.geometry.getCoordinates();
                window.flutter_inappwebview.callHandler('mapClick', coords[0], coords[1]);
              });
              
              myMap.events.add('click', function(e) {
                var coords = e.get('coords');
                window.myPlacemark.geometry.setCoordinates(coords);
                window.flutter_inappwebview.callHandler('mapClick', coords[0], coords[1]);
              });
            } else {
              console.error('Map element not found: $_mapElementId');
            }
          });
        } catch(e) {
          console.error('Error initializing map:', e);
        }
      ''';
      
      js.context.callMethod('eval', [jsCode]);
      
      _setupJsCallbacks();
    });
  }
  
  void _setupJsCallbacks() {
    html.window.addEventListener('message', (event) {
      if (event is html.MessageEvent) {
        final message = event.data;
        if (message is Map) {
          try {
            if (message['type'] == 'mapClick') {
              final lat = message['lat'];
              final lng = message['lng'];
              if (lat != null && lng != null) {
                final double latDouble = lat is double ? lat : double.parse(lat.toString());
                final double lngDouble = lng is double ? lng : double.parse(lng.toString());
                _updateCoordinates(latDouble, lngDouble);
              }
            }
          } catch (e) {
            print('Error processing message from JavaScript: $e');
          }
        }
      }
    });
    
    final jsCallbackCode = '''
      if (!window.flutter_inappwebview) {
        window.flutter_inappwebview = {};
      }
      
      window.flutter_inappwebview.callHandler = function(name, lat, lng) {
        if (name === 'mapClick') {
          window.postMessage({
            'type': 'mapClick',
            'lat': lat,
            'lng': lng
          }, '*');
        }
      };
    ''';
    
    js.context.callMethod('eval', [jsCallbackCode]);
  }
  
  Future<void> _updateCoordinates(double lat, double lng) async {
    if (!mounted) return;
    
    setState(() {
      _latitude = lat;
      _longitude = lng;
    });
    
    await _reverseGeocode(lat, lng);
    
    _animateMapToAddress(lat, lng);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Адрес выбран: $_fullAddress'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (_addressValidated && mounted) {
      widget.onAddressValidated();
    }
  }
  
  void _animateMapToAddress(double lat, double lng) {
    final jsAnimationCode = '''
      try {
        if (window.myMap && window.myPlacemark) {
          window.myPlacemark.geometry.setCoordinates([$lat, $lng]);
          
          window.myMap.panTo([$lat, $lng], {
            flying: true,
            duration: 500
          }).then(function() {
            window.myMap.setZoom(17, {
              duration: 300
            });
          });
          
          window.myPlacemark.options.set('iconColor', '#ff0000');
          setTimeout(function() {
            window.myPlacemark.options.set('iconColor', '#1e98ff');
          }, 500);
        } else {
          console.error('Map or placemark not initialized');
        }
      } catch(e) {
        console.error('Error animating map:', e);
      }
    ''';
    
    js.context.callMethod('eval', [jsAnimationCode]);
  }
  
  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final response = await http.get(Uri.parse(
        'https://geocode-maps.yandex.ru/1.x/?apikey=$_apiKey&format=json&geocode=$lng,$lat&results=1'
      ));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final geoObject = data['response']['GeoObjectCollection']['featureMember'][0]['GeoObject'];
        
        final address = geoObject['metaDataProperty']['GeocoderMetaData']['text'];
        final addressDetails = geoObject['metaDataProperty']['GeocoderMetaData']['Address']['Components'];
        
        String street = '';
        String house = '';
        
        for (var component in addressDetails) {
          if (component['kind'] == 'street') {
            street = component['name'];
          } else if (component['kind'] == 'house') {
            house = component['name'];
          }
        }
        
        setState(() {
          _fullAddress = address;
          _addressValidated = true;
          
          if (street.isNotEmpty) {
            widget.streetController.text = street;
          }
          if (house.isNotEmpty) {
            widget.houseController.text = house;
          }
        });
      }
    } catch (e) {
      print('Error during reverse geocoding: $e');
    }
  }
  
  Future<void> _geocodeAddress() async {
    if (!mounted) return;
    
    final street = widget.streetController.text;
    final house = widget.houseController.text;
    
    if (street.isEmpty || house.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите улицу и номер дома')),
        );
      }
      return;
    }
    
    try {
      final address = '$_defaultCity, $street, $house';
      final response = await http.get(Uri.parse(
        'https://geocode-maps.yandex.ru/1.x/?apikey=$_apiKey&format=json&geocode=${Uri.encodeComponent(address)}&results=1'
      ));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['response']['GeoObjectCollection']['featureMember'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Адрес не найден')),
          );
          return;
        }
        
        final geoObject = data['response']['GeoObjectCollection']['featureMember'][0]['GeoObject'];
        final coordinates = geoObject['Point']['pos'].split(' ');
        
        final double lng = double.parse(coordinates[0]);
        final double lat = double.parse(coordinates[1]);
        final fullAddress = geoObject['metaDataProperty']['GeocoderMetaData']['text'];
        
        setState(() {
          _latitude = lat;
          _longitude = lng;
          _fullAddress = fullAddress;
          _addressValidated = true;
        });
        
        Future.delayed(Duration(milliseconds: 100), () {
          _animateMapToAddress(lat, lng);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Адрес найден: $fullAddress'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        if (mounted) {
          widget.onAddressValidated();
        }
      }
    } catch (e) {
      print('Error during geocoding: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка геокодирования: $e')),
        );
      }
    }
  }
  
  Future<void> _getSuggestions(String query) async {
    if (!mounted) return;
    
    if (query.length < 3) {
      setState(() {
        _suggestedAddresses = [];
      });
      return;
    }
    
    setState(() {
      _isLoadingSuggestions = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse(
          'https://suggest-maps.yandex.ru/v1/suggest?apikey=$_apiKey&text=${Uri.encodeComponent(query)}&lang=ru_RU&results=5&types=street,house&ll=$_defaultLng,$_defaultLat'
        ),
        headers: {'Accept': 'application/json'}
      ).timeout(Duration(seconds: 5));
      
      if (!mounted) return;
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final suggestions = data['results']
              .map<String>((item) => item['title'] as String)
              .toList();
          
          setState(() {
            _suggestedAddresses = suggestions;
            _isLoadingSuggestions = false;
          });
        } else {
          setState(() {
            _suggestedAddresses = [];
            _isLoadingSuggestions = false;
          });
        }
      } else {
        print('Ошибка API: ${response.statusCode} ${response.body}');
        setState(() {
          _isLoadingSuggestions = false;
          _suggestedAddresses = [];
        });
      }
    } catch (e) {
      print('Error getting suggestions: $e');
      if (mounted) {
        setState(() {
          _isLoadingSuggestions = false;
          _suggestedAddresses = [];
        });
      }
    }
  }
  
  void _selectSuggestion(String suggestion) {
    final parts = suggestion.split(', ');
    if (parts.length > 1) {
      widget.streetController.text = parts[0];
      widget.houseController.text = parts.length > 1 ? parts[1] : '';
    } else {
      widget.streetController.text = suggestion;
    }
    
    setState(() {
      _suggestedAddresses = [];
    });
    
    _geocodeAddress();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите адрес доставки',
          style: theme.textTheme.titleMedium,
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('На карте'),
                    icon: Icon(Icons.map),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Вручную'),
                    icon: Icon(Icons.edit_location_alt),
                  ),
                ],
                selected: {_isMapInputActive},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isMapInputActive = newSelection.first;
                  });
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_mapInitialized && _isMapInputActive)
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: HtmlElementView(viewType: _mapElementId),
          )
        else if (_isMapInputActive)
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: CircularProgressIndicator()),
          ),
        
        if (_isMapInputActive)
          const SizedBox(height: 16),
        
        if (_isMapInputActive)
          Text(
            'Выберите адрес на карте или введите вручную',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: widget.streetController,
                    style: theme.textTheme.labelSmall,
                    decoration: InputDecoration(
                      labelText: 'Улица',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                      suffixIcon: _isLoadingSuggestions 
                          ? SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(strokeWidth: 2)
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите улицу';
                      }
                      return null;
                    },
                  ),
                  
                  if (_suggestedAddresses.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      constraints: BoxConstraints(maxHeight: 200),
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestedAddresses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: Text(
                              _suggestedAddresses[index],
                              style: theme.textTheme.labelSmall,
                            ),
                            onTap: () => _selectSuggestion(_suggestedAddresses[index]),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: widget.houseController,
                decoration: const InputDecoration(
                  labelText: 'Дом',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                style: theme.textTheme.labelSmall,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите номер дома';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            if (!_isMapInputActive)
              ElevatedButton(
                onPressed: _geocodeAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Icon(Icons.search),
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_addressValidated)
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Адрес подтвержден',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(_fullAddress),
                  if (_latitude != null && _longitude != null)
                    Text(
                      'Координаты: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}