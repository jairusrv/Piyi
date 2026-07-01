import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../data/business_review.dart';
import '../data/business_reviews_repository.dart';
import 'business_reviews_controller.dart';

class BusinessReviewSummaryCard extends ConsumerWidget {
  const BusinessReviewSummaryCard({
    super.key,
    required this.businessId,
  });

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(businessReviewSummaryProvider(businessId));

    return summaryAsync.when(
      data: (summary) => PiyiCard(
        child: Row(
          children: [
            const Icon(Icons.star, color: PiyiColors.warning, size: 42),
            const SizedBox(width: PiyiSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary.averageRating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  Text('${summary.totalReviews} reseñas'),
                ],
              ),
            ),
            _Stars(value: summary.averageRating.round()),
          ],
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const PiyiLoadingCard(),
    );
  }
}

class BusinessReviewsList extends ConsumerWidget {
  const BusinessReviewsList({
    super.key,
    required this.businessId,
  });

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(businessReviewsProvider(businessId));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const PiyiEmptyState(
            icon: Icons.rate_review_outlined,
            title: 'Aún no hay reseñas',
            message: 'Sé la primera persona en calificar este negocio.',
          );
        }

        return Column(
          children: reviews
              .map(
                (review) => Padding(
                  padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
                  child: BusinessReviewCard(
                    businessId: businessId,
                    review: review,
                  ),
                ),
              )
              .toList(),
        );
      },
      error: (error, _) => PiyiEmptyState(
        icon: Icons.error_outline,
        title: 'No pudimos cargar reseñas',
        message: '$error',
      ),
      loading: () => const PiyiLoadingList(itemCount: 3),
    );
  }
}

class BusinessReviewCard extends ConsumerWidget {
  const BusinessReviewCard({
    super.key,
    required this.businessId,
    required this.review,
  });

  final String businessId;
  final BusinessReview review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PiyiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PiyiAvatar(name: review.userName ?? 'Usuario', size: 42, icon: Icons.person),
              const SizedBox(width: PiyiSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Usuario Piyí',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    _Stars(value: review.rating),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.flag_outlined),
                onPressed: () async {
                  await ref.read(businessReviewsRepositoryProvider).reportReview(
                        businessId: businessId,
                        reviewId: review.id,
                        reason: 'Reportada desde la app',
                      );
                  if (context.mounted) {
                    PiyiSnackBar.success(context, 'Reseña reportada.');
                  }
                },
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: PiyiSpacing.sm),
            Text(review.comment!),
          ],
          if (review.businessReply != null && review.businessReply!.isNotEmpty) ...[
            const SizedBox(height: PiyiSpacing.sm),
            PiyiAlertCard(
              title: 'Respuesta del negocio',
              subtitle: review.businessReply!,
            ),
          ],
        ],
      ),
    );
  }
}

class CreateBusinessReviewCard extends ConsumerStatefulWidget {
  const CreateBusinessReviewCard({
    super.key,
    required this.businessId,
  });

  final String businessId;

  @override
  ConsumerState<CreateBusinessReviewCard> createState() => _CreateBusinessReviewCardState();
}

class _CreateBusinessReviewCardState extends ConsumerState<CreateBusinessReviewCard> {
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(businessReviewsRepositoryProvider).createReview(
            businessId: widget.businessId,
            rating: _rating,
            comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
          );

      ref.invalidate(businessReviewsProvider(widget.businessId));
      ref.invalidate(businessReviewSummaryProvider(widget.businessId));

      _commentController.clear();

      if (mounted) {
        PiyiSnackBar.success(context, 'Reseña publicada.');
      }
    } catch (e) {
      if (mounted) {
        PiyiSnackBar.error(context, 'No se pudo publicar la reseña.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Califica este negocio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: PiyiSpacing.sm),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                icon: Icon(
                  value <= _rating ? Icons.star : Icons.star_border,
                  color: PiyiColors.warning,
                ),
                onPressed: () => setState(() => _rating = value),
              );
            }),
          ),
          PiyiTextField(
            controller: _commentController,
            label: 'Comentario',
            hint: 'Cuéntanos cómo fue tu experiencia',
            icon: Icons.comment,
            maxLines: 3,
          ),
          const SizedBox(height: PiyiSpacing.sm),
          PiyiPrimaryButton(
            label: 'Publicar reseña',
            icon: Icons.send,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: PiyiColors.warning,
          size: 18,
        );
      }),
    );
  }
}
