# Changelog

All notable changes to this project will be documented in this file.

## [v0.5.0] - 2025-10-10
### Added
- Extended the `subnet` module to support dedicated endpoint subnets, including optional CIDR inputs and new endpoint subnet outputs.
- Introduced `endpoint_subnet_cidrs` to the complete example so consumers can provision endpoint subnets alongside existing subnet tiers.

### Changed
- Regenerated module documentation to surface the AWS provider version and highlight endpoint subnet capabilities across READMEs.
- Updated repository examples and top-level guidance to reference the `v0.5.0` release tag.

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
