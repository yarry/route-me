//
//  RMMapOverlayView.m
//  MapView
//
// Copyright (c) 2008-2013, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMMapOverlayView.h"
#import "RMMarker.h"
#import "RMAnnotation.h"
#import "RMPixel.h"
#import "RMMapView.h"
#import "RMUserLocation.h"

@implementation RMMapOverlayView

+ (Class)layerClass
{
    return [CAScrollLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;

    self.layer.masksToBounds = NO;

    //self.layer.masksToBounds = YES;
    
/*
    _trackPanGesture = NO;
    _lastTranslation = CGPointZero;
    _draggedAnnotation = nil;

    UITapGestureRecognizer *doubleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)] autorelease];
    doubleTapRecognizer.numberOfTapsRequired = 2;

    UITapGestureRecognizer *singleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)] autorelease];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] autorelease];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;

    [self addGestureRecognizer:singleTapRecognizer];
    [self addGestureRecognizer:doubleTapRecognizer];
    [self addGestureRecognizer:panGestureRecognizer];
*/
    
    return self;
}

- (unsigned)sublayersCount
{
    return [self.layer.sublayers count];
}

- (void)addSublayer:(CALayer *)aLayer
{
    [self.layer addSublayer:aLayer];
}

- (void)insertSublayer:(CALayer *)aLayer atIndex:(unsigned)index
{
    [self.layer insertSublayer:aLayer atIndex:index];
}

- (void)insertSublayer:(CALayer *)aLayer below:(CALayer *)sublayer
{
    [self.layer insertSublayer:aLayer below:sublayer];
}

- (void)insertSublayer:(CALayer *)aLayer above:(CALayer *)sublayer
{
    [self.layer insertSublayer:aLayer above:sublayer];
}

- (void)moveLayersBy:(CGPoint)delta
{
    [self.layer scrollPoint:CGPointMake(-delta.x, -delta.y)];
}

#if 0

#pragma mark -
#pragma mark Event handling

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([[event touchesForView:self] count] > 1)
        return NO;

    CALayer *hit = [self.layer hitTest:point];

    RMAnnotation *hitAnnotation = [self findAnnotationInLayer:hit];
    
    if (!hit || !hitAnnotation || ![hitAnnotation.layer isKindOfClass:[RMMarker class]])
        return NO;

    return hitAnnotation.enabled;
}

- (RMAnnotation *)findAnnotationInLayer:(CALayer *)layer
{
    if ([layer respondsToSelector:@selector(annotation)])
        return [((RMMarker *)layer) annotation];

    CALayer *superlayer = [layer superlayer];

    if (superlayer != nil && [superlayer respondsToSelector:@selector(annotation)])
        return [((RMMarker *)superlayer) annotation];
    else if ([superlayer superlayer] != nil && [[superlayer superlayer] respondsToSelector:@selector(annotation)])
        return [((RMMarker *)[superlayer superlayer]) annotation];

    return nil;
}

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    CALayer *hit = [self.layer hitTest:[recognizer locationInView:self]];

    if (!hit)
        return;

    CALayer *superlayer = [hit superlayer];

    // See if tap was on a marker or marker label and send delegate protocol method
    if ([hit isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:tapOnAnnotation:atPoint:)])
            [delegate mapOverlayView:self tapOnAnnotation:[((RMMarker *)hit) annotation] atPoint:[recognizer locationInView:self]];
    }
/*    else if (superlayer != nil && [superlayer isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:tapOnLabelForAnnotation:atPoint:)])
            [delegate mapOverlayView:self tapOnLabelForAnnotation:[((RMMarker *)superlayer) annotation] atPoint:[recognizer locationInView:self]];
    }*/
    /*else if ([superlayer superlayer] != nil && [[superlayer superlayer] isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:tapOnLabelForAnnotation:atPoint:)])
            [delegate mapOverlayView:self tapOnLabelForAnnotation:[((RMMarker *)[superlayer superlayer]) annotation] atPoint:[recognizer locationInView:self]];
    }*/
    else
    {
        while(superlayer)
        {
            if(superlayer != nil && [superlayer isKindOfClass:[RMMarker class]])
            {
                if ([delegate respondsToSelector:@selector(mapOverlayView:tapOnLabelForAnnotation:onLayer:atPoint:)])
                    [delegate mapOverlayView:self tapOnLabelForAnnotation:[((RMMarker *)superlayer) annotation] onLayer:hit atPoint:[recognizer locationInView:self]];
                
                else if ([delegate respondsToSelector:@selector(mapOverlayView:tapOnLabelForAnnotation:atPoint:)])
                    [delegate mapOverlayView:self tapOnLabelForAnnotation:[((RMMarker *)superlayer) annotation] atPoint:[recognizer locationInView:self]];
            }
            superlayer = superlayer.superlayer;
        }
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer
{
    CALayer *hit = [self.layer hitTest:[recognizer locationInView:self]];

    if (!hit)
        return;

    CALayer *superlayer = [hit superlayer];

    // See if tap was on a marker or marker label and send delegate protocol method
    if ([hit isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:doubleTapOnAnnotation:atPoint:)])
            [delegate mapOverlayView:self doubleTapOnAnnotation:[((RMMarker *)hit) annotation] atPoint:[recognizer locationInView:self]];
    }
    else if (superlayer != nil && [superlayer isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:doubleTapOnLabelForAnnotation:atPoint:)])
            [delegate mapOverlayView:self doubleTapOnLabelForAnnotation:[((RMMarker *)superlayer) annotation] atPoint:[recognizer locationInView:self]];
    }
    else if ([superlayer superlayer] != nil && [[superlayer superlayer] isKindOfClass:[RMMarker class]])
    {
        if ([delegate respondsToSelector:@selector(mapOverlayView:doubleTapOnLabelForAnnotation:atPoint:)])
            [delegate mapOverlayView:self doubleTapOnLabelForAnnotation:[((RMMarker *)[superlayer superlayer]) annotation] atPoint:[recognizer locationInView:self]];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CALayer *hit = [self.layer hitTest:[recognizer locationInView:self]];

        if (!hit)
            return;

        if ([hit respondsToSelector:@selector(enableDragging)] && ![(RMMarker *)hit enableDragging])
            return;

        _lastTranslation = CGPointZero;
        [_draggedAnnotation release];
        _draggedAnnotation = [[self findAnnotationInLayer:hit] retain];

        if ([delegate respondsToSelector:@selector(mapOverlayView:shouldDragAnnotation:)])
            _trackPanGesture = [delegate mapOverlayView:self shouldDragAnnotation:_draggedAnnotation];
        else
            _trackPanGesture = NO;
    }

    if (!_trackPanGesture)
        return;

    if (recognizer.state == UIGestureRecognizerStateChanged && [delegate respondsToSelector:@selector(mapOverlayView:didDragAnnotation:withDelta:)])
    {
        CGPoint translation = [recognizer translationInView:self];
        CGPoint delta = CGPointMake(_lastTranslation.x - translation.x, _lastTranslation.y - translation.y);
        _lastTranslation = translation;

        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        [delegate mapOverlayView:self didDragAnnotation:_draggedAnnotation withDelta:delta];
        [CATransaction commit];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded && [delegate respondsToSelector:@selector(mapOverlayView:didEndDragAnnotation:)])
    {
        [delegate mapOverlayView:self didEndDragAnnotation:_draggedAnnotation];
        _trackPanGesture = NO;
        [_draggedAnnotation release]; _draggedAnnotation = nil;
    }
}

#endif

- (CALayer *)overlayHitTest:(CGPoint)point
{
    RMMapView *mapView = ((RMMapView *)self.superview);

    // Here we be sure to hide disabled but visible annotations' layers to
    // avoid touch events, then re-enable them after scoring the hit. We
    // also show the user location if enabled and we're in tracking mode,
    // since its layer is hidden and we want a possible hit. 
    //
    NSPredicate *annotationPredicate = [NSPredicate predicateWithFormat:@"SELF.enabled = NO AND SELF.layer != %@ AND SELF.layer.isHidden = NO", [NSNull null]];

    NSArray *disabledVisibleAnnotations = [mapView.annotations filteredArrayUsingPredicate:annotationPredicate];

    for (RMAnnotation *annotation in disabledVisibleAnnotations)
        annotation.layer.hidden = YES;

    if (mapView.userLocation.enabled && mapView.userTrackingMode == RMUserTrackingModeFollowWithHeading)
        mapView.userLocation.layer.hidden = NO;

    CALayer *hit = [self.layer hitTest:point];

    if (mapView.userLocation.enabled && mapView.userTrackingMode == RMUserTrackingModeFollowWithHeading)
        mapView.userLocation.layer.hidden = YES;

    for (RMAnnotation *annotation in disabledVisibleAnnotations)
        annotation.layer.hidden = NO;

    return hit;
}


@end
