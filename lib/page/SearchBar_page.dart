import 'package:flutter/material.dart';
import '../models/Foot.dart';

class SearchbarPage extends StatefulWidget {
  final List<Meals> allMeals;
  final Function(String) onSearch;
  final bool searchHasResult;

  const SearchbarPage({
    Key? key,
    required this.allMeals,
    required this.onSearch,
    this.searchHasResult = true,
  }) : super(key: key);

  @override
  _SearchbarPageState createState() => _SearchbarPageState();
}

class _SearchbarPageState extends State<SearchbarPage> {
  final TextEditingController controller = TextEditingController();

  void performSearch() {
    String query = controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query);
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
                  onSubmitted: (_) =>
                      performSearch(), // Déclenche la recherche lors de l'appui sur la touche Entrée
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: performSearch,
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
