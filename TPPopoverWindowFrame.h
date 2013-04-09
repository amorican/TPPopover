//
//  TPPopoverWindow.h
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TPPopoverWindow.h"

// ========================================
// The class that actually does the work of drawing the popover window
// ========================================
@interface TPPopoverWindowFrame : NSView
{
    SFBPopoverPosition _popoverPosition;
    
    CGFloat _distance;
    
    NSColor * _borderColor;
    CGFloat _borderWidth;
    CGFloat _cornerRadius;
    
    BOOL _drawsArrow;
    CGFloat _arrowWidth;
    CGFloat _arrowHeight;
    BOOL _drawRoundCornerBesideArrow;
    
    CGFloat _viewMargin;
    NSColor * _backgroundColor;
    
    BOOL _movable;
    BOOL _resizable;
}

// ========================================
// Properties

- (SFBPopoverPosition)popoverPosition;
- (void)setPopoverPosition:(SFBPopoverPosition)newValue;

- (CGFloat)distance;
- (void)setDistance:(CGFloat)newValue;

- (NSColor *)borderColor;
- (void)setBorderColor:(NSColor *)newValue;

- (CGFloat)borderWidth;
- (void)setBorderWidth:(CGFloat)newValue;

- (CGFloat)cornerRadius;
- (void)setCornerRadius:(CGFloat)newValue;

- (BOOL)drawsArrow;
- (void)setDrawsArrow:(BOOL)newValue;

- (CGFloat)arrowWidth;
- (void)setArrowWidth:(CGFloat)newValue;

- (CGFloat)arrowHeight;
- (void)setArrowHeight:(CGFloat)newValue;

- (BOOL)drawRoundCornerBesideArrow;
- (void)setDrawRoundCornerBesideArrow:(BOOL)newValue;

- (CGFloat)viewMargin;
- (void)setViewMargin:(CGFloat)newValue;

- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)newValue;

- (BOOL)isMovable;
- (void)setMovable:(BOOL)newValue;

- (BOOL)isResizable;
- (void)setResizable:(BOOL)newValue;

// ========================================
// Geometry calculations
- (NSRect) frameRectForContentRect:(NSRect)contentRect;
- (NSRect) contentRectForFrameRect:(NSRect)windowFrame;

- (NSPoint) attachmentPoint;
- (NSPoint) attachmentPointForRect:(NSRect)rect;

@end
