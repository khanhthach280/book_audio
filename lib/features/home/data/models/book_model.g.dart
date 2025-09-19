// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      category: json['category'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'audioUrl': instance.audioUrl,
      'duration': instance.duration.inMicroseconds,
      'category': instance.category,
      'rating': instance.rating,
      'isFavorite': instance.isFavorite,
      'isDownloaded': instance.isDownloaded,
      'progress': instance.progress,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
