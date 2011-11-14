
#import <UIKit/UIKit.h>
#import "ArticleView.h"

@interface TouchCatView : UIView <UIGestureRecognizerDelegate>
{
	// Views the user can move
	ArticleView *catView;

    BOOL piecesOnTop;  // Keeps track of whether or not two or more pieces are on top of each other
	int touchCount;
    
    UIView *pieceForReset;
    
	CGPoint startTouchPosition; 

    CGFloat imageOriginScale;
    
}

@property (nonatomic, retain) ArticleView *catView;
- (void)addGestureRecognizersToPiece:(UIView *)piece;
-(id)initWithImage:(UIImage *)image targetView:(UIView *)tView;
@end

