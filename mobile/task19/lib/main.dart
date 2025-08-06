import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_trivia/core/di/app_module.dart';
import 'package:number_trivia/core/theme/app_theme.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppModule.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<NumberTriviaBloc>(
              create: (context) => sl<NumberTriviaBloc>(),
            ),
          ],
          child: MaterialApp(
            title: 'Number Trivia',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme.copyWith(
              useMaterial3: true,
            ),
            home: const NumberTriviaPage(),
          ),
        );
      },
    );
  }
}