import 'package:flutter/material.dart';
import 'model/product.dart';
import 'product_grid.dart';

class HomePage extends StatelessWidget {
  final Category category;

  const HomePage({this.category = Category.all, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGrid(category: category),
    );
  }
}
