import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/category_carousel.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar.dart' as custom;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Product> products = [];
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
    print('Fetched categories: $categories');
    products = await ApiService.getBestSoldProducts(1, 10, categoryId: selectedCategoryId);
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
            Expanded(
              child: ProductGrid(
                products: products,
                scrollController: _scrollController,
                loading: isLoadingMore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}