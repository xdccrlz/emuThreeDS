# emuThreeDS
Nintendo 3DS emulator for Apple devices based on Citra.

## Support
Support the development of all of my emulation work by going to the links below!
> Donations are greatly appreciated but are by no means necessary.

[BuyMeACoffee](https://buymeacoffee.com/antiquecodes), [Ko-Fi](https://ko-fi.com/antiquecodes), [PayPal](https://paypal.me/officialantique)

## Regarding Code Theft, etc.
Please be aware that if it is found you are stealing my or Citra's code **and** not open-sourcing it (as per GPLv3) nor attributing it, all progress on this emulator by me will cease.

### Building
This project is built in a way that is different from most and as such it will not be easy to build. I will not be making a guide on how to build it nor will I be providing any assistance.

## Updates
### Amiibo, Mii
Amiibo will now be fully supported in v1.0.5 and above. Users can place Amiibo .bin data files into `/amiibo` in the emuThreeDS directory of the Files app and insert or remove them via the new options button.
- Support for both inserting and removing an Amiibo is available.
- Amiibo naming is based on the file name currently, this should change if header data is available.

### On-Screen Gamepad
The native on-screen gamepad will now be available in v1.0.5 and above and displayed when no physical controller is connected. Users can manually present or dismiss the on-screen gamepad via the new options button.

### Bottom Screen Touch
Bottom screen touch has been partially added with only half of the bottom screen functional, this will hopefully be fixed before the release of v1.0.5.

## Progress
Progression details for sections within the project.

### Audio
![99%](https://progress-bar.dev/99?width=110)  
Audio appears to work fully, progress will stay at 99% for now.

### Common
![75%](https://progress-bar.dev/75?width=110)  
Common appears to work fully, progress will stay at 75% until rom installation, etc. is tested.

### Core
![99%](https://progress-bar.dev/99?width=110)  
Core appears to work fully, progress will stay at 99% until the JIT requirement is removed.

### Dedicated Room
![0%](https://progress-bar.dev/0?width=110)  
No changes have been made to dedicated room yet.

### ~~Input Common~~
![90%](https://progress-bar.dev/90?width=110)  
Input Common now supports iOS supported gamepads, the iOS native on-screen gamepad and partial bottom screen touch (currently misaligned, likely x/y value miscalculations).

### Network
![0%](https://progress-bar.dev/0?width=110)  
No changes have been made to network yet.

### Video Core
![99%](https://progress-bar.dev/99?width=110)  
Video Core appears to work fully, progress will stay at 99% until further testing is done.
- I'd like to implement LayoutOption::SeparateWindows into Vulkan.
- Current shader conversion pipeline is GLSL > SPIR-V > MSL.
  - This could be improved by rewriting the GLSL shaders to SPIR-V meaning one less layer of conversion is needed.
  - SPIR-V shaders are required for MoltenVK afaik.

### Web Service
![0%](https://progress-bar.dev/0?width=110)  
No changes have been made to web service yet.
