import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

/// Book model for data layer
@JsonSerializable()
class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.description,
    required super.coverUrl,
    required super.audioUrl,
    required super.duration,
    required super.category,
    super.rating,
    super.isFavorite = false,
    super.isDownloaded = false,
    super.progress = 0.0,
    super.createdAt,
    super.updatedAt,
  });
  
  /// Create BookModel from JSON
  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
  
  /// Convert BookModel to JSON
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
  
  /// Create BookModel from Book entity
  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      coverUrl: book.coverUrl,
      audioUrl: book.audioUrl,
      duration: book.duration,
      category: book.category,
      rating: book.rating,
      isFavorite: book.isFavorite,
      isDownloaded: book.isDownloaded,
      progress: book.progress,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
  }
  
  /// Convert BookModel to Book entity
  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      description: description,
      coverUrl: coverUrl,
      audioUrl: audioUrl,
      duration: duration,
      category: category,
      rating: rating,
      isFavorite: isFavorite,
      isDownloaded: isDownloaded,
      progress: progress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
