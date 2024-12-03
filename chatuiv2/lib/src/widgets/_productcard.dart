import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            
            color: Colors.transparent,
            child: Stack(
              children: [
                ClipRRect(
                  // This will handle the border radius for the image
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    //color: Colors.grey[200],
                    child: Image.network(
                      'https://tse1.mm.bing.net/th?id=OIP.UqqTa19Z7fiHZa_-uLllVwHaE8&pid=Api',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // Handle minus
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Options",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    // Handle plus
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
