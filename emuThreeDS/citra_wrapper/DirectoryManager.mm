//
//  DirectoryManager.mm
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

#include <Foundation/Foundation.h>
#import "DirectoryManager.h"

std::string DirectoryManager::DocumentDirectory() {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] path] cStringUsingEncoding:NSUTF8StringEncoding];
}
