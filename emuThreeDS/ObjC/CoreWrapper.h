//
//  CoreWrapper.h
//  emuThreeDS
//
//  Created by Antique on 27/3/2023.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus
#include <cstring>
#include <string>

#include "common/common_types.h"
#include "core/savestate.h"


namespace GameInfo {
std::vector<u8> GetSMDHData(std::string physical_name);

std::u16string GetTitle(std::string physical_name);

std::u16string GetPublisher(std::string physical_name);

std::string GetRegions(std::string physical_name);

std::vector<u16> GetIcon(std::string physical_name);
}
#endif


typedef enum {
    OK,
    RevisionDismatch,
} ValidationStatus;

@interface SaveState : NSObject
@property (nonatomic) uint32_t slot;
@property (nonatomic) uint64_t time;

@property (nonatomic) ValidationStatus status;

-(id) initWith:(uint32_t)slot time:(uint64_t)time status:(ValidationStatus)status;
@end


@interface AmiiboData : NSObject
    /*
     std::array<u8, 7> uuid;
     INSERT_PADDING_BYTES(0x4D);
     u16_le char_id;
     u8 char_variant;
     u8 figure_type;
     u16_be model_number;
     u8 series;
     INSERT_PADDING_BYTES(0x1C1);
     */
@property (nonatomic) uint8_t char_variant;

-(id) initWith:(uint8_t)char_id;
@end



@interface CoreWrapper : NSObject
@property (nonatomic, strong) MTKView *metalView;
@property (nonatomic) bool run;

-(void) insertRom:(NSString *)path layer:(CAMetalLayer *)layer;
-(void) touch:(CGPoint)point;

-(void) installCIA:(NSString *)path withCompletion:(void (^)(NSString *path))completionHandler;
-(NSMutableArray<NSString *> *) installedGamePaths;

-(NSString *) InstalledGamesPath;
-(void) GameIcon:(NSString *)path completion:(void (^)(uint16_t *bitmapData))completionHandler;
-(NSString *) GameTitle:(NSString *)path;

-(NSMutableArray<SaveState *> *) ListSaveStates;
-(bool) SaveState;
-(void) LoadState:(SaveState *)state;

-(bool) InsertAmiibo:(NSString *)path;
-(void) RemoveAmiibo;
-(NSMutableArray<NSString *> *) ListAmiibos;
@end
