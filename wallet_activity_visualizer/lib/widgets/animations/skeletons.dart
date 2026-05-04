import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surface2,
      highlightColor: AppTheme.border,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 80, height: 11),
          SizedBox(height: 10),
          ShimmerBox(width: 120, height: 24),
          SizedBox(height: 6),
          ShimmerBox(width: 60, height: 11),
        ],
      ),
    );
  }
}

class TxRowSkeleton extends StatelessWidget {
  const TxRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 36, height: 36, radius: 10),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 12),
                SizedBox(height: 6),
                ShimmerBox(width: 80, height: 11),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 70, height: 12),
              SizedBox(height: 6),
              ShimmerBox(width: 50, height: 11),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartSkeleton extends StatelessWidget {
  final double height;
  const ChartSkeleton({super.key, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 100, height: 11),
            const SizedBox(height: 16),
            Expanded(child: ShimmerBox(height: height - 60, radius: 8)),
          ],
        ),
      ),
    );
  }
}
