import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Interactive visualizer demonstrating Clean Architecture, BLoC unidirectional
/// data flow, offline caching in Hive, and cloud sync via AWS SigV4 / RabbitMQ.
class BlocSimulatorWidget extends StatefulWidget {
  const BlocSimulatorWidget({super.key});

  @override
  State<BlocSimulatorWidget> createState() => _BlocSimulatorWidgetState();
}

class _BlocSimulatorWidgetState extends State<BlocSimulatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _activeStep = 0; // 0: Idle, 1: UI -> BLoC, 2: BLoC -> Domain, 3: Domain -> Data, 4: Data -> UI
  String _currentState = 'OrderState.idle()';
  String _currentEvent = 'No event dispatched';
  final List<String> _consoleLogs = [
    '// Architecture Engine ready.',
    '// BLoC Stream initialized with initial state: OrderState.idle()',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _animController.addListener(() {
      final val = _animController.value;
      int step;
      if (val < 0.25) {
        step = 1; // UI -> BLoC
      } else if (val < 0.50) {
        step = 2; // BLoC -> Domain
      } else if (val < 0.75) {
        step = 3; // Domain -> Data (Hive / S3)
      } else if (val < 1.0) {
        step = 4; // Data -> BLoC State Emission
      } else {
        step = 0;
      }

      if (step != _activeStep) {
        setState(() {
          _activeStep = step;
        });
      }
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _activeStep = 0;
          _currentState = 'OrderState.synchronized(synced: true)';
          _addLog('✓ State Emitted: OrderState.synchronized(podUploaded: true)');
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addLog(String msg) {
    setState(() {
      _consoleLogs.add(msg);
      if (_consoleLogs.length > 8) {
        _consoleLogs.removeAt(0);
      }
    });
  }

  void _triggerScenario(String eventName, String desc) {
    if (_animController.isAnimating) return;

    setState(() {
      _currentEvent = eventName;
      _currentState = 'OrderState.processing()';
      _addLog('→ Event Dispatched: $eventName');
      _addLog('  $desc');
    });

    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.08),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hub_rounded,
                            color: AppColors.cyan, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Live Architecture & BLoC Stream Simulator',
                            style: AppTypography.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore how offline transactions flow through Clean Architecture, Hive, and AWS Cloud in Vyshnav\'s production apps.',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('EVENT-DRIVEN',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interactive Event Trigger Bar
          Text(
            'SELECT A PRODUCTION ACTION TO DISPATCH:',
            style: AppTypography.codeBadge.copyWith(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildTriggerButton(
                title: 'PlaceOfflineOrder()',
                subtitle: 'Hive Cache & Queue',
                color: AppColors.cyan,
                icon: Icons.offline_bolt_rounded,
                onTap: () => _triggerScenario(
                  'OrderEvent.createOffline(orderId: #9401)',
                  'Persisting payload to encrypted Hive box under zero network',
                ),
              ),
              _buildTriggerButton(
                title: 'SyncAwsSigV4()',
                subtitle: 'Background S3 Upload',
                color: AppColors.emerald,
                icon: Icons.cloud_upload_rounded,
                onTap: () => _triggerScenario(
                  'SyncEvent.uploadWithSigV4(batchSize: 14)',
                  'Generating AWS Signature V4 headers and streaming multipart',
                ),
              ),
              _buildTriggerButton(
                title: 'RabbitMqPacket()',
                subtitle: 'Warehouse Dispatch',
                color: const Color(0xFFF97316),
                icon: Icons.move_to_inbox_rounded,
                onTap: () => _triggerScenario(
                  'DispatchEvent.receivePacket(queue: "oda_wh_402")',
                  'AMQP ack received -> Decoding payload -> Dispatching to BLoC',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Luminous Traveling Data Packet Pipeline Track
          _buildPacketPipelineTrack(),

          const SizedBox(height: 12),

          // 4 Architecture Flow Nodes
          if (isDesktop)
            _buildDesktopNodes()
          else
            _buildMobileNodes(),

          const SizedBox(height: 24),

          // Current State and Console Log Stream
          _buildConsoleTerminal(),
        ],
      ),
    );
  }

  Widget _buildTriggerButton({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isRunning = _animController.isAnimating;

    return MouseRegion(
      cursor: isRunning ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isRunning ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isRunning ? 0.05 : 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: isRunning ? 0.2 : 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isRunning ? AppColors.textMuted : color),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 12,
                      color: isRunning ? AppColors.textMuted : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: isRunning ? AppColors.textMuted : color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPacketPipelineTrack() {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final isAnimating = _animController.isAnimating;
        final progress = _animController.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF090E1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAnimating
                  ? AppColors.cyan.withValues(alpha: 0.6)
                  : AppColors.cardBorder,
              width: isAnimating ? 1.5 : 1.0,
            ),
            boxShadow: isAnimating
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAnimating ? AppColors.cyan : AppColors.textMuted,
                          boxShadow: isAnimating
                              ? [
                                  BoxShadow(
                                    color: AppColors.cyan,
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAnimating
                            ? 'LUMINOUS DATA PACKET STREAM ACTIVE'
                            : 'PIPELINE STANDBY (TRIGGER ANY SCENARIO ABOVE)',
                        style: AppTypography.codeBadge.copyWith(
                          fontSize: 10,
                          color: isAnimating ? AppColors.cyan : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    isAnimating
                        ? '${(progress * 100).toInt()}% • Step $_activeStep/4'
                        : 'READY',
                    style: AppTypography.codeBadge.copyWith(
                      fontSize: 10,
                      color: isAnimating ? AppColors.emerald : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Track with glowing traveling packet
              LayoutBuilder(
                builder: (context, constraints) {
                  final trackWidth = constraints.maxWidth;
                  final packetX = (progress * trackWidth).clamp(0.0, trackWidth);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Base rail track
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Progress gradient fill
                      if (isAnimating)
                        Container(
                          height: 4,
                          width: packetX,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.cyan,
                                AppColors.purple,
                                AppColors.emerald,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      // Luminous Traveling Photon Packet
                      if (isAnimating)
                        Positioned(
                          left: math.max(0.0, packetX - 7),
                          top: -5,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan,
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: AppColors.purple,
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopNodes() {
    return Row(
      children: [
        Expanded(
          child: _buildNodeCard(
            stepNumber: 1,
            title: 'Presentation',
            subtitle: 'UI Widget / Event',
            tech: 'Flutter UI',
            icon: Icons.touch_app_rounded,
            color: AppColors.cyan,
            isActive: _activeStep == 1,
          ),
        ),
        _buildFlowArrow(
          isActive: _activeStep == 1 || _activeStep == 2,
          isReverse: false,
        ),
        Expanded(
          child: _buildNodeCard(
            stepNumber: 2,
            title: 'BLoC Machine',
            subtitle: 'Stream<State>',
            tech: 'flutter_bloc',
            icon: Icons.architecture_rounded,
            color: AppColors.purple,
            isActive: _activeStep == 2 || _activeStep == 4,
          ),
        ),
        _buildFlowArrow(
          isActive: _activeStep == 2 || _activeStep == 3,
          isReverse: false,
        ),
        Expanded(
          child: _buildNodeCard(
            stepNumber: 3,
            title: 'Domain Layer',
            subtitle: 'UseCases & Logic',
            tech: 'Clean Arch',
            icon: Icons.layers_rounded,
            color: AppColors.blue,
            isActive: _activeStep == 3,
          ),
        ),
        _buildFlowArrow(
          isActive: _activeStep == 3 || _activeStep == 4,
          isReverse: _activeStep == 4,
        ),
        Expanded(
          child: _buildNodeCard(
            stepNumber: 4,
            title: 'Data Sources',
            subtitle: 'Hive & AWS S3',
            tech: 'NoSQL / AMQP',
            icon: Icons.dns_rounded,
            color: AppColors.emerald,
            isActive: _activeStep == 3 || _activeStep == 4,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNodes() {
    return Column(
      children: [
        _buildNodeCard(
          stepNumber: 1,
          title: 'Presentation (Flutter UI)',
          subtitle: 'Dispatches UI events to BLoC',
          tech: 'Flutter UI',
          icon: Icons.touch_app_rounded,
          color: AppColors.cyan,
          isActive: _activeStep == 1,
        ),
        _buildVerticalFlowArrow(
          isActive: _activeStep == 1 || _activeStep == 2,
          isReverse: false,
        ),
        _buildNodeCard(
          stepNumber: 2,
          title: 'BLoC State Machine',
          subtitle: 'Unidirectional stream transforms',
          tech: 'flutter_bloc',
          icon: Icons.architecture_rounded,
          color: AppColors.purple,
          isActive: _activeStep == 2 || _activeStep == 4,
        ),
        _buildVerticalFlowArrow(
          isActive: _activeStep == 2 || _activeStep == 3,
          isReverse: false,
        ),
        _buildNodeCard(
          stepNumber: 3,
          title: 'Domain Layer',
          subtitle: 'UseCases, Entities & Business Rules',
          tech: 'Clean Arch',
          icon: Icons.layers_rounded,
          color: AppColors.blue,
          isActive: _activeStep == 3,
        ),
        _buildVerticalFlowArrow(
          isActive: _activeStep == 3 || _activeStep == 4,
          isReverse: _activeStep == 4,
        ),
        _buildNodeCard(
          stepNumber: 4,
          title: 'Data Sources',
          subtitle: 'Hive local caching & AWS SigV4 remote sync',
          tech: 'Hive / AWS / Dio',
          icon: Icons.dns_rounded,
          color: AppColors.emerald,
          isActive: _activeStep == 3 || _activeStep == 4,
        ),
      ],
    );
  }

  Widget _buildFlowArrow({required bool isActive, bool isReverse = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.4)
                : Colors.transparent,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Icon(
          isReverse ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
          size: 16,
          color: isActive
              ? (isReverse ? AppColors.purple : AppColors.cyan)
              : AppColors.cardBorder,
        ),
      ),
    );
  }

  Widget _buildVerticalFlowArrow({required bool isActive, bool isReverse = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.4)
                : Colors.transparent,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: (isReverse ? AppColors.purple : AppColors.cyan).withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Icon(
          isReverse ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 14,
          color: isActive
              ? (isReverse ? AppColors.purple : AppColors.cyan)
              : AppColors.cardBorder,
        ),
      ),
    );
  }

  Widget _buildNodeCard({
    required int stepNumber,
    required String title,
    required String subtitle,
    required String tech,
    required IconData icon,
    required Color color,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.15)
            : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : AppColors.cardBorder,
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tech,
                  style: AppTypography.codeBadge.copyWith(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              color: isActive ? color : AppColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleTerminal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090E17),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'bloc_architecture_stream.log',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'EVENT: $_currentEvent',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 10,
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'STATE: $_currentState',
                      style: AppTypography.codeBadge.copyWith(
                        fontSize: 10,
                        color: AppColors.emerald,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.cardBorder, height: 20),
          ..._consoleLogs.map(
            (log) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                log,
                style: AppTypography.codeBadge.copyWith(
                  fontSize: 11,
                  color: log.startsWith('✓')
                      ? AppColors.emerald
                      : (log.startsWith('→')
                          ? AppColors.cyan
                          : AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
