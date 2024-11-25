import 'package:flutter/material.dart';
import 'Detaille_Page.dart';
import '../models/Foot.dart';

class Footcart extends StatefulWidget {
  final Meals foot; // Assuming Meals is a model for your meal data

  const Footcart({
    super.key,
    required this.foot,
  });

  @override
  _FootcartState createState() => _FootcartState();
}

class _FootcartState extends State<Footcart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetaillePage(
                              mealsId: widget.foot.id,
                              quantity: 1,
                            ), // Use widget.foot.id
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.foot.imageUrl, // Use widget.foot.imageUrl
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    widget.foot.name, // Use widget.foot.name
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${widget.foot.price}\$',
                        // widget.foot.price, // Use widget.foot.price
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.foot.minute} mn', // Use widget.foot.minute
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.star, color: Colors.yellow, size: 25),
                      Icon(Icons.star, color: Colors.yellow, size: 25),
                      Icon(Icons.star, color: Colors.yellow, size: 25),
                    ],
                  ),
                ),
                //  Text('salut')
              ],
            ),
            Positioned(
              right: 2,
              child: IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {},
                icon: const Icon(Icons.favorite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
