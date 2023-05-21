import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
part 'library_states.dart';

class LibraryBloc extends Cubit<Library> {
  late CollectionReference cr1;
  LibraryBloc() : super(LibraryInitial()) {
    cr1 = FirebaseFirestore.instance.collection('library');
  }

  Future<void> fetchBooks() async {
    emit(LibraryLoaded([]));
    try {
      var snapshot = await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('books')
          .get();
      List<Map<String, String>> books = [];
      for (int i = 0; i < snapshot.docs.length; i++) {
        books.add(snapshot.docs[i].data().map(
              (bookkey, bookvalue) => MapEntry(
                bookkey.toString(),
                bookvalue.toString(),
              ),
            ));
      }
      log(books.toString());
      emit(LibraryLoaded(books));
    } catch (error) {
      log(error.toString());
      emit(LibraryError(error.toString()));
    }
  }

  Future<void> addBook(Map<String, String> library, String date) async {
    emit(LibraryLoading());
    try {
      await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('books')
          .doc(library['bookName'])
          .set(library);

      log(date);

      //set timer to delete the book
      setDeleteTime(
        library['bookName']!,
        deleteBook,
        DateTime.parse(date),
      );

      emit(BookUploaded());
      await fetchBooks();
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  Future<void> deleteBook(String name) async {
    emit(LibraryLoading());
    try {
      await cr1
          .doc(
            User.m!['UID'].toString().substring(0, 11),
          )
          .collection('books')
          .doc(name)
          .delete();
      emit(BookDeleted());
      await fetchBooks();
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  void setDeleteTime(
      String bookName, Function deleteBook, DateTime returnDate) {
    log('setting the timer');
    log(DateTime.now().toString());
    log(returnDate.toString());
    Duration difference = returnDate.difference(DateTime.now());
    log(difference.toString());
    if (difference.isNegative) {
      return;
    }
    log('Timer set!');
    Timer(difference, () {
      deleteBook(bookName);
    });

  }
}
