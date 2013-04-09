//
//  TPPopover.m
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import "TPPopover.h"

#import "TPPopoverWindow.h"
#import "TPPopoverWindowFrame.h"

#ifdef GNUSTEP
#else
#include <QuartzCore/QuartzCore.h>
#endif



@implementation TPPopover

- (id) init
{
	return [self initWithContentViewController:nil];
}

- (id) initWithContentView:(NSView *)contentView
{
	NSViewController *contentViewController = [[[NSViewController alloc] init] autorelease];
	[contentViewController setView:contentView];
	return [self initWithContentViewController:contentViewController];
}

- (id) initWithContentViewController:(NSViewController *)contentViewController
{
	if((self = [super init])) {
        [self setContentViewController:contentViewController];
		_animates = NO;

		NSView *contentView = [_contentViewController view];
        NSRect contentFrame = [contentView frame];
		_popoverWindow = [[TPPopoverWindow alloc] initWithContentRect:contentFrame styleMask:0 backing:NSBackingStoreBuffered defer:NO];

        if (ApplicationPlatform == MacOSX)
        {
            [self setDrawsArrow:YES];
            [self setCornerRadius:8];
            [self setArrowHeight:16];
            [self setArrowWidth:20];
            [self setViewMargin:3];
            _animates = YES;
        }
        else
        {
            [self setDrawsArrow:NO];
			[self setViewMargin:-2];
            [self setArrowHeight:0];
            [self setArrowWidth:0];
            [self setDistance:0];
            [self setCornerRadius:0];
            _animates = NO;
        }

		[_popoverWindow setContentView:contentView];

#ifdef GNUSTEP
#else
		CAAnimation *animation = [CABasicAnimation animation];
		[animation setDelegate:self];
		[_popoverWindow setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"alphaValue"]];
#endif

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:_popoverWindow];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidResignActive:) name:NSApplicationDidResignActiveNotification object:nil];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [_popoverWindow release];
    [_contentViewController release];
    [super dealloc];
}

- (SFBPopoverPosition) bestPositionInWindow:(NSWindow *)window atPoint:(NSPoint)point
{
	// Get all relevant geometry in screen coordinates.
	NSRect screenFrame = NSZeroRect;
	if(window && [window screen])
		screenFrame = [[window screen] visibleFrame];
	else
		screenFrame = [[NSScreen mainScreen] visibleFrame];

	NSPoint pointOnScreen = window ? [window convertBaseToScreen:point] : point;

	TPPopoverWindow *popoverWindow = _popoverWindow;
	NSSize popoverSize = [popoverWindow frame].size;
	popoverSize.width += 2 * [popoverWindow viewMargin];
	popoverSize.height += 2 * [popoverWindow viewMargin];

	// By default, position us centered below.
	SFBPopoverPosition side = SFBPopoverPositionBottom;
	CGFloat distance = [popoverWindow arrowHeight] + [popoverWindow distance];

	// We'd like to display directly below the specified point, since this gives a 
	// sense of a relationship between the point and this window. Check there's room.
	if(pointOnScreen.y - popoverSize.height - distance < NSMinY(screenFrame)) {
		// We'd go off the bottom of the screen. Try the right.
		if(pointOnScreen.x + popoverSize.width + distance >= NSMaxX(screenFrame)) {
			// We'd go off the right of the screen. Try the left.
			if(pointOnScreen.x - popoverSize.width - distance < NSMinX(screenFrame)) {
				// We'd go off the left of the screen. Try the top.
				if (pointOnScreen.y + popoverSize.height + distance < NSMaxY(screenFrame))
					side = SFBPopoverPositionTop;
			}
			else
				side = SFBPopoverPositionLeft;
		}
		else
			side = SFBPopoverPositionRight;
	}

	CGFloat halfWidth = popoverSize.width / 2;
	CGFloat halfHeight = popoverSize.height / 2;

	NSRect parentFrame = window ? NSIntersectionRect([window frame], screenFrame) : screenFrame;
	CGFloat arrowInset = ([popoverWindow arrowWidth] / 2) + ([popoverWindow drawRoundCornerBesideArrow] ? [popoverWindow cornerRadius] : 0);

	// We're currently at a primary side.
	// Try to avoid going outwith the parent area in the secondary dimension,
	// by checking to see if an appropriate corner side would be better.
	switch(side) {
		case SFBPopoverPositionBottom:
		case SFBPopoverPositionTop:
			// Check to see if we go beyond the left edge of the parent area.
			if(pointOnScreen.x - halfWidth < NSMinX(parentFrame)) {
				// We go beyond the left edge. Try using right position.
				if(pointOnScreen.x + popoverSize.width - arrowInset < NSMaxX(screenFrame)) {
					// We'd still be on-screen using right, so use it.
					if(SFBPopoverPositionBottom == side)
						side = SFBPopoverPositionBottomRight;
					else
						side = SFBPopoverPositionTopRight;
				}
			}
			else if(pointOnScreen.x + halfWidth >= NSMaxX(parentFrame)) {
				// We go beyond the right edge. Try using left position.
				if(pointOnScreen.x - popoverSize.width + arrowInset >= NSMinX(screenFrame)) {
					// We'd still be on-screen using left, so use it.
					if(SFBPopoverPositionBottom == side)
						side = SFBPopoverPositionBottomLeft;
					else
						side = SFBPopoverPositionTopLeft;
				}
			}
			break;

		case SFBPopoverPositionRight:
		case SFBPopoverPositionLeft:
			// Check to see if we go beyond the bottom edge of the parent area.
			if(pointOnScreen.y - halfHeight < NSMinY(parentFrame)) {
				// We go beyond the bottom edge. Try using top position.
				if(pointOnScreen.y + popoverSize.height - arrowInset < NSMaxY(screenFrame)) {
					// We'd still be on-screen using top, so use it.
					if(SFBPopoverPositionRight == side)
						side = SFBPopoverPositionRightTop;
					else
						side = SFBPopoverPositionLeftTop;
				}
			}
			else if(pointOnScreen.y + halfHeight >= NSMaxY(parentFrame)) {
				// We go beyond the top edge. Try using bottom position.
				if(pointOnScreen.y - popoverSize.height + arrowInset >= NSMinY(screenFrame)) {
					// We'd still be on-screen using bottom, so use it.
					if(SFBPopoverPositionRight == side)
						side = SFBPopoverPositionRightBottom;
					else
						side = SFBPopoverPositionLeftBottom;
				}
			}
			break;

		default:
			break;
	}

	return side;
}

- (void) displayPopoverInWindow:(NSWindow *)window atPoint:(NSPoint)point
{
	[self displayPopoverInWindow:window atPoint:point chooseBestLocation:NO];
}

- (void) displayPopoverInWindow:(NSWindow *)window atPoint:(NSPoint)point chooseBestLocation:(BOOL)chooseBestLocation
{
	if([_popoverWindow isVisible])
		return;

	if(chooseBestLocation)
		[_popoverWindow setPopoverPosition:[self bestPositionInWindow:window atPoint:point]];

	NSPoint attachmentPoint = [[_popoverWindow popoverWindowFrame] attachmentPoint];
	NSPoint pointOnScreen = (nil != window) ? [window convertBaseToScreen:point] : point;

	pointOnScreen.x -= attachmentPoint.x;
	pointOnScreen.y -= attachmentPoint.y;

	[_popoverWindow setFrameOrigin:pointOnScreen];

	if(_animates)
		[_popoverWindow setAlphaValue:0];

	[window addChildWindow:_popoverWindow ordered:NSWindowAbove];

	[_popoverWindow makeKeyAndOrderFront:self];

	if(_animates)
	{
#ifdef GNUSTEP
#else
		[[_popoverWindow animator] setAlphaValue:.75];
#endif
	}
}

- (void) movePopoverToPoint:(NSPoint)point
{
	NSPoint attachmentPoint = [[_popoverWindow popoverWindowFrame] attachmentPoint];
	NSWindow *window = [_popoverWindow parentWindow];
	NSPoint pointOnScreen = (nil != window) ? [window convertBaseToScreen:point] : point;

	pointOnScreen.x -= attachmentPoint.x;
	pointOnScreen.y -= attachmentPoint.y;

	[_popoverWindow setFrameOrigin:pointOnScreen];
}

- (IBAction) closePopover:(id)sender
{
	if(![_popoverWindow isVisible])
		return;

	if(_animates) {
#ifdef GNUSTEP
#else
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:.2];
        [[_popoverWindow animator] setAlphaValue:0];
        [NSAnimationContext endGrouping];
#endif   
//		[[_popoverWindow animator] setAlphaValue:0];
	}
	else {
		NSWindow *parentWindow = [_popoverWindow parentWindow];
		[parentWindow removeChildWindow:_popoverWindow];
		[_popoverWindow orderOut:sender];
	}
}

- (NSViewController *)contentViewController
{
    return _contentViewController;
}

- (void)setContentViewController:(NSViewController *)contentViewController
{
    if (contentViewController != _contentViewController)
    {
        [_contentViewController release];
        _contentViewController = nil;
        _contentViewController = [contentViewController retain];
    }
}

- (NSWindow *) popoverWindow
{
	return _popoverWindow;
}

- (BOOL) isVisible
{
	return [_popoverWindow isVisible];
}

- (SFBPopoverPosition) position
{
	return [_popoverWindow popoverPosition];
}

- (void) setPosition:(SFBPopoverPosition)position
{
	[_popoverWindow setPopoverPosition:position];
}

- (CGFloat) distance
{
	return [_popoverWindow distance];
}

- (void) setDistance:(CGFloat)distance
{
	[_popoverWindow setDistance:distance];
}

- (NSColor *) borderColor
{
	return [_popoverWindow borderColor];
}

- (void) setBorderColor:(NSColor *)borderColor
{
	[_popoverWindow setBorderColor:borderColor];
}

- (CGFloat) borderWidth
{
	return [_popoverWindow borderWidth];
}

- (void) setBorderWidth:(CGFloat)borderWidth
{
	[_popoverWindow setBorderWidth:borderWidth];
}

- (CGFloat) cornerRadius
{
	return [_popoverWindow cornerRadius];
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
	[_popoverWindow setCornerRadius:cornerRadius];
}

- (BOOL) drawsArrow
{
	return [_popoverWindow drawsArrow];
}

- (void) setDrawsArrow:(BOOL)drawsArrow
{
	[_popoverWindow setDrawsArrow:drawsArrow];
}

- (CGFloat) arrowWidth
{
	return [_popoverWindow arrowWidth];
}

- (void) setArrowWidth:(CGFloat)arrowWidth
{
	[_popoverWindow setArrowWidth:arrowWidth];
}

- (CGFloat) arrowHeight
{
	return [_popoverWindow arrowHeight];
}

- (void) setArrowHeight:(CGFloat)arrowHeight
{
	[_popoverWindow setArrowHeight:arrowHeight];
}

- (BOOL) drawRoundCornerBesideArrow
{
	return [_popoverWindow drawRoundCornerBesideArrow];
}

- (void) setDrawRoundCornerBesideArrow:(BOOL)drawRoundCornerBesideArrow
{
	[_popoverWindow setDrawRoundCornerBesideArrow:drawRoundCornerBesideArrow];
}

- (CGFloat) viewMargin
{
	return [_popoverWindow viewMargin];
}

- (void) setViewMargin:(CGFloat)viewMargin
{
	[_popoverWindow setViewMargin:viewMargin];
}

- (NSColor *) backgroundColor
{
	return [_popoverWindow popoverBackgroundColor];
}

- (void) setBackgroundColor:(NSColor *)backgroundColor
{
	[_popoverWindow setPopoverBackgroundColor:backgroundColor];
}

- (BOOL) isMovable
{
	return [_popoverWindow isMovable];
}

- (void) setMovable:(BOOL)movable
{
	[_popoverWindow setMovable:movable];
}

- (BOOL) isResizable
{
	return [_popoverWindow isResizable];
}

- (void) setResizable:(BOOL)resizable
{
	[_popoverWindow setResizable:resizable];
}

@end

#ifdef GNUSTEP
#else
@implementation TPPopover (NSAnimationDelegateMethods)

- (void) animationDidStop:(CAAnimation *)animation finished:(BOOL)flag 
{
#pragma unused(animation)
	// Detect the end of fade out and close the window
	if(flag && 0 == [_popoverWindow alphaValue]) {
		NSWindow *parentWindow = [_popoverWindow parentWindow];
		[parentWindow removeChildWindow:_popoverWindow];
		[_popoverWindow orderOut:nil];
		[_popoverWindow setAlphaValue:1];
	}
}

@end
#endif

@implementation TPPopover (NSWindowDelegateMethods)

- (void) windowDidResignKey:(NSNotification *)notification
{
	if(_closesWhenPopoverResignsKey)
		[self closePopover:notification];
}

- (void) applicationDidResignActive:(NSNotification *)notification
{
	if(_closesWhenApplicationBecomesInactive)
		[self closePopover:notification];
}

@end
