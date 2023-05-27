//
//  file_handle.cpp
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "file_handle.h"

float ResolutionHandle::GetScreenWidth() {
    return [[UIScreen mainScreen] nativeBounds].size.width;
}

float ResolutionHandle::GetScreenHeight() {
    return [[UIScreen mainScreen] nativeBounds].size.height;
}


bool ResolutionHandle::IsPortrait() {
    __block UIWindowScene *scene;
    dispatch_async(dispatch_get_main_queue(), ^{
        scene = (UIWindowScene *)[[UIApplication sharedApplication] connectedScenes].allObjects.lastObject;
    });
    
    return scene.interfaceOrientation == UIInterfaceOrientationPortrait;
}
