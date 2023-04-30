import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/club_posts.dart';
import 'package:firebase/screens/Clubs/ui/event_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/global_data.dart';

class ClubEvent extends StatefulWidget {
  static const routeName = '/clubs_events';

  @override
  State<ClubEvent> createState() => _ClubEventState();
}

class _ClubEventState extends State<ClubEvent> {
  @override
  Widget build(BuildContext context) {
    String clubName = ModalRoute.of(context)!.settings.arguments as String;
    List<Map<String, String>> event = User.events[clubName]!.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(clubName),
      ),
      body: event.isEmpty
          ? const Center(child: Text('No Events'))
          : BlocConsumer<ClubsCubit, ClubStates>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ClubLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ClubsErrorState) {
                  return Center(child: Text(state.error));
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        //Navigate
                        Navigator.of(context).pushNamed(
                            EventDescription.routeName,
                            arguments: event[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        color: Colors.blue[200],
                        child: Center(
                            child:
                                Text(event[index]['title'] ?? 'Unnamed Event')),
                      ),
                    ),
                    itemCount: event.length,
                  );
                }
              },
            ),
      floatingActionButton: (User.m!['UID'] == User.clubs[clubName])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ClubsForm.routeName, arguments: clubName);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
