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

@property (nonatomic, strong) NSNumber *uuid;

- (void)doSomething:(NSString *)argument completion:(void(^)(void))completion;
@end

@implementation TestActor

- (void)doSomething:(NSString *)argument completion:(void(^)(void))completion
{
    NSLog(@"uuid: %@, argument: %@", self.uuid, argument);
    if (completion) {
        completion();
    }
}
@end

@interface actortestTests : XCTestCase
@property (nonatomic, strong) TestActor *actor;
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
    
    [[self.actor async] setUuid:@(5)];
    [[self.actor async] doSomething:@"foobar" completion:^{
        
        XCTAssertFalse([[NSThread currentThread] isMainThread], @"actor should execute task on dedicated thread");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
