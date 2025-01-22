import 'package:flutter/material.dart';
import 'package:maresto/core/constants/app_constant.dart';
import 'package:maresto/presentation/widgets/loading_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  final String pictureId;

  const NetworkImageWidget({
    super.key,
    required this.pictureId,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$imageUrl$pictureId',
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: LoadingWidget(),
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.food_bank_rounded,
          size: 80,
          color: Colors.red,
        );
      },
      fit: BoxFit.cover,
    );
  }
}
