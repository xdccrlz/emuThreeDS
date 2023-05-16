# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5.3] - 16th May 2023
### Added
- Added virtual (on-screen) controller support.
- Added Game tab alongside Roms tab.
  - **NOTE**: Do not tap the Game tab in v1.0.5.3, it will result in a crash.
- Added direction pad and joystick option to the Emulation menu.
- Added landscape support.
  - Landscape touch support will need to be tested.

### Changed
- Updated to the latest Vulkan backend.
  - Huge thanks to emufan ([@GPUcode](https://github.com/gpucode)), Vulkan makes this port possible.
- Changed the way audio is handled to hopefully reduce crackling, latency, etc.

## [1.0.5.2] - 7th May 2023
### Added
- Added Emulation menu to the in-game options button.
  - Added pause and resume emulation option to the Emulation menu.
- Added preload textures by default to improve performance.
- Added portrait touch and drag support.
- Reimplemented landscape mode for testing (screens will not be side-by-side yet).

### Changed
- Changed the layout of the emulation to display below the status bar.
- Increased priority of the emulation thread to squeeze out more performance.

### Fixed
- Fixed an issue where the status bar would display black text on a black background.

## [1.0.5.1] - 5th May 2023
### Added
- Added portrait touch support.
- Added support section in settings.
- Added Amiibo support.
- Added application icon.

### Removed
- Removed SDL2.
- Removed landscape while testing portrait touch support.
