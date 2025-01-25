import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/data.dart';
import '../../utils/sharedpref.dart';
import 'home_event.dart';
import 'home_state.dart';


class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final int petsPerPage = 20;
  List<Map<String, dynamic>> filteredPets = pets;
  List<String> adoptedPetsIds = [];
  int currentPage = 0;

  HomePageBloc() : super(HomePageLoading()) {
    on<FetchAdoptedPetsEvent>((event, emit) {
      adoptedPetsIds = SharedPref.getListString(SharedPref.adoptedPetsIds);
      add(LoadPetsEvent());
    });

    on<LoadPetsEvent>((event, emit) {
      final petsToDisplay = _loadPetsForPage();
      emit(HomePageLoaded(
        pets: petsToDisplay,
        adoptedPetIds: adoptedPetsIds,
      ));
    });

    on<SearchPetsEvent>((event, emit) {
      currentPage = 0;
      if (event.query.isEmpty) {
        filteredPets = pets;
      } else {
        filteredPets = pets
            .where((pet) => pet['name']
            .toLowerCase()
            .contains(event.query.toLowerCase()))
            .toList();
      }
      add(LoadPetsEvent());
    });

    on<LoadMorePetsEvent>((event, emit) {
      if ((currentPage + 1) * petsPerPage < filteredPets.length) {
        currentPage++;
        final petsToDisplay = _loadPetsForPage();
        final currentState = state;
        if (currentState is HomePageLoaded) {
          emit(HomePageLoaded(
            pets: petsToDisplay,
            adoptedPetIds: adoptedPetsIds,
            isLoadingMore: false,
          ));
        }
      }
    });
  }

  List<Map<String, dynamic>> _loadPetsForPage() {
    int endIndex = (currentPage + 1) * petsPerPage;
    if (endIndex > filteredPets.length) {
      endIndex = filteredPets.length;
    }
    return filteredPets.sublist(0, endIndex);
  }
}
