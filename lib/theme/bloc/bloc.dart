import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app2/theme/bloc/state.dart';
import '../../utils/sharedpref.dart';
import 'event.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool isDarkMode = false;

  ThemeBloc() : super(LightThemeState()) {
    // Load theme preference on initialization
    on<LoadThemeEvent>((event, emit) async {
      await _loadTheme(); // Load the theme when the event is triggered
      emit(isDarkMode ? DarkThemeState() : LightThemeState());
    });

    on<ToggleThemeEvent>((event, emit) {
      isDarkMode = !isDarkMode;
      _saveTheme(isDarkMode);
      emit(isDarkMode ? DarkThemeState() : LightThemeState());
    });
  }

  Future<void> _loadTheme() async {
    isDarkMode = SharedPref.getBool(SharedPref.isDarkMode);
  }

  // Save the theme preference to SharedPreferences
  Future<void> _saveTheme(bool isDarkMode) async {
    SharedPref.setBool(SharedPref.isDarkMode,isDarkMode);
  }
}
