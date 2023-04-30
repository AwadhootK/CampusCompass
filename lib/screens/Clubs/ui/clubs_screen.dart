import 'package:firebase/screens/Clubs/ui/club_events.dart';
import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClubsScreen extends StatelessWidget {
  static const routeName = '/clubs_screen';
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('CLUBS')),
        body: BlocConsumer<ClubsCubit, ClubStates>(
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
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<ClubsCubit>(context).fetchClubEvents();
                },
                child: Center(
                  child: ListView(
                    children: state.l.map((element) {
                      return GestureDetector(
                        onTap: () {
                          // print(User.events);
                          Navigator.of(context).pushNamed(ClubEvent.routeName,
                              arguments: element);
                        },
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.blue[900],
                          child: Container(
                            height: 50,
                            color: Colors.blue[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(element),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            } else if (state is ClubsErrorState) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
