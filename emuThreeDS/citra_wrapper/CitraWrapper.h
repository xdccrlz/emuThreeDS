//
//  CitraWrapper.h
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#include <string>
#include <vector>

namespace GameInfo {
std::vector<uint8_t> GetSMDHData(std::string physical_name);

std::u16string GetPublisher(std::string physical_name);
std::string GetRegions(std::string physical_name);
std::u16string GetTitle(std::string physical_name);

std::vector<uint16_t> GetIcon(std::string physical_name);
}
#endif


NS_ASSUME_NONNULL_BEGIN
@interface CitraWrapper : NSObject
+(CitraWrapper *) sharedInstance;

-(uint16_t*) GetIcon:(NSString *)path;
-(NSString *) GetPublisher:(NSString *)path;
-(NSString *) GetTitle:(NSString *)path;
@end
NS_ASSUME_NONNULL_END
