import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/router/app_router.dart';
import 'package:flutter_app/bloc/product/product_bloc.dart';
import 'package:flutter_app/bloc/product/product_event.dart';
import 'package:flutter_app/bloc/cart/cart_bloc.dart';
import 'package:flutter_app/bloc/cart/cart_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc()..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => CartBloc()..add(LoadCart()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Mini Market',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
