import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;
  final  _nameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  final  _confirmPasswordController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                    'NEST_',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.eco, color: Colors.black, size: 26),
                  ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'ShareNest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 18
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        body: SafeArea(
  child: ListView(
    padding: const EdgeInsets.all(20),
    children: [
     const SizedBox(height: 24),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 28,
          bottom: 28,
          left: 22,
          right:22,
          ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 0, 0, 0),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: const Text(
                'Be part of a community where sharing and growing together feels effortless',
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 126, 123, 123), height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _inputField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                    controller: _nameController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter your full name';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _inputField(
                    label: 'Password',
                    hintText: '********',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    label: 'Confirm Password',
                    hintText: '********',
                    icon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 242, 243, 245),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _acceptedTerms,
                      onChanged: (bool? value){
                        setState(() {
                          if(value == true){
                            _acceptedTerms = true;
                          } else {
                            _acceptedTerms = false;
                          }
                        });
                      },
                      title: RichText(text: TextSpan(children: [
                        const TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(fontSize: 13, color: Colors.green),
                        ),
                        const TextSpan(
                          text: ' and ',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(fontSize: 13, color: Colors.green),
                        ),
                      ],)),
                      activeColor: Colors.green,
                      contentPadding:
                          const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:(){
                        if(_formKey.currentState!= null){
                          if(_formKey.currentState!.validate()){
                            if(_acceptedTerms){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account created successfully')),
                              );
                              context.go('/home');
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please accept the terms to proceed')),
                          );
                        }
                          }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all fields correctly')),
                          );
                        }
                      }
                    },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                        backgroundColor: const Color.fromARGB(200, 2, 150, 16),
                      ),
                      child: const Text(
                        'Create Account',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Login',
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

  Widget _inputField({
    required String label,
    String? hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.bold
            ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 245, 242, 240),
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.green),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 224, 224, 224)),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
