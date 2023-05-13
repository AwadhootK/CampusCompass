import 'dart:convert';

import 'package:firebase/screens/Canteen/admin/add_update_form.dart';
import 'package:firebase/screens/Canteen/admin/logic/admin_cubit.dart';
import 'package:firebase/screens/Canteen/admin/logic/daily_item_cubit.dart';
import 'package:firebase/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:firebase/screens/Canteen/admin/widgets/admin_food_card.dart';
import 'package:firebase/screens/Canteen/admin/widgets/meal_image_picker.dart';
import 'package:firebase/screens/Canteen/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AdminAuthCubit>(context).logout();
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              child: const TabBar(
                indicatorColor: Colors.black,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: 'Edit Daily Menu'),
                  Tab(text: 'Edit Meals'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () => Future.delayed(
                          const Duration(seconds: 1),
                          () => BlocProvider.of<FoodItemCubit>(context)
                              .fetchFoodItems(),
                        ),
                        child: BlocConsumer<FoodItemCubit, FoodItemState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is FoodItemLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FoodItemsFetchedState) {
                              return ListView.builder(
                                itemCount: state.items.length,
                                itemBuilder: (context, index) => ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 350,
                                  ),
                                  child: ExpandableFoodCard(
                                    foodItem: state.items[index],
                                  ),
                                ),
                              );
                            } else if (state is FoodItemErrorState) {
                              return Center(
                                child: Text(state.error),
                              );
                            } else {
                              return const Center(
                                child: Text('Something went wrong'),
                              );
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: const Alignment(
                            0.9, 0.95), // aligns the button to bottom right
                        child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => FoodItemCubit(),
                                  child: FoodItemForm(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  RefreshIndicator(
                    onRefresh: () => Future.delayed(
                      const Duration(seconds: 1),
                      () => BlocProvider.of<DailyItemCubit>(context)
                          .getDailyMenu(),
                    ),
                    child: BlocConsumer<DailyItemCubit, DailyItemState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is DailyItemErrorState) {
                          return Center(
                            child: Text(state.error),
                          );
                        } else if (state is DailyMenuLoadedState) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.memory(
                                  base64Decode(state.img),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageInput(),
                                    ),
                                  );
                                },
                                child: const Text('Upload New Menu'),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
