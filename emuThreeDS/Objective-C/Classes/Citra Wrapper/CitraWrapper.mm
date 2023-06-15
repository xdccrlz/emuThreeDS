//
//  CitraWrapper.m
//  emuThreeDS
//
//  Created by Antique on 14/6/2023.
//

#import "CitraWrapper.h"

#include "core/core.h"
#include "core/hle/service/am/am.h"
#include "game_info.h"

Core::System& core{Core::System::GetInstance()};
@implementation CitraWrapper
-(instancetype) init {
    if(self = [super init]) {
        
    } return self;
}

+(CitraWrapper *) sharedInstance {
    static CitraWrapper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CitraWrapper alloc] init];
    });
    return sharedInstance;
}


-(void) importCIAs:(NSArray<NSURL *> *)urls {
    [urls enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
        Service::AM::InstallStatus status = Service::AM::InstallCIA(std::string([obj.path UTF8String]), [&self, &obj](std::size_t received, std::size_t total) {
            [self.delegate importingProgressDidChange:obj received:received total:total];
        });
        
        switch (status) {
            case Service::AM::InstallStatus::Success:
                NSLog(@"Success");
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"importingProgressDidFinish" object:obj]];
                break;
            case Service::AM::InstallStatus::ErrorFailedToOpenFile:
                NSLog(@"ErrorFailedToOpenFile");
                break;
            case Service::AM::InstallStatus::ErrorFileNotFound:
                NSLog(@"ErrorFileNotFound");
                break;
            case Service::AM::InstallStatus::ErrorAborted:
                NSLog(@"ErrorAborted");
                break;
            case Service::AM::InstallStatus::ErrorInvalid:
                NSLog(@"ErrorInvalid");
                break;
            case Service::AM::InstallStatus::ErrorEncrypted:
                NSLog(@"ErrorEncrypted");
                break;
        }
    }];
}

-(NSArray<NSString *> *) importedCIAs {
     NSMutableArray<NSString *> *games = @[].mutableCopy;
     const FileUtil::DirectoryEntryCallable ScanDir = [&games, &ScanDir](u64*, const std::string& directory, const std::string& virtual_name) {
         std::string path = directory + virtual_name;
         if (FileUtil::IsDirectory(path)) {
             path += '/';
             FileUtil::ForeachDirectoryEntry(nullptr, path, ScanDir);
         } else {
             if (!FileUtil::Exists(path))
                 return false;
             auto loader = Loader::GetLoader(path);
             if (loader) {
                 bool executable{};
                 const Loader::ResultStatus result = loader->IsExecutable(executable);
                 if (Loader::ResultStatus::Success == result && executable) {
                     [games addObject:[NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding]];
                 }
             }
         } return true;
     };


     ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::SDMCDir) + "Nintendo " "3DS/00000000000000000000000000000000/" "00000000000000000000000000000000/title/00040000");
     ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::NANDDir) + "00000000000000000000000000000000/title/00040010");
     return games;
 }


-(uint16_t*) GetIcon:(NSString *)path {
    auto icon = GameInfo::GetIcon(std::string([path UTF8String]));
    return icon.data(); // huh? "Address of stack memory associated with local variable 'icon' returned"
}

-(NSString *) GetPublisher:(NSString *)path {
    auto publisher = GameInfo::GetPublisher(std::string([path UTF8String]));
    return [NSString stringWithCharacters:(const unichar*)publisher.c_str() length:publisher.length()];
}

-(NSString *) GetRegion:(NSString *)path {
    auto regions = GameInfo::GetRegions(std::string([path UTF8String]));
    return [NSString stringWithCString:regions.c_str() encoding:NSUTF8StringEncoding];
}

-(NSString *) GetTitle:(NSString *)path {
    auto title = GameInfo::GetTitle(std::string([path UTF8String]));
    return [NSString stringWithCharacters:(const unichar*)title.c_str() length:title.length()];
}
@end
