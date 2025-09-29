import 'package:flutter/material.dart';
import 'services/api_service.dart';
<<<<<<< HEAD
import 'dart:async';
=======
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Enhanced News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
=======
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
      ),
      home: const NewsListPage(),
    );
  }
}

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

<<<<<<< HEAD
class _NewsListPageState extends State<NewsListPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> news = [];
  List<dynamic> filteredNews = [];
  List<dynamic> categories = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedCategory = 'all';
  String searchQuery = '';

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  late TabController _tabController;
=======
class _NewsListPageState extends State<NewsListPage> {
  List news = [];
  bool isLoading = true;
  String? errorMessage;
  final ApiService _apiService = ApiService();
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _tabController = TabController(length: 1, vsync: this);
    loadNews();
    loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
=======
    loadNews();
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
  }

  Future<void> loadNews() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
<<<<<<< HEAD
=======
      // Test connection first
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
      final connected = await _apiService.testConnection();
      if (!connected) {
        if (!mounted) return;
        setState(() {
          errorMessage =
              "Cannot connect to server. Make sure your FastAPI server is running.";
          isLoading = false;
        });
        return;
      }

      final data = await _apiService.fetchNews();
      if (!mounted) return;
      setState(() {
        news = data;
<<<<<<< HEAD
        filteredNews = data;
=======
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Error loading news: $e";
        isLoading = false;
      });
    }
  }

<<<<<<< HEAD
  Future<void> loadCategories() async {
    try {
      final data = await _apiService.getCategories();
      if (!mounted) return;

      // Safely extract categories with null checks
      final newCats = (data['categories'] as List?)
              ?.where((cat) => cat != null)
              .toList() ??
          [];

      setState(() {
        categories = newCats;

        // Only recreate controller if length changed
        if (_tabController.length != categories.length + 1) {
          _tabController.dispose();
          _tabController = TabController(
            length: categories.length + 1,
            vsync: this,
          );
        }
      });
    } catch (e) {
      debugPrint('Failed to load categories: $e');
      // Ensure we have a valid controller even on error
      if (!mounted) return;
      setState(() {
        categories = [];
        if (_tabController.length != 1) {
          _tabController.dispose();
          _tabController = TabController(length: 1, vsync: this);
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query.toLowerCase();
        _applyFilters();
      });
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredNews = news.where((article) {
        if (article == null) return false;

        final articleCategory =
            article['category']?.toString().toLowerCase() ?? '';
        final articleTitle = article['title']?.toString().toLowerCase() ?? '';
        final articleSummary =
            article['summary']?.toString().toLowerCase() ?? '';

        bool categoryMatch = selectedCategory == 'all' ||
            articleCategory == selectedCategory.toLowerCase();

        bool searchMatch = searchQuery.isEmpty ||
            articleTitle.contains(searchQuery) ||
            articleSummary.contains(searchQuery);

        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  Future<void> showNewsDetails(int newsId, String title) async {
    try {
      final newsDetails = await _apiService.getNewsDetails(newsId);
=======
  Future<void> showNewsDetails(int newsId, String title) async {
    try {
      final newsDetails = await _apiService.getNewsDetails(newsId);

>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsDetailPage(
<<<<<<< HEAD
            article: newsDetails,
=======
            title: title,
            content: newsDetails['content'] ?? 'No content available',
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading news details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('Enhanced News'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadNews();
              loadCategories();
            },
            tooltip: 'Refresh',
          ),
        ],
        bottom: categories.isNotEmpty
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                onTap: (index) {
                  if (index == 0) {
                    _onCategoryChanged('all');
                  } else if (index - 1 < categories.length) {
                    final category = categories[index - 1];
                    if (category != null) {
                      final categoryName =
                          category['name']?.toString() ?? 'general';
                      _onCategoryChanged(categoryName);
                    }
                  }
                },
                tabs: [
                  const Tab(text: 'All'),
                  ...categories.map((cat) {
                    if (cat == null) {
                      return const Tab(text: 'Unknown (0)');
                    }
                    final displayName = cat['display_name']?.toString() ??
                        cat['name']?.toString() ??
                        'Unknown';
                    final count = cat['count']?.toString() ?? '0';
                    return Tab(text: '$displayName ($count)');
                  }),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? _buildErrorWidget()
                    : filteredNews.isEmpty
                        ? _buildEmptyWidget()
                        : RefreshIndicator(
                            onRefresh: loadNews,
                            child: ListView.builder(
                              itemCount: filteredNews.length,
                              itemBuilder: (context, index) {
                                final article = filteredNews[index];
                                if (article == null) {
                                  return const SizedBox.shrink();
                                }
                                return _buildArticleCard(article);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final articleId = article['id'];
          final articleTitle = article['title']?.toString() ?? 'No Title';

          if (articleId != null && articleId is int) {
            showNewsDetails(articleId, articleTitle);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid article ID'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article['category'] != null &&
                  article['category'].toString().isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(article['category'].toString()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article['category'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                article['title']?.toString() ?? 'No Title',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (article['summary'] != null &&
                  article['summary'].toString().isNotEmpty)
                Text(
                  article['summary'].toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(article['created_at']?.toString()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  if (article['source_file'] != null &&
                      article['source_file'].toString().isNotEmpty)
                    Chip(
                      label: Text(
                        article['source_file'].toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadNews,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    String message = searchQuery.isNotEmpty || selectedCategory != 'all'
        ? 'No articles found matching your criteria'
        : 'No news articles available';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isNotEmpty ? Icons.search_off : Icons.article_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (searchQuery.isNotEmpty || selectedCategory != 'all') ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  searchQuery = '';
                  selectedCategory = 'all';
                  try {
                    _tabController.animateTo(0);
                  } catch (_) {}
                  _applyFilters();
                });
              },
              child: const Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Colors.green;
      case 'politics':
        return Colors.red;
      case 'business':
        return Colors.blue;
      case 'technology':
        return Colors.purple;
      case 'entertainment':
        return Colors.orange;
      case 'health':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({
    super.key,
    required this.article,
=======
        title: const Text('News App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadNews,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: loadNews,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : news.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 64),
                          SizedBox(height: 16),
                          Text('No news articles available'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        final article = news[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              article['title'] ?? 'No Title',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              article['summary'] ?? (article['category'] ?? ''),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => showNewsDetails(
                              article['id'],
                              article['title'] ?? 'No Title',
                            ),
                          ),
                        );
                      },
                    ),
      // Removed PDF import button as requested
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.content,
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          article['title']?.toString() ?? 'Article',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing feature coming soon!')),
              );
            },
          ),
        ],
=======
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            if (article['category'] != null &&
                article['category'].toString().isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(article['category'].toString()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  article['category'].toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article['title']?.toString() ?? 'No Title',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(article['created_at']?.toString()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                if (article['source_file'] != null &&
                    article['source_file'].toString().isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.description,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      article['source_file'].toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            if (article['summary'] != null &&
                article['summary'].toString().isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  article['summary'].toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              article['content']?.toString() ?? 'No content available',
=======
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Colors.green;
      case 'politics':
        return Colors.red;
      case 'business':
        return Colors.blue;
      case 'technology':
        return Colors.purple;
      case 'entertainment':
        return Colors.orange;
      case 'health':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
=======
}
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
