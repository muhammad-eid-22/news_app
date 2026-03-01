import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import '../../../../core/theme/app_colors.dart';

class CustomDrawerWidget extends StatelessWidget {
  final void Function() onTap;

  const CustomDrawerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      width: MediaQuery.of(context).size.width * 0.65,
      child: Column(
        spacing: 8,
        children: [
          Container(
            height: 240,
            color: AppColors.white,
            alignment: Alignment.center,
            child: Text(
              "News App",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.black),
            ),
          ),
          Bounceable(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.other_houses_outlined, color: AppColors.white),

                  Text(
                    "Go To Home",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: AppColors.white,
            thickness: 1,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.imagesearch_roller_outlined, color: AppColors.white),
                Text(
                  "Theme",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.white,
            thickness: 1,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.language, color: AppColors.white),
                Text(
                  "Language",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.white,
            thickness: 1,
            endIndent: 16,
            indent: 16,
          ),
        ],
      ),
    );
  }
}
