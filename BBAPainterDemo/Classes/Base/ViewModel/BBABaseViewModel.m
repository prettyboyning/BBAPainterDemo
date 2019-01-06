//
//  BBABaseViewModel.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/4.
//

#import "BBABaseViewModel.h"

@interface BBABaseViewModel () {
    dispatch_queue_t prelayout_queue;
}

@property (nonatomic, strong) NSError *error;

@end

@implementation BBABaseViewModel

- (id)init {
    self = [super init];
    if (self){
        _error = nil;
        const char *queue_name = [[NSString stringWithFormat:@"%@_prelayout_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        prelayout_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)reloadDataWithParams:(NSDictionary *)params completion:(BBAPrelayoutCompletionBlock)completion {
    
}

@end

@implementation BBABaseViewModel (SafeInvoke)



@end
