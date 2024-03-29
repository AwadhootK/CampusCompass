import 'package:CampusCompass/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:CampusCompass/screens/BottomNavBar/ui/landing_screen.dart';
import 'package:CampusCompass/screens/Canteen/admin/admin_signup.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/admin_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/admin_home.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/daily_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:CampusCompass/screens/Clubs/logic/clubs_cubit.dart';
import 'package:CampusCompass/screens/Login/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminAuthCubit, AdminAuthStates>(
      listener: (context, state) {
        if (state is AdminAuthErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error),
              ),
            );
        } else if (state is AdminAuthSuccessState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Login Successful'),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is AdminAuthInitialState) {
          return AdminLoginSignup();
        } else if (state is AdminAuthSuccessState) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => FoodItemCubit()..fetchFoodItems(),
              ),
              BlocProvider(
                create: (context) => DailyItemCubit()..getDailyMenu(),
              ),
            ],
            child: const AdminHome(),
          );
        } else if (state is AdminAuthErrorState) {
          return AdminLoginSignup();
        } else if (state is AdminAuthLogoutState) {
          return LoginSignup();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
