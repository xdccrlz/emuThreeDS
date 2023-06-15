//
//  CitraWrapper.h
//  emuThreeDS
//
//  Created by Antique on 14/6/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImportingProgressDelegate <NSObject>
@optional
-(void) importingProgressDidChange:(NSURL *)url received:(CGFloat)received total:(CGFloat)total;
@end

@interface CitraWrapper : NSObject
-(instancetype) init;
+(CitraWrapper *) sharedInstance NS_SWIFT_NAME(shared());


@property (nonatomic, assign) id<ImportingProgressDelegate> delegate;


-(void) importCIAs:(NSArray<NSURL *> *)urls;
-(NSArray<NSString *> *) importedCIAs;


-(uint16_t*) GetIcon:(NSString *)path;
-(NSString *) GetPublisher:(NSString *)path;
-(NSString *) GetRegion:(NSString *)path;
-(NSString *) GetTitle:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
