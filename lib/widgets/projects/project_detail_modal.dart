import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Modal dialog providing architectural deep-dive into each production application.
class ProjectDetailModal extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailModal({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isDesktop ? 750 : screenWidth * 0.92,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: project.accentColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: project.accentColor.withValues(alpha: 0.2),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: project.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: project.accentColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(project.icon,
                              size: 26, color: project.accentColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.category.toUpperCase(),
                                style: AppTypography.codeBadge.copyWith(
                                  fontSize: 10,
                                  color: project.accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                project.title,
                                style: AppTypography.titleLarge.copyWith(
                                  fontSize: isDesktop ? 20 : 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                project.role,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.cardBorder, height: 32),

              // Scrollable Details Body
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary
                      Text(
                        'OVERVIEW & MISSION',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        project.summary,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Metrics Highlights
                      Text(
                        'PRODUCTION BENCHMARKS',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: project.metrics.entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: project.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    project.accentColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key.toUpperCase(),
                                  style: AppTypography.codeBadge.copyWith(
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: AppTypography.codeBadge.copyWith(
                                    fontSize: 12,
                                    color: project.accentColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Key Engineering Contributions
                      Text(
                        'ENGINEERING CONTRIBUTIONS & SOLUTIONS',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...project.bulletPoints.map((point) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 16,
                                  color: project.accentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  point,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Architecture Note Callout
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090E17),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.hub_rounded,
                                size: 18, color: AppColors.cyan),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Architecture Blueprint',
                                    style: AppTypography.codeBadge.copyWith(
                                      fontSize: 11,
                                      color: AppColors.cyan,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    project.architectureNote,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Tech Stack Tags
                      Text(
                        'TECHNOLOGY STACK',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.techStack.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Text(
                              tech,
                              style: AppTypography.codeBadge.copyWith(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
