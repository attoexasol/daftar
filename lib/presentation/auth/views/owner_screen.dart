import 'package:daftar/core/services/language_service.dart';
import 'package:daftar/core/widgets/app_drawer.dart';
import 'package:daftar/core/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Owner Screen - Interactive Owner Guide
/// Exact UI match to React OwnerDemo.jsx component
/// Features: 13 steps, progress tracking, practical scenarios, help section
class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {

  void _doNothing() {}

  int currentStep = 0;
  final int totalSteps = 13;
  Set<int> completedSteps = {};

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';
    final stepData = _getStepData(isRTL);
    final currentStepData = stepData[currentStep];
    final progress = ((currentStep + 1) / totalSteps * 100).round();

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Owner'.tr,
        onLanguageChange: LanguageService.instance.toggleLanguage,
        onRefresh: _doNothing
      ),
      drawer: AppDrawer(),
      backgroundColor: const Color(0xFFF0F4FF),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              // Header Section
              _buildHeader(isRTL),
              const SizedBox(height: 32),

              // Progress Bar
              _buildProgressBar(progress, isRTL),
              const SizedBox(height: 32),

              // Main Content Area
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1024) {
                    // Desktop Layout - 3 columns
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Steps Sidebar
                        Expanded(
                          flex: 1,
                          child: _buildStepsSidebar(stepData, isRTL),
                        ),
                        const SizedBox(width: 32),

                        // Main Content
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildMainContent(currentStepData, isRTL),
                              if (currentStep == 0) ...[
                                const SizedBox(height: 32),
                                _buildPracticalScenarios(isRTL),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Mobile Layout - Stack
                    return Column(
                      children: [
                        _buildMainContent(currentStepData, isRTL),
                        const SizedBox(height: 32),
                        if (currentStep == 0) ...[
                          _buildPracticalScenarios(isRTL),
                          const SizedBox(height: 32),
                        ],
                        _buildStepsSidebar(stepData, isRTL),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Help Section
              _buildHelpSection(isRTL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isRTL) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.play_circle,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            isRTL ? 'دليل المالك التفاعلي' : 'Interactive Owner Guide',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            isRTL ? 'تعلم كيفية استخدام دفتر في 15 دقيقة' : 'Learn how to use Daftar in 15 minutes',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Time Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 20, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text(
                      isRTL ? 'الوقت المتوقع: 15 دقيقة' : 'Estimated Time: 15 minutes',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      isRTL ? 'مميزات جديدة' : 'New Features',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int progress, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRTL ? 'تقدمك' : 'Your Progress',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              Text(
                '${completedSteps.length} / $totalSteps ${isRTL ? 'مكتمل' : 'Completed'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSidebar(List<StepData> stepData, bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Colors.white],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              isRTL ? 'الخطوات' : 'Steps',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: stepData.length,
              itemBuilder: (context, index) {
                final step = stepData[index];
                final isCompleted = completedSteps.contains(index);
                final isCurrent = currentStep == index;
                final isNew = index <= 6;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentStep = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isCurrent
                          ? const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            )
                          : null,
                      color: isCurrent
                          ? null
                          : isCompleted
                              ? const Color(0xFFF0FDF4)
                              : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.white.withOpacity(0.2)
                                : isCompleted
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isCompleted ? Icons.check_circle : step.icon,
                            color: isCurrent
                                ? Colors.white
                                : isCompleted
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF6B7280),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      step.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isCurrent
                                            ? Colors.white
                                            : const Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                  if (isNew && !isCurrent)
                                    const Icon(
                                      Icons.auto_awesome,
                                      size: 12,
                                      color: Color(0xFF8B5CF6),
                                    ),
                                ],
                              ),
                              Text(
                                step.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCurrent
                                      ? Colors.white.withOpacity(0.8)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(StepData stepData, bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: stepData.gradientColors,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: stepData.iconGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        stepData.icon,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    if (currentStep <= 6)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isRTL ? 'AI' : 'AI',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF374151),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isRTL
                                  ? 'الخطوة ${currentStep + 1} من $totalSteps'
                                  : 'Step ${currentStep + 1} of $totalSteps',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (currentStep <= 6) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    isRTL ? 'جديد' : 'New',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stepData.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stepData.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  stepData.description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF374151),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Features
                _buildFeaturesSection(stepData, isRTL),
                const SizedBox(height: 24),

                // Example
                _buildExampleSection(stepData, isRTL),
                const SizedBox(height: 24),

                // Tip
                _buildTipSection(stepData, isRTL),
                const SizedBox(height: 24),

                // Try Now Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (stepData.route != null) {
                        Get.toNamed(stepData.route!);
                      } else {
                        Get.snackbar(
                          isRTL ? 'قريباً' : 'Coming Soon',
                          isRTL ? 'هذه الميزة ستكون متاحة قريباً' : 'This feature will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
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
                        gradient: stepData.iconGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              isRTL ? 'جرب الآن' : 'Try Now',
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
                const SizedBox(height: 24),

                // Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: currentStep > 0
                          ? () {
                              setState(() {
                                currentStep--;
                              });
                            }
                          : null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back),
                          const SizedBox(width: 8),
                          Text(isRTL ? 'السابق' : 'Previous'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentStep < totalSteps - 1) {
                          setState(() {
                            completedSteps.add(currentStep);
                            currentStep++;
                          });
                        } else {
                          setState(() {
                            completedSteps.add(currentStep);
                          });
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Text(
                                currentStep == totalSteps - 1
                                    ? (isRTL ? 'إنهاء' : 'Finish')
                                    : (isRTL ? 'التالي' : 'Next'),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                currentStep == totalSteps - 1
                                    ? Icons.check_circle
                                    : Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(StepData stepData, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 24),
            const SizedBox(width: 8),
            Text(
              isRTL ? 'المميزات الرئيسية' : 'Key Features',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...stepData.features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildExampleSection(StepData stepData, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                isRTL ? 'مثال عملي' : 'Practical Example',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stepData.example,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1E40AF),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection(StepData stepData, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
        ),
        border: Border.all(color: const Color(0xFFFCD34D), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                isRTL ? 'نصيحة سريعة' : 'Quick Tip',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78350F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stepData.tip,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF92400E),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticalScenarios(bool isRTL) {
    final scenarios = _getPracticalScenarios(isRTL);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book, color: Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 12),
              Text(
                isRTL ? 'سيناريوهات عملية' : 'Practical Scenarios',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 768) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: scenarios
                      .map((scenario) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _buildScenarioCard(scenario, isRTL),
                            ),
                          ))
                      .toList(),
                );
              } else {
                return Column(
                  children: scenarios
                      .map((scenario) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildScenarioCard(scenario, isRTL),
                          ))
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(Map<String, dynamic> scenario, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF9FAFB), Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenario['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 4),
                Text(
                  scenario['time'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...(scenario['steps'] as List<String>).map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHelpSection(bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRTL ? 'بحاجة للمساعدة؟' : 'Need Help?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  isRTL ? 'المساعد الذكي متاح 24/7' : 'Smart Assistant available 24/7',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.video_library),
            label: Text(isRTL ? 'شاهد الفيديو' : 'Watch Video'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat),
            label: Text(isRTL ? 'تواصل مع الدعم' : 'Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StepData> _getStepData(bool isRTL) {
    if (isRTL) {
      return [
        StepData(
          title: 'التوافق الضريبي - الأهم أولاً',
          subtitle: 'الفوترة الإلكترونية حسب قوانين الإمارات والسعودية',
          description:
              'ابدأ بإعداد معلومات المنشأة الضريبية للتوافق الكامل مع قوانين الفوترة الإلكترونية.',
          features: [
            'تسجيل الرقم الضريبي (TRN) من 15 رقم',
            'رقم السجل التجاري للسعودية',
            'اختيار الدولة الضريبية (إمارات 5% أو سعودية 15%)',
            'إعداد الفوترة الإلكترونية تلقائياً',
            'رموز QR متوافقة مع ZATCA/FTA',
          ],
          example:
              'مثال: صيدلية في دبي - TRN: 123456789012345 - VAT: 5% - الفواتير تحتوي على QR كود إلزامي',
          tip: '⚠️ إلزامي: لا يمكن إصدار فواتير قانونية بدون إكمال هذه الخطوة',
          icon: Icons.shield,
          gradientColors: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFF87171)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
          ),
          route: null,
        ),
        StepData(
          title: 'لوحة التحكم - نظرة سريعة',
          subtitle: 'افهم وضعك المالي في لحظة',
          description: 'لوحة التحكم هي أول ما تراه عند فتح التطبيق. تعرض لك ملخصاً شاملاً لوضعك المالي.',
          features: [
            'الرصيد الإجمالي - كم لديك من أموال الآن',
            'إيرادات ومصروفات الشهر الحالي',
            'صافي الربح والخسارة',
            'رسوم بيانية توضيحية',
            'آخر المعاملات المالية',
          ],
          example:
              'مثلاً: إذا كان رصيدك 50,000 د.إ وإيراداتك 30,000 د.إ ومصروفاتك 20,000 د.إ، فصافي ربحك 10,000 د.إ',
          tip: 'افتح التطبيق يومياً في الصباح لمدة دقيقة واحدة لتعرف وضعك المالي',
          icon: Icons.dashboard,
          gradientColors: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          ),
          route: '/dashboard',
        ),
        // Add remaining 11 steps here with same structure...
        // I'll add a few more for demonstration
        StepData(
          title: 'تطبيق الموبايل - إدارة من جيبك',
          subtitle: 'سجل المعاملات من أي مكان',
          description: 'تطبيق الموبايل يتيح لك إدارة مالية سريعة وسهلة من هاتفك مباشرة.',
          features: [
            'مسح الإيصالات بالكاميرا + AI',
            'استخراج البيانات تلقائياً (المبلغ، الوصف، التاريخ)',
            'إضافة معاملات سريعة',
            'عرض الرصيد والإحصائيات',
            'إشعارات فورية للمعاملات الكبيرة',
          ],
          example:
              'مثال: التقط صورة للإيصال → AI يستخرج: المبلغ 150 د.إ، فئة: مرافق → احفظ بضغطة واحدة ✅',
          tip: 'استخدم الموبايل للتسجيل الفوري - لا تنتظر حتى تصل للمكتب',
          icon: Icons.phone_android,
          gradientColors: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
          ),
          route: null,
        ),
      ];
    } else {
      return [
        StepData(
          title: 'Tax Compliance - Most Important First',
          subtitle: 'E-Invoicing per UAE & KSA regulations',
          description:
              'Start by setting up your tax information for full compliance with e-invoicing laws.',
          features: [
            'Register 15-digit Tax Registration Number (TRN)',
            'Commercial Registration Number for KSA',
            'Choose tax country (UAE 5% or KSA 15%)',
            'Auto-configure e-invoicing',
            'ZATCA/FTA compliant QR codes',
          ],
          example:
              'Example: Pharmacy in Dubai - TRN: 123456789012345 - VAT: 5% - Invoices contain mandatory QR code',
          tip: '⚠️ Mandatory: Cannot issue legal invoices without completing this step',
          icon: Icons.shield,
          gradientColors: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFF87171)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
          ),
          route: null,
        ),
        StepData(
          title: 'Dashboard - Quick Overview',
          subtitle: 'Understand your finances at a glance',
          description:
              'The dashboard is the first thing you see when opening the app. It shows a comprehensive summary of your financial status.',
          features: [
            'Total Balance - How much money you have now',
            'Current month income and expenses',
            'Net profit and loss',
            'Visual charts',
            'Latest financial transactions',
          ],
          example:
              'Example: If your balance is 50,000 AED, income 30,000 AED, expenses 20,000 AED, then net profit is 10,000 AED',
          tip: 'Open the app daily for one minute in the morning to know your financial status',
          icon: Icons.dashboard,
          gradientColors: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          ),
          route: '/dashboard',
        ),
        StepData(
          title: 'Mobile App - Manage from Your Pocket',
          subtitle: 'Record transactions from anywhere',
          description: 'Mobile app enables quick and easy financial management directly from your phone.',
          features: [
            'Scan receipts with camera + AI',
            'Auto-extract data (amount, description, date)',
            'Quick transaction entry',
            'View balance and statistics',
            'Instant notifications for large transactions',
          ],
          example:
              'Example: Take photo of receipt → AI extracts: Amount 150 AED, Category: Utilities → Save with one tap ✅',
          tip: 'Use mobile for instant recording - don\'t wait until you get to the office',
          icon: Icons.phone_android,
          gradientColors: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
          ),
          iconGradient: const LinearGradient(
            colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
          ),
          route: null,
        ),
      ];
    }
  }

  List<Map<String, dynamic>> _getPracticalScenarios(bool isRTL) {
    if (isRTL) {
      return [
        {
          'title': 'بداية اليوم: صباح الاثنين',
          'time': '3 دقائق',
          'steps': [
            'افتح التطبيق واطلع على لوحة التحكم',
            'راجع الرصيد والمعاملات الأخيرة',
            'تحقق من التنبيهات والفواتير المتأخرة',
          ],
        },
        {
          'title': 'خلال اليوم: بيع وشراء',
          'time': '5 دقائق',
          'steps': [
            'التقط صورة للفاتورة بالموبايل',
            'AI يستخرج البيانات تلقائياً',
            'راجع واحفظ المعاملة',
            'أصدر فاتورة للعميل بضغطة زر',
          ],
        },
        {
          'title': 'نهاية الشهر: مراجعة الأداء',
          'time': '10 دقائق',
          'steps': [
            'افتح صفحة التقارير',
            'راجع تقرير الدخل الشهري',
            'قارن بالشهر السابق',
            'صدّر التقرير PDF للمحاسب',
          ],
        },
      ];
    } else {
      return [
        {
          'title': 'Start of Day: Monday Morning',
          'time': '3 minutes',
          'steps': [
            'Open app and check dashboard',
            'Review balance and recent transactions',
            'Check alerts and overdue invoices',
          ],
        },
        {
          'title': 'During Day: Sales & Purchases',
          'time': '5 minutes',
          'steps': [
            'Take photo of invoice with mobile',
            'AI auto-extracts data',
            'Review and save transaction',
            'Issue customer invoice with one tap',
          ],
        },
        {
          'title': 'End of Month: Performance Review',
          'time': '10 minutes',
          'steps': [
            'Open reports page',
            'Review monthly income statement',
            'Compare with previous month',
            'Export PDF report for accountant',
          ],
        },
      ];
    }
  }
}

class StepData {
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final String example;
  final String tip;
  final IconData icon;
  final LinearGradient gradientColors;
  final LinearGradient iconGradient;
  final String? route;

  StepData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.example,
    required this.tip,
    required this.icon,
    required this.gradientColors,
    required this.iconGradient,
    this.route,
  });
}