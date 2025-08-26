import 'package:easy_localization/easy_localization.dart';

/// Translation keys for type-safe access
/// This helps prevent typos and provides IDE autocompletion
class AppTranslations {
  // App
  static const String appTitle = 'app.title';
  static const String appDescription = 'app.description';

  // Common
  static const String ok = 'common.ok';
  static const String cancel = 'common.cancel';
  static const String yes = 'common.yes';
  static const String no = 'common.no';
  static const String save = 'common.save';
  static const String edit = 'common.edit';
  static const String delete = 'common.delete';
  static const String add = 'common.add';
  static const String update = 'common.update';
  static const String loading = 'common.loading';
  static const String error = 'common.error';
  static const String success = 'common.success';
  static const String retry = 'common.retry';
  static const String back = 'common.back';
  static const String next = 'common.next';
  static const String previous = 'common.previous';
  static const String confirm = 'common.confirm';
  static const String search = 'common.search';
  static const String filter = 'common.filter';
  static const String sort = 'common.sort';
  static const String settings = 'common.settings';
  static const String home = 'common.home';
  static const String profile = 'common.profile';

  // Auth
  static const String login = 'auth.login';
  static const String logout = 'auth.logout';
  static const String register = 'auth.register';
  static const String forgotPassword = 'auth.forgotPassword';
  static const String email = 'auth.email';
  static const String password = 'auth.password';
  static const String confirmPassword = 'auth.confirmPassword';
  static const String rememberMe = 'auth.rememberMe';
  static const String loginSuccess = 'auth.loginSuccess';
  static const String loginFailed = 'auth.loginFailed';
  static const String invalidCredentials = 'auth.invalidCredentials';
  static const String accountCreated = 'auth.accountCreated';
  static const String resetPasswordSent = 'auth.resetPasswordSent';

  // Validation
  static const String required = 'validation.required';
  static const String emailInvalid = 'validation.emailInvalid';
  static const String passwordTooShort = 'validation.passwordTooShort';
  static const String passwordsDoNotMatch = 'validation.passwordsDoNotMatch';
  static const String phoneInvalid = 'validation.phoneInvalid';

  // Network
  static const String noConnection = 'network.noConnection';
  static const String serverError = 'network.serverError';
  static const String timeout = 'network.timeout';
  static const String unknownError = 'network.unknownError';
  static const String networkRetry = 'network.retry';

  // Permissions
  static const String cameraPermission = 'permissions.camera';
  static const String storagePermission = 'permissions.storage';
  static const String locationPermission = 'permissions.location';
  static const String notificationsPermission = 'permissions.notifications';

  // Home
  static const String welcome = 'home.welcome';
  static const String welcomeGuest = 'home.welcomeGuest';
  static const String haveNiceDay = 'home.haveNiceDay';
  static const String loginPrompt = 'home.loginPrompt';
  static const String loginButton = 'home.loginButton';
  static const String quickActions = 'home.quickActions';
  static const String detailInfo = 'home.detailInfo';
  static const String detailInfoSubtitle = 'home.detailInfoSubtitle';
  static const String webPage = 'home.webPage';
  static const String webPageSubtitle = 'home.webPageSubtitle';
  static const String profileAction = 'home.profileAction';
  static const String profileActionSubtitle = 'home.profileActionSubtitle';
  static const String loginAction = 'home.loginAction';
  static const String loginActionSubtitle = 'home.loginActionSubtitle';
  static const String settingsAction = 'home.settingsAction';
  static const String settingsActionSubtitle = 'home.settingsActionSubtitle';
  static const String imageViewer = 'home.imageViewer';
  static const String imageViewerSubtitle = 'home.imageViewerSubtitle';
}