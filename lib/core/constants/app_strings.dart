import '../api/language/language_helper.dart';

class AppStrings {
  AppStrings._();

  // COMMON STRINGS
  static String get cancel => TranslationsHolder.translate('cancel', 'Cancel');
  static String get delete => TranslationsHolder.translate('delete', 'Delete');
  static String get logout => TranslationsHolder.translate('logout', 'Logout');
  static String get signIn => TranslationsHolder.translate('signIn', 'Sign In');
  static String get signUp => TranslationsHolder.translate('signUp', 'Sign Up');
  static String get close => TranslationsHolder.translate('close', 'Close');
  static String get search => TranslationsHolder.translate('search', 'Search');
  static String get email => TranslationsHolder.translate('email', 'Email');
  static String get basic => TranslationsHolder.translate('basic', 'Basic');
  static String get sharing =>
      TranslationsHolder.translate('sharing', 'Sharing');
  static String get fromLabel =>
      TranslationsHolder.translate('fromLabel', 'From');
  static String get toLabel => TranslationsHolder.translate('toLabel', 'To');
  static String get confirm =>
      TranslationsHolder.translate('confirm', 'Confirm');
  static String get save => TranslationsHolder.translate('save', 'Save');
  static String get saveEvent =>
      TranslationsHolder.translate('saveEvent', 'Save Event');
  static String get updateEvent =>
      TranslationsHolder.translate('updateEvent', 'Update Event');
  static String get edit => TranslationsHolder.translate('edit', 'Edit');
  static String get yes => TranslationsHolder.translate('yes', 'Yes');
  static String get no => TranslationsHolder.translate('no', 'No');
  static String get ok => TranslationsHolder.translate('ok', 'OK');
  static String get next => TranslationsHolder.translate('next', 'Next');
  static String get back => TranslationsHolder.translate('back', 'Back');
  static String get denied => TranslationsHolder.translate('denied', 'Denied');
  static String get allowed =>
      TranslationsHolder.translate('allowed', 'Allowed');
  static String get phone => TranslationsHolder.translate('phone', 'Phone');
  static String get submit => TranslationsHolder.translate('submit', 'Submit');
  //login and signup
  static String get createAccountToGetStarted => TranslationsHolder.translate(
    'createAccountToGetStarted',
    'Create an account to get started',
  );

  static String get enterEmail =>
      TranslationsHolder.translate('enterEmail', 'Enter your email');
  static String get enterPassword =>
      TranslationsHolder.translate('enterPassword', 'Enter your password');
  static String get confirmPassword =>
      TranslationsHolder.translate('confirmPassword', 'Confirm Password');
  static String get reEnterPassword =>
      TranslationsHolder.translate('reEnterPassword', 'Re-enter your password');

  static String get alreadyHaveAnAccount => TranslationsHolder.translate(
    'alreadyHaveAnAccount',
    'Already have an account?',
  );
}
