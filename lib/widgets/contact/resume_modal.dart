import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ResumeModal extends StatelessWidget {
  const ResumeModal({super.key});

  Future<void> _launchUrlSafe(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {}
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        backgroundColor: AppColors.cyan,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isDesktop ? 800 : screenWidth * 0.94,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0C1220),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.cyan.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.85),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.2),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description_rounded,
                            size: 24, color: AppColors.cyan),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vyshnav A — Curriculum Vitae',
                              style: AppTypography.titleLarge
                                  .copyWith(fontSize: 18)),
                          Text('Flutter Developer • 2+ Years Production Experience',
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.cardBorder, height: 28),

              // Action Toolbar
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _buildActionButton(
                    label: 'Email Vyshnav',
                    icon: Icons.email_rounded,
                    color: AppColors.cyan,
                    onTap: () =>
                        _launchUrlSafe('mailto:vyshnavanchery0@gmail.com'),
                  ),
                  _buildActionButton(
                    label: 'Call +91 9539386773',
                    icon: Icons.phone_rounded,
                    color: AppColors.emerald,
                    onTap: () => _launchUrlSafe('tel:+919539386773'),
                  ),
                  _buildActionButton(
                    label: 'Copy Email',
                    icon: Icons.copy_rounded,
                    color: AppColors.purple,
                    onTap: () => _copyToClipboard(
                        context, 'vyshnavanchery0@gmail.com', 'Email address'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scrollable Resume Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080D18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Resume Top Info
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Vyshnav A',
                                style: AppTypography.titleLarge.copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Flutter Developer',
                                style: AppTypography.codeBadge.copyWith(
                                  fontSize: 14,
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Calicut, Kerala | vyshnavanchery0@gmail.com | +91 9539386773',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: AppColors.cardBorder, height: 28),

                        // Section 1: Professional Summary
                        _buildResumeSectionHeader('PROFESSIONAL SUMMARY'),
                        const SizedBox(height: 6),
                        Text(
                          'Flutter Developer with 2+ years of experience building and shipping production mobile applications across sales automation, logistics, transport, and Out-of-Home advertising platforms. Experienced in Flutter, Dart, BLoC, Clean Architecture, REST APIs, offline-first development, real-time communication, and third-party SDK integrations. Strong hands-on experience with Hive, Dio, Firebase, AWS S3, WebSockets, RabbitMQ, Google Maps, Razorpay, and Agora.',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 13,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Experience
                        _buildResumeSectionHeader('EXPERIENCE'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Team Tweaks Technologies Pvt Ltd | Flutter Developer',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 14,
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Jun 2024 – Present | Chennai, Tamil Nadu',
                              style: AppTypography.codeBadge.copyWith(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildResumeBullet(
                          'Served as primary Flutter developer across multiple production applications, delivering end-to-end features in collaboration with backend engineers; contributed to ODA as part of a 2-developer Flutter team alongside a senior Flutter developer, while also supporting several additional client projects across diverse domains.',
                        ),
                        _buildResumeBullet(
                          'Contributed to an offline-first supply chain application (Outbound Delivery & Warehouse Management – ODA) built with BLoC, GetIt, and Hive for operations in low-connectivity environments. Added Hive-to-Excel/CSV data export and Excel/CSV-to-Hive import to support offline data exchange and synchronization. Integrated RabbitMQ for real-time communication and AWS S3 for secure Proof of Delivery uploads using custom camera functionality.',
                        ),
                        _buildResumeBullet(
                          'Delivered a sales force automation application (EWF SFA) actively used by 30+ field employees for over a year, processing 10,000+ orders and 10,000+ payment collections. Built features using Flutter, BLoC, Dio, Google Maps API, Hive, AWS S3, and Firebase, including offline order caching, background file synchronization using AWS Signature Version 4, and application monitoring with Firebase Crashlytics.',
                        ),
                        _buildResumeBullet(
                          'Built a real-time transport booking ecosystem (Party to Driver) with role-based workflows. Integrated WebSockets for live location sharing, Razorpay for subscription payments, and Agora SDK for voice communication. Added multilingual support across 5 languages and used GoRouter for application navigation.',
                        ),
                        _buildResumeBullet(
                          'Contributing to a multi-application Out-of-Home advertising platform (Adnexo) consisting of three Flutter applications for End Users, Relationship Managers, and Mounter/Site Owners. Building role-specific workflows using Clean Architecture, BLoC, GoRouter, Dio, and REST APIs.',
                        ),
                        _buildResumeBullet(
                          'Configured and maintained Dev, Staging, and Production environments using Flutter Flavors, supporting QA testing, environment-specific configurations, and mobile application deployment workflows.',
                        ),
                        _buildResumeBullet(
                          'Contributed to additional client projects including TripCity, Cashipe, Style Buddy, Sapacare Vet Hospital Management, Backhoe Bos, and Unimation Robotics, gaining exposure to diverse product domains and client requirements.',
                        ),
                        const SizedBox(height: 20),

                        // Section 3: Skills
                        _buildResumeSectionHeader('TECHNICAL SKILLS'),
                        const SizedBox(height: 8),
                        _buildSkillRow('Languages & Frameworks', 'Dart, Flutter'),
                        _buildSkillRow('State Management',
                            'BLoC, Riverpod, Provider'),
                        _buildSkillRow('Architecture & Dev',
                            'Clean Architecture, MVVM, RESTful APIs, Dependency Injection, GetIt'),
                        _buildSkillRow(
                            'Databases & Storage', 'Hive, SQLite, Firebase Firestore'),
                        _buildSkillRow('Networking & Real-Time',
                            'Dio, WebSockets, RabbitMQ'),
                        _buildSkillRow('Cloud & Backend',
                            'AWS S3, Firebase FCM, Firebase Crashlytics, Supabase'),
                        _buildSkillRow('Third-Party SDKs & APIs',
                            'Google Maps API, Razorpay, Stripe, Agora SDK'),
                        _buildSkillRow('Tools & Practices',
                            'Git, GitHub, GitLab, CI/CD, Flutter Flavors, Postman, Jira, Agile/Scrum, Mobile App Deployment'),
                        const SizedBox(height: 20),

                        // Section 4: Education
                        _buildResumeSectionHeader('EDUCATION'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calicut University — Bachelor of Computer Applications (BCA)',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Nov 2018 – May 2021',
                              style: AppTypography.codeBadge.copyWith(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.5),
        ),
      ),
      child: Text(
        title,
        style: AppTypography.codeBadge.copyWith(
          fontSize: 12,
          color: AppColors.cyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildResumeBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 5, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String category, String items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              '• $category:',
              style: AppTypography.codeBadge.copyWith(
                fontSize: 11,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              items,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.codeBadge.copyWith(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
