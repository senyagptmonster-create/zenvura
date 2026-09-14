import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'zenvura_store.dart';
import 'screens.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ZenvuraStore()),
      ],
      child: MaterialApp(
        title: 'Zenvura',
        debugShowCheckedModeBanner: false,
        home: const ZenvuraHome(),
      ),
    );
  }
}
