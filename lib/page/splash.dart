import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';


class SplashScreen extends StatefulWidget {
  final BuildContext context;
  final VoidCallback onNavigateToLogin;

  const SplashScreen({
    Key? key,
    required this.context,
    required this.onNavigateToLogin,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    
    // Vérifier la connexion internet
    _checkInternetConnection();
    
    // Configuration de l'animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Délai avant navigation
    Timer(const Duration(seconds: 4), () {
      if (mounted && _isInternetConnected) {
        widget.onNavigateToLogin();
      }
    });
  }

  bool _isInternetConnected = false;

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isInternetConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isInternetConnected = false;
        _showDialog = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              ),
            ),
          ),

          // Logo avec animation
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/lunch.png', // Assurez-vous d'avoir cette image dans vos assets
                width: 150,
                height: 150,
              ),
            ),
          ),

          // Indicateur de chargement
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 6,
              ),
            ),
          ),

          // Texte en bas
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
              Text(
  'Bienvenue dans ScholarApp!',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
),
SizedBox(height: 8),
Text(
  'Chargement...',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Colors.white,
  ),
),

              ],
            ),
          ),

          // Boîte de dialogue si pas de connexion
          if (_showDialog)
            AlertDialog(
              title: Text('Connexion Internet requise'),
              content: Text('Vous devez être connecté à Internet pour continuer.'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showDialog = false;
                    });
                    // Optionnel: quitter l'application
                    // SystemNavigator.pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Pour utiliser cette classe, vous feriez quelque chose comme:
/*
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => SplashScreen(
    context: context,
    onNavigateToLogin: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    },
  )),
);
*/