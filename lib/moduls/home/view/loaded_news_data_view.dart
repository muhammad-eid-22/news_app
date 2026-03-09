import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:news_app/moduls/home/cubit/home_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/artical_data.dart';
import '../../../models/category_data_model.dart';
import '../sources/cubit/sources_cubit.dart';
import 'webview_screen.dart';

class LoadedNewsDataView extends StatefulWidget {
  final CategoryDataModel category;

  const LoadedNewsDataView({super.key, required this.category});

  @override
  State<LoadedNewsDataView> createState() => _LoadedNewsDataViewState();
}

class _LoadedNewsDataViewState extends State<LoadedNewsDataView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SourcesCubit>().getAllSources(widget.category.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<SourcesCubit, SourcesState>(
          builder: (context, state) {
            var currentCubit = context.watch<SourcesCubit>();
            switch (state) {
              case SourcesInitial():
                return const Center(child: Text("Initial State"));
              case LoadingGetSources():
                return const Center(child: CircularProgressIndicator());
              case ErrorGetSources():
                return const Center(child: Text("Error State"));
              case SuccessGetSources():
                var sourcesList = state.sourcesList;

                if (_tabController.length != sourcesList.length) {
                  _tabController.dispose();
                  _tabController = TabController(
                    length: sourcesList.length,
                    vsync: this,
                    initialIndex: currentCubit.selectedTab,
                  );

                  _tabController.addListener(() {
                    if (!_tabController.indexIsChanging) {
                      currentCubit.setSelectedTab(_tabController.index);
                      final selectedSource = sourcesList[_tabController.index];
                      context.read<HomeCubit>().resetPagination();
                      context.read<HomeCubit>().getAllArticles(
                        selectedSource.id,
                      );
                    }
                  });
                }

                context.read<HomeCubit>().setSourcesList(sourcesList);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (sourcesList.isNotEmpty) {
                    final selectedSource =
                        sourcesList[currentCubit.selectedTab];
                    context.read<HomeCubit>().getAllArticles(selectedSource.id);
                  }
                });

                return Column(
                  children: [
                    TabBar(
                      controller: _tabController,
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
                      tabs: List.generate(sourcesList.length, (index) {
                        final isSelected = currentCubit.selectedTab == index;
                        return Tab(
                          child: Text(
                            sourcesList[index].name,
                            style: isSelected
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context).textTheme.titleSmall,
                          ),
                        );
                      }),
                    ),
                  ],
                );
              case SourcesStateUpdated():
                return const SizedBox.shrink();
            }
          },
        ),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is LoadingGetAllArticlesState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SuccessGetAllArticlesState) {
                var articlesList = state.articlesList;
                if (articlesList.isEmpty) {
                  return const Center(child: Text("No articles found"));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Bounceable(
                      onTap: () {
                        _showArticleBottomSheet(context, articlesList[index]);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.black),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _buildArticleImage(articlesList[index]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              articlesList[index].title,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "By: ${articlesList[index].author ?? 'Unknown'}",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    articlesList[index].publishedAt,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
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
                    return const SizedBox.shrink();
                  },
                  itemCount: articlesList.length,
                );
              }
              if (state is ErrorGetAllArticlesState) {
                return const Center(child: Text("Error loading articles"));
              }
              return const Center(
                child: Text("Select a source to view articles"),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArticleImage(ArticleData article, {double? height}) {
    final imageUrl = article.urlToImage;
    final imageHeight = height ?? 200.0;

    if (imageUrl.isEmpty) {
      return Container(
        height: imageHeight,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          size: 48,
          color: Colors.grey,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: imageHeight,
      width: double.infinity,
      placeholder: (context, url) => Container(
        height: imageHeight,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: imageHeight,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _showArticleBottomSheet(BuildContext context, ArticleData article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12, bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Header with title and source
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            article.sourceName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(article.publishedAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Article image
              if (article.urlToImage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildArticleImage(article, height: 200),
                  ),
                ),

              if (article.urlToImage.isNotEmpty) const SizedBox(height: 20),

              // Description
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.description,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(height: 1.6, color: Colors.grey[800]),
                        ),

                        if (article.author != null &&
                            article.author!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            "Author",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.author!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Action button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text("Read Full Article"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
