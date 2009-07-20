/*
 * OSXSimpleAuth.m
 *
 * Created by Michael V. O'Brien on 02/07/2009.
 *
 * This code was written to show how to use
 * AuthorizationExecuteWithPrivileges in a simple and straightforward
 * example.  It is probably not secure, but it gets the job done for
 * demonstration purposes. Look at OSXSlightlyBetterAuth example for
 * more details.
 */


#import <Foundation/Foundation.h>
// Add Security.framework to the Xcode project

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    // Create authorization reference
    AuthorizationRef authorizationRef;
    OSStatus status;
	
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
	
    // Run the tool using the authorization reference
    char *tool = "/sbin/dmesg";
    char *args[] = {NULL};
    FILE *pipe = NULL;
	
    status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
	
    // Print to standard output
    char readBuffer[128];
    if (status == errAuthorizationSuccess) {
        for (;;) {
            int bytesRead = read(fileno(pipe), readBuffer, sizeof(readBuffer));
            if (bytesRead < 1) break;
            write(fileno(stdout), readBuffer, bytesRead);
        }
    } else {
        NSLog(@"Authorization Result Code: %d", status);
    }
	
    [pool drain];
    return 0;
}
