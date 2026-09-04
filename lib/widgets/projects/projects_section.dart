import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/tilt_card.dart';
import 'client_projects_grid.dart';
import 'project_detail_modal.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  void _openProjectModal(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => ProjectDetailModal(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 980;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 20.0,
        vertical: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'FEATURED PRODUCTION WORK',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Enterprise Mobile Applications',
              style: AppTypography.displaySmall.copyWith(
                fontSize: isDesktop ? 34 : 26,
              )),
          const SizedBox(height: 8),
          Text(
            'Shipped and maintained in production, serving tens of thousands of active users, real-time logistics, and mission-critical workflows.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Primary Featured Project Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount;
              if (width > 900) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              final itemWidth =
                  (width - (crossAxisCount - 1) * 24) / crossAxisCount;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: ProjectModel.featuredProjects.map((project) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildProjectCard(context, project),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 48),

          // Additional Multi-Domain Client Projects Grid
          const ClientProjectsGrid(),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    return TiltCard(
      borderRadius: 20,
      hoverBorderColor: project.accentColor,
      backgroundColor: AppColors.cardBg,
      padding: const EdgeInsets.all(24),
      onTap: () => _openProjectModal(context, project),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Category Badge + Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Icon(project.icon, size: 24, color: project.accentColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          project.category,
                          style: AppTypography.codeBadge.copyWith(
                            fontSize: 10,
                            color: project.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Title & Role
          Text(
            project.title,
            style: AppTypography.titleLarge.copyWith(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.role,
            style: AppTypography.codeBadge.copyWith(
              fontSize: 11,
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(height: 12),

          // Summary
          Text(
            project.summary,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Metrics Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.metrics.entries.map((entry) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: project.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 10,
                    color: project.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Tech Stack Badges
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.techStack.take(5).map((tech) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  tech,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Click to view deep-dive architecture
          Row(
            children: [
              Flexible(
                child: Text(
                  'View Architecture & Deep Dive',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: project.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded,
                  size: 14, color: project.accentColor),
            ],
          ),
        ],
      ),
    );
  }
}
