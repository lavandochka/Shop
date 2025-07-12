import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/category_carousel.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar.dart' as custom;
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Product> products = [];
  List<Product> bestSellingProducts = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  int? selectedCategoryId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        fetchMoreProducts();
      }
    });
  }

  Future<void> fetchInitialData() async {
    categories = await ApiService.getCategories();
    // Fetch best selling products for the carousel
    final res = await http.get(
      Uri.parse('https://mobile-shop-api.hiring.dev.devebs.net/products?page=1&page_size=10'),
      headers: {
        'accept': 'application/json',
        'X-CSRFToken': 'vUy4edACb7XvfHuVWesTq65E12AOrru3RyrAfyVIPP8BMUbb5uCAjBvCMUg5XqLt',
      },
    );
    final data = jsonDecode(res.body);
    final List results = data['results'];
    bestSellingProducts = results.map((json) => Product.fromJson(json)).toList();
    print('Fetched categories: $categories');
    products = await ApiService.getBestSoldProducts(1, 10);
    setState(() {});
  }

  Future<void> fetchMoreProducts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);
    final nextProducts = await ApiService.getBestSoldProducts(currentPage + 1, 10, categoryId: selectedCategoryId);
    setState(() {
      currentPage++;
      products.addAll(nextProducts);
      isLoadingMore = false;
    });
  }

  void onCategoryTap(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      products.clear();
      currentPage = 1;
    });
    fetchProductsForCategory();
  }

  Future<void> fetchProductsForCategory() async {
    products = await ApiService.getBestSoldProducts(1, 10, categoryId: selectedCategoryId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No categories found')),
      );
    }
    if (bestSellingProducts.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No best selling products found')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            custom.SearchBar(),
            CategoryCarousel(
              categories: categories,
              selectedCategoryId: selectedCategoryId,
              onCategoryTap: onCategoryTap,
            ),
            // Best Selling Section
            if (bestSellingProducts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Best Selling', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: Text('See all', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bestSellingProducts.length,
                  itemBuilder: (context, index) {
                    final product = bestSellingProducts[index];
                    return Container(
                      width: 180,
                      margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  product.image,
                                  height: 140,
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.star_border, size: 24),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Text(
                              product.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              product.subtitle ?? '',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Text(
                              ' 24${product.price.toStringAsFixed(0)}',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            // More to Explore Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('More to Explore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ProductGrid(
                products: products.take(6).toList(),
                scrollController: _scrollController,
                loading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}