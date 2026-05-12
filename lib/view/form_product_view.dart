import 'package:flutter/material.dart';
import '../services/product_service.dart';

class FormProductView extends StatefulWidget {
  final String token;
  const FormProductView({super.key, required this.token});

  @override
  State<FormProductView> createState() => _FormProductViewState();
}

class _FormProductViewState extends State<FormProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  
  final ProductService _productService = ProductService();
  bool _isLoading = false;

  void _simpanProduk() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        bool success = await _productService.saveDraft(
          token: widget.token,
          name: _nameController.text,
          price: int.parse(_priceController.text),
          description: _descController.text,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cookies berhasil ditambahkan ke katalog!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
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
        title: const Text('TAMBAH COOKIES'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Cookies',
                  prefixIcon: Icon(Icons.bakery_dining),
                ),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  prefixIcon: Icon(Icons.payments),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harga harus berupa angka valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Rasa',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _simpanProduk,
                    child: const Text('SIMPAN KE KATALOG'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}