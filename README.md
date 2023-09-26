# SCSH_3C_iOS
3C devices price comparison.

##  Architecture
<img width="972" alt="Screenshot 2023-08-01 at 3 48 46 PM" src="https://github.com/No-57/SCSH_3C_iOS/assets/38306406/d1674bd7-b54a-4821-8f00-ce5c48ab839a">

## Getting Started

### Prerequisites
- Xcode (latest version)

### Build And Run
1. Open `SCSH_3C_iOS.xcodeproj` via Xcode.
2. Waiting for everything to be set up (Note that it may take quite a little time at first time).
3. Choose one iOS simulator. (As shown on the left in the following image)
4. Project -> Run (shortcut: cmd + R)
5. SCSH_3S_iOS is running successfully. (As shown on the right in the following image)

<img width="700" alt="Screenshot 2023-07-10 at 7 37 46 PM" src="https://github.com/No-57/SCSH_3C_iOS/assets/38306406/a858491b-c9c2-4190-8922-4ddc2edd4812">

<img width="200" alt="Screenshot 2023-07-10 at 7 43 22 PM" src="https://github.com/No-57/SCSH_3C_iOS/assets/38306406/de6eb523-6b43-40ce-8bf5-afeb0c836aec">

## CI
### Prerequisites
- Install Fastlane: https://docs.fastlane.tools/getting-started/ios/setup/
- Set up Environment Variables: Environment variables are required by the CI script, Ensure that these are set up in your CI environment before running the script.
  ``` sh
  // Create a file named `.env`
  $ vi .env

  // Add all the variables you need.
  // ...

  // export all variables on the terminal session.
  $ source .env
  ```

### Environment variables
1. `GIT_REPO_URL`: The URL of the Git repository.
2. `GIT_PROJECT_PATH`: The local directory path where the Git repo will be cloned.
3. `XCODE_PROJECT_PATH`: The path to the Xcode project file within the cloned repository.

### Execution
- Run the lane named `ci_build` on platform `ios`.
  ``` sh
  $ fastlane ios ci_build
  ```
