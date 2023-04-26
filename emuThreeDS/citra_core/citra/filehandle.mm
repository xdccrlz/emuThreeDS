//
//  filehandle.m
//  emuThreeDS
//
//  Created by Antique on 27/3/2023.
//

#import "filehandle.h"
#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

std::string filehandle::rom_path() {
    return [[[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"roms"] URLByAppendingPathComponent:@"rom.3ds"].path cStringUsingEncoding:NSUTF8StringEncoding];
}

std::string FolderHandle::DocumentDirectory() {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] path] cStringUsingEncoding:NSUTF8StringEncoding];
}

float ResolutionHandle::GetScreenWidth() {
    return [[UIScreen mainScreen] nativeBounds].size.width;
}

float ResolutionHandle::GetScreenHeight() {
    return [[UIScreen mainScreen] nativeBounds].size.height;
}


bool ResolutionHandle::IsPortrait() {
    return [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait;
}
