import 'dart:convert';
import 'dart:developer';
import 'package:CampusCompass/helpers/global_data.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/cart_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/daily_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/widgets/food_card.dart';
import 'package:CampusCompass/screens/Canteen/cart_page.dart';
import 'package:flutter/material.dart';
import './admin/logic/food_item_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanteenMenu extends StatelessWidget {
  const CanteenMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // specify the number of tabs
      child: Column(
        children: [
          Container(
            color: Colors.purple[300],
            child: const TabBar(
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Daily Menu',
                ),
                Tab(
                  text: 'Meals',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                BlocConsumer<FoodItemCubit, FoodItemState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is FoodItemLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is FoodItemsFetchedState) {
                      return Stack(
                        children: [
                          ListView.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, index) => BlocProvider(
                              create: (context) => CartCubit(),
                              child: FoodItemWidget(
                                foodItem: state.items[index],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: FloatingActionButton(
                              backgroundColor: Colors.purple[300],
                              onPressed: () {
                                log('Cart button pressed');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<CartCubit>(
                                      create: (context) => CartCubit()
                                        ..getCartItems(
                                          User.m!['UID'],
                                          state.items,
                                        ),
                                      child: CartPage(),
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.shopping_cart),
                            ),
                          ),
                        ],
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
                RefreshIndicator(
                  onRefresh: () => Future.delayed(
                    const Duration(seconds: 1),
                    () =>
                        BlocProvider.of<DailyItemCubit>(context).getDailyMenu(),
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
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Weekly Meals Menu'),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.memory(
                                base64Decode(state.img),
                                fit: BoxFit.cover,
                              ),
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
    );
  }
}
