// part of 'api.dart';

// /// Extracts Cognito tokens from an AuthSession if available.
// /// Returns a map with 'accessToken', 'idToken', 'refreshToken' or null if not available.
// Map<String, String?> extractCognitoTokens(AuthSession session) {
//   if (session is CognitoAuthSession && session.isSignedIn) {
//     final CognitoUserPoolTokens? tokens =
//         session.userPoolTokensResult.valueOrNull;
//     final Map<String, String?> tokensMap = <String, String?>{
//       'accessToken': tokens?.accessToken.raw,
//       'idToken': tokens?.idToken.raw,
//       'refreshToken': tokens?.refreshToken,
//     };
//     AppLogger.log('[Cognito] Extracted tokens: $tokensMap');
//     return tokensMap;
//   }
//   return <String, String?>{};
// }
