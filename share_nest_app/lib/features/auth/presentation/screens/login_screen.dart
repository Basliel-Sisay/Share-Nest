import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../presentation/controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required String label,
    String? hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.green),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color.fromARGB(255, 245, 245, 245),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 224, 224, 224)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 224, 224, 224)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isLoading && next.error == null && next.isAuthenticated) {
        _dismissKeyboard();
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(134, 244, 241, 245),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'NEST_ ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.eco, color: Colors.black, size: 26),
              ],
            ),
            const Text(
              'ShareNest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 24,
            left: 20,
            right: 20,
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 26,
                top: 28,
                right: 26,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    'Connect with your community and share resources today.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 117, 117, 117),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _inputField(
                          label: 'Email Address',
                          hintText: 'Enter your email address',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        Builder(
                          builder: (context) {
                            late IconData visiblityIcon;
                            if (_obscurePassword) {
                              visiblityIcon = Icons.visibility_off;
                            } else {
                              visiblityIcon = Icons.visibility;
                            }
                            return _inputField(
                              label: 'Password',
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              suffix: IconButton(
                                icon: Icon(visiblityIcon, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        if (authState.error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            authState.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 13),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 247, 243),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: CheckboxListTile(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _rememberMe = value;
                                } else {
                                  _rememberMe = false;
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.green,
                            title: const Text(
                              'Remember me on this device',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                authState.isLoading ? null : _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/signup');
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
