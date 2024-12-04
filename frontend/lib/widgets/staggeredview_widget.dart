import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredViewWidget extends StatelessWidget {
  const StaggeredViewWidget({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
            child: // Generated code for this StaggeredView Widget...
                Opacity(
          opacity: 0.8,
          child: MasonryGridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: 11,
            itemBuilder: (context, index) {
              return [
                () => ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/sword.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/potion.png',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/bow.png',
                        width: 100,
                        height: 0,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/wow_knight.png',
                        width: 80,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/wand.png',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/bandit.png',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/goblin.png',
                        width: 120,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/magician.jpg',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/bag.png',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/bow.png',
                        width: 120,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://imgcdn.stablediffusionweb.com/2024/4/14/5de25de5-8b79-4831-aad2-e13fa5489ad5.jpg',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
              ][index]();
            },
          ),
        )),
        SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          // Ajouter un padding à gauche et à droite
          child: Align(
            alignment: Alignment.center, // Centrer le texte
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ));
  }
}
