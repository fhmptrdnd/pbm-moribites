import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'catalog_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool success = await _authService.login(
        _nimController.text, 
        _passController.text
      );

      setState(() => _isLoading = false);

      if (success) {
        String? token = await _authService.storage.read(key: 'token');
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CatalogView(token: token!)),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Gagal! Periksa NIM dan Password.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cookie, size: 80, color: Color(0xFF5D4037)),
                const SizedBox(height: 16),
                const Text(
                  'MORIBITES',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                    letterSpacing: 2,
                  ),
                ),
                const Text('Silakan login dengan NIM Anda'),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM (Username)',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? 'NIM wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'NIM (Password)',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) => value!.isEmpty ? 'Password wajib diisi' : null,
                ),
                const SizedBox(height: 32),
                
                _isLoading 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('MASUK KE TOKO'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}