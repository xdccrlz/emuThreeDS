# emuThreeDS
Nintendo 3DS emulator for Apple devices based on Citra.

## Support
Support the development of all of my emulation work by going to the links below!
> Donations are greatly appreciated but are by no means necessary.

[BuyMeACoffee](https://buymeacoffee.com/antiquecodes), [Ko-Fi](https://ko-fi.com/antiquecodes), [PayPal](https://paypal.me/officialantique)

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
![75%](https://progress-bar.dev/75?width=110)  
Input Common has now been replaced with native input support.

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
