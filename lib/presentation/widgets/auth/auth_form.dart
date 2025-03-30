import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Function(String email, String password, {String? name}) onSubmit;
  final VoidCallback onToggleMode;
  final VoidCallback onGoogleSignIn;

  const AuthForm({
    Key? key,
    required this.isLogin,
    required this.onSubmit,
    required this.onToggleMode,
    required this.onGoogleSignIn,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        widget.onSubmit(_emailController.text.trim(), _passwordController.text.trim());
      } else {
        widget.onSubmit(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          name: _nameController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isLogin ? 'Welcome Back' : 'Create Account',
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.isLogin ? 'Sign in to continue' : 'Sign up to get started',
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              // color: const Color(0xFF1C1917),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (!widget.isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                    decoration: AppTheme.getInputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icons.person,
                    ),
                    validator: (value) {
                      if (!widget.isLogin && (value == null || value.isEmpty)) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                  ),
                  decoration: AppTheme.getInputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icons.mail,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                  ),
                  decoration: AppTheme.getInputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                  ),
                  obscureText: true,
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
                if (!widget.isLogin) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                    decoration: AppTheme.getInputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: AppTheme.primaryButtonStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: _isLoading,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          ),
                        ),
                        Text(widget.isLogin ? 'Sign In' : 'Sign Up')
                      ],
                    ),
                  ),
                ),
                if (widget.isLogin) ...[
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : widget.onGoogleSignIn,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1a1a1a),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/images/icons/google_logo.png',
                        height: 24,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: widget.onToggleMode,
            child: Text(
              widget.isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Sign In',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontFamily: 'Orbitron',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}
