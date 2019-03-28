//
//  CALayer+BBAPainterTransaction.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "CALayer+BBAPainterTransaction.h"
#import "BBAPainterTransaction.h"
#import "BBAPainterTransactionGroup.h"
#import <objc/runtime.h>


static void* PainterTransactionsKey = @"PainterTransactionsKey";
static void* PainterCurrentTransacitonKey = @"PainterCurrentTransacitonKey";

@implementation CALayer (BBAPainterTransaction)

#pragma mark - Associations

- (void)setTransactions:(NSHashTable *)transactions {
    objc_setAssociatedObject(self, PainterTransactionsKey, transactions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)transactions {
    return objc_getAssociatedObject(self, PainterTransactionsKey);
}

- (void)setCurrentTransaction:(BBAPainterTransaction *)currentTransaction {
    objc_setAssociatedObject(self, PainterCurrentTransacitonKey, currentTransaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BBAPainterTransaction *)currentTransaction {
    return  objc_getAssociatedObject(self, PainterCurrentTransacitonKey);
}

- (PainterTransactionContainerState)transactionContainerState {
    return ([self.transactions count] == 0) ? PainterTransactionContainerStateNoTransactions : PainterTransactionContainerStatePendingTransactions;
}

- (void)painter_transactionContainerWillBeginTransaction:(BBAPainterTransaction *)transaction {
    
}

- (void)painter_transactionContainerrDidCompleteTransaction:(BBAPainterTransaction *)transaction {
    
}

- (void)painter_cancelAsyncTransactions {
    BBAPainterTransaction* currentTransaction = self.currentTransaction;
    [currentTransaction commit];
    self.currentTransaction = nil;
    for (BBAPainterTransaction* transaction in [self.transactions copy]) {
        [transaction cancel];
    }
}

- (void)painter_asyncTransactionContainerStateDidChange {
    id delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(painter_asyncTransactionContainerStateDidChange)]) {
        [delegate painter_asyncTransactionContainerStateDidChange];
    }
}

- (BBAPainterTransaction *)painter_asyncTransaction {
    BBAPainterTransaction* transaction = self.currentTransaction;
    if (transaction == nil) {
        NSHashTable* transactions = self.transactions;
        if (transactions == nil) {
            transactions = [NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
            self.transactions = transactions;
        }
        
        transaction = [[BBAPainterTransaction alloc] initWithCallbackQueue:dispatch_get_main_queue()
                                                   completionBlock:^(BBAPainterTransaction *completeTransaction, BOOL isCancelled) {
                                                       [transactions removeObject:completeTransaction];
                                                       [self painter_transactionContainerrDidCompleteTransaction:completeTransaction];
                                                       if ([transactions count] == 0) {
                                                           [self painter_asyncTransactionContainerStateDidChange];
                                                       }
                                                   }];
        [transactions addObject:transaction];
        self.currentTransaction = transaction;
        [self painter_transactionContainerWillBeginTransaction:transaction];
        if ([transactions count] == 1) {
            [self painter_asyncTransactionContainerStateDidChange];
        }
    }
    [[BBAPainterTransactionGroup mainTransactionGroup] addTransactionContainer:self];
    return transaction;
}
@end
