import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../animations/glow_border_card.dart';

/// Simulated modern mobile device frame running an interactive Flutter mini-app
/// showcasing Vyshnav's real-world production projects.
class InteractivePhoneMockup extends StatefulWidget {
  const InteractivePhoneMockup({super.key});

  @override
  State<InteractivePhoneMockup> createState() => _InteractivePhoneMockupState();
}

class _InteractivePhoneMockupState extends State<InteractivePhoneMockup>
    with SingleTickerProviderStateMixin {
  int _activeTab = 0; // 0: ODA, 1: Party to Driver, 2: EWF SFA

  // ODA State
  int _odaSyncItems = 14;
  bool _isExporting = false;
  bool _isRabbitMqActive = true;

  // Driver State
  bool _isInAgoraCall = false;
  double _driverPosAngle = 0;

  // SFA State
  int _ordersCount = 10482;
  bool _isSigV4Syncing = false;

  late AnimationController _tickerController;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _tickerController.addListener(() {
      if (mounted) {
        setState(() {
          _driverPosAngle = _tickerController.value * 2 * math.pi;
        });
      }
    });
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowBorderCard(
      borderRadius: 42,
      borderWidth: 2.0,
      glowColors: const [
        AppColors.cyan,
        AppColors.purple,
        Color(0xFF3B82F6),
        Colors.transparent,
        AppColors.cyan,
      ],
      child: Container(
        width: 320,
        height: 580,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 35,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
          // Dynamic Island / Speaker Notch
          _buildPhoneHeader(),

          // Project Tab Switcher
          _buildAppTabSwitcher(),

          // Simulated App Screen Body
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildActiveAppScreen(),
            ),
          ),

          // Android / iOS Home Indicator
          _buildHomeIndicator(),
        ],
      ),
    ),
    );
  }

  Widget _buildPhoneHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 6),
      color: const Color(0xFF0A0E17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '09:41',
            style: AppTypography.codeBadge.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Island Notch
          Container(
            width: 80,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.wifi_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Icon(Icons.battery_5_bar_rounded,
                  size: 15, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppTabSwitcher() {
    final tabs = [
      {'label': 'ODA', 'icon': Icons.local_shipping_outlined},
      {'label': 'Fleet', 'icon': Icons.navigation_outlined},
      {'label': 'SFA', 'icon': Icons.point_of_sale_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161F30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _activeTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[index]['icon'] as IconData,
                      size: 13,
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        tabs[index]['label'] as String,
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 11,
                          color:
                              isSelected ? Colors.black : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveAppScreen() {
    switch (_activeTab) {
      case 0:
        return _buildOdaScreen();
      case 1:
        return _buildPartyToDriverScreen();
      case 2:
        return _buildSfaScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  // SCREEN 1: ODA Logistics (Hive + RabbitMQ + S3)
  Widget _buildOdaScreen() {
    return Container(
      key: const ValueKey('oda_screen'),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Warehouse #402',
                        style: AppTypography.titleMedium.copyWith(fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                    Text('Offline-First Active',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.emerald, fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isRabbitMqActive = !_isRabbitMqActive;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRabbitMqActive
                              ? AppColors.emerald
                              : AppColors.rose,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'RabbitMQ',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Hive Queue Status Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2_rounded,
                      size: 20, color: AppColors.cyan),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hive Local Storage',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          )),
                      Text('$_odaSyncItems deliveries waiting sync',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('READY',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 9,
                        color: AppColors.emerald,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Proof of Delivery AWS S3 preview card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Proof of Delivery (POD)',
                          style: AppTypography.titleMedium.copyWith(fontSize: 11),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 6),
                    Text('AWS S3',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: const Color(0xFFFF9900),
                        )),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.cardBorder.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_rounded,
                          size: 15, color: AppColors.cyan),
                      const SizedBox(width: 6),
                      Text('Camera POD Captured',
                          style: AppTypography.codeBadge.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          )),
                      const SizedBox(width: 6),
                      const Icon(Icons.check_circle_rounded,
                          size: 14, color: AppColors.emerald),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Action Button: Export Hive to CSV / Sync
          GestureDetector(
            onTap: () {
              setState(() {
                _isExporting = true;
              });
              Future.delayed(const Duration(milliseconds: 1200), () {
                if (mounted) {
                  setState(() {
                    _isExporting = false;
                    _odaSyncItems = 0;
                  });
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.cyanPurpleGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: _isExporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sync_rounded,
                            size: 14, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          _odaSyncItems == 0
                              ? 'Sync Complete (CSV)'
                              : 'Export Hive to CSV',
                          style: AppTypography.codeBadge.copyWith(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // SCREEN 2: Party to Driver (WebSockets + Agora Voice + Map)
  Widget _buildPartyToDriverScreen() {
    return Container(
      key: const ValueKey('driver_screen'),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Cargo Transit',
                  style: AppTypography.titleMedium.copyWith(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                ),
                child: Text('WS: LIVE (38ms)',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 9,
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Interactive Radar Map Simulation
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF090E1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Radar grid circles
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.purple.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.cyan.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                ),

                // Animated Sweeping Radar Beam
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RadarSweepPainter(sweepAngle: _driverPosAngle),
                  ),
                ),

                // Center Warehouse Hub Icon
                const Icon(Icons.hub_rounded, size: 16, color: AppColors.cyan),

                // Moving Driver Dot on circle path
                Transform.translate(
                  offset: Offset(
                    math.cos(_driverPosAngle) * 42,
                    math.sin(_driverPosAngle) * 36,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_shipping_rounded,
                        size: 10, color: Colors.white),
                  ),
                ),
                // Bottom badge
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Text(
                    'Driver #KL-11-8402 (En Route)',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Agora In-App Voice Call Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isInAgoraCall
                  ? AppColors.purple.withValues(alpha: 0.15)
                  : const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isInAgoraCall ? AppColors.purple : AppColors.cardBorder,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isInAgoraCall
                        ? AppColors.rose.withValues(alpha: 0.2)
                        : AppColors.purple.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isInAgoraCall
                        ? Icons.call_end_rounded
                        : Icons.phone_in_talk_rounded,
                    size: 16,
                    color: _isInAgoraCall ? AppColors.rose : AppColors.purple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isInAgoraCall
                            ? 'Agora RTC Active Call'
                            : 'Agora Voice Communication',
                        style: AppTypography.titleMedium.copyWith(fontSize: 11),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _isInAgoraCall
                                  ? 'HD Stream (48 kHz) '
                                  : 'Direct Party <-> Driver Voice',
                              style: AppTypography.bodySmall.copyWith(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_isInAgoraCall) ...[
                            const SizedBox(width: 4),
                            _VoiceWaveformBars(animation: _tickerController),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isInAgoraCall = !_isInAgoraCall;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isInAgoraCall ? AppColors.rose : AppColors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _isInAgoraCall ? 'Mute' : 'Call Driver',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Razorpay Checkout Simulation Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payment_rounded,
                        size: 14, color: AppColors.cyan),
                    const SizedBox(width: 6),
                    Text('Razorpay Escrow',
                        style: AppTypography.codeBadge.copyWith(fontSize: 10)),
                  ],
                ),
                Text('₹4,250 Secured',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // SCREEN 3: EWF SFA (10,000+ Orders & AWS SigV4)
  Widget _buildSfaScreen() {
    return Container(
      key: const ValueKey('sfa_screen'),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sales Rep Portal',
                  style: AppTypography.titleMedium.copyWith(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('30+ FIELD REPS',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 9,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Production Order Counter
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF062D24)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LIFETIME PRODUCTION VOLUME',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 9,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_ordersCount+ Orders',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        )),
                    const Icon(Icons.trending_up_rounded,
                        color: AppColors.emerald, size: 20),
                  ],
                ),
                Text('10,000+ Payment Collections Handled',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: const Color(0xFFA7F3D0),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Google Maps Field Route card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_rounded,
                    size: 18, color: Color(0xFF34A853)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Google Maps Route Active',
                          style:
                              AppTypography.titleMedium.copyWith(fontSize: 11)),
                      Text('Chennai Region • 12 Outlet Visits',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_outline_rounded,
                    size: 14, color: AppColors.emerald),
              ],
            ),
          ),
          const Spacer(),

          // AWS SigV4 Background Sync Trigger
          GestureDetector(
            onTap: () {
              setState(() {
                _isSigV4Syncing = true;
              });
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (mounted) {
                  setState(() {
                    _isSigV4Syncing = false;
                    _ordersCount++;
                  });
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _isSigV4Syncing
                    ? AppColors.emerald.withValues(alpha: 0.2)
                    : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emerald),
                boxShadow: _isSigV4Syncing
                    ? [
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: _isSigV4Syncing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.emerald,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_sync_rounded,
                            size: 14, color: AppColors.emerald),
                        const SizedBox(width: 6),
                        Text('Sync Order via AWS SigV4',
                            style: AppTypography.codeBadge.copyWith(
                              fontSize: 11,
                              color: AppColors.emerald,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      width: double.infinity,
      height: 20,
      alignment: Alignment.center,
      child: Container(
        width: 90,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textMuted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Sweeping tactical radar beam painter with 360-degree radar fan beam
class _RadarSweepPainter extends CustomPainter {
  final double sweepAngle;

  _RadarSweepPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.width.isFinite || !size.height.isFinite || size.width <= 0 || size.height <= 0) {
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;

    // Crosshair lines
    final crossPaint = Paint()
      ..color = AppColors.cyan.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      crossPaint,
    );

    // Radar fan gradient beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi * 0.6,
        colors: [
          AppColors.cyan.withValues(alpha: 0.35),
          AppColors.purple.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Leading sweep ray line
    final linePaint = Paint()
      ..color = AppColors.cyan.withValues(alpha: 0.75)
      ..strokeWidth = 1.5;
    final endPoint = Offset(
      center.dx + radius * math.cos(sweepAngle),
      center.dy + radius * math.sin(sweepAngle),
    );
    canvas.drawLine(center, endPoint, linePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarSweepPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}

/// Live sound frequency waveform bars showing voice activity
class _VoiceWaveformBars extends StatelessWidget {
  final Animation<double> animation;

  const _VoiceWaveformBars({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final val = animation.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(5, (index) {
            final phase = index * 0.8;
            final height = 4.0 + 10.0 * (math.sin(val * 2 * math.pi * 2 + phase).abs());
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: index % 2 == 0 ? AppColors.cyan : AppColors.purple,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: (index % 2 == 0 ? AppColors.cyan : AppColors.purple).withValues(alpha: 0.5),
                    blurRadius: 3,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

