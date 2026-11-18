# Frostbite

**iOS jailbreak research scaffold — not a jailbreak.**

Target under investigation:
- Device identifier: `iPhone18,5` (confirm this on-device; do not assume model identifiers)
- iOS: `27.3 beta 1`
- Build: `24C5037i`

This repository is a safe, buildable starting point for device/build identification, compatibility evidence tracking, and reproducible GitHub Actions builds. It does **not** contain a kernel exploit, PAC/PPL bypass, AMFI bypass, privilege escalation, bootstrap, tweak injector, or persistence mechanism. It cannot jailbreak a device or install Sileo.

## Build

The GitHub Actions workflow generates an Xcode project with XcodeGen, builds an unsigned iOS Simulator app, and uploads it as an artifact. A Simulator `.app` is not an installable device IPA.

## GitHub setup

1. Create an empty repository named `Frostbite`.
2. Upload the contents of this ZIP to the repository root.
3. Enable Actions if GitHub asks.
4. Run **Frostbite CI** from the Actions tab.

## Research requirements

Do not add exploit code based on guessed offsets or results from another device. Every compatibility claim must name the exact device identifier, board/chip family, iOS build, exploit primitive, and reproducible evidence. Keep destructive restore or boot-chain experiments off a daily-use phone.
