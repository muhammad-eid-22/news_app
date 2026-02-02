import 'package:flutter/material.dart';
import 'package:news_app/screens/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), actions: [Icon(Icons.search)]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Text(
              "Good Morning\nHere is Some News For You",
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => CategoryCard(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
