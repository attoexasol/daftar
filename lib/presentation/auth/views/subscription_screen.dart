import 'package:daftar/core/services/language_service.dart';
import 'package:daftar/core/widgets/app_drawer.dart';
import 'package:daftar/core/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Subscription Screen
/// Exact UI match to React Subscription.jsx component
/// Features: 5 plans, billing toggle, payment methods, guarantees, CTA
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  void _doNothing() {}

  String billingCycle = 'monthly'; // 'monthly' or 'annually'
  String currentPlan = 'professional'; // Current user plan

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Subscription Plans'.tr,
        onLanguageChange: LanguageService.instance.toggleLanguage,
        onRefresh: _doNothing,
      ),
      drawer: AppDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              // Header
              _buildHeader(isRTL),
              const SizedBox(height: 32),

              // Billing Cycle Toggle
              _buildBillingToggle(isRTL),
              const SizedBox(height: 32),

              // Current Plan Badge (if user has a plan)
              _buildCurrentPlanBadge(isRTL),
              const SizedBox(height: 32),

              // Subscription Plans Grid
              _buildSubscriptionPlans(isRTL),
              const SizedBox(height: 32),

              // All Features Section
              _buildAllFeaturesSection(isRTL),
              const SizedBox(height: 32),

              // Payment Methods
              _buildPaymentMethods(isRTL),
              const SizedBox(height: 32),

              // Guarantees
              _buildGuarantees(isRTL),
              const SizedBox(height: 32),

              // CTA Section
              _buildCTA(isRTL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isRTL) {
    return Column(
      children: [
        Text(
          isRTL ? 'خطط الاشتراك' : 'Subscription Plans',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          isRTL
              ? 'اختر الخطة المناسبة لنشاطك التجاري'
              : 'Choose the right plan for your business',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBillingToggle(bool isRTL) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            isRTL ? 'شهرياً' : 'Monthly',
            'monthly',
            isRTL,
          ),
          const SizedBox(width: 16),
          _buildToggleButton(
            isRTL ? 'سنوياً' : 'Annually',
            'annually',
            isRTL,
            badge: isRTL ? 'وفّر 20%' : 'Save 20%',
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, String value, bool isRTL,
      {String? badge}) {
    final isSelected = billingCycle == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          billingCycle = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF111827),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlanBadge(bool isRTL) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRTL ? 'خطتك الحالية' : 'Your Current Plan',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    isRTL ? 'احترافي' : 'Professional',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '299 ${isRTL ? 'د.إ' : 'AED'}',
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

  Widget _buildSubscriptionPlans(bool isRTL) {
    final plans = _getPlans(isRTL);

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        if (constraints.maxWidth < 1400) crossAxisCount = 3;
        if (constraints.maxWidth < 900) crossAxisCount = 2;
        if (constraints.maxWidth < 600) crossAxisCount = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            mainAxisExtent: 650,
          ),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            final isCurrentPlan = currentPlan == plan.id;
            final isMostPopular = plan.id == 'professional';
            final isEnterprise = plan.id == 'enterprise';

            return _buildPlanCard(
                plan, isCurrentPlan, isMostPopular, isEnterprise, isRTL);
          },
        );
      },
    );
  }

  Widget _buildPlanCard(PlanData plan, bool isCurrentPlan, bool isMostPopular,
      bool isEnterprise, bool isRTL) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isEnterprise
                ? null
                : isCurrentPlan
                    ? Colors.white
                    : Colors.white,
            gradient: isEnterprise
                ? const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrentPlan
                  ? const Color(0xFF8B5CF6)
                  : isMostPopular && !isEnterprise
                      ? const Color(0xFF3B82F6)
                      : Colors.transparent,
              width: isCurrentPlan || (isMostPopular && !isEnterprise) ? 4 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
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
                  color: isEnterprise
                      ? Colors.white.withOpacity(0.1)
                      : isMostPopular
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF9FAFB),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isEnterprise
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isEnterprise
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Price
                    if (plan.price == 'custom')
                      Text(
                        isRTL ? 'حسب الطلب' : 'Custom',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isEnterprise
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            plan.price,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isEnterprise
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRTL ? 'د.إ' : 'AED',
                            style: TextStyle(
                              fontSize: 18,
                              color: isEnterprise
                                  ? Colors.white.withOpacity(0.8)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRTL ? '/شهرياً' : '/month',
                            style: TextStyle(
                              fontSize: 14,
                              color: isEnterprise
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    if (billingCycle == 'annually' &&
                        plan.price != 'custom' &&
                        plan.price != '0')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${(int.parse(plan.price) * 12 * 0.8).toStringAsFixed(0)} ${isRTL ? 'د.إ/سنوياً' : 'AED/year'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isEnterprise
                                ? Colors.white.withOpacity(0.7)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Features
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: plan.features.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: isEnterprise
                                        ? Colors.white
                                        : const Color(0xFF10B981),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      plan.features[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isEnterprise
                                            ? Colors.white.withOpacity(0.9)
                                            : const Color(0xFF374151),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subscribe Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isCurrentPlan
                              ? null
                              : () => _handleSubscribe(plan.id, isRTL),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCurrentPlan
                                ? const Color(0xFFE5E7EB)
                                : isEnterprise
                                    ? Colors.white
                                    : isMostPopular
                                        ? const Color(0xFF3B82F6)
                                        : null,
                            disabledBackgroundColor: const Color(0xFFE5E7EB),
                            foregroundColor: isEnterprise
                                ? const Color(0xFF8B5CF6)
                                : isMostPopular
                                    ? Colors.white
                                    : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isCurrentPlan
                                ? (isRTL ? 'الحالي' : 'Current')
                                : plan.id == 'enterprise'
                                    ? (isRTL ? 'تواصل معنا' : 'Contact Us')
                                    : (isRTL ? 'اشترك الآن' : 'Subscribe Now'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Most Popular Badge
        if (isMostPopular && !isEnterprise)
          Positioned(
            top: -16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      isRTL ? 'الأكثر شعبية' : 'Most Popular',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAllFeaturesSection(bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(32),
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
          Text(
            isRTL ? 'جميع الخطط تتضمن' : 'All Plans Include',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth < 900) crossAxisCount = 2;
              if (constraints.maxWidth < 600) crossAxisCount = 1;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 3,
                children: [
                  _buildFeatureItem(
                    Icons.shield,
                    const Color(0xFF3B82F6),
                    const Color(0xFFEFF6FF),
                    isRTL ? 'أمان متقدم' : 'Advanced Security',
                    isRTL
                        ? 'تشفير SSL وحماية البيانات'
                        : 'SSL encryption & data protection',
                  ),
                  _buildFeatureItem(
                    Icons.bolt,
                    const Color(0xFF10B981),
                    const Color(0xFFF0FDF4),
                    isRTL ? 'أداء عالي' : 'High Performance',
                    isRTL ? 'سرعة استجابة فورية' : 'Instant response time',
                  ),
                  _buildFeatureItem(
                    Icons.auto_awesome,
                    const Color(0xFF8B5CF6),
                    const Color(0xFFF5F3FF),
                    isRTL ? 'ذكاء اصطناعي' : 'AI Powered',
                    isRTL
                        ? 'تحليلات ذكية وتنبؤات'
                        : 'Smart analytics & predictions',
                  ),
                  _buildFeatureItem(
                    Icons.trending_up,
                    const Color(0xFFF59E0B),
                    const Color(0xFFFFF7ED),
                    isRTL ? 'نمو مضمون' : 'Guaranteed Growth',
                    isRTL
                        ? 'تحسين الأداء المالي'
                        : 'Financial performance boost',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, Color iconColor, Color bgColor,
      String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(32),
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
              const Icon(Icons.credit_card, color: Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 12),
              Text(
                isRTL ? 'طرق الدفع المتاحة' : 'Available Payment Methods',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPaymentMethodItem(
                  Icons.credit_card, const Color(0xFF3B82F6), 'Stripe'),
              _buildPaymentMethodItem(
                  Icons.payment, const Color(0xFF3B82F6), 'PayPal'),
              _buildPaymentMethodItem(
                  Icons.account_balance,
                  const Color(0xFF10B981),
                  isRTL ? 'تحويل بنكي' : 'Bank Transfer'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(IconData icon, Color color, String name) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 40),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildGuarantees(bool isRTL) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Row(
            children: [
              Expanded(child: _buildGuaranteeCard(isRTL, 'money_back')),
              const SizedBox(width: 24),
              Expanded(child: _buildGuaranteeCard(isRTL, 'no_commitment')),
              const SizedBox(width: 24),
              Expanded(child: _buildGuaranteeCard(isRTL, 'cancel_anytime')),
            ],
          );
        } else {
          return Column(
            children: [
              _buildGuaranteeCard(isRTL, 'money_back'),
              const SizedBox(height: 24),
              _buildGuaranteeCard(isRTL, 'no_commitment'),
              const SizedBox(height: 24),
              _buildGuaranteeCard(isRTL, 'cancel_anytime'),
            ],
          );
        }
      },
    );
  }

  Widget _buildGuaranteeCard(bool isRTL, String type) {
    IconData icon;
    Color color;
    String title;
    String description;

    switch (type) {
      case 'money_back':
        icon = Icons.shield;
        color = const Color(0xFF10B981);
        title = isRTL
            ? 'ضمان استرداد المال خلال 30 يوم'
            : '30-Day Money Back Guarantee';
        description = isRTL
            ? 'لا تعجبك؟ استرد أموالك كاملة'
            : 'Not satisfied? Get full refund';
        break;
      case 'no_commitment':
        icon = Icons.calendar_today;
        color = const Color(0xFF3B82F6);
        title = isRTL ? 'بدون التزامات طويلة الأجل' : 'No Long-term Commitment';
        description = isRTL
            ? 'ادفع شهرياً بدون عقود طويلة'
            : 'Pay monthly with no long contracts';
        break;
      case 'cancel_anytime':
        icon = Icons.close;
        color = const Color(0xFF8B5CF6);
        title = isRTL ? 'إلغاء في أي وقت' : 'Cancel Anytime';
        description = isRTL ? 'إلغاء بضغطة زر واحدة' : 'Cancel with one click';
        break;
      default:
        icon = Icons.check;
        color = const Color(0xFF10B981);
        title = '';
        description = '';
    }

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
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isRTL ? 'جاهز للبدء؟' : 'Ready to Get Started?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isRTL
                ? 'انضم لأكثر من 500 صيدلية تستخدم دفتر'
                : 'Join 500+ pharmacies using Daftar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _handleSubscribe('professional', isRTL),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isRTL ? 'اشترك الآن' : 'Subscribe Now',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe(String planId, bool isRTL) {
    if (planId == 'enterprise') {
      // Open email or contact form
      Get.snackbar(
        isRTL ? 'تواصل معنا' : 'Contact Us',
        isRTL ? 'سيتم فتح نموذج الاتصال' : 'Contact form will open',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B82F6),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    Get.snackbar(
      isRTL ? 'قريباً' : 'Coming Soon',
      isRTL
          ? 'سيتم إضافة الاشتراك قريباً'
          : 'Subscription will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  List<PlanData> _getPlans(bool isRTL) {
    if (isRTL) {
      return [
        PlanData(
          id: 'free',
          name: 'تجريبي مجاني',
          description: 'مثالي لتجربة النظام',
          price: '0',
          features: [
            '14 يوم تجريبي مجاني',
            'حتى 50 فاتورة/شهرياً',
            '1 مستخدم',
            '1 فرع',
            'تقارير أساسية',
            'دعم عبر البريد',
          ],
        ),
        PlanData(
          id: 'basic',
          name: 'أساسي',
          description: 'للصيدليات والمنشآت الصغيرة',
          price: '99',
          features: [
            'حتى 500 فاتورة/شهرياً',
            '3 مستخدمين',
            '2 فروع',
            'تقارير متقدمة',
            'الفوترة الإلكترونية',
            'ربط بنكي أساسي',
            'دعم فني 24/7',
            'نسخ احتياطي يومي',
          ],
        ),
        PlanData(
          id: 'professional',
          name: 'احترافي',
          description: 'للصيدليات المتوسطة والمتنامية',
          price: '299',
          features: [
            'حتى 2000 فاتورة/شهرياً',
            '10 مستخدمين',
            '5 فروع',
            'جميع مميزات Basic +',
            'ذكاء اصطناعي متقدم',
            'تحليلات تنبؤية',
            'أتمتة كاملة',
            'بوابة عملاء',
            'تكامل API',
            'دعم ذو أولوية',
          ],
        ),
        PlanData(
          id: 'premium',
          name: 'بريميوم',
          description: 'للصيدليات الكبيرة والسلاسل',
          price: '599',
          features: [
            'فواتير غير محدودة',
            '25 مستخدم',
            '15 فرع',
            'جميع مميزات Professional +',
            'مدير حساب مخصص',
            'تدريب شامل',
            'تخصيص كامل',
            'White Label',
            'SLA مضمون 99.9%',
            'تقارير مخصصة',
          ],
        ),
        PlanData(
          id: 'enterprise',
          name: 'مؤسسات',
          description: 'للمؤسسات الكبرى والسلاسل الوطنية',
          price: 'custom',
          features: [
            'كل شيء غير محدود',
            'مستخدمين غير محدود',
            'فروع غير محدودة',
            'جميع مميزات Premium +',
            'بنية تحتية خاصة',
            'أمان متقدم',
            'Compliance كامل',
            'تكامل ERP',
            'دعم متواصل 24/7/365',
            'استشارات مجانية',
          ],
        ),
      ];
    } else {
      return [
        PlanData(
          id: 'free',
          name: 'Free Trial',
          description: 'Perfect for trying the system',
          price: '0',
          features: [
            '14-day free trial',
            'Up to 50 invoices/month',
            '1 user',
            '1 branch',
            'Basic reports',
            'Email support',
          ],
        ),
        PlanData(
          id: 'basic',
          name: 'Basic',
          description: 'For small pharmacies',
          price: '99',
          features: [
            'Up to 500 invoices/month',
            '3 users',
            '2 branches',
            'Advanced reports',
            'E-invoicing',
            'Basic bank integration',
            '24/7 support',
            'Daily backups',
          ],
        ),
        PlanData(
          id: 'professional',
          name: 'Professional',
          description: 'For growing pharmacies',
          price: '299',
          features: [
            'Up to 2000 invoices/month',
            '10 users',
            '5 branches',
            'All Basic features +',
            'Advanced AI',
            'Predictive analytics',
            'Full automation',
            'Client portal',
            'API integration',
            'Priority support',
          ],
        ),
        PlanData(
          id: 'premium',
          name: 'Premium',
          description: 'For large chains',
          price: '599',
          features: [
            'Unlimited invoices',
            '25 users',
            '15 branches',
            'All Professional features +',
            'Dedicated account manager',
            'Comprehensive training',
            'Full customization',
            'White Label',
            '99.9% SLA guarantee',
            'Custom reports',
          ],
        ),
        PlanData(
          id: 'enterprise',
          name: 'Enterprise',
          description: 'For large organizations',
          price: 'custom',
          features: [
            'Everything unlimited',
            'Unlimited users',
            'Unlimited branches',
            'All Premium features +',
            'Dedicated infrastructure',
            'Advanced security',
            'Full compliance',
            'ERP integration',
            '24/7/365 support',
            'Free consultations',
          ],
        ),
      ];
    }
  }
}

class PlanData {
  final String id;
  final String name;
  final String description;
  final String price;
  final List<String> features;

  PlanData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });
}
