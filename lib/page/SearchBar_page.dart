import 'package:flutter/material.dart';

class SearchbarPage extends StatefulWidget {
  final Function(String) onSearch;
  final bool
      searchHasResult; // Indique si la recherche a retourné des résultats

  const SearchbarPage({
    Key? key,
    required this.onSearch,
    this.searchHasResult = true, // Par défaut, la recherche a des résultats
  }) : super(key: key);

  @override
  _SearchbarPageState createState() => _SearchbarPageState();
}

class _SearchbarPageState extends State<SearchbarPage> {
  final TextEditingController controller = TextEditingController();

  void performSearch() {
    String query = controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query); // Appeler la fonction de recherche
    } else {
      setState(() {
        // On ne change rien à searchHasResult si le champ est vide
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 330,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Faites votre recherche ici",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed:
                    performSearch, // Lancer la recherche lorsqu'on appuie sur l'icône
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (!widget.searchHasResult)
          const Text(
            'Aucun résultat trouvé',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
