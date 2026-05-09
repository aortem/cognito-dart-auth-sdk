# Changelog

## [0.0.4]
### Added
* Added non-admin Cognito user-pool operation request wrappers for GetLogDeliveryConfiguration, GetSigningCertificate, GetUICustomization, GetUser, GetUserAttributeVerificationCode, GetUserPoolMfaConfig, GlobalSignOut, InitiateAuth, ListDevices, ListGroups, ListIdentityProviders, ListResourceServers, ListTagsForResource, ListUserImportJobs, ListUserPoolClients, ListUserPools, ListUsers, ResendConfirmationCode, RespondToAuthChallenge, and RevokeToken.
* Added matching consumer/builder facades for the same operation set, including paginator aliases for supported list operations.
* Added public `AortemCognito*` compatibility aliases for the new request and consumer surfaces.

### Changed
* Exported the new user-pool request and consumer surfaces from the package entrypoint.

### Tests
* Added unit coverage for Cognito JSON API target wiring, required-field validation, service error handling, public exports, and `AortemCognito*` aliases.

## [0.0.3]
### Fixed
* Corrected admin request validation for device keys, supported admin auth flows, and short session tokens used in challenge-response flows.
* Replaced empty integration test files with placeholder `main()` entries so `dart test` can discover the suite cleanly.

### Changed
* Moved `ds_tools_testing` into `dev_dependencies` and added an explicit package license for cleaner published metadata.
* Added package/archive excludes for docs and generated example artifacts to reduce publish noise.

## [0.0.2]
### Added
* **Public Alias**
  * Added `CognitoAuth` as a clearer public alias for the primary SDK client.

### Changed
* **Dart & Dependency Baseline**
  * Updated direct package constraints to the latest supported releases on pub.dev, including `ds_standard_features`, `jwt_generator`, `lints`, and `test`.
* **Documentation**
  * Reworked the main README and example README to reflect the current backend-first SDK direction and the maintained sample apps.
* **CI Validation**
  * Aligned pipeline validation and development CI with the Dart `3.11.4` baseline and current example paths.

## [0.0.1]
### Added
* **UI & Code Readability Improvements (Example Apps)**

  * Streamlined layout and widget construction across multiple example Flutter screens.
  * Added cleaner, more consistent formatting for:

    * `SnackBar` usage
    * `MaterialPageRoute` navigation
    * `AppBar` declarations
    * Loading indicators and async UI states
  * Introduced improved helper patterns for displaying results and errors.

* **Inline UI Simplifications**

  * Many widgets converted from multi-line constructors to single-line readable expressions without changing functionality.

### Changed
* **General UI Refactors Across Example Apps**

  * Consolidated repeated code patterns in authentication flows (Apple, Google, email/password, MFA).
  * Updated parameter formatting in ViewModel methods for clarity and consistency.
  * Cleaned up `Navigator.push` calls and standardised screen transitions.
  * Simplified WebView initialization and request URL builders for OAuth-related flows.

* **Home & Auth State Screens**

  * Token display logic reformatted for readability.
  * Improved provider-linking UI, making layout more consistent with other screens.

* **Multi-Factor & Phone Auth Screens**

  * Cleaner button actions and error handling patterns.
  * Reduced nested widget structures for better maintainability.

* **Popup, Redirect, and OAuth Screens**

  * More compact formatting for builder functions and row/column structures.
  * Updated Google Sign-In scopes to use inline array syntax.

### Removed
* **Legacy Example App Placeholder File**

  * Deleted: `example/cognito-dart-auth-sdk-flutter-web-app/placeholder.txt`.

### Renamed
* *(None in this patch.)*

## [0.0.1-pre+1]
### Added
- **Local Dev Tools**  
  - New scripts in `cognito-dart-auth-sdk/local_dev_tools/` (`validate_branch.dart`, `validate_commit_msg.dart`) to enforce branch and commit-message conventions.  
- **Core SDK Entry Point**  
  - `bin/main.dart` added to bootstrap the Cognito-Dart Auth SDK CLI.  
- **Tests**  
  - Integration tests under `test/integration/` and unit tests under `test/unit/`.  
- **Authentication Modules**  
  - Initial AWS Cognito flows implemented in `lib/src/auth/` (sign-up, sign-in, token management, etc.).  

### Changed
- **Example App Restructure**  
  - Renamed and moved **214** files from  
    `example/cognito-dart-auth-sdk-sample-app/` →  
    `example/cognito-dart-auth-sdk-flutter-mobile-app/`,  
    including FVM configs, Android & iOS assets, web manifests, sample code, etc.
- **CI Pipeline Reorganization**  
  - Moved child-CI YAML configs from `tools/pipelines/` →  
    `tools/pipelines/backend/` and `tools/pipelines/frontend/`.  
- **Project Metadata Updates**  
  - `.gitignore`, `.gitlab-ci.yml`, `cloudbuild.yaml`, `.firebaserc`, and `README.md` revised.  
- **Pubspec & Lockfile**  
  - Bumped SDK version, updated dependencies in `pubspec.yaml`/`pubspec.lock`.  
- **GitHub Issue Templates**  
  - Updated `.github/ISSUE_TEMPLATE/config.yml` and removed the deprecated `workflows/dart-analysis.yml`.  

### Removed
- **Deprecated Example Files**  
  - Deleted **84** legacy files under the old `example/...-sample-app/` path.  
- **Obsolete Workflow**  
  - Removed `.github/ISSUE_TEMPLATE/workflows/dart-analysis.yml`.  

### Renamed
- **Example Directory** (214 renames)  
  - All files in `example/cognito-dart-auth-sdk-sample-app/…` →  
    `example/cognito-dart-auth-sdk-flutter-mobile-app/…`.  


## [0.0.1-pre]
- Initial pre-release version of the cognito Dart Auth SDK.

