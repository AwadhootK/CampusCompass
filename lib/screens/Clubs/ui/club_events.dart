import 'dart:convert';

import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/club_posts.dart';
import 'package:firebase/screens/Clubs/ui/event_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/global_data.dart';

class PostWidget extends StatelessWidget {
  final String eventName;
  final String imageUrl;

  const PostWidget({
    required this.eventName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Container(
              height: 300,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Hero(
                  tag: imageUrl,
                  child: Image.memory(
                    base64Decode(imageUrl),
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Text(
              eventName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(clubName),
        centerTitle: true,
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
                  return ListView(children: [
                    ...event.map(
                      (e) => GestureDetector(
                        onTap: () {
                          //Navigate
                          Navigator.of(context).pushNamed(
                            EventDescription.routeName,
                            arguments: e,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PostWidget(
                            eventName: e['title']!,
                            imageUrl: e['poster']!,
                          ),
                        ),
                      ),
                    )
                  ]);
                }
              },
            ),
      floatingActionButton: (User.m!['UID'] == User.clubs[clubName])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ClubsCubit()..showForm(),
                      child: ClubsForm(),
                    ),
                    settings: RouteSettings(
                      arguments: clubName,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
