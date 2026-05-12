import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'form_product_view.dart';
import 'submit_task_view.dart';

class CatalogView extends StatefulWidget {
  final String token;
  const CatalogView({super.key, required this.token});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>> _futureProducts;

  final Color primaryBrown = const Color(0xFF5D4037);
  final Color lightCream = const Color(0xFFFDF5E6);
  final Color accentGold = const Color(0xFFFBC02D);

  @override
  void initState() {
    super.initState();
    _futureProducts = _productService.fetchProducts(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCream,
      appBar: AppBar(
        title: const Text(
          'MORIBITES CATALOG',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
        ),
        backgroundColor: primaryBrown,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            color: Colors.white,
            tooltip: 'Submit Tugas Akhir',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitTaskView(token: widget.token),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryBrown));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cookies found yet...'));
          }

          List<ProductModel> products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 0.75, 
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              ProductModel product = products[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Stack( 
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: accentGold.withValues(alpha: 0.2),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: const Center(
                            child: Icon(Icons.cookie, size: 50, color: Colors.brown),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  color: primaryBrown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${product.price.toInt()}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Cookies?'),
                                content: Text('Yakin ingin membuang draft "${product.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final messenger = ScaffoldMessenger.of(context);
                                      
                                      Navigator.pop(context); 
                                      
                                      try {
                                        bool success = await _productService.deleteDraft(widget.token, product.id);
                                        
                                        if (success) {                                          
                                          messenger.showSnackBar(
                                            const SnackBar(content: Text('Cookies dibuang (Soft Delete).')),
                                          );
                                          
                                          if (mounted) {
                                            setState(() {
                                              _futureProducts = _productService.fetchProducts(widget.token);
                                            });
                                          }
                                        }
                                      } catch (e) {
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    },
                                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBrown,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormProductView(token: widget.token),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                _futureProducts = _productService.fetchProducts(widget.token);
              });
            }
          });
        },
      ),
    );
  }
}