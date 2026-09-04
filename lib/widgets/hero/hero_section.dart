import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/animated_counter.dart';
import '../animations/pulse_badge.dart';
import 'interactive_phone_mockup.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onExploreProjects;
  final VoidCallback onTestArchitecture;
  final VoidCallback onContactTap;
  final VoidCallback onViewResume;

  const HeroSection({
    super.key,
    required this.onExploreProjects,
    required this.onTestArchitecture,
    required this.onContactTap,
    required this.onViewResume,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _roleController;
  int _currentRoleIndex = 0;
  final List<String> _roles = [
    'Flutter Developer',
    'Mobile Application Architect',
    'Offline-First Specialist (Hive & S3)',
    'Real-Time Systems (WebSockets & Agora)',
    'Clean Architecture & BLoC Expert',
  ];

  @override
  void initState() {
    super.initState();
    _roleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentRoleIndex = (_currentRoleIndex + 1) % _roles.length;
          });
          _roleController.forward(from: 0.0);
        }
      });
    _roleController.forward();
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _launchUrlSafe(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 980;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 20.0,
        vertical: isDesktop ? 60.0 : 30.0,
      ),
      child: Column(
        children: [
          // Main Hero Row / Column
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildHeroTextContent(isDesktop: true),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 5,
                  child: Center(child: const InteractivePhoneMockup()),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeroTextContent(isDesktop: false),
                const SizedBox(height: 48),
                Center(child: const InteractivePhoneMockup()),
              ],
            ),

          const SizedBox(height: 70),

          // High-Impact Production Metrics Bar
          _buildMetricsBar(isDesktop),
        ],
      ),
    );
  }

  Widget _buildHeroTextContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Status badge
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment:
              isDesktop ? WrapAlignment.start : WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const PulseBadge(
              label: 'AVAILABLE FOR HIGH-IMPACT ROLES',
              color: AppColors.emerald,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.cyan),
                  const SizedBox(width: 4),
                  Text(
                    'Calicut • Chennai, India',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Name headline
        RichText(
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Hi, I'm ",
                style: AppTypography.displayLarge.copyWith(
                  fontSize: isDesktop ? 54 : 36,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.heroGradient.createShader(bounds),
                  child: Text(
                    'Vyshnav A',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: isDesktop ? 54 : 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Animated Cycling Title
        Container(
          height: 38,
          alignment:
              isDesktop ? Alignment.centerLeft : Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _roles[_currentRoleIndex],
              key: ValueKey<int>(_currentRoleIndex),
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.cyan,
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary Description
        Text(
          'Flutter Developer with 2+ years of hands-on experience building and shipping mission-critical mobile applications across sales automation, supply chain logistics, real-time transport, and Out-of-Home advertising. Specialist in Clean Architecture, BLoC, offline-first data sync (Hive/AWS S3), and live WebSockets.',
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            fontSize: isDesktop ? 16 : 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),

        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 14,
          alignment:
              isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            // Primary: Explore Projects
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onExploreProjects,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanPurpleGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Flexible(
                        child: Text(
                          'Explore Featured Projects',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_downward_rounded,
                          size: 16, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),

            // Secondary: Test Architecture Simulator
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onTestArchitecture,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.cyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.memory_rounded,
                          size: 18, color: AppColors.cyan),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Architecture Simulator',
                          style: AppTypography.codeBadge.copyWith(
                            color: AppColors.cyan,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tertiary: View / Download Resume
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onViewResume,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.description_outlined,
                          size: 18, color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'View Full Resume',
                          style: AppTypography.codeBadge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Quick Social Links & Direct Contacts
        Wrap(
          spacing: 14,
          runSpacing: 10,
          alignment:
              isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _buildSocialPill(
              label: 'Email',
              detail: 'vyshnavanchery0@gmail.com',
              icon: Icons.alternate_email_rounded,
              onTap: () => _launchUrlSafe('mailto:vyshnavanchery0@gmail.com'),
            ),
            _buildSocialPill(
              label: 'Phone',
              detail: '+91 9539386773',
              icon: Icons.phone_rounded,
              onTap: () => _launchUrlSafe('tel:+919539386773'),
            ),
            _buildSocialPill(
              label: 'LinkedIn',
              detail: 'Connect',
              icon: Icons.link_rounded,
              onTap: () =>
                  _launchUrlSafe('https://www.linkedin.com/in/vyshnav-a'),
            ),
            _buildSocialPill(
              label: 'GitHub',
              detail: 'Code',
              icon: Icons.code_rounded,
              onTap: () => _launchUrlSafe('https://github.com'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialPill({
    required String label,
    required String detail,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF101626),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.cyan),
              const SizedBox(width: 6),
              Text(
                '$label: ',
                style: AppTypography.codeBadge.copyWith(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
              Flexible(
                child: Text(
                  detail,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsBar(bool isDesktop) {
    final metrics = [
      {
        'value': 10000,
        'suffix': '+',
        'label': 'Orders Processed',
        'sub': 'Production sales automation',
        'color': AppColors.cyan,
      },
      {
        'value': 10000,
        'suffix': '+',
        'label': 'Payment Collections',
        'sub': 'Secured financial sync',
        'color': AppColors.emerald,
      },
      {
        'value': 30,
        'suffix': '+',
        'label': 'Field Representatives',
        'sub': 'Daily active enterprise users',
        'color': AppColors.purple,
      },
      {
        'value': 2,
        'suffix': '+ Years',
        'label': 'Production Experience',
        'sub': 'Flutter & Clean Architecture',
        'color': AppColors.amber,
      },
      {
        'value': 10,
        'suffix': '+',
        'label': 'Client Applications',
        'sub': 'Delivered across diverse domains',
        'color': const Color(0xFF38BDF8),
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: metrics.map((m) {
                return Expanded(
                  child: _buildMetricItem(
                    targetValue: m['value'] as int,
                    suffix: m['suffix'] as String,
                    label: m['label'] as String,
                    sub: m['sub'] as String,
                    accentColor: m['color'] as Color,
                  ),
                );
              }).toList(),
            );
          } else {
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: metrics.map((m) {
                return SizedBox(
                  width: 150,
                  child: _buildMetricItem(
                    targetValue: m['value'] as int,
                    suffix: m['suffix'] as String,
                    label: m['label'] as String,
                    sub: m['sub'] as String,
                    accentColor: m['color'] as Color,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildMetricItem({
    required int targetValue,
    required String suffix,
    required String label,
    required String sub,
    required Color accentColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedCounter(
          targetValue: targetValue,
          suffix: suffix,
          style: AppTypography.statNumber.copyWith(
            color: accentColor,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
