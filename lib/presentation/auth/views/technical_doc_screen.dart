import 'package:daftar/app/theme/app_colors.dart';
import 'package:daftar/core/services/language_service.dart';
import 'package:daftar/core/widgets/app_drawer.dart';
import 'package:daftar/core/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Technical Documentation Screen
/// Complete implementation matching React TechnicalDoc.jsx component
///
/// Features:
/// - 70+ pages documentation overview
/// - 12 sections with Table of Contents
/// - Statistics cards (Pages, Sections, Code Examples, Diagrams)
/// - 8 feature highlights
/// - 4 download/conversion methods
/// - Download and Print functionality
/// - Full RTL support for Arabic
/// - Responsive layout (Desktop/Tablet/Mobile)
/// - Gradient styling and animations
///
/// Usage:
/// ```dart
/// Get.toNamed('/technical-doc');
/// // or
/// Navigator.push(context, MaterialPageRoute(
///   builder: (context) => TechnicalDocScreen(),
/// ));
/// ```

class TechnicalDocScreen extends StatefulWidget {
  const TechnicalDocScreen({super.key});

  @override
  State<TechnicalDocScreen> createState() => _TechnicalDocScreenState();
}

class _TechnicalDocScreenState extends State<TechnicalDocScreen> {
  void _doNothing() {}
  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Technical Documentation'.tr,
        onLanguageChange: LanguageService.instance.toggleLanguage,
        onRefresh: _doNothing,
      ),
      drawer: AppDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 768 ? 32 : 16,
            vertical: MediaQuery.of(context).size.width > 768 ? 32 : 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and action buttons
                  _buildHeader(isRTL),
                  const SizedBox(height: 24),

                  // Green status card - Document Ready
                  _buildStatusCard(isRTL),
                  const SizedBox(height: 24),

                  // Statistics grid (4 cards)
                  _buildStatisticsGrid(isRTL),
                  const SizedBox(height: 24),

                  // Overview/Description card
                  _buildOverviewCard(isRTL),
                  const SizedBox(height: 24),

                  // Features grid (8 features)
                  _buildFeaturesGrid(isRTL),
                  const SizedBox(height: 24),

                  // Table of Contents (12 sections)
                  _buildTableOfContents(isRTL),
                  const SizedBox(height: 24),

                  // Download Instructions (4 methods)
                  _buildDownloadInstructions(isRTL),
                  const SizedBox(height: 24),

                  // Bottom action buttons
                  _buildBottomActions(isRTL),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header with gradient icon, title, subtitle, and action buttons
  Widget _buildHeader(bool isRTL) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          // Mobile layout - stacked
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isRTL
                          ? 'الوثيقة التقنية الشاملة'
                          : 'Complete Technical Documentation',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isRTL
                    ? 'دليل المطور الكامل لتحويل التطبيق إلى Native Mobile App'
                    : 'Full Developer Guide for Native Mobile App Conversion',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDownloadButton(isRTL, compact: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPrintButton(isRTL, compact: true),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Desktop layout - side by side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Title and subtitle
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRTL
                                ? 'الوثيقة التقنية الشاملة'
                                : 'Complete Technical Documentation',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isRTL
                                ? 'دليل المطور الكامل لتحويل التطبيق إلى Native Mobile App'
                                : 'Full Developer Guide for Native Mobile App Conversion',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side - Action buttons
              Row(
                children: [
                  _buildDownloadButton(isRTL),
                  const SizedBox(width: 12),
                  _buildPrintButton(isRTL),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDownloadButton(bool isRTL, {bool compact = false}) {
    return ElevatedButton.icon(
      onPressed: _handleDownload,
      icon: Icon(Icons.download, size: compact ? 18 : 20),
      label: Text(
        isRTL ? 'تحميل PDF' : 'Download PDF',
        style: TextStyle(fontSize: compact ? 14 : 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 24,
          vertical: compact ? 14 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ).copyWith(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ).decorated(
      gradient: const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildPrintButton(bool isRTL, {bool compact = false}) {
    return OutlinedButton.icon(
      onPressed: _handlePrint,
      icon: Icon(Icons.print, size: compact ? 18 : 20),
      label: Text(
        isRTL ? 'طباعة' : 'Print',
        style: TextStyle(fontSize: compact ? 14 : 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 24,
          vertical: compact ? 14 : 16,
        ),
        side: const BorderSide(color: Color(0xFFD1D5DB), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Green success card showing document ready status
  Widget _buildStatusCard(bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
        ),
        border: Border.all(color: const Color(0xFF86EFAC), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Green check icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRTL ? 'الوثيقة جاهزة' : 'Document Ready',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRTL ? 'جاهزة للإرسال للمطور' : 'Ready to Send to Developer',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF047857),
                  ),
                ),
              ],
            ),
          ),
          // Badge showing page count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '70+ ${isRTL ? 'صفحة' : 'Pages'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Statistics grid with 4 cards (Pages, Sections, Code Examples, Diagrams)
  Widget _buildStatisticsGrid(bool isRTL) {
    final stats = [
      _StatData(
        icon: Icons.description_outlined,
        value: '70+',
        label: isRTL ? 'صفحة' : 'Pages',
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
        ),
        iconColor: const Color(0xFF3B82F6),
        textColor: const Color(0xFF1E3A8A),
      ),
      _StatData(
        icon: Icons.menu_book,
        value: '18',
        label: isRTL ? 'قسم' : 'Sections',
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
        ),
        iconColor: const Color(0xFF8B5CF6),
        textColor: const Color(0xFF581C87),
      ),
      _StatData(
        icon: Icons.code,
        value: '50+',
        label: isRTL ? 'مثال برمجي' : 'Code Examples',
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
        ),
        iconColor: const Color(0xFF10B981),
        textColor: const Color(0xFF065F46),
      ),
      _StatData(
        icon: Icons.settings,
        value: '15+',
        label: isRTL ? 'رسم توضيحي' : 'Diagrams',
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
        ),
        iconColor: const Color(0xFFF59E0B),
        textColor: const Color(0xFF92400E),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 1024) crossAxisCount = 2;
        if (constraints.maxWidth < 640) crossAxisCount = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: stat.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    stat.icon,
                    size: 48,
                    color: stat.iconColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat.value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: stat.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: stat.textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Overview/Description card
  Widget _buildOverviewCard(bool isRTL) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: isRTL ? 'نظرة عامة' : 'Overview',
          ),
          const SizedBox(height: 16),
          Text(
            isRTL
                ? 'وثيقة تقنية شاملة بأكثر من 70 صفحة تحتوي على كل ما يحتاجه المطور لتحويل التطبيق إلى تطبيق موبايل Native لـ iOS و Android'
                : 'Comprehensive technical documentation with 70+ pages containing everything a developer needs to convert the app to Native iOS & Android mobile apps',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF374151),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Features grid with 8 feature cards
  Widget _buildFeaturesGrid(bool isRTL) {
    final features = [
      _FeatureData(
        icon: Icons.check_circle,
        label: isRTL ? 'شاملة 100%' : '100% Comprehensive',
        color: const Color(0xFF10B981),
      ),
      _FeatureData(
        icon: Icons.code,
        label: isRTL ? 'تقنية ومفصلة' : 'Technical & Detailed',
        color: const Color(0xFF3B82F6),
      ),
      _FeatureData(
        icon: Icons.bolt,
        label: isRTL ? 'كود جاهز للاستخدام' : 'Ready-to-Use Code',
        color: const Color(0xFF8B5CF6),
      ),
      _FeatureData(
        icon: Icons.menu_book,
        label: isRTL ? 'خطوة بخطوة' : 'Step-by-Step',
        color: const Color(0xFFF59E0B),
      ),
      _FeatureData(
        icon: Icons.description_outlined,
        label: isRTL ? 'رسوم توضيحية' : 'Visual Diagrams',
        color: const Color(0xFFEC4899),
      ),
      _FeatureData(
        icon: Icons.shield,
        label: isRTL ? 'أفضل الممارسات' : 'Best Practices',
        color: const Color(0xFF14B8A6),
      ),
      _FeatureData(
        icon: Icons.verified,
        label: isRTL ? 'مُختبر وجاهز' : 'Tested & Ready',
        color: const Color(0xFF10B981),
      ),
      _FeatureData(
        icon: Icons.phone_android,
        label: isRTL ? 'جاهز للنشر' : 'App Store Ready',
        color: const Color(0xFF3B82F6),
      ),
    ];

    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.bolt,
            iconColor: const Color(0xFFF59E0B),
            title: isRTL ? 'المحتويات' : 'Includes',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth < 1024) crossAxisCount = 2;
              if (constraints.maxWidth < 640) crossAxisCount = 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          feature.icon,
                          color: feature.color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Table of Contents with 12 sections
  Widget _buildTableOfContents(bool isRTL) {
    final sections = [
      _SectionData(
        icon: Icons.menu_book,
        title: isRTL ? 'الملخص التنفيذي' : 'Executive Summary',
        pages: 3,
      ),
      _SectionData(
        icon: Icons.settings,
        title: isRTL ? 'البنية التقنية' : 'Technical Architecture',
        pages: 5,
      ),
      _SectionData(
        icon: Icons.storage,
        title: isRTL ? 'قاعدة البيانات' : 'Database Schema',
        pages: 8,
      ),
      _SectionData(
        icon: Icons.bolt,
        title: 'PWA Implementation',
        pages: 6,
      ),
      _SectionData(
        icon: Icons.shield,
        title: isRTL ? 'الوظائف Offline' : 'Offline Functionality',
        pages: 5,
      ),
      _SectionData(
        icon: Icons.security,
        title: isRTL ? 'الأمان' : 'Security Implementation',
        pages: 4,
      ),
      _SectionData(
        icon: Icons.psychology,
        title: isRTL ? 'الذكاء الاصطناعي' : 'AI Integration',
        pages: 4,
      ),
      _SectionData(
        icon: Icons.phone_android,
        title: isRTL ? 'دليل تحويل الموبايل' : 'Mobile Conversion Guide',
        pages: 15,
      ),
      _SectionData(
        icon: Icons.code,
        title: isRTL ? 'توثيق API' : 'API Documentation',
        pages: 6,
      ),
      _SectionData(
        icon: Icons.check_circle,
        title: isRTL ? 'الاختبار' : 'Testing Requirements',
        pages: 5,
      ),
      _SectionData(
        icon: Icons.cloud_upload,
        title: isRTL ? 'النشر' : 'Deployment Guide',
        pages: 6,
      ),
      _SectionData(
        icon: Icons.gavel,
        title: isRTL ? 'التوافق القانوني' : 'Legal Compliance',
        pages: 4,
      ),
    ];

    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.menu_book,
            iconColor: const Color(0xFF3B82F6),
            title: isRTL ? 'جدول المحتويات' : 'Table of Contents',
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sections.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final section = sections[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9FAFB), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        section.icon,
                        color: const Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and pages
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isRTL
                                ? '${section.pages} صفحة'
                                : '${section.pages} pages',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section number badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Download Instructions with 4 methods
  Widget _buildDownloadInstructions(bool isRTL) {
    final methods = [
      _MethodData(
        number: '1',
        title: isRTL
            ? 'استخدم VS Code مع إضافة Markdown PDF'
            : 'Use VS Code with Markdown PDF extension',
        code: 'Ctrl+Shift+P → Markdown PDF',
        color: const Color(0xFF8B5CF6),
        borderColor: const Color(0xFFE9D5FF),
      ),
      _MethodData(
        number: '2',
        title: isRTL ? 'استخدم موقع dillinger.io' : 'Use dillinger.io website',
        code: 'dillinger.io',
        link: 'https://dillinger.io',
        color: const Color(0xFF3B82F6),
        borderColor: const Color(0xFFBFDBFE),
      ),
      _MethodData(
        number: '3',
        title: isRTL ? 'استخدم Pandoc من Terminal' : 'Use Pandoc from Terminal',
        code: 'pandoc file.md -o doc.pdf',
        color: const Color(0xFF10B981),
        borderColor: const Color(0xFFA7F3D0),
      ),
      _MethodData(
        number: '4',
        title: isRTL
            ? 'طباعة من المتصفح (Ctrl+P) → Save as PDF'
            : 'Print from browser (Ctrl+P) → Save as PDF',
        code: 'Ctrl+P → Save as PDF',
        color: const Color(0xFFF59E0B),
        borderColor: const Color(0xFFFCD34D),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F3FF), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE9D5FF), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.download, color: Color(0xFF8B5CF6), size: 24),
                const SizedBox(width: 8),
                Text(
                  isRTL ? 'تعليمات التحميل' : 'Download Instructions',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            isRTL
                ? 'الملف متاح كـ Markdown. يمكنك تحويله إلى PDF باستخدام أحد الطرق التالية:'
                : 'The file is available as Markdown. You can convert it to PDF using one of these methods:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          // Methods grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth < 768) crossAxisCount = 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: crossAxisCount == 1 ? 4 : 3,
                ),
                itemCount: methods.length,
                itemBuilder: (context, index) {
                  final method = methods[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: method.borderColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Number badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: method.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            method.number,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                method.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (method.link != null)
                                GestureDetector(
                                  onTap: () => _launchURL(method.link!),
                                  child: Row(
                                    children: [
                                      Text(
                                        method.code,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF3B82F6),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.open_in_new,
                                        size: 12,
                                        color: Color(0xFF3B82F6),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    method.code,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Bottom action buttons (View Document and Print)
  Widget _buildBottomActions(bool isRTL) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          // View Document button with gradient
          SizedBox(
            width: 240,
            height: 56,
            child: ElevatedButton(
              onPressed: _handleDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isRTL ? 'عرض الوثيقة' : 'View Document',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Print button
          SizedBox(
            width: 200,
            height: 56,
            child: OutlinedButton(
              onPressed: _handlePrint,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD1D5DB), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.print, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isRTL ? 'طباعة' : 'Print',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== EVENT HANDLERS =====

  void _handleDownload() {
    Get.snackbar(
      Get.locale?.languageCode == 'ar' ? 'تحميل الوثيقة' : 'Download Document',
      Get.locale?.languageCode == 'ar'
          ? 'جاري فتح الوثيقة التقنية...'
          : 'Opening technical documentation...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.download, color: Colors.white),
    );

    // TODO: In production, open the actual document
    // Example: launch('https://your-domain.com/TECHNICAL_DOCUMENTATION.md');
    // Or open a local PDF viewer
  }

  void _handlePrint() {
    Get.snackbar(
      Get.locale?.languageCode == 'ar' ? 'طباعة' : 'Print',
      Get.locale?.languageCode == 'ar'
          ? 'جاري فتح معاينة الطباعة...'
          : 'Opening print preview...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6B7280),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.print, color: Colors.white),
    );

    // TODO: In production, trigger print dialog
    // For Flutter web: html.window.print();
    // For mobile: Use printing package
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

// ===== HELPER WIDGETS =====

/// Reusable card container with white background and shadow
class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Card header with optional icon
class _CardHeader extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String title;

  const _CardHeader({
    this.icon,
    this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== DATA MODELS =====

class _StatData {
  final IconData icon;
  final String value;
  final String label;
  final LinearGradient gradient;
  final Color iconColor;
  final Color textColor;

  _StatData({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    required this.iconColor,
    required this.textColor,
  });
}

class _FeatureData {
  final IconData icon;
  final String label;
  final Color color;

  _FeatureData({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _SectionData {
  final IconData icon;
  final String title;
  final int pages;

  _SectionData({
    required this.icon,
    required this.title,
    required this.pages,
  });
}

class _MethodData {
  final String number;
  final String title;
  final String code;
  final String? link;
  final Color color;
  final Color borderColor;

  _MethodData({
    required this.number,
    required this.title,
    required this.code,
    this.link,
    required this.color,
    required this.borderColor,
  });
}

// ===== EXTENSION FOR GRADIENT BUTTON =====

extension WidgetExtension on Widget {
  Widget decorated({
    required Gradient gradient,
    required BorderRadius borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  
}
