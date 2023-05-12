import 'package:firebase/screens/Canteen/admin/widgets/food_card.dart';
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
            color: Colors.blue,
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
                      return ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) => FoodItemWidget(
                          foodItem: state.items[index],
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
                Container(
                  child: Center(
                    child: Text('Tab 2 content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
