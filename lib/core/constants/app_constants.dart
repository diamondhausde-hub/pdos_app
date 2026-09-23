/// App-wide constants
class AppConstants {
  AppConstants._();

  /// Storage bucket names
  static const String profileImagesBucket = 'profile-images';
  static const String productImagesBucket = 'product-images';

  /// Edge Function names
  static const String createUserFunction = 'create-user';
  static const String toggleUserStatusFunction = 'toggle-user-status';
  static const String changePasswordFunction = 'change-password';

  /// Email verification polling interval
  static const Duration emailVerificationPollInterval = Duration(seconds: 3);

  /// Resend verification cooldown
  static const Duration resendCooldown = Duration(seconds: 60);

  /// Max image file size (5MB)
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  /// Supported image MIME types
  static const List<String> supportedImageTypes = ['image/jpeg', 'image/png', 'image/webp'];

  /// Iraqi governorates for region dropdown
  static const List<String> iraqGovernates = [
    'Baghdad',
    'Basra',
    'Nineveh',
    'Erbil',
    'Sulaymaniyah',
    'Najaf',
    'Karbala',
    'Kirkuk',
    'Diyala',
    'Anbar',
    'Babel',
    'Wasit',
    'Dhi Qar',
    'Maysan',
    'Muthanna',
    'Qadisiyyah',
    'Saladin',
    'Duhok',
  ];

  /// Reminder options (in minutes)
  static const List<int> reminderOptions = [15, 30, 60, 120];
}
