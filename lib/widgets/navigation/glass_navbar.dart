import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class GlassNavbar extends StatelessWidget {
  final VoidCallback onAboutTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onArchitectureTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;
  final VoidCallback onViewResume;

  const GlassNavbar({
    super.key,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onArchitectureTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
    required this.onViewResume,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 980;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 20,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF080D18).withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.cardBorder,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Monogram + Name
              GestureDetector(
                onTap: onAboutTap,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.cyanPurpleGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.35),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'VA',
                          style: AppTypography.codeBadge.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Vyshnav A',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Flutter Developer',
                            style: AppTypography.codeBadge.copyWith(
                              fontSize: 11,
                              color: AppColors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right: Navigation Items for Desktop
              if (isDesktop)
                Row(
                  children: [
                    _buildNavItem('About', onAboutTap),
                    _buildNavItem('Skills', onSkillsTap),
                    _buildNavItem('Architecture', onArchitectureTap),
                    _buildNavItem('Projects', onProjectsTap),
                    _buildNavItem('Experience', onExperienceTap),
                    _buildNavItem('Contact', onContactTap),
                    const SizedBox(width: 16),

                    // Resume button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onViewResume,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.cyanPurpleGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.description_rounded,
                                  size: 14, color: Colors.black),
                              const SizedBox(width: 6),
                              Text(
                                'Resume',
                                style: AppTypography.codeBadge.copyWith(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Mobile Action Menu
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.description_rounded,
                          color: AppColors.cyan, size: 20),
                      onPressed: onViewResume,
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => _openMobileMenu(context),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: AppTypography.codeBadge.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C1220),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.cardBorder),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              _buildMobileDrawerItem(context, 'About', onAboutTap),
              _buildMobileDrawerItem(context, 'Skills Arsenal', onSkillsTap),
              _buildMobileDrawerItem(
                  context, 'Architecture Simulator', onArchitectureTap),
              _buildMobileDrawerItem(
                  context, 'Featured Projects', onProjectsTap),
              _buildMobileDrawerItem(
                  context, 'Experience Journey', onExperienceTap),
              _buildMobileDrawerItem(context, 'Get in Touch', onContactTap),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onViewResume();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanPurpleGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'View & Print Full Resume',
                    style: AppTypography.codeBadge.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawerItem(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(fontSize: 15),
      ),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: AppColors.cyan),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
