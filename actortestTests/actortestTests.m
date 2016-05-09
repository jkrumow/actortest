//
//  actortestTests.m
//  actortestTests
//
//  Created by Julian Krumow on 09.11.15.
//  Copyright © 2015 Julian Krumow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "actortest.h"

@interface TestActor : NSObject

- (void)doSomething:(NSString *)argument completion:(void(^)(void))completion;
@end

@implementation TestActor

- (void)doSomething:(NSString *)argument completion:(void(^)(void))completion
{
    NSLog(@"argument: %@", argument);
    if (completion) {
        completion();
    }
}
@end

@interface actortestTests : XCTestCase
@property TestActor *actor;
@end

@implementation actortestTests

- (void)setUp
{
    [super setUp];
    _actor = [TestActor new];
}

- (void)tearDown
{
    _actor = nil;
    [super tearDown];
}

- (void)testSendMessageToActor
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"actor acts"];
    
    __block NSOperationQueue *currentQueue = nil;
    [self.actor.async doSomething:@"foobar" completion:^{
        currentQueue = [NSOperationQueue currentQueue];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
    
    XCTAssertEqual(currentQueue, self.actor.actorQueue, @"actor should execute task on its dedicated operation queue");
}

@end
