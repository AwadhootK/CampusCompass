import 'dart:convert';

import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/Canteen/admin/logic/cart_cubit.dart';
import 'package:firebase/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  FoodItem foodItem;
  final Function removeItem;
  CartItem({super.key, required this.foodItem, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150, maxWidth: 100),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(base64Decode(foodItem.image!)),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 8,
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name ?? '',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '₹ ${foodItem.price ?? 0}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      InkWell(
                        child: const Icon(Icons.remove_circle),
                        onTap: () {
                          // TODO: Decrease quantity
                        },
                      ),
                      // const SizedBox(width: 8.0),
                      // const Text(
                      //   '${3}',
                      //   style: TextStyle(fontSize: 16.0),
                      // ),
                      const SizedBox(width: 8.0),
                      InkWell(
                        child: const Icon(Icons.add_circle),
                        onTap: () {
                          // TODO: Increase quantity
                        },
                      ),
                      const SizedBox(width: 16.0),
                      InkWell(
                        child: const Icon(Icons.delete),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: const Text('Remove item?'),
                                    content: const Text(
                                        'Are you sure you want to remove this item from cart?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final nv = Navigator.of(context);
                                          final sc =
                                              ScaffoldMessenger.of(context);
                                          removeItem(
                                              foodItem.name!, User.m!['UID']);
                                          sc.showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.blue,
                                              content: Text(
                                                  'Item removed from cart'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          nv.pop();
                                          nv.pop();
                                        },
                                        child: const Text('Remove'),
                                      ),
                                    ]);
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
