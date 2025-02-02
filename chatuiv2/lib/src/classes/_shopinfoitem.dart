import 'package:flutter/material.dart';

class ShopInfoItem {
  final String header;
  final String description;
  final String imageUrl;
  final Color color;

  ShopInfoItem({
    required this.header, 
    required this.description,
    required this.imageUrl,
    required this.color,
  });
}