import 'package:flutter/material.dart';
import '../services/product_service.dart';

class SubmitTaskView extends StatefulWidget {
  final String token;
  const SubmitTaskView({super.key, required this.token});

  @override
  State<SubmitTaskView> createState() => _SubmitTaskViewState();
}

class _SubmitTaskViewState extends State<SubmitTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController(); 
  
  final ProductService _productService = ProductService();
  bool _isLoading = false;

  void _prosesSubmitFinal() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        bool success = await _productService.submitTask(
          token: widget.token,
          name: _nameController.text,
          price: int.parse(_priceController.text),
          description: _descController.text,
          githubUrl: _githubController.text,
        );

        if (success && mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Berhasil!'),
              content: const Text('Tugas Moribites kamu sudah tercatat di sistem asisten.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        title: const Text(
          'SUBMIT FINAL',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5D4037),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) => value!.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _githubController,
                decoration: const InputDecoration(
                  labelText: 'Link Repository GitHub',
                  hintText: 'https://github.com/...',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Link GitHub wajib diisi';
                  if (!value.contains('github.com')) return 'Link harus valid dari GitHub';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                    onPressed: _prosesSubmitFinal,
                    child: const Text('SUBMIT'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}