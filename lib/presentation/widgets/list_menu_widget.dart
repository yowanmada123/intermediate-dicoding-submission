import 'package:flutter/material.dart';
import 'package:maresto/data/models/restaurant_detail_response.dart';

class ListMenuWidget extends StatelessWidget {
  final List<Category> menu;
  final String imgPrefix;
  final String title;
  final int length;
  const ListMenuWidget({
    super.key,
    required this.title,
    required this.length,
    required this.menu,
    required this.imgPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            '$imgPrefix${(index % 8) + 1}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menu[index].name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 32),
      ],
    );
  }
}
