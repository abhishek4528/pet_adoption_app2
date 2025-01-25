import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app2/ui/screens/pet_detail.dart';
import '../../theme/bloc/bloc.dart';
import '../../theme/bloc/event.dart';
import '../../theme/bloc/state.dart';
import '../../widgets/pet_item.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc()..add(FetchAdoptedPetsEvent()),
      child: Scaffold(
        backgroundColor:  Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdoptionHistoryScreen(),
              ),
            );
          },
          label: const Text(
            "View History",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.history),
        ),
        appBar: AppBar(
          title: const Text("Adopt Me",
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
          actions: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return IconButton(
                  icon: Icon(
                    themeState is DarkThemeState
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              if (state is HomePageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomePageLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        autofocus: false,
                        onChanged: (query) => context
                            .read<HomePageBloc>()
                            .add(SearchPetsEvent(query)),
                        decoration: InputDecoration(
                          hintText: "Search pets by name...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        controller: ScrollController()
                          ..addListener(() {
                            if (ScrollController().position.pixels >=
                                ScrollController()
                                    .position
                                    .maxScrollExtent) {
                              context
                                  .read<HomePageBloc>()
                                  .add(LoadMorePetsEvent());
                            }
                          }),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: state.pets.length,
                        itemBuilder: (context, index) {
                          final pet = state.pets[index];
                          final isAdopted =
                          state.adoptedPetIds.contains(pet['id']);
                          return Center(
                            child: Hero(
                              tag: pet['image'],
                              child: Opacity(
                                opacity: isAdopted ? 0.4 : 1,
                                child: PetItem(
                                  isAdopted: isAdopted,
                                  data: pet,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          petDetails: {
                                            'name': pet['name'] ?? 'Unknown Name',
                                            'imageUrl': pet['image'],
                                            'age': pet['age'] ?? 'Unknown Age',
                                            'breed': pet['breed'] ??
                                                'Unknown Breed',
                                            'description': pet['description'] ??
                                                'No description available.',
                                            'color': pet['color'],
                                            'price': pet['price'],
                                            'id': pet['id'],
                                          },
                                          onAdopt: () {
                                            context
                                                .read<HomePageBloc>()
                                                .add(FetchAdoptedPetsEvent());
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (state.isLoadingMore)
                      const CircularProgressIndicator(strokeWidth: 2),
                  ],
                );
              } else if (state is HomePageError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}







