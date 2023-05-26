import 'dart:developer';

import 'package:CampusCompass/screens/Clubs/ui/club_events.dart';
import 'package:CampusCompass/screens/Clubs/logic/clubs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CustomCard({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: FadeInImage(
                    placeholder: const AssetImage(
                      'assets/club_placeholder.jpg',
                    ),
                    fadeInCurve: Curves.easeIn,
                    image: NetworkImage(
                      imageUrl,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              width: double.infinity,
              height: 30,
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubsScreen extends StatelessWidget {
  static const routeName = '/clubs_screen';
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClubsCubit, ClubStates>(
      listener: (context, state) {
        if (state is ClubsErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is ClubLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClubsLoadedState) {
          // log(state.l.toString());
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<ClubsCubit>(context).fetchClubEvents();
            },
            child: Container(
              color: Colors.black12,
              child: ListView.builder(
                itemCount: state.l.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // print(User.events);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  ClubsCubit()..fetchClubEvents(),
                              child: ClubEvent(),
                            ),
                            settings: RouteSettings(
                              arguments: state.l[index],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCard(
                          name: state.l[index],
                          imageUrl: state.clubLogos[state.l[index]]!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is ClubsErrorState) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
