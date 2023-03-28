import 'package:flutter/material.dart';
import 'package:smartplate/src/pages/home_page.dart';
import 'package:smartplate/src/pages/placa_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Placas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PlacaDetalle(),

      },
    );
  }

}