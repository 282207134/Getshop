import 'package:flutter/material.dart';

class Product {
  const Product(
    this.id,
    this.name,
    this.price,
    this.colour,
    this.swatch, {
    this.sales = 0,
  });
  final String id;
  final String name;
  final int price;
  final String colour;
  final Color swatch;
  final int sales;
  String get title => '$name Women';
}

const products = [
  Product('green', 'Green Bag', 20, 'Green', Color(0xFFD4DFC6), sales: 80),
  Product('red', 'Red Bag', 20, 'Red', Color(0xFFFF7177), sales: 120),
  Product('yellow', 'Yellow Bag', 15, 'Yellow', Color(0xFFFFD87A), sales: 65),
  Product('black', 'Black Bag', 18, 'Black', Color(0xFF3B3A49), sales: 100),
  Product('olive', 'Green Bag', 12, 'Green', Color(0xFFA9BFA6), sales: 32),
  Product('rose', 'Red Bag', 10, 'Pink', Color(0xFFFFB0CA), sales: 45),
];
