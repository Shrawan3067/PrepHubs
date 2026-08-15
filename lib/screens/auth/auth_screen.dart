import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../navigation/main_navigation_wrapper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate auth API

    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.signInWithEmail(
        _emailController.text.trim(),
        _nameController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
        );
      }
    }
  }

  void _continueAsGuest() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.signOut(); // Ensure guest profile is loaded
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Create Account' : 'Sign In'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isSignUp
                      ? 'Join 50,000+ Students'
                      : 'Welcome Back, Scholar',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignUp
                      ? 'Prepare for TCS, Infosys, Wipro & top IT placement exams'
                      : 'Sign in to sync progress, streaks and bookmarked questions',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (_isSignUp) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'College Email ID',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) =>
                      val == null || !val.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                  validator: (val) =>
                      val == null || val.length < 6 ? 'Password must be 6+ chars' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(_isSignUp ? 'Create Free Account' : 'Sign In'),
                ),
                const SizedBox(height: 16),

                // Social Auth Mock
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  label: const Text('Continue with Google'),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isSignUp
                        ? 'Already have an account?'
                        : "Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        setState(() => _isSignUp = !_isSignUp);
                      },
                      child: Text(_isSignUp ? 'Sign In' : 'Sign Up'),
                    ),
                  ],
                ),

                const Divider(height: 32),

                Center(
                  child: TextButton.icon(
                    onPressed: _continueAsGuest,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('Continue as Guest (Practise Limited Questions)'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
