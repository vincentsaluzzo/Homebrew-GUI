//
//  main.m
//  HomebrewXPC
//
//  Created by Seán Labastille on 12/1/13.
//
//

#include <xpc/xpc.h>
#include <Foundation/Foundation.h>
#include "LLCXPCListenerDelegate.h"

int main(int argc, const char *argv[])
{
    LLCXPCListenerDelegate *delegate = [[LLCXPCListenerDelegate alloc] init];
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;
    [listener resume];
	exit(EXIT_FAILURE);
}
