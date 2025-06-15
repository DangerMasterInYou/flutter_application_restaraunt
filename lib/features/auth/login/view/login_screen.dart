import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '/core/repositories/auth/login/login.dart';
import '../bloc/login_bloc.dart';
import '../widgets/countdown_timer_widget.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc(GetIt.I<AbstractLoginRepository>());
  final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // bool _obscurePassword = true;
  
  final _emailFocusNode = FocusNode();
  // final _passwordFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    // _passwordFocusNode.addListener(_onFocusChange);
    _codeFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _loginBloc.close();
    _emailController.dispose();
    // _passwordController.dispose();
    _codeController.dispose();
    _emailFocusNode.dispose();
    // _passwordFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _loginBloc.add(SendVerificationCodeEvent(
        email: _emailController.text,
      ));
    }
  }

  void _handleVerifyCode() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final currentState = _loginBloc.state;
      String emailForVerification = _emailController.text;
      if (currentState is VerificationCodeSentSuccess) {
        emailForVerification = currentState.email;
      } else if (currentState is LoginFailure) {
        emailForVerification = currentState.email;
      }

      _loginBloc.add(VerifyCodeEvent(
        email: emailForVerification, 
        code: _codeController.text,
      ));
    }
  }

  void _handleChangeEmail() {
    _codeController.clear();
    _loginBloc.add(ChangeEmailEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: BlocConsumer<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.router.replaceNamed('/menu');
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ошибка: ${state.exception}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              if (state.email.isNotEmpty) {
                  _emailController.text = state.email;
              }
            } else if (state is VerificationCodeSentFailure) {
                 ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ошибка отправки кода: ${state.exception}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            bool showVerifyCodeWidget = state is VerificationCodeSentSuccess || 
                                      (state is LoginFailure && _codeController.text.isNotEmpty) ||
                                      (state is LoginLoading && _loginBloc.state is VerificationCodeSentSuccess); // Показываем виджет кода и при загрузке после отправки кода
            
            // Если код успешно отправлен, email берем из состояния
            if (state is VerificationCodeSentSuccess && _emailController.text != state.email) {
                _emailController.text = state.email;
            }

            return Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: isWideScreen ? 400 : screenSize.width * 0.9,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: SvgPicture.asset(
                          'assets/svg/logo.svg',
                          fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          showVerifyCodeWidget ? 'Введите код' : 'Авторизация',
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          showVerifyCodeWidget ? 'Код отправлен на ваш email' : 'Введите email для получения кода',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        if (state is LoginFailure && state.attemptsLeft < 5 && state.attemptsLeft > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Осталось попыток: ${state.attemptsLeft}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (state is LoginBlocked)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CountdownTimerWidget(
                              blockUntil: state.blockUntil,
                              onTimerEnd: () {
                                String emailForEvent = _emailController.text;
                                if (state is LoginBlocked) {
                                  _loginBloc.add(TimerEndedEvent());
                                }
                                
                              },
                            ),
                          ),
                        const SizedBox(height: 32),
                         if (state is LoginBlocked)
                          TextButton(
                            onPressed: _handleChangeEmail,
                            child: Text(
                              'Изменить Email',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontSize: 16),
                            ),
                          ),
                        if (!showVerifyCodeWidget && state is! LoginBlocked)
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: theme.textTheme.bodyMedium,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleSendCode(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите email';
                              }
                              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                                return 'Пожалуйста, введите корректный email';
                              }
                              return null;
                            },
                          ),
                        if (!showVerifyCodeWidget) const SizedBox(height: 24),

                        if (showVerifyCodeWidget) ...[
                          TextFormField(
                            controller: _codeController,
                            focusNode: _codeFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Код из Email',
                              prefixIcon: const Icon(Icons.shopify_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 6,
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleVerifyCode(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите код';
                              }
                              if (value.length != 6) {
                                return 'Код должен состоять из 6 цифр';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: (state is LoginLoading || state is LoginBlocked) ? null : _handleVerifyCode,
                            child: state is LoginLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Вход'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: (state is LoginLoading || state is LoginBlocked) ? null : _handleChangeEmail,
                            child: Text(
                              'Изменить Email',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                            ),
                          ),
                        ],

                        if (!showVerifyCodeWidget)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: (state is LoginLoading || state is LoginBlocked) ? null : _handleSendCode,
                            child: state is LoginLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Отправить код'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}