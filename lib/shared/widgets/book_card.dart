import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/domain/entities/book.dart';

/// Book card widget for displaying book information
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onFavoriteToggle,
  });
  
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book cover
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.coverUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: AppColors.greyLight,
                      child: const Icon(
                        Icons.book,
                        size: 40,
                        color: AppColors.grey,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Author
                    Text(
                      book.author,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        book.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Duration and rating
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.formattedDuration,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        if (book.rating != null) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            book.rating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    if (book.progress > 0) ...[
                      const SizedBox(height: 8),
                      // Progress bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                book.formattedProgress,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: book.progress,
                            backgroundColor: AppColors.greyLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Favorite button
              IconButton(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  book.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: book.isFavorite ? AppColors.error : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
