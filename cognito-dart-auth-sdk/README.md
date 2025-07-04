````markdown
# Cognito Dart Auth SDK

## Overview

The **Cognito Dart Auth SDK** provides a full-featured Dart implementation of AWS Cognito authentication flows for both server-side and Flutter apps. With this SDK you can:

- Sign users up and confirm their accounts  
- Sign users in (username/password, OAuth, custom tokens)  
- Manage user attributes and multi-factor authentication (SMS, TOTP)  
- Generate and verify ID/access tokens  
- Admin operations: list users, disable/enable accounts, reset passwords, and more  

Whether you’re building a backend service in pure Dart or a mobile/web client in Flutter, this SDK makes integrating with AWS Cognito seamless.

## Features

- **User Sign-Up & Sign-In**  
  Support for email/phone/password sign-up, OAuth/social providers, and custom auth challenges.  
- **Multi-Factor Authentication**  
  Configure SMS or TOTP second-factor flows, challenge users, and verify codes.  
- **Token Management**  
  Automatically handle access, ID, and refresh tokens; verify signatures; refresh tokens.  
- **Admin APIs**  
  Create, list, update, disable, and delete users; manage groups and user attributes.  
- **Custom Token Minting**  
  Generate AWS credentials or integrate with your own identity provider.  
- **Platform-Agnostic**  
  Works in Dart VM (server), Flutter mobile, and Flutter web.

## Getting Started

1. **Prerequisites**  
   - Dart SDK ≥ 3.4.x, or Flutter SDK ≥ 3.0  
   - An AWS account with a Cognito User Pool (and optionally an Identity Pool)

2. **Configure AWS Credentials**  
   - For **server-side** or CLI use a JSON credentials file (`~/.aws/credentials`) or environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).  
   - For **mobile/web** with Cognito User Pools only, you don’t need AWS credentials—just your pool and client IDs.

## Installation

Add the SDK to your project:

```bash
# Dart:
dart pub add cognito_dart_auth_sdk

# Flutter:
flutter pub add cognito_dart_auth_sdk
````

Or add manually to your `pubspec.yaml`:

```yaml
dependencies:
  cognito_dart_auth_sdk: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### 1. Initialize the SDK

```dart
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

void main() async {
  // For server-side or local CLI
  final auth = CognitoAuth(
    region: 'us-east-1',
    userPoolId: 'us-east-1_ABCDEFG',
    clientId:  'XXXXXXXXXXXXXXXXXXXX',
  );

  // For Flutter web / mobile you can omit AWS credentials if using only User Pools
  // and rely on CORS-enabled endpoints.
}
```

### 2. Sign Up & Confirm

```dart
// Sign up a new user
final signUpResult = await auth.signUp(
  username: 'alice@example.com',
  password: 'SuperSecret123!',
  userAttributes: {
    'email': 'alice@example.com',
    'custom:role': 'admin',
  },
);

// Later, confirm their account with a code sent over email/SMS
await auth.confirmSignUp(
  username: 'alice@example.com',
  confirmationCode: '123456',
);
```

### 3. Sign In & Token Handling

```dart
// Sign in
final session = await auth.signIn(
  username: 'alice@example.com',
  password: 'SuperSecret123!',
);

// Access tokens, ID tokens, and refresh tokens:
final accessToken  = session.accessToken;
final idToken      = session.idToken;
final refreshToken = session.refreshToken;

// Verify an ID token’s signature
final claims = await auth.verifyIdToken(idToken);
print('User ID: ${claims.sub}');
```

### 4. Admin Operations

```dart
// List users in a group
final users = await auth.adminListUsers(
  filter: 'status="CONFIRMED"',
  limit: 10,
);

// Disable a user
await auth.adminDisableUser(username: 'alice@example.com');
```

## Advanced

* **Multi-Factor (MFA):**

  ```dart
  await auth.setMfaPreference(
    username: 'alice@example.com',
    smsEnabled: true,
    totpEnabled: false,
  );
  ```

* **Password Reset:**

  ```dart
  // Initiate
  await auth.forgotPassword(username: 'alice@example.com');
  // Confirm
  await auth.confirmForgotPassword(
    username: 'alice@example.com',
    confirmationCode: '654321',
    newPassword: 'NewSecret123!',
  );
  ```

## Documentation

For full API reference, examples, and architecture guides, see our GitBook:

👉 [Cognito Dart Auth SDK Docs](https://aortem.gitbook.io/cognito-dart-auth-sdk/)

---

