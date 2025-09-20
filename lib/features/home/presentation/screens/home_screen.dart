import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/book_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/books_provider.dart';

/// Home screen widget
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(booksProvider.notifier).loadMoreBooks();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(booksProvider.notifier).refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          // Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildBody(booksState, l10n),
      ),
    );
  }

  Widget _buildBody(BooksState booksState, AppLocalizations l10n) {
    if (booksState.isLoading && booksState.books.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    if (booksState.error != null && booksState.books.isEmpty) {
      return Center(
        child: CustomErrorWidget(
          message: booksState.error!,
          onRetry: () {
            ref.read(booksProvider.notifier).clearError();
            ref.read(booksProvider.notifier).loadBooks();
          },
        ),
      );
    }

    if (booksState.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noData,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.pullToRefresh,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: booksState.books.length + (booksState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < booksState.books.length) {
          final book = booksState.books[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BookCard(
              book: book,
              onTap: () {
                // TODO: Navigate to book details
              },
              onFavoriteToggle: () {
                ref.read(booksProvider.notifier).toggleFavorite(book.id);
              },
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: LoadingIndicator()),
          );
        }
      },
    );
  }
}
