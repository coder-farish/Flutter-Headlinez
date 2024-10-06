import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:news_app/common/colors.dart';
import 'package:news_app/models/listdata_model.dart';
import 'package:news_app/models/news_model.dart' as m;
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home/widgets/newsCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  int activeCategory = 0;
  int page = 1;
  bool isFinish = false;
  bool data = false;
  List<m.News> articles = [];

  @override
  void initState() {
    super.initState();
    getNewsData();
  }

  Future<bool> getNewsData() async {
    ListData listData = await NewsProvider()
        .GetEverything(categories[activeCategory].toString(), page++);

    if (listData.status) {
      List<m.News> items = listData.data as List<m.News>;
      data = true;

      if (mounted) {
        setState(() {});
      }

      if (items.length == listData.totalContent) {
        isFinish = true;
      }

      if (items.isNotEmpty) {
        articles.addAll(items);
        setState(() {});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 5,
        title: const Text(
          'The Headlinez Online',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            color: AppColors.white,
            tooltip: 'About',
            onPressed: () {
              _showAboutDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (BuildContext context, int index) {
                bool isActive = index == activeCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeCategory = index;
                      articles = [];
                      page = 1;
                      isFinish = false;
                      data = false;
                    });
                    getNewsData();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        categories[index].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(thickness: 1, color: Colors.grey), // Elegant divider
          Expanded(
            child: LoadMore(
              isFinish: isFinish,
              onLoadMore: getNewsData,
              whenEmptyLoad: true,
              delegate: const DefaultLoadMoreDelegate(),
              textBuilder: DefaultLoadMoreTextBuilder.english,
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  child: NewsCard(article: articles[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('The Headlinez Online'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Stay informed and up-to-date with the latest news from around the world using the app. Our sleek, modern interface delivers real-time news updates across various categories, including Business, Entertainment, Health, Science, Sports, Technology, and General news.'),
              const SizedBox(height: 10),
              const Text('Author: Muhammad Farhan (Flutter-270063)'),
              const SizedBox(height: 10),
              const Text('Version: 1.0.0'),
              const SizedBox(height: 10),
              const Text(
                  'This app is developed during learning of Flutter & Dart from SMIT'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
