import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
// your theme/colors

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMedium),
          child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Left Side: Promo Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Promo Tag
                      Container(
                        // width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Promo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        "Buy one get\none FREE",
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),

                // Right Side: Coffee Image
              ],
            ),
          ),
        ),
        // Coffee Beans Decoration Image
        Positioned(
          top: 110,
          right: 140,
          child: ClipRRect(
            child: Image.asset(
              "assets/images/coffeebeans.png",
              width: 150,
              height: 150,
            ),
          ),
        ),
        // Coffee Image on Top
        Positioned(
          top: 88,
          right: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/cofffeeimagetop.png", // add your coffee image here
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        // Brown Hearts Decoration Image
        Positioned(
          top: 60,
          right: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/brownhearts.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
