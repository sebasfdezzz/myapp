// API and Cognito configuration
class Config {
  static final String apiBaseUrl = 'https://ftulr3i9bh.execute-api.us-east-2.amazonaws.com/dev/'; // Replace with your API base URL
  static final String cognitoUserPoolId = 'us-east-2_PQyoxAlS9'; // Replace with your Cognito User Pool ID
  static final String cognitoClientId = '44m5uoj1g5m0vjmrvbp7ff9r9h'; // Replace with your Cognito App Client ID
  // Add other identifiers as needed

  // Global variable to store the Cognito user sub (unique user id)
  static String? globalUserSub;
}
