abstract class HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Map<String, dynamic>> pets;
  final List<String> adoptedPetIds;
  final bool isLoadingMore;

  HomePageLoaded({
    required this.pets,
    required this.adoptedPetIds,
    this.isLoadingMore = false,
  });
}

class HomePageError extends HomePageState {
  final String message;

  HomePageError(this.message);
}
