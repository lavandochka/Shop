import 'package:flutter/material.dart';
import '../models/category.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryCarousel extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int> onCategoryTap;

  const CategoryCarousel({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final isSelected = categories[i].id == selectedCategoryId;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => onCategoryTap(categories[i].id),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[100] : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
                      border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: categories[i].iconUrl,
                        width: 36,
                        height: 36,
                        placeholder: (_, __) => CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (_, __, ___) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    categories[i].name,
                    style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}