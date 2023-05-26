import 'dart:convert';

import 'package:CampusCompass/screens/Canteen/admin/add_update_form.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpandableFoodCard extends StatefulWidget {
  final FoodItem foodItem;

  ExpandableFoodCard({
    required this.foodItem,
  });

  @override
  _ExpandableFoodCardState createState() => _ExpandableFoodCardState();
}

class _ExpandableFoodCardState extends State<ExpandableFoodCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.memory(
                base64Decode(
                  widget.foodItem.image!,
                ),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodItem.name!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Price: ₹ ${widget.foodItem.price!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.foodItem.availability!
                        ? 'Available'
                        : 'Not Available',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: widget.foodItem.availability!
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Handle editing the food item
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider<FoodItemCubit>(
                              create: (context) => FoodItemCubit(),
                              child: FoodItemForm(
                                item: widget.foodItem,
                                isEditing: true,
                              ),
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(widget.foodItem.availability!
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline),
                        onPressed: () {
                          // Handle removing the food item -> make it unavailable
                          BlocProvider.of<FoodItemCubit>(context)
                              .updateFoodItemAvailability({
                            'name': widget.foodItem.name,
                            'price': widget.foodItem.price,
                            'image': widget.foodItem.image,
                            'availability':
                                widget.foodItem.availability ?? false
                                    ? false
                                    : true,
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Handle deleting the food item -> delete it from database
                          BlocProvider.of<FoodItemCubit>(context)
                              .deleteFoodItem(widget.foodItem.name!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
