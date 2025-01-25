import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_adoption_app2/theme/bloc/bloc.dart';
import 'package:pet_adoption_app2/theme/bloc/event.dart';
import 'package:pet_adoption_app2/theme/bloc/state.dart';
import 'package:pet_adoption_app2/ui/bloc/home_bloc.dart';
import 'package:pet_adoption_app2/ui/screens/home.dart';
import 'package:pet_adoption_app2/utils/sharedpref.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(414, 896),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()..add(LoadThemeEvent())), // Dispatch LoadThemeEvent on startup
          BlocProvider(create: (_) => HomePageBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Pet App',
              theme: themeState.themeData,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}


