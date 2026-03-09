import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/moduls/home/cubit/home_cubit.dart';
import 'package:news_app/moduls/home/view/widgets/category_card.dart';
import 'package:news_app/moduls/home/view/widgets/custom_drawer_widget.dart';
import 'package:news_app/moduls/search/cubit/search_cubit.dart';
import 'package:news_app/moduls/search/view/search_screen.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../models/category_data_model.dart';
import '../sources/cubit/sources_cubit.dart';
import 'loaded_news_data_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CategoryDataModel> categories = [
    CategoryDataModel(
      id: "general",
      name: "General",
      image: Assets.images.earth.path,
    ),
    CategoryDataModel(
      id: "business",
      name: "Business",
      image: Assets.images.business.path,
    ),
    CategoryDataModel(
      id: "sports",
      name: "Sports",
      image: Assets.images.sports.path,
    ),
    CategoryDataModel(
      id: "technology",
      name: "Technology",
      image: Assets.images.tech.path,
    ),
    CategoryDataModel(
      id: "entertainment",
      name: "Entertainment",
      image: Assets.images.popcorn.path,
    ),
    CategoryDataModel(
      id: "health",
      name: "Health",
      image: Assets.images.health.path,
    ),
    CategoryDataModel(
      id: "science",
      name: "Science",
      image: Assets.images.medical.path,
    ),
  ];
  CategoryDataModel? SelectedCategory;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => SourcesCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            SelectedCategory == null ? "News App" : SelectedCategory!.name,
            style: theme.textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SearchCubit(),
                      child: const SearchScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: CustomDrawerWidget(onTap: _goToHome),
        body: SelectedCategory == null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning\nHere is Some News For You",
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.start,
                      ),
                      ...List.generate(
                        categories.length,
                        (index) => CategoryCard(
                          onTap: _onCategoryTap,
                          isEven: index % 2 == 0,
                          category: categories[index],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : LoadedNewsDataView(category: SelectedCategory!),
      ),
    );
  }

  void _onCategoryTap(CategoryDataModel category) {
    setState(() {
      SelectedCategory = category;
    });
  }

  void _goToHome() {
    setState(() {
      SelectedCategory = null;
      Navigator.pop(context);
    });
  }
}
