import 'package:flutter/material.dart';

Map<String, GlobalKey> keys = {
  'contact': GlobalKey(),
  'faq': GlobalKey(),
};

void scrollToSection(String section) {
    final targetKey = keys[section];
    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
