import 'package:flutter/material.dart';
import '../../models/skill_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/tilt_card.dart';

class SkillsMatrixSection extends StatefulWidget {
  const SkillsMatrixSection({super.key});

  @override
  State<SkillsMatrixSection> createState() => _SkillsMatrixSectionState();
}

class _SkillsMatrixSectionState extends State<SkillsMatrixSection> {
  String _selectedCategory = 'all';

  List<SkillItem> get _filteredSkills {
    if (_selectedCategory == 'all') {
      return SkillsData.skills;
    }
    return SkillsData.skills
        .where((s) => s.categoryId == _selectedCategory)
        .toList();
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
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'TECHNICAL ARSENAL',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Specialized Skills & Core Competencies',
              style: AppTypography.displaySmall.copyWith(
                fontSize: isDesktop ? 34 : 26,
              )),
          const SizedBox(height: 8),
          Text(
            'Battle-tested in shipping high-volume production applications with offline resilience, real-time telematics, and clean maintainable codebases.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 28),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: SkillsData.categories.map((cat) {
                final isSelected = _selectedCategory == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat.id;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.cyan.withValues(alpha: 0.15)
                              : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.cyan
                                : AppColors.cardBorder,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.cyan.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cat.icon,
                              size: 16,
                              color: isSelected
                                  ? AppColors.cyan
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cat.name,
                              style: AppTypography.codeBadge.copyWith(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Skills Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount;
              if (width > 1200) {
                crossAxisCount = 3;
              } else if (width > 760) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              final itemWidth =
                  (width - (crossAxisCount - 1) * 20) / crossAxisCount;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: _filteredSkills.map((skill) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildSkillCard(skill),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(SkillItem skill) {
    return TiltCard(
      borderRadius: 18,
      hoverBorderColor: skill.accentColor,
      backgroundColor: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Level badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: skill.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: skill.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(skill.icon, size: 22, color: skill.accentColor),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  skill.experienceLevel,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 10,
                    color: skill.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Skill Name
          Text(
            skill.name,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            skill.description,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Animated Proficiency Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Proficiency',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${(skill.proficiency * 100).toInt()}%',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 11,
                      color: skill.accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 6,
                  color: const Color(0xFF1E293B),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: skill.proficiency),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: val,
                        child: Container(
                          decoration: BoxDecoration(
                            color: skill.accentColor,
                            boxShadow: [
                              BoxShadow(
                                color: skill.accentColor.withValues(alpha: 0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skill.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  tag,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
