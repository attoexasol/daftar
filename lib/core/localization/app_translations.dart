import 'package:get/get.dart';

/// App Translations
/// Contains all translation strings for the application
/// Supports Arabic (ar) and English (en)
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          // App Info
          'app_name': 'دفتر',
          'app_description': 'نظام المحاسبة الذكي',
          'powered_by_ai': 'مدعوم بالذكاء الاصطناعي',

          // Login Screen
          'login_title': 'تسجيل الدخول',
          'login_subtitle': 'مرحباً بك في دفتر - نظام المحاسبة الذكي',
          'email': 'البريد الإلكتروني',
          'email_hint': 'أدخل بريدك الإلكتروني',
          'password': 'كلمة المرور',
          'password_hint': '••••••••',
          'login': 'تسجيل الدخول',
          'forgot_password': 'نسيت كلمة المرور؟',
          'no_account': 'ليس لديك حساب؟',
          'register_now': 'سجل الآن',
          'or_continue_with': 'أو تابع باستخدام',
          'demo_mode': 'تجربة الوضع التجريبي',
          'remember_me': 'تذكرني',

          // Language
          'language': 'اللغة',
          'language_changed': 'تم تغيير اللغة',
          'language_changed_message': 'تم تغيير اللغة إلى الإنجليزية',
          'switch_language': 'English',
          'current_language': 'العربية',

          // Validation
          'email_required': 'البريد الإلكتروني مطلوب',
          'email_invalid': 'البريد الإلكتروني غير صالح',
          'password_required': 'كلمة المرور مطلوبة',
          'password_min_length': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',

          // Messages
          'login_success': 'نجح تسجيل الدخول',
          'login_failed': 'فشل تسجيل الدخول',
          'welcome_back': 'مرحباً بعودتك، @name!',
          'invalid_credentials': 'بيانات الدخول غير صحيحة',
          'network_error': 'خطأ في الاتصال. يرجى المحاولة مرة أخرى',
          'loading': 'جاري التحميل...',
          'please_wait': 'الرجاء الانتظار...',

          // Features
          'feature_1': 'إدارة مالية شاملة',
          'feature_2': 'تقارير ذكية بالذكاء الاصطناعي',
          'feature_3': 'أمان وخصوصية عالية',
          'feature_4': 'دعم متعدد اللغات',

          // Demo Mode
          'demo_mode_description':
              'سيتم تسجيل الدخول بحساب تجريبي. هذا الحساب للعرض فقط وقد يتم حذف البيانات.',
          'continue': 'متابعة',
          'cancel': 'إلغاء',

          // Errors
          'error_occurred': 'حدث خطأ',
          'try_again': 'حاول مرة أخرى',
          'no_internet': 'لا يوجد اتصال بالإنترنت',
          'server_error': 'خطأ في الخادم. يرجى المحاولة لاحقاً',
          'session_expired': 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى',

          // Common Actions
          'ok': 'حسناً',
          'yes': 'نعم',
          'no': 'لا',
          'save': 'حفظ',
          'delete': 'حذف',
          'edit': 'تعديل',
          'close': 'إغلاق',
          'back': 'رجوع',
          'next': 'التالي',
          'submit': 'إرسال',
          'confirm': 'تأكيد',

          // Dashboard
          'dashboard': 'لوحة التحكم',
          'home': 'الرئيسية',
          'profile': 'الملف الشخصي',
          'settings': 'الإعدادات',
          'logout': 'تسجيل الخروج',

          // Registration
          'register': 'تسجيل',
          'full_name': 'الاسم الكامل',
          'full_name_hint': 'أدخل اسمك الكامل',
          'organization_name': 'اسم المؤسسة',
          'organization_name_hint': 'أدخل اسم مؤسستك (اختياري)',
          'phone': 'رقم الهاتف',
          'phone_hint': 'أدخل رقم هاتفك',
          'confirm_password': 'تأكيد كلمة المرور',
          'confirm_password_hint': 'أعد إدخال كلمة المرور',
          'already_have_account': 'لديك حساب بالفعل؟',
          'login_now': 'سجل الدخول الآن',
          'terms_and_conditions': 'الشروط والأحكام',
          'agree_to_terms': 'أوافق على الشروط والأحكام',

          // Password Reset
          'reset_password': 'إعادة تعيين كلمة المرور',
          'reset_password_instructions':
              'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
          'send_reset_link': 'إرسال رابط إعادة التعيين',
          'reset_link_sent': 'تم إرسال رابط إعادة التعيين',
          'check_your_email': 'تحقق من بريدك الإلكتروني',
          'new_password': 'كلمة المرور الجديدة',
          'new_password_hint': 'أدخل كلمة المرور الجديدة',

          // User Info
          'welcome': 'مرحباً',
          'user': 'مستخدم',
          'admin': 'مدير',
          'super_admin': 'مدير عام',
          'accountant': 'محاسب',
          'owner': 'مالك',
          'manager': 'مدير',

          // Dashboard
          'dashboard': 'لوحة التحكم',
          'total_balance': 'الرصيد الإجمالي',
          'income': 'الإيرادات',
          'expense': 'المصروفات',
          'net_profit': 'صافي الربح',
          'quick_actions': 'إجراءات سريعة',
          'new_transaction': 'معاملة جديدة',
          'new_invoice': 'فاتورة جديدة',
          'view_reports': 'عرض التقارير',
          'recent_activity': 'النشاط الأخير',
          'view_all': 'عرض الكل',
          'no_recent_activity': 'لا يوجد نشاط حديث',
          'start_by_adding_transaction': 'ابدأ بإضافة معاملة جديدة',
          'transactions': 'المعاملات',
          'invoices': 'الفواتير',
          'reports': 'التقارير',
          'help': 'المساعدة',
          'help_message': 'سنساعدك قريباً!',
          'logout_confirmation': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          'logged_out': 'تم تسجيل الخروج',
          'logout_success': 'تم تسجيل الخروج بنجاح',
          'logout_failed': 'فشل تسجيل الخروج',
          'refreshed': 'تم التحديث',
          'dashboard_updated': 'تم تحديث لوحة التحكم',
          'failed_to_load_dashboard': 'فشل تحميل لوحة التحكم',
          'coming_soon': 'قريباً',
          'feature_coming_soon': 'هذه الميزة ستكون متاحة قريباً',
          'refresh': 'تحديث',
          'change_language': 'تغيير اللغة',
          'please_login_again': 'الرجاء تسجيل الدخول مرة أخرى',
        },
        'en': {
          // App Info
          'app_name': 'Welcome to دفتر',
          'app_description': 'Smart Accounting System',
          'powered_by_ai': 'Powered by AI',

          // Login Screen
          'login_title': 'Sign In',
          'login_subtitle': 'Sign in to continue',
          'email': 'Email',
          'email_hint': 'Enter your email',
          'password': 'Password',
          'password_hint': '••••••••',
          'login': 'Sign In',
          'forgot_password': 'Forgot Password?',
          'no_account': "Don't have an account?",
          'register_now': 'Register Now',
          'or_continue_with': 'Or continue with',
          'demo_mode': 'Try Demo Mode',
          'remember_me': 'Remember Me',

          // Language
          'language': 'Language',
          'language_changed': 'Language Changed',
          'language_changed_message': 'Language changed to Arabic',
          'switch_language': 'العربية',
          'current_language': 'English',

          // Validation
          'email_required': 'Email is required',
          'email_invalid': 'Invalid email address',
          'password_required': 'Password is required',
          'password_min_length': 'Password must be at least 6 characters',

          // Messages
          'login_success': 'Login Successful',
          'login_failed': 'Login Failed',
          'welcome_back': 'Welcome back, @name!',
          'invalid_credentials': 'Invalid email or password',
          'network_error': 'Network error. Please try again',
          'loading': 'Loading...',
          'please_wait': 'Please wait...',

          // Features
          'feature_1': 'Comprehensive Financial Management',
          'feature_2': 'AI-Powered Smart Reports',
          'feature_3': 'High Security & Privacy',
          'feature_4': 'Multi-language Support',

          // Demo Mode
          'demo_mode_description':
              'You will be logged in with a demo account. This account is for demonstration purposes only and data may be deleted.',
          'continue': 'Continue',
          'cancel': 'Cancel',

          // Errors
          'error_occurred': 'An error occurred',
          'try_again': 'Try Again',
          'no_internet': 'No internet connection',
          'server_error': 'Server error. Please try again later',
          'session_expired': 'Session expired. Please login again',

          // Common Actions
          'ok': 'OK',
          'yes': 'Yes',
          'no': 'No',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          'close': 'Close',
          'back': 'Back',
          'next': 'Next',
          'submit': 'Submit',
          'confirm': 'Confirm',

          // Dashboard
          'dashboard': 'Dashboard',
          'home': 'Home',
          'profile': 'Profile',
          'settings': 'Settings',
          'logout': 'Logout',

          // Registration
          'register': 'Register',
          'full_name': 'Full Name',
          'full_name_hint': 'Enter your full name',
          'organization_name': 'Organization Name',
          'organization_name_hint': 'Enter your organization name (optional)',
          'phone': 'Phone Number',
          'phone_hint': 'Enter your phone number',
          'confirm_password': 'Confirm Password',
          'confirm_password_hint': 'Re-enter your password',
          'already_have_account': 'Already have an account?',
          'login_now': 'Login Now',
          'terms_and_conditions': 'Terms and Conditions',
          'agree_to_terms': 'I agree to the Terms and Conditions',

          // Password Reset
          'reset_password': 'Reset Password',
          'reset_password_instructions':
              'Enter your email and we will send you a link to reset your password',
          'send_reset_link': 'Send Reset Link',
          'reset_link_sent': 'Reset Link Sent',
          'check_your_email': 'Check Your Email',
          'new_password': 'New Password',
          'new_password_hint': 'Enter your new password',

          // User Info
          'welcome': 'Welcome',
          'user': 'User',
          'admin': 'Admin',
          'super_admin': 'Super Admin',
          'accountant': 'Accountant',
          'owner': 'Owner',
          'manager': 'Manager',

          // Dashboard
          'dashboard': 'Dashboard',
          'total_balance': 'Total Balance',
          'income': 'Income',
          'expense': 'Expense',
          'net_profit': 'Net Profit',
          'quick_actions': 'Quick Actions',
          'new_transaction': 'New Transaction',
          'new_invoice': 'New Invoice',
          'view_reports': 'View Reports',
          'recent_activity': 'Recent Activity',
          'view_all': 'View All',
          'no_recent_activity': 'No recent activity',
          'start_by_adding_transaction': 'Start by adding a new transaction',
          'transactions': 'Transactions',
          'invoices': 'Invoices',
          'reports': 'Reports',
          'help': 'Help',
          'help_message': 'We will help you soon!',
          'logout_confirmation': 'Are you sure you want to logout?',
          'logged_out': 'Logged Out',
          'logout_success': 'Logged out successfully',
          'logout_failed': 'Logout failed',
          'refreshed': 'Refreshed',
          'dashboard_updated': 'Dashboard updated',
          'failed_to_load_dashboard': 'Failed to load dashboard',
          'coming_soon': 'Coming Soon',
          'feature_coming_soon': 'This feature will be available soon',
          'refresh': 'Refresh',
          'change_language': 'Change Language',
          'please_login_again': 'Please login again',
        },
      };
}
