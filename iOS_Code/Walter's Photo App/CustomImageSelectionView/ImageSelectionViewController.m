//
//  ImageSelectionViewController.m
//  Walter's Automotive
//
//  Created by Administrator on 4/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "ImageSelectionViewController.h"

@interface ImageSelectionViewController () <CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>

{
    UIView *zoomView;
    UIImageView *zoomImageView;
    UIScrollView *zoomScrollView;
    CLImageEditor *myEditor;
}

@end

@implementation ImageSelectionViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.frameImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.frameImageView.frame.origin.y)];
    top.backgroundColor = [UIColor blackColor];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameImageView.frame.origin.y + self.frameImageView.frame.size.height, self.view.frame.size.width, 300)];
    bottom.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:top];
    [self.view addSubview:bottom];
    
    [self.view bringSubviewToFront:self.btnDone];
    [self.view bringSubviewToFront:self.btnCancel];
    [self.view bringSubviewToFront:self.lblMoveAndScale];
    
    
    if(zoomView == Nil)
    {
        zoomView = [[UIView alloc]initWithFrame:self.frameImageView.frame];
        zoomImageView = [[UIImageView alloc]init];
        zoomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, zoomView.frame.size.width, zoomView.frame.size.height)];
    }
    
    [zoomScrollView setUserInteractionEnabled:YES];
    [zoomScrollView setDelegate:self];
    [zoomView addSubview:zoomScrollView];
    [zoomImageView setImage:self.selectedImage];
    [zoomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:zoomView];
    
    
    //    Set up the image we want to scroll & zoom and add it to the scroll view
    //    UIImage *image = [UIImage imageNamed:@"photo1.png"];
    //    self.imageView = [[UIImageView alloc] initWithImage:image];
    //    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [zoomImageView setFrame:zoomScrollView.frame];
    zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [zoomScrollView addSubview:zoomImageView];
    
    // Tell the scroll view the size of the contents
    zoomScrollView.contentSize = zoomScrollView.frame.size;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [zoomScrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [zoomScrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    CGRect scrollViewFrame = zoomScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / zoomScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / zoomScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    zoomScrollView.minimumZoomScale = 0.5f;
    zoomScrollView.maximumZoomScale = 3.0f;
    zoomScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
    
    [self.view bringSubviewToFront:self.frameImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCancel_Clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDone_Clicked:(id)sender {
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frameImageView.frame.size.width, self.frameImageView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [zoomView.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    myEditor = [[CLImageEditor alloc] initWithImage:screenShot];
    CLImageToolInfo *tool = [myEditor.toolInfo subToolInfoWithToolName:@"CLResizeTool" recursive:NO];
    tool.available = NO;
    myEditor.delegate = self;
    [self.navigationController pushViewController:myEditor animated:YES];
}

#pragma mark Image Zooming Methods

- (void)centerScrollViewContents {
    CGSize boundsSize = zoomScrollView.bounds.size;
    CGRect contentsFrame = zoomImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    zoomImageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:zoomImageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = zoomScrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, zoomScrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = zoomScrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [zoomScrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = zoomScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, zoomScrollView.minimumZoomScale);
    [zoomScrollView setZoomScale:newZoomScale animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark- CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)editedImage
{
//    isFirstTime = true;
//    _imageView.image = editedImage;
//    frameImageView.hidden = NO;
//    
//    if (self.isFromCamera) {
//        [editor.navigationController setNavigationBarHidden:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else {
//        [editor dismissViewControllerAnimated:YES completion:nil];
//    }
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0); // 0.7 is JPG quality

    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"IMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
//    if (self.isFromCamera) {
//        [editor.navigationController setNavigationBarHidden:YES];
//    }
//    frameImageView.hidden = NO;
}

- (void)imageEditorDidCancel:(CLImageEditor *)editor {
//    frameImageView.hidden = NO;
//    [editor.navigationController setNavigationBarHidden:YES];
//    [editor dismissViewControllerAnimated:YES completion:nil];
//    
//    //    if (isFromConfirm) {
//    //        [editor dismissViewControllerAnimated:YES completion:^{
//    //            [self.navigationController popViewControllerAnimated:YES];
//    //        }];
//    //    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
