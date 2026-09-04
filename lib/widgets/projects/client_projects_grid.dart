import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/tilt_card.dart';

class ClientProjectsGrid extends StatelessWidget {
  const ClientProjectsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
              ),
              child: Text(
                'MULTI-DOMAIN CLIENT ECOSYSTEM',
                style: AppTypography.codeBadge.copyWith(
                  fontSize: 11,
                  color: AppColors.purple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Additional Production Client Projects',
            style: AppTypography.titleLarge.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text(
          'Contributed to end-to-end client applications across diverse industry sectors, adapting to unique architecture patterns and API backends.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount;
            if (width > 1100) {
              crossAxisCount = 3;
            } else if (width > 700) {
              crossAxisCount = 2;
            } else {
              crossAxisCount = 1;
            }

            final itemWidth =
                (width - (crossAxisCount - 1) * 16) / crossAxisCount;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: ProjectModel.clientEcosystem.map((client) {
                final color = client['color'] as Color;
                final icon = client['icon'] as IconData;

                return SizedBox(
                  width: itemWidth,
                  child: TiltCard(
                    borderRadius: 16,
                    hoverBorderColor: color,
                    backgroundColor: const Color(0xFF0D1424),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icon, size: 20, color: color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client['title'] as String,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    client['domain'] as String,
                                    style: AppTypography.codeBadge.copyWith(
                                      fontSize: 10,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          client['desc'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
