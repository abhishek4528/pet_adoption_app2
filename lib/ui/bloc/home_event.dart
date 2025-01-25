abstract class HomePageEvent {}

class LoadPetsEvent extends HomePageEvent {}

class SearchPetsEvent extends HomePageEvent {
  final String query;

  SearchPetsEvent(this.query);
}

class LoadMorePetsEvent extends HomePageEvent {}

class FetchAdoptedPetsEvent extends HomePageEvent {}
