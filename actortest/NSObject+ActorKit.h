#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (ActorKit)
@property (nonatomic, strong, nonnull) NSOperationQueue *actorQueue;
- (nonnull NSOperationQueue *)actorQueue;
- (nonnull id)async;
@end