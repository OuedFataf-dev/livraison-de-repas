import 'package:flutter/material.dart';

class Profile_Cusinier extends StatelessWidget {
  const Profile_Cusinier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Cusinier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Photo de profil
            const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/téléchargement.jpeg')),
            const SizedBox(height: 16), // Espace entre l'image et le texte
            // Nom de l'utilisateur
            const Text(
              'baro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Espace entre le nom et l'email
            // Email de l'utilisateur
            const Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
                height: 16), // Espace avant les informations supplémentaires
            // Informations supplémentaires
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  children: [
                    Icon(Icons.phone, color: Colors.blue),
                    SizedBox(height: 4),
                    Text('Téléphone'),
                    Text('07310559'),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/téléchargement.jpeg'),
                          fit: BoxFit
                              .cover, // You can set fit as per your requirement
                        ),
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(height: 4),
                    const Text('Localisation'),
                    const Text('Ouagadougou'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('pays ', style: TextStyle(fontSize: 20)),
                    const Text('Burkiina faso', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
