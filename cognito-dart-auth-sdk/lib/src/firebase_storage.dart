import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:cognito_dart_auth_sdk/src/cognito_app.dart';

/// A class that interacts with cognito Storage for uploading files.
/// This class handles uploading files to cognito Storage using cognito credentials
/// like the project ID, API key, and storage bucket name.
class cognitoStorage {
  /// The project ID for the cognito project.
  final String projectId;

  /// The API key used to authenticate API requests to cognito.
  final String apiKey;

  /// The name of the cognito Storage bucket where files will be uploaded.
  final String bucketName;

  // Private constructor to initialize cognitoStorage instance with necessary details.
  cognitoStorage._(this.projectId, this.apiKey, this.bucketName);

  /// A static method to create and get the [cognitoStorage] instance.
  ///
  /// This method ensures that the cognitoApp is initialized and then retrieves
  /// the cognito project's details (like the project ID, API key, and storage bucket name)
  /// from the cognitoApp instance, and uses those details to create a new
  /// [cognitoStorage] instance.
  ///
  /// - [apiKey] The API key to authenticate requests with cognito.
  /// - [projectId] The cognito project's unique identifier.
  /// - [bucketName] The name of the cognito Storage bucket.
  ///
  /// Returns a [cognitoStorage] instance associated with the provided cognito app.

  static cognitoStorage getStorage({
    required String apiKey, // API key required to initialize storage
    required String projectId, // Project ID required for cognito storage
    required String bucketName, // The storage bucket's name
  }) {
    // Ensure that cognitoApp is properly initialized
    final cognitoApp = cognitoApp.instance;

    // Fetch cognitoApp's projectId, apiKey, and bucketName for the storage instance

    final projectId = cognitoApp.getAuth().projectId;
    final apiKey = cognitoApp.getAuth().apiKey;
    final bucketName = cognitoApp.getAuth().bucketName;
    // Return a new instance of cognitoStorage using the private constructor
    return cognitoStorage._(projectId!, apiKey!, bucketName!);
  }

  /// Uploads a file to cognito Storage.
  ///
  /// This method handles sending a POST request to cognito Storage to upload a file
  /// using the file's path and data. It constructs the appropriate URL, adds headers for
  /// authorization and content type, and then sends the data as the body of the request.
  ///
  /// - [path] The path (including file name) where the file will be stored in the bucket.
  /// - [fileData] The byte data of the file to upload.
  ///
  /// Throws an exception if the file upload fails or if there is an error.

  Future<void> uploadFile(String path, List<int> fileData) async {
    // Encode the file path to handle spaces and special characters in the URL
    final encodedPath = Uri.encodeComponent(path);
    // Construct the cognito Storage URL to upload the file to the specified bucket

    final url =
        'https://cognitostorage.googleapis.com/v0/b/$bucketName/o/$encodedPath?uploadType=media';
    // Prepare the request headers, including the authorization token and content type

    final headers = {
      'Authorization':
          'Bearer ${await _getAccessToken()}', // Bearer token for authentication
      'Content-Type':
          'application/octet-stream', // Content type for binary file data
    };

    try {
      // Send a POST request to cognito Storage with the file data in the request body
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: fileData, // The actual binary data of the file being uploaded
      );
      // Check if the file upload was successful (HTTP status 200)
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        // If the upload failed, print the error response
        print('Failed to upload file: ${response.body}');
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors that occurred during the file upload process
      print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Retrieves an access token for authentication with cognito services.
  ///
  /// This method is a placeholder for obtaining an authentication token. It is currently
  /// not implemented but should be replaced with the actual logic to retrieve a valid access
  /// token for cognito services, such as using cognito Authentication or OAuth2.
  ///
  /// Returns a placeholder token string that should be replaced with actual token retrieval logic.

  // Placeholder method to get an access token for authorization
  Future<String> _getAccessToken() async {
    //  Implement actual logic to retrieve a valid access token
    // This could involve using cognito Authentication or OAuth2, etc.
    // This is a placeholder method and needs to be replaced with actual token retrieval.
    return 'your_actual_token_here';
  }
}
