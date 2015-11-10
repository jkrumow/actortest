#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (ActorKit)
@property NSOperationQueue *actorQueue;
- (id)async;
@end