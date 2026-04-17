# Cognito Dart Auth SDK

Backend/admin AWS Cognito SDK for Dart.

This package is intended for server-side use where requests are signed for Amazon Cognito Identity Provider. The SDK exposes both direct request APIs and consumer/builder-style helpers through `package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart`.

## Installation

```yaml
dependencies:
  cognito_dart_auth_sdk: ^0.0.2
```

## Recommended Initialization Model

Use `CognitoAuth` (a public alias of `Cognito`) with:

1. an AWS region
2. a `CognitoHttpClient` implementation that signs requests for `cognito-idp`

If you already have request-sending and SigV4-signing logic, `CognitoSigV4HttpClient` can wrap it.

## Preferred Backend Initialization

```dart
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

Future<void> main() async {
  final httpClient = CognitoSigV4HttpClient(
    ({
      required Uri uri,
      required Map<String, String> headers,
      required String body,
      Duration? timeout,
    }) async {
      throw UnimplementedError('Provide your HTTP sender.');
    },
    ({
      required String region,
      required String service,
      required String method,
      required Uri uri,
      required Map<String, String> headers,
      required String body,
    }) async {
      throw UnimplementedError('Provide your SigV4 signer.');
    },
  );

  final auth = CognitoAuth(
    region: 'us-east-1',
    httpClient: httpClient,
  );

  await auth.adminCreateUser(
    userPoolId: 'us-east-1_example',
    username: 'alice@example.com',
  );
}
```

## Common Backend Operations

### Create or inspect a user

```dart
await auth.adminCreateUser(
  userPoolId: 'us-east-1_example',
  username: 'alice@example.com',
);

final user = await auth.adminGetUser(
  userPoolId: 'us-east-1_example',
  username: 'alice@example.com',
);

print(user);
```

### Add custom attributes to a user pool

```dart
await auth.addCustomAttributes(
  userPoolId: 'us-east-1_example',
  customAttributes: [
    CognitoSchemaAttributeType(
      name: 'custom:department',
      attributeDataType: CognitoAttributeDataType.string,
    ),
  ],
);
```

### Record adaptive-auth feedback

```dart
await auth.adminUpdateAuthEventFeedback(
  userPoolId: 'us-east-1_example',
  username: 'alice@example.com',
  eventId: 'event-id',
  feedbackValue: 'Valid',
);
```

## Consumer/Builder APIs

Many operations are also exposed in consumer-style variants such as:

- `adminCreateUserWith(...)`
- `adminRespondToAuthChallengeWith(...)`
- `adminUpdateAuthEventFeedbackWith(...)`

Use those when you want builder validation or a more fluent payload setup.

## Security Guidance

- Keep AWS credentials and SigV4 signing on the backend.
- Grant only the Cognito actions your service needs.
- Do not ship privileged signing logic or admin credentials in browser/mobile apps.
- Treat the sample apps as integration references, not as a secure admin deployment model.

## Examples

See the `example/` directory for current frontend sample apps and integration references.
