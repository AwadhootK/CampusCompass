import 'package:firebase/screens/Canteen/admin/logic/cart_cubit.dart';
import 'package:firebase/screens/Canteen/admin/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is CartLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartLoaded) {
                return Column(
                  children: [
                    Container(
                      height: 600,
                      child: state.items.isEmpty
                          ? const Center(
                              child: Text('Cart is empty'),
                            )
                          : ListView.builder(
                              itemCount: state.items.length,
                              itemBuilder: (context, index) => CartItem(
                                foodItem: state.items[index],
                                removeItem: BlocProvider.of<CartCubit>(context)
                                    .removeFromCart,
                              ),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CartCubit>(context).payAndCheckOut();
                      },
                      child: const Text('Pay'),
                    ),
                  ],
                );
              } else if (state is CartErrorState) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
