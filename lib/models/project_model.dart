import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String title;
  final String role;
  final String category;
  final String summary;
  final List<String> bulletPoints;
  final List<String> techStack;
  final Map<String, String> metrics;
  final IconData icon;
  final Color accentColor;
  final bool isFeatured;
  final String architectureNote;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.role,
    required this.category,
    required this.summary,
    required this.bulletPoints,
    required this.techStack,
    required this.metrics,
    required this.icon,
    required this.accentColor,
    this.isFeatured = true,
    required this.architectureNote,
  });

  static List<ProjectModel> get featuredProjects => [
    const ProjectModel(
      id: 'oda',
      title: 'ODA (Outbound Delivery & Warehouse Management)',
      role: 'Core Flutter Developer (2-Dev Team)',
      category: 'Supply Chain & Logistics',
      summary:
          'Mission-critical offline-first mobile application built for supply chain delivery and warehouse operations under zero or low-connectivity environments.',
      bulletPoints: [
        'Engineered offline-first architecture with BLoC, GetIt, and Hive local storage ensuring uninterrupted warehouse shifts.',
        'Developed bidirectional Hive-to-Excel/CSV export and Excel/CSV-to-Hive import for field data exchange.',
        'Integrated RabbitMQ for real-time order dispatch and warehouse event processing.',
        'Architected secure Proof of Delivery (POD) image capture and background upload directly to AWS S3 with custom camera implementation.',
      ],
      techStack: [
        'Flutter',
        'BLoC',
        'Hive',
        'GetIt',
        'RabbitMQ',
        'AWS S3',
        'Custom Camera',
        'CSV/Excel Engine',
      ],
      metrics: {
        'Sync': '100% Offline Capable',
        'Protocol': 'RabbitMQ Real-Time',
        'Storage': 'Encrypted Hive & AWS S3',
      },
      icon: Icons.local_shipping_rounded,
      accentColor: Color(0xFF00F2FE),
      isFeatured: true,
      architectureNote:
          'Clean Architecture with isolated Local DataSource (Hive) & Remote DataSource (RabbitMQ/Dio), orchestrated via Domain UseCases and BLoC state streams.',
    ),
    const ProjectModel(
      id: 'ewf-sfa',
      title: 'EWF SFA (Enterprise Sales Force Automation)',
      role: 'Lead Flutter Developer',
      category: 'Sales Automation & Enterprise',
      summary:
          'Production field sales application actively utilized by 30+ field representatives across Tamil Nadu and Kerala for over a year.',
      bulletPoints: [
        'Processed over 10,000+ customer orders and 10,000+ payment collections seamlessly in production.',
        'Engineered robust offline order caching and background file synchronization utilizing AWS Signature Version 4 (SigV4).',
        'Implemented field route tracking, client geolocation, and distance calculations via Google Maps API.',
        'Integrated Firebase Crashlytics and performance telemetry, maintaining a 99.8% crash-free session rate.',
      ],
      techStack: [
        'Flutter',
        'BLoC',
        'Dio',
        'Google Maps API',
        'Hive',
        'AWS S3 (SigV4)',
        'Firebase Crashlytics',
      ],
      metrics: {
        'Orders': '10,000+ Processed',
        'Payments': '10,000+ Collections',
        'Field Reps': '30+ Daily Active',
      },
      icon: Icons.point_of_sale_rounded,
      accentColor: Color(0xFF10B981),
      isFeatured: true,
      architectureNote:
          'Strict repository pattern decoupling AWS SigV4 signed requests, background sync queues, and offline transaction rollback mechanisms.',
    ),
    const ProjectModel(
      id: 'party-driver',
      title: 'Party to Driver Ecosystem',
      role: 'Full-Cycle Flutter Engineer',
      category: 'Real-Time Transport & Fleet',
      summary:
          'Real-time transport booking and dispatch ecosystem connecting cargo parties with vehicle drivers through automated role-based workflows.',
      bulletPoints: [
        'Implemented low-latency WebSockets for real-time bidirectional location telemetry and driver tracking.',
        'Integrated Razorpay gateway for seamless automated subscription and dispatch billing.',
        'Integrated Agora Voice SDK for crystal-clear in-app driver-client voice communication.',
        'Localized application across 5 languages and structured seamless deep-linking using GoRouter.',
      ],
      techStack: [
        'Flutter',
        'WebSockets',
        'Agora Audio SDK',
        'Razorpay',
        'GoRouter',
        'i18n (5 Languages)',
        'BLoC',
      ],
      metrics: {
        'Latency': '< 100ms Live Telemetry',
        'Languages': '5 Regional Locales',
        'Voice': 'Agora HD Voice Stream',
      },
      icon: Icons.navigation_rounded,
      accentColor: Color(0xFF8B5CF6),
      isFeatured: true,
      architectureNote:
          'Event-driven reactive streams binding WebSocket channels directly to DriverLocationBloc and CallManagementBloc with automatic reconnection handlers.',
    ),
    const ProjectModel(
      id: 'adnexo',
      title: 'Adnexo Out-of-Home (OOH) Advertising',
      role: 'Flutter Developer & Architect',
      category: 'Advertising Platforms',
      summary:
          'Multi-application Out-of-Home billboard and media advertising suite consisting of three specialized Flutter applications.',
      bulletPoints: [
        'Built role-specific applications for End Users, Relationship Managers, and Site Mounters/Owners.',
        'Applied Clean Architecture and BLoC to share core domain models while adapting custom presentation layers.',
        'Streamlined billboard inventory tracking, proof-of-mounting camera validation, and REST API communications.',
        'Integrated GoRouter with path parameters and role-based route guards for flawless deep-linking.',
      ],
      techStack: [
        'Flutter',
        'Clean Architecture',
        'BLoC',
        'GoRouter',
        'Dio REST APIs',
        'Flavor Configurations',
      ],
      metrics: {
        'Apps Suite': '3 Interlinked Apps',
        'Roles': 'User, Manager, Mounter',
        'Code Sharing': 'Shared Domain Core',
      },
      icon: Icons.campaign_rounded,
      accentColor: Color(0xFFF59E0B),
      isFeatured: true,
      architectureNote:
          'Modular multi-package architecture isolating Domain (Entities/UseCases), Core Networking (Dio interceptors), and tailored presentation packages.',
    ),
  ];

  static List<Map<String, dynamic>> get clientEcosystem => [
    {
      'title': 'TripCity',
      'domain': 'Travel & Ride Sharing',
      'icon': Icons.directions_car_filled_rounded,
      'color': Color(0xFF38BDF8),
      'desc': 'On-demand commute and intercity booking with interactive routing.',
    },
    {
      'title': 'Cashipe',
      'domain': 'Fintech & Digital Payments',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFF10B981),
      'desc': 'Digital wallet, peer transfers, and merchant payment flows.',
    },
    {
      'title': 'Style Buddy',
      'domain': 'Fashion & Personal Styling',
      'icon': Icons.style_rounded,
      'color': Color(0xFFEC4899),
      'desc': 'Personal stylist consultation booking and curated fashion catalogue.',
    },
    {
      'title': 'Sapacare Vet Hospital',
      'domain': 'Healthcare Management',
      'icon': Icons.pets_rounded,
      'color': Color(0xFF8B5CF6),
      'desc': 'Veterinary hospital patient records, appointment queues, and vet diagnosis.',
    },
    {
      'title': 'Backhoe Bos',
      'domain': 'Heavy Machinery & Fleet',
      'icon': Icons.agriculture_rounded,
      'color': Color(0xFFF59E0B),
      'desc': 'Excavator rental, equipment operator dispatch, and fuel telematics.',
    },
    {
      'title': 'Unimation Robotics',
      'domain': 'Industrial Robotics & Automation',
      'icon': Icons.precision_manufacturing_rounded,
      'color': Color(0xFF00F2FE),
      'desc': 'Industrial robot monitoring dashboard and telemetry metrics.',
    },
  ];
}
