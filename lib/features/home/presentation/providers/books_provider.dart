import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';

/// Books state for managing list of books
class BooksState {
  const BooksState({
    this.books = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });
  
  final List<Book> books;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final int currentPage;
  
  BooksState copyWith({
    List<Book>? books,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return BooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
  
  BooksState clearError() {
    return copyWith(error: null);
  }
  
  BooksState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }
  
  BooksState setLoadingMore(bool loading) {
    return copyWith(isLoadingMore: loading);
  }
  
  BooksState setBooks(List<Book> books, {bool hasMore = true}) {
    return copyWith(
      books: books,
      hasMore: hasMore,
      isLoading: false,
      isLoadingMore: false,
      error: null,
    );
  }
  
  BooksState addBooks(List<Book> newBooks, {bool hasMore = true}) {
    return copyWith(
      books: [...books, ...newBooks],
      hasMore: hasMore,
      isLoading: false,
      isLoadingMore: false,
      error: null,
    );
  }
  
  BooksState setError(String error) {
    return copyWith(
      error: error,
      isLoading: false,
      isLoadingMore: false,
    );
  }
  
  BooksState updateBook(Book updatedBook) {
    final updatedBooks = books.map((book) {
      return book.id == updatedBook.id ? updatedBook : book;
    }).toList();
    
    return copyWith(books: updatedBooks);
  }
}

/// Books provider
final booksProvider = StateNotifierProvider<BooksNotifier, BooksState>((ref) {
  return BooksNotifier();
});

/// Books notifier for managing books state
class BooksNotifier extends StateNotifier<BooksState> {
  BooksNotifier() : super(const BooksState()) {
    loadBooks();
  }
  
  /// Load initial books
  Future<void> loadBooks({bool refresh = false}) async {
    if (refresh) {
      state = state.setLoading(true).clearError();
    } else {
      state = state.setLoading(true).clearError();
    }
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final books = _generateMockBooks(1, 20);
      state = state.setBooks(books, hasMore: true);
    } catch (e) {
      state = state.setError('Failed to load books');
    }
  }
  
  /// Load more books for pagination
  Future<void> loadMoreBooks() async {
    if (state.isLoadingMore || !state.hasMore) return;
    
    state = state.setLoadingMore(true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final nextPage = state.currentPage + 1;
      final newBooks = _generateMockBooks(nextPage, 20);
      
      state = state.addBooks(newBooks, hasMore: nextPage < 5); // Simulate 5 pages max
    } catch (e) {
      state = state.setError('Failed to load more books');
    }
  }
  
  /// Refresh books
  Future<void> refreshBooks() async {
    await loadBooks(refresh: true);
  }
  
  /// Toggle favorite status
  Future<void> toggleFavorite(String bookId) async {
    try {
      final book = state.books.firstWhere((book) => book.id == bookId);
      final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
      state = state.updateBook(updatedBook);
    } catch (e) {
      state = state.setError('Failed to update favorite status');
    }
  }
  
  /// Update book progress
  Future<void> updateProgress(String bookId, double progress) async {
    try {
      final book = state.books.firstWhere((book) => book.id == bookId);
      final updatedBook = book.copyWith(progress: progress);
      state = state.updateBook(updatedBook);
    } catch (e) {
      state = state.setError('Failed to update progress');
    }
  }
  
  /// Clear error
  void clearError() {
    state = state.clearError();
  }
  
  /// Generate mock books for demonstration
  List<Book> _generateMockBooks(int page, int count) {
    final books = <Book>[];
    final startIndex = (page - 1) * count;
    
    for (int i = 0; i < count; i++) {
      final index = startIndex + i;
      books.add(Book(
        id: 'book_$index',
        title: 'Book Title ${index + 1}',
        author: 'Author ${index + 1}',
        description: 'This is a description for book ${index + 1}. It contains interesting content that will keep you engaged.',
        coverUrl: 'https://picsum.photos/200/300?random=$index',
        audioUrl: 'https://example.com/audio/$index.mp3',
        duration: Duration(minutes: 30 + (index % 120)),
        category: _getCategory(index),
        rating: 3.5 + (index % 3) * 0.5,
        isFavorite: index % 3 == 0,
        isDownloaded: index % 5 == 0,
        progress: (index % 10) / 10.0,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(hours: index)),
      ));
    }
    
    return books;
  }
  
  String _getCategory(int index) {
    final categories = ['Fiction', 'Non-Fiction', 'Science', 'History', 'Biography', 'Self-Help'];
    return categories[index % categories.length];
  }
}

/// Books list provider
final booksListProvider = Provider<List<Book>>((ref) {
  final booksState = ref.watch(booksProvider);
  return booksState.books;
});

/// Is loading books provider
final isBooksLoadingProvider = Provider<bool>((ref) {
  final booksState = ref.watch(booksProvider);
  return booksState.isLoading;
});

/// Is loading more books provider
final isBooksLoadingMoreProvider = Provider<bool>((ref) {
  final booksState = ref.watch(booksProvider);
  return booksState.isLoadingMore;
});

/// Books error provider
final booksErrorProvider = Provider<String?>((ref) {
  final booksState = ref.watch(booksProvider);
  return booksState.error;
});

/// Has more books provider
final hasMoreBooksProvider = Provider<bool>((ref) {
  final booksState = ref.watch(booksProvider);
  return booksState.hasMore;
});
