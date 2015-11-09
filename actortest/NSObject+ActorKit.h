#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (ActorKit)
@property (nonatomic, strong) NSOperationQueue *actorQueue;
- (id)async;
@end