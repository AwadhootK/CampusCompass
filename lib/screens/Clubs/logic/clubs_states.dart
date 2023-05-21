part of 'clubs_cubit.dart';

abstract class ClubStates {}

class ClubLoadingState extends ClubStates {}

class ClubsLoadedState extends ClubStates {
  List<String> l = [
    'PASC',
    'PCSB',
    'PISB',
    'Pictoreal',
    'GDU',
    'GDSC',
    'NSS',
    'Art Circle',
    'DebSoc',
  ];
  Map<String, String> clubLogos = {
    'PASC': "https://pict.acm.org/pulzion19/About-us/data1/PASClogo.png",
    'PCSB': "https://www.pictcsi.com/assets/CSI%20Logo%20Nav.png",
    'PISB': "https://pictieee.in/Home/img/pisb-colour.png",
    'Pictoreal': "https://pictoreal.in/assets/img/favicon.png",
    'GDU':
        "https://media.licdn.com/dms/image/C4D0BAQEr1uTqVRocxQ/company-logo_200_200/0/1625553253896?e=2147483647&v=beta&t=cBI2tLkqmd-7ZazkVCQbbsmwCL8lHCNv0UkMSSlTH6E",
    'GDSC':
        "https://res.cloudinary.com/startup-grind/image/upload/c_fill,dpr_2,f_auto,g_center,q_auto:good/v1/gcs/platform-data-dsc/contentbuilder/GDG-Bevy-ChapterThumbnail.png",
    'NSS':
        "https://pbs.twimg.com/profile_images/1252082062242217984/oFwEYzZz_400x400.jpg",
    'Art Circle':
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAPG-K8edqZHeuGNZ58W8775-u9g6o5gf4dWoZJaRaZA&s",
    'DebSoc': "https://pict-debsoc.netlify.app/assets/img/logo.png",
  };
  final Map<String, Map<String, Map<String, String>>> events;
  ClubsLoadedState(this.events);
}

class ClubsErrorState extends ClubStates {
  final String error;
  ClubsErrorState(this.error);
}
