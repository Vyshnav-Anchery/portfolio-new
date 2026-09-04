import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/tilt_card.dart';

class ContactSection extends StatefulWidget {
  final VoidCallback onViewResume;

  const ContactSection({super.key, required this.onViewResume});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrlSafe(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {}
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        backgroundColor: AppColors.cyan,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _isSubmitted = true;
          });
          // Also open pre-filled email client
          final emailUrl = Uri(
            scheme: 'mailto',
            path: 'vyshnavanchery0@gmail.com',
            query:
                'subject=Project Inquiry from ${_nameController.text}&body=${_messageController.text}%0D%0A%0D%0AFrom: ${_emailController.text}',
          ).toString();
          _launchUrlSafe(emailUrl);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 980;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 20.0,
        vertical: 50.0,
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
                  color: AppColors.rose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.rose.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'GET IN TOUCH',
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 11,
                    color: AppColors.rose,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text("Let's Build Production Impact",
              style: AppTypography.displaySmall.copyWith(
                fontSize: isDesktop ? 34 : 26,
              )),
          const SizedBox(height: 8),
          Text(
            'Seeking full-time roles, strategic contract engineering, or high-impact Flutter application builds.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 36),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildContactInfoCards(),
                ),
                const SizedBox(width: 36),
                Expanded(
                  flex: 6,
                  child: _buildInteractiveForm(),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildContactInfoCards(),
                const SizedBox(height: 32),
                _buildInteractiveForm(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCards() {
    return Column(
      children: [
        // Email Card
        TiltCard(
          borderRadius: 16,
          hoverBorderColor: AppColors.cyan,
          backgroundColor: AppColors.cardBg,
          padding: const EdgeInsets.all(20),
          onTap: () => _launchUrlSafe('mailto:vyshnavanchery0@gmail.com'),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mail_outline_rounded,
                    size: 22, color: AppColors.cyan),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Direct Email',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        )),
                    const SizedBox(height: 2),
                    Text('vyshnavanchery0@gmail.com',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    size: 16, color: AppColors.textSecondary),
                onPressed: () => _copyToClipboard(
                    'vyshnavanchery0@gmail.com', 'Email address'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Phone Card
        TiltCard(
          borderRadius: 16,
          hoverBorderColor: AppColors.emerald,
          backgroundColor: AppColors.cardBg,
          padding: const EdgeInsets.all(20),
          onTap: () => _launchUrlSafe('tel:+919539386773'),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_rounded,
                    size: 22, color: AppColors.emerald),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Call / WhatsApp',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        )),
                    const SizedBox(height: 2),
                    Text('+91 9539386773',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    size: 16, color: AppColors.textSecondary),
                onPressed: () =>
                    _copyToClipboard('+919539386773', 'Phone number'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Location Card
        TiltCard(
          borderRadius: 16,
          hoverBorderColor: AppColors.purple,
          backgroundColor: AppColors.cardBg,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.pin_drop_rounded,
                    size: 22, color: AppColors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Locations',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        )),
                    const SizedBox(height: 2),
                    Text('Calicut, Kerala & Chennai, Tamil Nadu',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Resume Modal Trigger Card
        GestureDetector(
          onTap: widget.onViewResume,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.cyanPurpleGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.description_rounded,
                    size: 20, color: Colors.black),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'View & Print Full Structured Resume',
                    style: AppTypography.codeBadge.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveForm() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SEND A DIRECT MESSAGE',
                style: AppTypography.codeBadge.copyWith(
                  fontSize: 11,
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 6),
            Text('Quick Inquiry', style: AppTypography.titleLarge),
            const SizedBox(height: 20),

            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'Your Name or Company',
              hint: 'e.g. Alex Morgan / Tech Innovations Ltd',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'Your Email Address',
              hint: 'alex@company.com',
              icon: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!v.contains('@') || !v.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message Field
            _buildTextField(
              controller: _messageController,
              label: 'Project Details or Role Opportunity',
              hint:
                  'Tell me about your mobile project, tech stack, or engineering role...',
              icon: Icons.message_outlined,
              maxLines: 4,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a brief message'
                  : null,
            ),
            const SizedBox(height: 24),

            // Submit Button
            GestureDetector(
              onTap: _isSubmitting ? null : _handleSubmit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: _isSubmitted
                      ? AppColors.emeraldCyanGradient
                      : AppColors.cyanPurpleGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isSubmitted
                                ? Icons.check_circle_rounded
                                : Icons.send_rounded,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _isSubmitted
                                  ? 'Message Prepared & Dispatched!'
                                  : 'Send Inquiry to Vyshnav',
                              style: AppTypography.codeBadge.copyWith(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.codeBadge.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: maxLines == 1
                ? Icon(icon, size: 18, color: AppColors.textSecondary)
                : null,
            filled: true,
            fillColor: const Color(0xFF0A0F1D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
