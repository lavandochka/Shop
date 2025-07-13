import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    product.image,
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_border, size: 28),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text('Size XL'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text('Colour'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  product.details ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Reviews Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: GestureDetector(
                  onTap: () {},
                  child: Text('Write your', style: TextStyle(color: Colors.green, fontSize: 16)),
                ),
              ),
              // Sample reviews
              _ReviewTile(
                avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                name: 'Samuel Smith',
                rating: 5,
                review: 'Wonderful jean, perfect gift for my girl for our anniversary!',
              ),
              _ReviewTile(
                avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
                name: 'Beth Aida',
                rating: 4,
                review: 'The shoes were very comfortable and fit just right.',
              ),
              _ReviewTile(
                avatarUrl: 'https://randomuser.me/api/portraits/men/65.jpg',
                name: 'Jeremy Winston',
                rating: 5,
                review: 'The Leather is Buttery Soft - High Quality and the Insole is very soft as well. Very Comfortable shoes!',
              ),
              SizedBox(height: 80), // Add space for the bottom bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PRICE', style: TextStyle(color: Colors.grey)),
                Text(' 4${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(120, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text('ADD', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int rating;
  final String review;

  const _ReviewTile({
    required this.avatarUrl,
    required this.name,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        Icons.star,
                        color: i < rating ? Colors.amber : Colors.grey[300],
                        size: 20,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(review, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 