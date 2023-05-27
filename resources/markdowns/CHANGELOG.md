# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## WIP
## [1.0.6] - Unknown
### Added
- Built XCFrameworks for 90% of all external libraries
  - Only includes support for iOS and iPadOS for now, tvOS support is planned
  - Clone the repository with `--branch swiftui-rework --recursive` to built the app yourself
    - <span style="color: rgb(255, 59, 48)">This is only recommended for developers, it does not do anything important yet</span>
- Added rom icon and publisher within the Library screen
- Improved the handling of roms with **[LibraryManager.swift](../../emuThreeDS/Swift/Classes/LibraryManager.swift)**

### Changed
- Transitioned to SwiftUI by recreating the Xcode project
- Updated VulkanSDK from `v1.3.239.0` to `v1.3.243.0`
- Updated Citra to the latest Vulkan fork by GPUcode

### Removed
- Removed numerous header and source files that are no longer needed