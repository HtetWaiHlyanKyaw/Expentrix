import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  const Category(this.name, this.icon);
}

final List<Category> categories = [
  Category('Food & Groceries', Icons.restaurant),
  Category('Housing', Icons.home_outlined),
  Category('transportation', Icons.directions_car_filled_outlined),
  Category('Health & Medical', Icons.local_hospital_outlined),
  Category('Personal & Lifestyle', Icons.person_outline),
  Category('Education', Icons.school_outlined),
  Category('Entertainment', Icons.movie_creation_outlined),
  Category('Savings & Investment', Icons.savings_outlined),
  Category('Other', Icons.more_horiz),
  //
  //
  // Category('bill', Icons.receipt_long_outlined),
  // Category('entertainment', Icons.tv),
  // Category('shopping', Icons.shopping_basket_outlined),
  // Category('other', Icons.more_horiz),
];
