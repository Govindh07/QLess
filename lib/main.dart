import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_less/QLess/Provider/payment_provider.dart';
import 'package:q_less/QLess/Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>PaymentProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(

              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: HomePage(),
            ),
        );
    }
}