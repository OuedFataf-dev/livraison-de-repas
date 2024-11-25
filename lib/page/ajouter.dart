import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class PickerFileFromFirebase extends StatefulWidget {
  const PickerFileFromFirebase({super.key});

  @override
  State<PickerFileFromFirebase> createState() => _PickerFileFromFirebaseState();
}

class _PickerFileFromFirebaseState extends State<PickerFileFromFirebase> {
  File? imageFile;
  bool isLoading = false;
  bool isFilePickerActive = false;
  String? uploadedImageUrl;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController mealController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController descroController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController commController = TextEditingController();

  bool get isFormValid {
    return imageFile != null &&
        mealController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        minuteController.text.isNotEmpty &&
        descroController.text.isNotEmpty &&
        ratingController.text.isNotEmpty &&
        commController.text.isNotEmpty;
  }

  @override
  void dispose() {
    priceController.dispose();
    mealController.dispose();
    minuteController.dispose();
    descroController.dispose();
    ratingController.dispose();
    commController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sélectionner une image"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isFilePickerActive ? null : getImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "Sélectionner l'image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  imageFile!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: mealController,
              decoration: InputDecoration(
                labelText: "Nom du repas",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "Prix",
                border: OutlineInputBorder(),
              ),
              // keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            TextField(
              controller: minuteController,
              decoration: InputDecoration(
                labelText: "Minute",
                border: OutlineInputBorder(),
              ),
              // keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: descroController,
              decoration: InputDecoration(
                labelText: "description",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: "rating",
                border: OutlineInputBorder(),
              ),
              // keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            TextField(
              controller: commController,
              decoration: InputDecoration(
                labelText: "commentaire",
                border: OutlineInputBorder(),
              ),
              // keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isFormValid && !isLoading ? uploadImage : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                backgroundColor:
                    isFormValid && !isLoading ? Colors.blue : Colors.grey,
              ),
              child: Text(
                "Envoyer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (uploadedImageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Image téléchargée avec succès',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    if (isFilePickerActive) return;

    setState(() {
      isFilePickerActive = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          imageFile = File(result.files.single.path!);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Aucun fichier sélectionné',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Erreur lors de la sélection de fichier: $e');
      Fluttertoast.showToast(
        msg: 'Erreur lors de la sélection de fichier',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isFilePickerActive = false;
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(
        msg: 'Veuillez sélectionner une image et entrer les détails',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await uploadFileToServer(imageFile!);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final imageUrl = responseBody['url'];

        if (imageUrl != null) {
          final sendDataResponse = await sendDataToNode(imageUrl);

          if (sendDataResponse) {
            setState(() {
              uploadedImageUrl = imageUrl;
              imageFile = null;
              mealController.clear();
              priceController.clear();
              minuteController.clear();
            });

            Fluttertoast.showToast(
              msg: 'Image et données téléchargées avec succès',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Erreur lors de l\'envoi des données au serveur',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'URL de l\'image non reçue du serveur',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Erreur lors du téléchargement de l\'image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Erreur: $e');
      Fluttertoast.showToast(
        msg: 'Erreur lors de la connexion au serveur',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<http.Response> uploadFileToServer(File file) async {
    final uri = Uri.parse('https://node-js-flutter-1.onrender.com/api/upload');
    final request = http.MultipartRequest('POST', uri);

    try {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print('Erreur lors de l\'upload du fichier: $e');
      throw Exception('Erreur lors de l\'upload du fichier');
    }
  }

  Future<bool> sendDataToNode(String imageUrl) async {
    final uri = Uri.parse('https://node-js-flutter.onrender.com/api/endpoint');

    final Map<String, dynamic> data = {
      "imageUrl": imageUrl,
      "price": priceController.text,
      "minute": minuteController.text,
      "name": mealController.text,
      "description": descroController.text,
      "rating": ratingController.text,
      "commentaire": commController.text,
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de l\'envoi des données: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de l\'envoi des données au serveur: $e');
      return false;
    }
  }
}
