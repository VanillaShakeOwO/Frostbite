# Security and device safety

Frostbite currently contains no exploit implementation. A successful CI build or a matching device/build report is not proof of jailbreak compatibility.

Before future device-level research:
- Keep a current, restorable backup.
- Do not run unverified restore, boot-chain, kernel-memory-write, or filesystem-remount code on a primary device.
- Do not use offsets copied from a different SoC, board, or iOS build.
- Record exact source commits and reproducible test evidence.
- Prefer read-only diagnostics until a primitive has been independently validated.
