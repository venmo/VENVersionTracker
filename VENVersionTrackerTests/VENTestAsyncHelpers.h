BOOL isWaitingForBlockExecution = NO;

#define VENStartAsyncBlock() isWaitingForBlockExecution = YES

#define VENEndAsyncBlock() isWaitingForBlockExecution = NO

#define VENWaitForAsyncBlock() WaitWhile(isWaitingForBlockExecution)

#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.15]]; \
} \
} while(0)