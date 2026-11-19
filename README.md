
# Frostbite

**iOS jailbreak research scaffold — not a jailbreak.**

Frostbite is a read-only device information and research dashboard. It helps record device/build information and organize compatibility evidence.

## Current research target

The current target being investigated is:

- Device identifier: `iPhone18,5`
- iOS: `27.3 beta 1`
- Build: `24C5037i`
- Board configuration: `V159AP`
- Board ID (BDID): `0x16`
- Chip ID (CPID): `0x8150`
- Platform: `t8150`
- Architecture: `arm64e`

These are research reference values, not proof that Frostbite has detected or verified the hardware. Some fields require privileged access or external diagnostics and may not be readable by an ordinary iOS app.

## Current capabilities and limitations

Frostbite can display information exposed to an ordinary iOS app, such as the machine identifier and system version.

This repository does **not** contain:

- A kernel exploit
- PAC/PPL bypass
- AMFI bypass
- Privilege escalation
- A jailbreak bootstrap
- A tweak injector
- Persistence mechanisms

It cannot currently jailbreak a device or install Sileo. A successful build or matching device report is not evidence of jailbreak compatibility.

## Build with GitHub Actions

The **Frostbite iOS IPA Build** workflow:

1. Installs XcodeGen.
2. Generates the Xcode project from `project.yml`.
3. Builds an unsigned app for the iOS device SDK.
4. Packages the app into `Frostbite.ipa`.
5. Uploads the IPA as the `Frostbite-IPA` workflow artifact.

The IPA is **unsigned**. It must be signed using a valid signing method before installation, such as an IPA signing app and your own certificate.

Building Frostbite does not bypass iOS security or enable jailbreak functionality.

To build:

1. Open the repository's **Actions** tab.
2. Select **Frostbite iOS IPA Build**.
3. Select **Run workflow**.
4. Wait for the build to finish.
5. Download the `Frostbite-IPA` artifact.

Pushes to `main` or `master` also trigger the workflow.

## Research requirements

Do not add exploit code based on guessed offsets or results from another device.

Every compatibility claim should identify:

- Exact device identifier
- Board and chip family
- Exact iOS build
- Exploit primitive
- Reproducible evidence

Keep destructive restore, boot-chain, kernel-memory-write, and filesystem-remount experiments off a daily-use phone.
