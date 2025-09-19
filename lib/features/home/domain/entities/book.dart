import 'package:equatable/equatable.dart';

/// Book entity representing a book in the system
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    required this.category,
    this.rating,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.progress = 0.0,
    this.createdAt,
    this.updatedAt,
  });
  
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final String category;
  final double? rating;
  final bool isFavorite;
  final bool isDownloaded;
  final double progress; // 0.0 to 1.0
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    coverUrl,
    audioUrl,
    duration,
    category,
    rating,
    isFavorite,
    isDownloaded,
    progress,
    createdAt,
    updatedAt,
  ];
  
  /// Create a copy of this book with updated fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? audioUrl,
    Duration? duration,
    String? category,
    double? rating,
    bool? isFavorite,
    bool? isDownloaded,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Format duration as string
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// Format progress as percentage
  String get formattedProgress {
    return '${(progress * 100).toInt()}%';
  }
}
