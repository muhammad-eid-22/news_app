import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:news_app/models/source_data_model.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/artical_data.dart';
import '../../../models/category_data_model.dart';
import '../../../network_handler/network_handler.dart';
import '../view_model/home_view_model/home_view_model.dart';
import 'webview_screen.dart';

class LoadedNewsDataView extends StatefulWidget {
  final CategoryDataModel category;

  const LoadedNewsDataView({super.key, required this.category});

  @override
  State<LoadedNewsDataView> createState() => _LoadedNewsDataViewState();
}

class _LoadedNewsDataViewState extends State<LoadedNewsDataView> {
  late HomeViewModelProvider homeViewModel;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      homeViewModel = Provider.of<HomeViewModelProvider>(
        context,
        listen: false,
      );
    }
    Future.wait([homeViewModel.getAllSources(widget.category.id)]).then((
      value,
    ) {
      homeViewModel.getAllArticles();
    });
  }

  void _showArticleBottomSheet(BuildContext context, ArticleData article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    article.description ?? "No description available",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          url: article.url,
                          title: article.sourceName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("View Full Article"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModelProvider>(
      builder: (context, viewModelProvider, _) {
        return Column(
          children: [
            DefaultTabController(
              length: viewModelProvider.sourcesList.length,
              child: TabBar(
                onTap: viewModelProvider.setSelectedTab,
                isScrollable: true,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.black,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                tabs: List.generate(viewModelProvider.sourcesList.length, (
                  index,
                ) {
                  final isSelected = viewModelProvider.selectedTab == index;
                  return Text(
                    viewModelProvider.sourcesList[index].name,
                    style: isSelected
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleSmall,
                  );
                }),
              ),
            ),
            if (viewModelProvider.articlesList.isEmpty) Text("NO DATA FOUND"),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Bounceable(
                    onTap: () {
                      _showArticleBottomSheet(
                        context,
                        viewModelProvider.articlesList[index],
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.black),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              viewModelProvider.articlesList[index].urlToImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            viewModelProvider.articlesList[index].title,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "By : ${viewModelProvider.articlesList[index].author}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  viewModelProvider
                                      .articlesList[index]
                                      .publishedAt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox.shrink();
                },
                itemCount: viewModelProvider.articlesList.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
