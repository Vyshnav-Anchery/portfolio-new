import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'widgets/animations/cursor_aura.dart';
import 'widgets/animations/fade_slide_in.dart';
import 'widgets/animations/particle_background.dart';
import 'widgets/architecture/bloc_simulator_widget.dart';
import 'widgets/contact/contact_section.dart';
import 'widgets/contact/resume_modal.dart';
import 'widgets/experience/experience_timeline.dart';
import 'widgets/hero/hero_section.dart';
import 'widgets/navigation/glass_navbar.dart';
import 'widgets/projects/projects_section.dart';
import 'widgets/skills/skills_matrix_section.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VyshnavPortfolioApp());
}

class VyshnavPortfolioApp extends StatelessWidget {
  const VyshnavPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyshnav A | Flutter Developer & Mobile Architect',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyan,
          secondary: AppColors.purple,
          surface: AppColors.cardBg,
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _architectureKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 400 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openResumeModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => const ResumeModal(),
    );
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

    return Scaffold(
      body: CursorAuraFollower(
        child: ParticleBackground(
          child: Stack(
            children: [
              // Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 70), // Spacer for sticky navbar

                      // 1. Hero Section
                      FadeSlideIn(
                        delay: Duration.zero,
                        child: Container(
                          key: _heroKey,
                          child: HeroSection(
                            onExploreProjects: () =>
                                _scrollToSection(_projectsKey),
                            onTestArchitecture: () =>
                                _scrollToSection(_architectureKey),
                            onContactTap: () => _scrollToSection(_contactKey),
                            onViewResume: _openResumeModal,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 2. Skills Matrix
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 100),
                        child: Container(
                          key: _skillsKey,
                          child: const SkillsMatrixSection(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 3. Interactive Architecture & BLoC Stream Simulator
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 150),
                        child: Container(
                          key: _architectureKey,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 48.0 : 20.0,
                            vertical: 30.0,
                          ),
                          child: const BlocSimulatorWidget(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 4. Featured Production Projects & Client Ecosystem
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          key: _projectsKey,
                          child: const ProjectsSection(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 5. Experience & Education Timeline
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 250),
                        child: Container(
                          key: _experienceKey,
                          child: const ExperienceTimeline(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 6. Contact Section & Quick Message Form
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 300),
                        child: Container(
                          key: _contactKey,
                          child: ContactSection(
                            onViewResume: _openResumeModal,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 7. Footer
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 350),
                        child: _buildFooter(isDesktop),
                      ),
                    ],
                  ),
                ),
              ),

            // Sticky Blurred Glass Navbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassNavbar(
                onAboutTap: () => _scrollToSection(_heroKey),
                onSkillsTap: () => _scrollToSection(_skillsKey),
                onArchitectureTap: () => _scrollToSection(_architectureKey),
                onProjectsTap: () => _scrollToSection(_projectsKey),
                onExperienceTap: () => _scrollToSection(_experienceKey),
                onContactTap: () => _scrollToSection(_contactKey),
                onViewResume: _openResumeModal,
              ),
            ),

            // Back To Top Floating Action Button
            if (_showBackToTop)
              Positioned(
                bottom: 28,
                right: 28,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.cyan.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.25),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.cyan,
                        size: 22,
                      ),
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

  Widget _buildFooter(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 20.0,
        vertical: 36.0,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF060910),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.cyanPurpleGradient,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'VA',
                      style: AppTypography.codeBadge.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vyshnav A',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.alternate_email_rounded,
                        size: 18, color: AppColors.textSecondary),
                    onPressed: () =>
                        _launchUrlSafe('mailto:vyshnavanchery0@gmail.com'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_rounded,
                        size: 18, color: AppColors.textSecondary),
                    onPressed: () => _launchUrlSafe('tel:+919539386773'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link_rounded,
                        size: 18, color: AppColors.textSecondary),
                    onPressed: () =>
                        _launchUrlSafe('https://www.linkedin.com/in/vyshnav-a'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.code_rounded,
                        size: 18, color: AppColors.textSecondary),
                    onPressed: () => _launchUrlSafe('https://github.com'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            height: 1,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '© 2026 Vyshnav A. Engineered with Flutter Web & Dart.',
                style: AppTypography.bodySmall.copyWith(fontSize: 11),
              ),
              Row(
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
                  Flexible(
                    child: Text(
                      'BLoC • Clean Arch • Hive • WebSockets',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 10,
                        color: AppColors.emerald,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
