// API and Cognito configuration

const String apiBaseUrl = 'https://your-api-url.com'; // Replace with your API base URL
const String cognitoUserPoolId = 'your_cognito_user_pool_id'; // Replace with your Cognito User Pool ID
const String cognitoClientId = 'your_cognito_client_id'; // Replace with your Cognito App Client ID
// Add other identifiers as needed

// Global variable to store the Cognito user sub (unique user id)
String? globalUserSub;