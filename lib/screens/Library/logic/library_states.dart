part of 'library_cubit.dart';

abstract class Library {}

class LibraryInitial extends Library {}

class BookUploaded extends Library {}

class BookDeleted extends Library {}

class LibraryLoading extends Library {}

class LibraryLoaded extends Library {
  final List<Map<String, String>> l;
  LibraryLoaded(this.l);
}

class LibraryError extends Library {
  final String message;
  LibraryError(this.message);
}
