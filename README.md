# Calley Mobile App

Flutter mobile application built for the Calley Mobile App Developer test, following the provided Figma design and Postman Mock API V2.

## Overview

The application implements the complete onboarding and calling workflow:

* Language selection
* User registration and OTP verification
* Getting Started with video walkthrough
* Dashboard empty state with Load Number To Call
* Calling lists bottom drawer fetched from API
* Active dashboard with custom donut chart and metrics
* Prospect records list and call detail modal
* Navigation drawer with user profile and settings
* Simulated auto dialer session

## Tech Stack

* Flutter and Dart
* Provider for state management
* HTTP client for REST API integration
* SharedPreferences for local storage
* Custom canvas painter for donut chart

## API Integration

* POST /api/auth/register
* POST /api/auth/login
* POST /api/auth/send-otp
* POST /api/auth/verify-otp
* GET /api/list
* GET /api/list/details

## How to Run

1. Install dependencies:
flutter pub get

2. Run the application:
flutter run

3. Run tests:
flutter test

4. Run code analysis:
flutter analyze
