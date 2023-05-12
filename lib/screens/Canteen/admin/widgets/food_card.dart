import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/food_item_model.dart';

class FoodItemWidget extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemWidget({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle tapping on the food item
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food item photo
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(foodItem.image!)),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Food item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹ ${foodItem.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    foodItem.availability! ? 'Available' : 'Not available',
                    style: TextStyle(
                      color: foodItem.availability! ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: foodItem.availability!
                  ? () {
                      // Handle adding to cart
                    }
                  : null,
              icon: Icon(
                Icons.shopping_cart,
                color: foodItem.availability!
                    ? Colors.green[700]
                    : Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
