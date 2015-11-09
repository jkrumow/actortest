#import "NSObject+ActorKit.h"
@interface TBActorProxyAsync : NSProxy
@property (nonatomic, strong, nonnull) NSObject *actor;
- (nullable instancetype)initWithActor:(nonnull NSObject *)actor;
@end
@implementation TBActorProxyAsync
- (instancetype)initWithActor:(NSObject *)actor {
    _actor = actor;
    return self;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.actor methodSignatureForSelector:selector];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation setTarget:self.actor];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    [self.actor.actorQueue addOperation:operation];
}
@end
@implementation NSObject (ActorKit)
@dynamic actorQueue;
- (NSOperationQueue *)actorQueue {
    @synchronized(self) {
        NSOperationQueue *queue = objc_getAssociatedObject(self, @selector(actorQueue));
        if (queue == nil) {
            queue = [NSOperationQueue new];
            queue.maxConcurrentOperationCount = 1;
            self.actorQueue = queue;
        }
        return queue;
    }
}
- (void)setActorQueue:(NSOperationQueue *)actorQueue {
    objc_setAssociatedObject(self, @selector(actorQueue), actorQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)async {
    return  [[TBActorProxyAsync alloc] initWithActor:self];
}
@end