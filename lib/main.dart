import 'package:cookeazy/models/Menu.dart';
import 'package:cookeazy/page/Home_pages.dart';
import 'package:cookeazy/services/api.dart';
import 'package:flutter/material.dart';
//import 'Home_Page.dart';
import 'Authentification/login.dart';
import 'Authentification/register.dart';
import './page/screen_pagesmenu.dart';
import './page/Menu_principale.dart';
import './page/ajouter.dart';
import './page/Meals.pages.dart';
import 'ajouterImage.dart';
import 'package:cookeazy/page/Menu_principale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import './page/commandes.dart';
import './page/ SingleChildScrollViewpro.dart';
import './page/Menu_Page.dart';
import './page/SearchBar_page.dart';
import './page/homeAppbar.dart';
import './page/Detaille_Page.dart';
import './services/suivi_commande.dart';
import './services/provider.dart';
import 'package:provider/provider.dart';

///import 'Authentification/login.dart';
void main() {
  // Initialiser Stripe avec la clé publique
  Stripe.publishableKey =
      'pk_test_51Od6veCXR1cwPbKYeHcRW1ibOuwoWh4r3JVoymcLmiulT6F0BKFJd83kNYRRnGz2Ii5ZMVWs6KJ50zuRFqVAJWmf00bybu9wPK';

  runApp(
    ChangeNotifierProvider(
      create: (_) => CommandeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  //const HomePage({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final mealsId = '455';
  //final detailId = '25';
  int currentIndex = 0;
  setcurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'APPLICATION DE LIVRAISON DE REPAS',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            body: Register()));
  }
}
