# Changelog

All notable changes to this project will be documented in this file.

## [v0.4.0] - 2024-05-28
### Added
- Documented provider baseline and example sources aligned to this repository.

### Changed
- Raised the AWS provider requirement to the 6.x major line and refreshed module documentation.
- Updated terraform-docs tooling output to include current inputs and providers for every module.

### Fixed
- Corrected subnet module public IP handling, AZ validations, and outputs for mixed public/private deployments.
- Hardened flow log provisioning when reusing external log groups and ensured example locals reference valid tags.
- Swapped all module source references to the maintained repository path and refreshed example refs for v0.4.0.

## [v0.3.0]
- Previous release.
