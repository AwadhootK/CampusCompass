part of 'clubs_cubit.dart';

abstract class ClubStates{}

class ClubLoadingState extends ClubStates{}

class ClubsLoadedState extends ClubStates{
  List<String> l = ['PASC', 'PCSB', 'PISB', 'Pictoreal', 'GDU', 'GDSC'];
  final Map<String, Map<String, Map<String, String>>> events;
  ClubsLoadedState(this.events);
}

class ClubsErrorState extends ClubStates{
  final String error;
  ClubsErrorState(this.error);
}