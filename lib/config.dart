// API and Cognito configuration
class Config {
  static final String apiBaseUrl = 'https://your-api-url.com'; // Replace with your API base URL
  static final String cognitoUserPoolId = 'your_cognito_user_pool_id'; // Replace with your Cognito User Pool ID
  static final String cognitoClientId = 'your_cognito_client_id'; // Replace with your Cognito App Client ID
  // Add other identifiers as needed

  // Global variable to store the Cognito user sub (unique user id)
  static String? globalUserSub;
}
