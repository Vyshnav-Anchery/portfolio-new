import 'package:flutter/material.dart';

class SkillCategory {
  final String id;
  final String name;
  final IconData icon;

  const SkillCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class SkillItem {
  final String name;
  final String categoryId;
  final double proficiency; // 0.0 to 1.0
  final String experienceLevel;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> tags;

  const SkillItem({
    required this.name,
    required this.categoryId,
    required this.proficiency,
    required this.experienceLevel,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.tags,
  });
}

class SkillsData {
  SkillsData._();

  static const List<SkillCategory> categories = [
    SkillCategory(id: 'all', name: 'All Skills', icon: Icons.grid_view_rounded),
    SkillCategory(id: 'state_arch', name: 'State & Architecture', icon: Icons.account_tree_rounded),
    SkillCategory(id: 'realtime_net', name: 'Real-Time & APIs', icon: Icons.sync_alt_rounded),
    SkillCategory(id: 'storage_cloud', name: 'Storage & Cloud', icon: Icons.cloud_done_rounded),
    SkillCategory(id: 'sdks_tools', name: 'SDKs & DevOps', icon: Icons.extension_rounded),
  ];

  static const List<SkillItem> skills = [
    // Languages & Frameworks
    SkillItem(
      name: 'Flutter (Web, Android, iOS)',
      categoryId: 'state_arch',
      proficiency: 0.95,
      experienceLevel: '2+ Years Production',
      description: 'Cross-platform app development with native performance, custom rendering, and responsive design.',
      icon: Icons.flutter_dash_rounded,
      accentColor: Color(0xFF00F2FE),
      tags: ['Multiplatform', 'Canvas Rendering', 'Animations', 'Flavors'],
    ),
    SkillItem(
      name: 'Dart',
      categoryId: 'state_arch',
      proficiency: 0.95,
      experienceLevel: 'Advanced',
      description: 'Sound null-safety, async/streams, isolates, records, pattern matching, and functional code patterns.',
      icon: Icons.code_rounded,
      accentColor: Color(0xFF38BDF8),
      tags: ['Async/Await', 'Streams', 'Isolates', 'Generics'],
    ),
    SkillItem(
      name: 'BLoC Pattern',
      categoryId: 'state_arch',
      proficiency: 0.95,
      experienceLevel: 'Primary Solution',
      description: 'Predictable unidirectional state management separating UI events from business logic with streams.',
      icon: Icons.architecture_rounded,
      accentColor: Color(0xFF8B5CF6),
      tags: ['Event-Driven', 'Stream-based', 'Testable', 'Scalable'],
    ),
    SkillItem(
      name: 'Clean Architecture & MVVM',
      categoryId: 'state_arch',
      proficiency: 0.92,
      experienceLevel: 'Core Practice',
      description: 'Layered separation of Presentation, Domain (UseCases/Entities), and Data (Repositories/DataSources).',
      icon: Icons.layers_rounded,
      accentColor: Color(0xFF10B981),
      tags: ['Domain-Driven', 'Dependency Inversion', 'SOLID'],
    ),
    SkillItem(
      name: 'Riverpod & Provider',
      categoryId: 'state_arch',
      proficiency: 0.85,
      experienceLevel: 'Production Ready',
      description: 'Compile-safe dependency injection and reactive state caching across widget trees.',
      icon: Icons.hub_rounded,
      accentColor: Color(0xFF06B6D4),
      tags: ['Compile-Safe', 'DI', 'Reactivity'],
    ),
    SkillItem(
      name: 'GetIt & Injectable',
      categoryId: 'state_arch',
      proficiency: 0.90,
      experienceLevel: 'Core Practice',
      description: 'Service locator and loose-coupling dependency injection for robust unit testing and modularity.',
      icon: Icons.link_rounded,
      accentColor: Color(0xFFF59E0B),
      tags: ['Service Locator', 'Singleton/Factory', 'IoC'],
    ),

    // Real-Time & Networking
    SkillItem(
      name: 'Dio & RESTful APIs',
      categoryId: 'realtime_net',
      proficiency: 0.95,
      experienceLevel: 'Production Core',
      description: 'Custom interceptors for JWT auth refresh, error handling, file upload/download, and offline retry queues.',
      icon: Icons.http_rounded,
      accentColor: Color(0xFF10B981),
      tags: ['Interceptors', 'JWT Auth', 'Form Data', 'Retry Logic'],
    ),
    SkillItem(
      name: 'WebSockets',
      categoryId: 'realtime_net',
      proficiency: 0.90,
      experienceLevel: 'Real-Time Apps',
      description: 'Bi-directional live channels for location telemetry, instant status broadcasts, and auto-reconnect logic.',
      icon: Icons.cable_rounded,
      accentColor: Color(0xFF00F2FE),
      tags: ['Live Telemetry', 'Driver Tracking', 'Heartbeats'],
    ),
    SkillItem(
      name: 'RabbitMQ',
      categoryId: 'realtime_net',
      proficiency: 0.88,
      experienceLevel: 'Enterprise Logistics',
      description: 'Message queuing for warehouse order distribution, dispatch events, and distributed event consumption.',
      icon: Icons.move_to_inbox_rounded,
      accentColor: Color(0xFFF97316),
      tags: ['AMQP', 'Queues', 'Pub/Sub', 'Event-Driven'],
    ),
    SkillItem(
      name: 'Agora Voice SDK',
      categoryId: 'realtime_net',
      proficiency: 0.85,
      experienceLevel: 'Transport Ecosystem',
      description: 'Integrated in-app crystal-clear RTC voice calls between cargo parties and vehicle drivers.',
      icon: Icons.phone_in_talk_rounded,
      accentColor: Color(0xFF8B5CF6),
      tags: ['VoIP', 'Audio Streams', 'Call State'],
    ),

    // Storage & Cloud
    SkillItem(
      name: 'Hive (NoSQL)',
      categoryId: 'storage_cloud',
      proficiency: 0.95,
      experienceLevel: 'Offline First',
      description: 'High-speed key-value database with type adapters, encryption, and Excel/CSV bidirectional export/import.',
      icon: Icons.inventory_2_rounded,
      accentColor: Color(0xFFF59E0B),
      tags: ['TypeAdapters', 'Offline Cache', 'CSV Export'],
    ),
    SkillItem(
      name: 'AWS S3 & SigV4',
      categoryId: 'storage_cloud',
      proficiency: 0.90,
      experienceLevel: 'Secure Uploads',
      description: 'AWS Signature Version 4 background sync, pre-signed upload URLs, and Proof of Delivery archiving.',
      icon: Icons.cloud_upload_rounded,
      accentColor: Color(0xFFFF9900),
      tags: ['SigV4', 'Bucket Storage', 'Background Sync'],
    ),
    SkillItem(
      name: 'Firebase Suite (Firestore, FCM, Crashlytics)',
      categoryId: 'storage_cloud',
      proficiency: 0.90,
      experienceLevel: 'Production Apps',
      description: 'Push notifications with FCM, real-time Firestore database, and Crashlytics stability monitoring.',
      icon: Icons.local_fire_department_rounded,
      accentColor: Color(0xFFEF4444),
      tags: ['FCM Push', 'Crashlytics', 'Firestore'],
    ),
    SkillItem(
      name: 'SQLite & Supabase',
      categoryId: 'storage_cloud',
      proficiency: 0.85,
      experienceLevel: 'Relational DB',
      description: 'Relational querying, local table migrations, and Postgres cloud integration.',
      icon: Icons.storage_rounded,
      accentColor: Color(0xFF10B981),
      tags: ['SQL', 'Relational', 'PostgreSQL'],
    ),

    // SDKs & Tools
    SkillItem(
      name: 'Google Maps API',
      categoryId: 'sdks_tools',
      proficiency: 0.92,
      experienceLevel: 'Live Geolocation',
      description: 'Custom markers, polyline routing, live vehicle tracking, distance computation, and geocoding.',
      icon: Icons.map_rounded,
      accentColor: Color(0xFF34A853),
      tags: ['Live Polylines', 'Geocoding', 'Marker Clustering'],
    ),
    SkillItem(
      name: 'Razorpay & Stripe',
      categoryId: 'sdks_tools',
      proficiency: 0.90,
      experienceLevel: 'Fintech Payments',
      description: 'Subscription billing, payment checkouts, webhook verification, and UPI/card processing.',
      icon: Icons.payment_rounded,
      accentColor: Color(0xFF3B82F6),
      tags: ['Payment Gateways', 'Subscriptions', 'UPI'],
    ),
    SkillItem(
      name: 'Flutter Flavors & CI/CD',
      categoryId: 'sdks_tools',
      proficiency: 0.92,
      experienceLevel: 'DevOps & Deployment',
      description: 'Multi-environment setup (Dev, Staging, Prod), build configurations, GitHub Actions, and app signing.',
      icon: Icons.tune_rounded,
      accentColor: Color(0xFF00F2FE),
      tags: ['Dev/Staging/Prod', 'App Signing', 'CI/CD Pipelines'],
    ),
    SkillItem(
      name: 'Git, GitLab, Postman & Jira',
      categoryId: 'sdks_tools',
      proficiency: 0.95,
      experienceLevel: 'Team Workflows',
      description: 'Agile/Scrum sprints, PR reviews, merge conflict resolutions, and API testing suites.',
      icon: Icons.terminal_rounded,
      accentColor: Color(0xFFE2E8F0),
      tags: ['Version Control', 'Agile/Scrum', 'API Testing'],
    ),
  ];
}
