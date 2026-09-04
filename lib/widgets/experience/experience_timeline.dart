import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/tilt_card.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

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
          // Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'CAREER JOURNEY',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.amber,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Experience & Education',
              style: AppTypography.displaySmall.copyWith(
                fontSize: isDesktop ? 34 : 26,
              )),
          const SizedBox(height: 8),
          Text(
            'Demonstrated track record of delivering production-ready mobile systems, architecting offline-first applications, and collaborating with cross-functional engineering teams.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Experience Item 1: Team Tweaks Technologies
          _buildExperienceItem(
            isDesktop: isDesktop,
            period: 'Jun 2024 – Present',
            isCurrent: true,
            role: 'Flutter Developer',
            company: 'Team Tweaks Technologies Pvt Ltd',
            location: 'Chennai, Tamil Nadu',
            highlights: [
              'Served as primary Flutter developer across multiple production applications, delivering end-to-end features in close collaboration with backend and product engineers.',
              'Contributed to ODA (Outbound Delivery & Warehouse Management) within a 2-developer Flutter team alongside a senior Flutter developer for low-connectivity offline-first warehouse operations.',
              'Developed bidirectional Hive-to-Excel/CSV data export and Excel/CSV-to-Hive import to support field data synchronization under zero-network conditions.',
              'Delivered EWF SFA actively used by 30+ field employees for over a year, processing 10,000+ orders and 10,000+ payment collections with AWS SigV4 background sync.',
              'Built real-time transport booking ecosystem (Party to Driver) with WebSockets, Razorpay payments, Agora audio voice SDK, and 5-language localization.',
              'Building role-specific workflows for Adnexo Out-of-Home advertising suite across 3 separate Flutter applications using Clean Architecture and BLoC.',
              'Configured and maintained Dev, Staging, and Production environments using Flutter Flavors, supporting QA testing and mobile application deployment workflows.',
              'Delivered features across client projects: TripCity, Cashipe, Style Buddy, Sapacare Vet Hospital, Backhoe Bos, and Unimation Robotics.',
            ],
            techUsed: [
              'Flutter',
              'Dart',
              'BLoC',
              'Clean Architecture',
              'Hive',
              'Dio',
              'WebSockets',
              'RabbitMQ',
              'AWS S3 (SigV4)',
              'Agora SDK',
              'Google Maps API',
              'Razorpay',
              'Flutter Flavors',
            ],
          ),
          const SizedBox(height: 32),

          // Education Item 2: Calicut University
          _buildEducationItem(
            isDesktop: isDesktop,
            period: 'Nov 2018 – May 2021',
            degree: 'Bachelor of Computer Applications (BCA)',
            institution: 'Calicut University',
            location: 'Calicut, Kerala',
            description:
                'Solid academic grounding in computer science fundamentals, data structures, algorithms, object-oriented software engineering, relational databases, and modern programming languages.',
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required bool isDesktop,
    required String period,
    required bool isCurrent,
    required String role,
    required String company,
    required String location,
    required List<String> highlights,
    required List<String> techUsed,
  }) {
    return TiltCard(
      borderRadius: 22,
      hoverBorderColor: AppColors.cyan,
      backgroundColor: AppColors.cardBg,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period & Current Beacon
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
                child: Text(
                  period,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.emerald.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.emerald,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'CURRENT ROLE',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Role & Company
          Text(
            role,
            style: AppTypography.titleLarge.copyWith(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                company,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 15,
                  color: AppColors.cyan,
                ),
              ),
              Text(
                '• $location',
                style: AppTypography.bodySmall.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Key Highlights
          ...highlights.map((h) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.arrow_right_rounded,
                        size: 20, color: AppColors.cyan),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      h,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),

          // Tech stack tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: techUsed.map((tech) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildEducationItem({
    required bool isDesktop,
    required String period,
    required String degree,
    required String institution,
    required String location,
    required String description,
  }) {
    return TiltCard(
      borderRadius: 20,
      hoverBorderColor: AppColors.purple,
      backgroundColor: AppColors.cardBg,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                ),
                child: Text(
                  period,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded,
                    size: 18, color: AppColors.purple),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            degree,
            style: AppTypography.titleLarge.copyWith(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$institution • $location',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
