#import "NSObject+ActorKit.h"

@interface TBActorProxyAsync : NSProxy
@property NSObject *actor;
@end

@implementation TBActorProxyAsync

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [self.actor methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    invocation.target = self.actor;
    [self.actor.actorQueue addOperation:[[NSInvocationOperation alloc] initWithInvocation:invocation]];
}

@end

@implementation NSObject (ActorKit)
@dynamic actorQueue;

- (NSOperationQueue *)actorQueue
{
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

- (void)setActorQueue:(NSOperationQueue *)actorQueue
{
    objc_setAssociatedObject(self, @selector(actorQueue), actorQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)async
{
    TBActorProxyAsync *proxy = [TBActorProxyAsync alloc];
    proxy.actor = self;
    return proxy;
}

@end
