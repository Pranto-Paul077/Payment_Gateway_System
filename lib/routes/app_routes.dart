import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/payment_method_management/payment_method_management.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/profile_settings/profile_settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String paymentMethodManagement = '/payment-method-management';
  static const String dashboardScreen = '/dashboard-screen';
  static const String registrationScreen = '/registration-screen';
  static const String transactionHistory = '/transaction-history';
  static const String profileSettings = '/profile-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => DashboardScreen(),
    loginScreen: (context) => LoginScreen(),
    paymentMethodManagement: (context) => PaymentMethodManagement(),
    dashboardScreen: (context) => DashboardScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    transactionHistory: (context) => TransactionHistory(),
    profileSettings: (context) => ProfileSettings(),
    // TODO: Add your other routes here
  };
}
