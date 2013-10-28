//
//  HelloWorldTests.m
//  HelloWorldTests
//
//  Created by Craig Young on 2013/10/13.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HelloWorldTests : XCTestCase

@end

@interface ARCTests : XCTestCase
@property BOOL isObjectDestroyed;
@property (strong, nonatomic) NSObject *strongReference;
@property (weak, nonatomic) NSObject *weakReference;
@end

@implementation HelloWorldTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    NSString *s = [NSString new];
    XCTAssertNotNil(s, @"Bad news");
}

@end

@interface SimpleObject : NSObject
@property (weak, nonatomic) ARCTests *testCase;
@property (strong, nonatomic) NSObject *strongReference;
@end


@implementation ARCTests

- (void)testObjectDestroyed
{
    self.isObjectDestroyed = NO;
    SimpleObject *object = [SimpleObject new];
    XCTAssertNotNil(object, @"Object is assigned");
    object.testCase = self;
    object = nil;
    XCTAssertTrue(self.isObjectDestroyed, @"Object has been destroyed");
}

-(void)testObjectWithStrongReferenceNotDestroyed
{
    self.isObjectDestroyed = NO;
    SimpleObject *object = [SimpleObject new];
    object.testCase = self;
    self.strongReference = object;
    object = nil;
    XCTAssertFalse(self.isObjectDestroyed, @"Object cannot be destroyed while strong reference exists.");
    self.strongReference = nil;
    XCTAssertTrue(self.isObjectDestroyed, @"Object has been destroyed");
}

-(void)testObjectWithWeakReferenceDestroyed
{
    self.isObjectDestroyed = NO;
    SimpleObject *object = [SimpleObject new];
    object.testCase = self;
    self.weakReference = object;
    object = nil;
    XCTAssertTrue(self.isObjectDestroyed, @"Object has been destroyed");
    XCTAssertNil(self.weakReference, @"Weak reference set to nil");
}

-(void)testCircularReferenceLeaksMemory
{
    self.isObjectDestroyed = NO;
    SimpleObject *object1 = [SimpleObject new];
    SimpleObject *object2 = [SimpleObject new];
    /* Either instance can be used to mark that an object has been destroyed. */
    object1.testCase = self;
    object2.testCase = self;
    /* Set up the circular reference. */
    object1.strongReference = object2;
    object2.strongReference = object1;
    /* Clear the local references */
    object1 = nil;
    object2 = nil;

    XCTAssertFalse(self.isObjectDestroyed, @"Neither object destroyed while they are looking at each other.");
}

@end

@implementation SimpleObject
- (void)dealloc
{
    if (self.testCase != nil) {
        self.testCase.isObjectDestroyed = YES;
    }
}
@end

