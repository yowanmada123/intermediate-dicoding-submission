import 'package:flutter/material.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/theme_provider.dart';
import 'package:maresto/presentation/widgets/image_widget.dart';
import 'package:provider/provider.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantInfo restaurant;
  final bool isFavoriteCard;
  final Function() onTap;
  final Function()? onDelete;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.isFavoriteCard,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeViewModel.isDarkTheme;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: theme.cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 120,
                  minHeight: 120,
                  maxWidth: 120,
                  minWidth: 120,
                ),
                child: Hero(
                  tag: restaurant.pictureId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: NetworkImageWidget(
                      pictureId: restaurant.pictureId,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: textTheme.headlineLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isFavoriteCard) ...[
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            color: Colors.redAccent,
                            onPressed: onDelete,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isDarkTheme ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 18,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.city,
                              style: textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toString(),
                              style: textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
