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
