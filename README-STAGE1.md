# Frostbite Stage 1 drop-in files

This is the first UI/integration milestone for the existing Frostbite
XcodeGen project. Copy the contents of `Frostbite/` into the repository's
existing `Frostbite/` directory, replacing `FrostbiteApp.swift`.

## What this stage adds

- Dynamic Island Studio with X/Y offsets, axis selection, and a live
  in-app preview.
- Liquid Glass Studio with preview controls for material, tint, blur,
  and contrast.
- Backend status panel that explicitly reports that no system write
  backend is connected yet.
- GPL-3.0-or-later project license and third-party notice.

## Important limitation

The sliders and Liquid Glass controls in this stage affect only Frostbite's
own preview. They do not reposition the real SpringBoard Dynamic Island,
change system-wide Liquid Glass, or write MobileGestalt. The `worse_query`
escape code is intentionally not bundled in this first UI milestone.

## Install

1. Back up the current repository files.
2. Copy all files from this package's `Frostbite/` folder into the repo's
   `Frostbite/` folder.
3. Replace the existing `FrostbiteApp.swift` with the included file.
4. Keep the existing XcodeGen `project.yml`; it already includes the whole
   `Frostbite` source folder.
5. Build with the existing GitHub Actions workflow.

The current project deployment target remains unchanged. This stage uses
SwiftUI APIs compatible with the existing project baseline.
