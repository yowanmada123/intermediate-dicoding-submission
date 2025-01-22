import 'package:flutter/material.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/restaurant_detail_provider.dart';
import 'package:maresto/data/providers/restaurant_favorite_provider.dart';
import 'package:maresto/data/state/restaurant_add_review_state.dart';
import 'package:maresto/data/state/restaurant_detail_state.dart';
import 'package:maresto/presentation/widgets/image_widget.dart';
import 'package:maresto/presentation/widgets/list_menu_widget.dart';
import 'package:maresto/presentation/widgets/textField_custom_widget.dart';
import 'package:provider/provider.dart';
import 'package:maresto/presentation/widgets/loading_widget.dart';

class DetailScreen extends StatelessWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RestaurantDetailProvider>(context, listen: false);

    final favoriteProvider =
        Provider.of<FavoriteRestaurantProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.fetchRestaurantDetail(restaurantId);
    });

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController reviewController = TextEditingController();

    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, state, child) {
          final detailState = state.detailState;

          if (detailState is DetailLoading) {
            return const Center(child: LoadingWidget());
          }

          if (detailState is DetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(detailState.errorMessage, style: textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => state.fetchRestaurantDetail(restaurantId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (detailState is DetailSuccess) {
            final restaurant = detailState.restaurantDetail;
            bool isFavorite = favoriteProvider.favoriteRestaurants
                .any((r) => r.id == restaurantId);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  backgroundColor: theme.colorScheme.primary,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: false,
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: top < 120.0 ? 1.0 : 0.0,
                          child: Text(
                            "Detail Restaurant",
                            style: textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: restaurant.pictureId,
                              child: NetworkImageWidget(
                                pictureId: restaurant.pictureId,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black..withValues(alpha: 0.6),
                                    Colors.transparent,
                                    Colors.black..withValues(alpha: 0.6),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      weight: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    Consumer<FavoriteRestaurantProvider>(
                      builder: (context, favoriteProvider, child) {
                        return IconButton(
                          icon: favoriteProvider.isLoading
                              ? const LoadingWidget()
                              : Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                          onPressed: () async {
                            if (favoriteProvider.isLoading) return;

                            if (isFavorite) {
                              await favoriteProvider
                                  .removeFromFavorites(restaurant.id);
                              isFavorite = !isFavorite;
                            } else {
                              await favoriteProvider.addToFavorites(
                                RestaurantInfo(
                                  id: restaurant.id,
                                  name: restaurant.name,
                                  description: restaurant.description,
                                  pictureId: restaurant.pictureId,
                                  city: restaurant.city,
                                  rating: restaurant.rating,
                                ),
                              );
                              isFavorite = !isFavorite;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${restaurant.name} - ",
                                style: textTheme.headlineLarge,
                              ),
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating.toString(),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.place,
                                          color: Colors.red),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${restaurant.address}, ${restaurant.city}",
                                        style: textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              state.toggleDescription();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.isDescriptionExpanded
                                      ? restaurant.description
                                      : '${restaurant.description.substring(0, 100)}... ',
                                  textAlign: TextAlign.justify,
                                  style: textTheme.bodyLarge,
                                ),
                                Text(
                                  state.isDescriptionExpanded
                                      ? 'Show Less'
                                      : 'Show More',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 32),
                          Text(
                            'Kategori',
                            style: textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurant.categories.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        restaurant.categories[index].name,
                                        style: textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(height: 32),
                          ListMenuWidget(
                            title: 'Foods',
                            menu: restaurant.menus.foods,
                            length: restaurant.menus.foods.length,
                            imgPrefix: 'assets/mak',
                          ),
                          ListMenuWidget(
                            title: 'Drinks',
                            menu: restaurant.menus.drinks,
                            length: restaurant.menus.drinks.length,
                            imgPrefix: 'assets/min',
                          ),
                          Text(
                            'Customer Reviews',
                            style: textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: restaurant.customerReviews.reversed
                                .skip(state.currentPage * state.reviewsPerPage)
                                .take(state.reviewsPerPage)
                                .map((review) {
                              return Card(
                                elevation: 2,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.cardColor,
                                    child: Text(review.name[0].toUpperCase(),
                                        style: textTheme.bodyMedium),
                                  ),
                                  title: Text(review.name,
                                      style: textTheme.bodyLarge),
                                  subtitle: Text(review.review,
                                      style: textTheme.bodyMedium),
                                  trailing: Text(
                                    review.date,
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: state.currentPage == 0
                                    ? null
                                    : () => state.previousPage(),
                                child: const Text('Previous'),
                              ),
                              ElevatedButton(
                                onPressed: (state.currentPage + 1) *
                                            state.reviewsPerPage >=
                                        restaurant.customerReviews.length
                                    ? null
                                    : () => state.nextPage(),
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Text(
                            'Add Your Review',
                            style: textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: nameController,
                            labelText: 'Your Name',
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: reviewController,
                            labelText: 'Your Review',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isEmpty ||
                                    reviewController.text.isEmpty) {
                                  return;
                                }

                                await state.addReview(
                                  restaurantId,
                                  nameController.text,
                                  reviewController.text,
                                );

                                if (state.addReviewState is AddReviewSuccess) {
                                  await state
                                      .fetchRestaurantDetail(restaurantId);

                                  nameController.clear();
                                  reviewController.clear();
                                }
                              },
                              child: state.addReviewState is AddReviewSubmitting
                                  ? const LoadingWidget()
                                  : const Text("Submit Review"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
