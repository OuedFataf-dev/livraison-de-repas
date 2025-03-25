import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Ajouterimage extends StatefulWidget {
  @override
  State<Ajouterimage> createState() => _AjouterimageState();
}

class _AjouterimageState extends State<Ajouterimage> {
  File? imageFile;
  bool isLoading = false;
  bool isFilePickerActive = false;
  String? uploadedImageUrl;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController chefIdController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();

  bool availability = false;

  @override
  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
    ratingController.dispose();
    chefIdController.dispose();
    ingredientsController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return imageFile != null &&
        priceController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        ratingController.text.isNotEmpty &&
        chefIdController.text.isNotEmpty &&
        ingredientsController.text.isNotEmpty;
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
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            if (imageFile != null) buildImagePreview(),
            SizedBox(height: 20),
            buildTextField(priceController, "Prix"),
            SizedBox(height: 20),
            buildTextField(descriptionController, "Description"),
            SizedBox(height: 20),
            buildTextField(ingredientsController,
                "Ingrédients (séparés par des virgules)"),
            SizedBox(height: 20),
            buildTextField(ratingController, "Évaluation (sur 5)",
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            buildTextField(chefIdController, "Chef ID"),
            SizedBox(height: 20),
            buildAvailabilitySwitch(),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            SizedBox(height: 20),
            buildSubmitButton(),
            if (uploadedImageUrl != null) buildSuccessMessage(),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.file(
        imageFile!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
    );
  }

  Widget buildAvailabilitySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Disponible"),
        Switch(
          value: availability,
          onChanged: (value) {
            setState(() {
              availability = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: isFormValid && !isLoading ? uploadImage : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        backgroundColor: isFormValid && !isLoading ? Colors.blue : Colors.grey,
      ),
      child: Text(
        "Envoyer",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget buildSuccessMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        'Image téléchargée avec succès',
        style: TextStyle(fontSize: 16, color: Colors.green),
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
        showToast('Aucun fichier sélectionné', Colors.orange);
      }
    } catch (e) {
      print('Erreur lors de la sélection de fichier: $e');
      showToast('Erreur lors de la sélection de fichier', Colors.red);
    } finally {
      setState(() {
        isFilePickerActive = false;
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      showToast(
          'Veuillez sélectionner une image et entrer le prix', Colors.orange);
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
            resetForm(imageUrl);
            showToast('Image et prix téléchargés avec succès', Colors.green);
          } else {
            showToast(
                'Erreur lors de l\'envoi des données au serveur', Colors.red);
          }
        } else {
          showToast('URL de l\'image non reçue du serveur', Colors.red);
        }
      } else {
        showToast('Erreur lors du téléchargement de l\'image', Colors.red);
      }
    } catch (e) {
      print('Erreur: $e');
      showToast('Erreur lors de la connexion au serveur', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<http.Response> uploadFileToServer(File file) async {
    final uri = Uri.parse('http://192.168.12.60:5000/add/api');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<bool> sendDataToNode(String imageUrl) async {
    final uri = Uri.parse('http://192.168.12.60:5000/add/endpoint');
    List<String> ingredientsList =
        ingredientsController.text.split(',').map((e) => e.trim()).toList();
    final Map<String, dynamic> data = {
      "imageUrl": imageUrl,
      "price": priceController.text,
      "description": descriptionController.text,
      "availability": availability,
      "ingredients": ingredientsList,
      "rating": double.parse(ratingController.text),
      "chefId": chefIdController.text,
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de l\'envoi des données au serveur: $e');
      return false;
    }
  }

  void resetForm(String imageUrl) {
    setState(() {
      uploadedImageUrl = imageUrl;
      imageFile = null;
      priceController.clear();
      descriptionController.clear();
      ratingController.clear();
      chefIdController.clear();
      ingredientsController.clear();
    });
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
