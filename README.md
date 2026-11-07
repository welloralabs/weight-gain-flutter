# Weight Gain Calculator - Flutter (Stage 1)

Package name: `app.web.wgcalc_hp_2610`

This is a native Flutter app (no WebView). The original web app is not touched.

## Stage 1 contains
- Home, Calculators list, bottom navigation (same colours as the web app)
- Weight Gain Calculator + BMR, BMI, Protein, Weight Loss, Ideal Weight (same formulas)
- Sponsored Link (opens in the browser), trust cards, "How we calculate"
- Nutrition, Workout, Profile are placeholders ("Coming in the next build")
- `test/calc_test.dart`: golden tests. Every expected number was captured from the real web app.

## How to build the APK (no Android Studio needed)
1. Create a new repository on github.com (private is fine).
2. Upload everything from this folder (keep the folder structure).
   - If `.github/workflows/build.yml` did not upload, click "Add file > Create new file",
     type the name `.github/workflows/build.yml` and paste the file's content.
3. Open the **Actions** tab. The "Build Android APK" job starts by itself
   (or press "Run workflow").
4. When it turns green, open the run and download **weight-gain-apk** from "Artifacts".
5. Unzip it and install `app-release.apk` on your phone.

If the job turns red, open it, copy the red error lines and send them to Claude.

## Signing
This test APK uses Flutter's default debug signing. A proper release key
(needed for stores) is set up in the last stage.
