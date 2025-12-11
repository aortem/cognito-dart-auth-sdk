## **0.0.1

### **Added**

* **CI/CD Debugging Enhancements**

  * Added stderr/stdout capture for Firebase preview deployments to improve debugging reliability during hosting channel deploys.
  * Introduced `mktemp`-based temporary file handling for error inspection.

* **API Key Referrer Management**

  * Added automatic preview-origin referrer injection into the Preview/QA Firebase API Key using Google API Keys API.
  * Implemented fallback logic and three-attempt retry behavior for resilient PATCH updates.

* **Preview Environment Metadata Output**

  * Added JSON pretty-printing (`jq`) for Firebase Hosting preview deploy responses.
  * Added extraction logic for preview URL + origin pattern (`https://<site>.web.app/*`).

### **Changed**

* **CI Pipeline (Preview Deploy Job)**

  * Updated preview deploy script to:

    * Print full raw Firebase deploy output.
    * Capture and inspect HTTP error codes.
    * Display current key configuration before referrer updates.
  * Improved ordering of steps for clearer debugging workflow.

* **HTTP & Curl Operations**

  * Updated fetch and patch operations to use consistent `-sS` flags and JSON encoding.
  * Normalized formatting in all request/response handlers for readability.

* **Environment Variable Handling**

  * Improved validation for `GOOGLE_APPLICATION_CREDENTIALS`, preview key IDs, and access tokens.
  * Standardized echo messages and exit handling for missing configuration.

* **Referrer Merge Process**

  * Unified existing + new + localhost referrers into a single deduplicated array using `jq`.
  * Improved temporary file handling via `mktemp` for safe merge operations.

### **Removed**

* **Old Inline Firebase Preview Logic**

  * Replaced earlier unstructured preview deploy calls with the new JSON-driven deploy + referrer update system.
  * Removed previous implicit behavior that skipped referrer updates silently.

### **Renamed**

* *(None in this patch)* — file paths were preserved; only internal logic and script formatting were changed.


## 0.0.1-pre+1

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


## 0.0.1-pre

- Initial pre-release version of the cognito Dart Auth SDK.
