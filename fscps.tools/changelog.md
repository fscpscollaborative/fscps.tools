# Changelog
## 1.1.0 (2026-02-23)
 - New: Get-FSCPSNuget now supports `-KnownVersion` and `-KnownType` parameters to resolve NuGet versions from short FNO versions (e.g. `10.0.45`) with GA/Latest strategy
 - New: Added `VersionStrategy` enum (GA, Latest)
 - Fix: Fixed Cyrillic character in variable names in `Invoke-CloudRuntimeAssembliesImport` that caused parse errors
 - Upd: Get-FSCPSNuget now automatically creates the destination path if it does not exist

