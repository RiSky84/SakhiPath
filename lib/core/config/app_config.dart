
class AppConfig {
  AppConfig._();

  static const String appName = 'SakhiPath';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Empowering Women\'s Safety';

  static const String baseUrl = 'https:
  static const String apiVersion = 'v1';
  static String get apiBaseUrl => '$baseUrl/api/$apiVersion';

  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  static const bool enableVoiceCommands = true;
  static const bool enableBiometricMonitoring = true;
  static const bool enableStealthMode = true;
  static const bool enableDeterrentMode = true;

  static const double safetyScoreThreshold = 7.0;
  static const int sosAutoTriggerHeartRateIncrease = 60;
  static const double fallDetectionThresholdG = 2.5;

  static const int normalLocationUpdateIntervalSeconds = 30;
  static const int sosLocationUpdateIntervalSeconds = 5;
  static const int virtualEscortLocationUpdateIntervalSeconds = 10;

  static const String emergencyNumber = '112';
  static const String womenHelpline = '1091';
  static const String policeNumber = '100';

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'hi', 'name': 'हिंदी', 'nameEn': 'Hindi'},
    {'code': 'en', 'name': 'English', 'nameEn': 'English'},
    {'code': 'bn', 'name': 'বাংলা', 'nameEn': 'Bengali'},
    {'code': 'ta', 'name': 'தமிழ்', 'nameEn': 'Tamil'},
    {'code': 'te', 'name': 'తెలుగు', 'nameEn': 'Telugu'},
    {'code': 'mr', 'name': 'मराठी', 'nameEn': 'Marathi'},
    {'code': 'gu', 'name': 'ગુજરાતી', 'nameEn': 'Gujarati'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ', 'nameEn': 'Kannada'},
    {'code': 'ml', 'name': 'മലയാളം', 'nameEn': 'Malayalam'},
    {'code': 'pa', 'name': 'ਪੰਜਾਬੀ', 'nameEn': 'Punjabi'},
  ];

  static const Map<String, List<String>> emergencyTriggerWords = {
    'hi': ['bachao', 'help', 'madad', 'sos', 'emergency'],
    'en': ['help', 'emergency', 'sos', 'danger', 'police'],
    'bn': ['bachao', 'sohayota', 'emergency'],
    'ta': ['uthavi', 'help', 'aabathu'],
    'te': ['sahayam', 'rakshana', 'help'],
    'mr': ['vachva', 'madad', 'help'],
    'gu': ['bachavo', 'madad', 'sahay'],
    'kn': ['rakshisi', 'sahaya', 'help'],
    'ml': ['rakshikkuka', 'sahayam', 'help'],
    'pa': ['bachao', 'madad', 'help'],
  };

  static const List<String> safeSpotCategories = [
    'hospital',
    'police_station',
    'petrol_pump',
    'cafe_24x7',
    'hotel',
    'temple',
    'mosque',
    'gurudwara',
    'church',
    'pharmacy',
  ];

  static const String routePreferenceSafest = 'safest';
  static const String routePreferenceFastest = 'fastest';
  static const String routePreferenceBalanced = 'balanced';

  static const int apiTimeoutSeconds = 30;
  static const int locationTimeoutSeconds = 15;
  static const int sosResponseTimeoutSeconds = 5;

  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyTrustedContacts = 'trusted_contacts';
  static const String keyRoutePreference = 'route_preference';
  static const String keyLanguagePreference = 'language_preference';
  static const String keyVoiceCalibration = 'voice_calibration';
  static const String keyBiometricBaseline = 'biometric_baseline';
  static const String keyStealthModeEnabled = 'stealth_mode_enabled';
  static const String keyOnboardingComplete = 'onboarding_complete';
}
