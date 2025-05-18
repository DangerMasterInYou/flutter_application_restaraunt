import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/repositories/auth/login/login.dart';
import '../bloc/login_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc(GetIt.I<AbstractLoginRepository>());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {

    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      
      _loginBloc.add(SubmitLogin(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: BlocConsumer<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state is LoginLoaded) {
              // Navigate to menu screen
              
              context.router.replaceNamed('/menu');
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => TalkerScreen(talker: TalkerFlutter.init()),
              //   )
              // );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Login failed: ${state.exception}',
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
            return Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
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
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          'Welcome Back',
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
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
                          obscureText: _obscurePassword,
                          style: theme.textTheme.bodyMedium,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _handleLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        if (state is LoginFailure)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Error: ${state.exception}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TalkerScreen(talker: TalkerFlutter.init()),
                                )
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        ElevatedButton(
                          onPressed: state is LoginLoading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is LoginLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                        const SizedBox(height: 24),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: theme.textTheme.labelSmall,
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child: Text(
                                'Sign Up',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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