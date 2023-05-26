import 'dart:convert';
import 'dart:developer';

import 'package:CampusCompass/screens/Library/logic/library_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/notifications_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/global_data.dart';
import './library_form.dart';
import '../ui/libraryRecords.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final NotificationScheduler _notificationScheduler = NotificationScheduler();

  @override
  void initState() {
    super.initState();
    initialize();
    _notificationScheduler.initializeNotifications();
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    log(timeZoneName);
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, Library>(
      bloc: BlocProvider.of<LibraryBloc>(context)..fetchBooks(),
      listener: (context, state) {
        if (state is BookUploaded) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
                content: Text('Book Uploaded'),
              ),
            );
        } else if (state is BookDeleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
                content: Text('Book Deleted'),
              ),
            );
        }
      },
      builder: (context, state) {
        log(state.toString());
        if (state is LibraryInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LibraryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LibraryLoaded) {
          return RefreshIndicator(
            onRefresh: () => BlocProvider.of<LibraryBloc>(context).fetchBooks(),
            child: Stack(
              children: [
                if (state.l.isEmpty)
                  const Center(
                    child: Text('No Books Added'),
                  )
                else
                  ListView.builder(
                    itemCount: state.l.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LibraryCardWidget(
                          state.l[index],
                          BlocProvider.of<LibraryBloc>(context).deleteBook,
                        ),
                      );
                    },
                  ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => LibraryForm(
                          BlocProvider.of<LibraryBloc>(context).addBook,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is LibraryError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
