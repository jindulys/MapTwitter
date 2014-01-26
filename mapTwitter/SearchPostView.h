//
//  SearchPostView.h
//  mapTwitter
//
//  Created by Li Yansong on 13-12-31.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SearchTextFormFontSize 14.0f
#define SearchTextFormMaxLine  8
#define SearchTextFormMinLine  4

@protocol SearchPostViewDelegate;

@class IOS7CorrectedTextView;

@interface SearchPostView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id <SearchPostViewDelegate> delegate;
@property (nonatomic, strong) IOS7CorrectedTextView *textView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIImageView *borderImageView;
@property (nonatomic, strong) UINavigationItem *navigationItem;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIBarButtonItem *sendButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIView *hearderView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic) BOOL requireText;

- (NSString *)text;
- (void)setText:(NSString *)text;
- (void)dismiss;
- (void)handleSendButtonTapped:(id)sender;
- (void)handleCancelButtonTapped:(id)sender;
- (void)updateNavItem;
- (void)configureNavItem;
- (void)enableForm:(BOOL)enabled;
- (BOOL)shouldEnableSendButton;

@end

@protocol SearchPostViewDelegate <NSObject>

@optional

- (void)SearchPostViewWillSend:(SearchPostView *)SearchPostView;
- (void)SearchPostViewDidSend:(SearchPostView *)SearchPostView;
- (void)SearchPostViewDidCancel:(SearchPostView *)SearchPostView;
- (void)SearchPostViewShouldDismiss:(SearchPostView *)SearchPostView;
- (void)SearchPostViewDidBeginEditting:(SearchPostView *)SearchPostView;
- (void)SearchPostViewDidChange:(SearchPostView *)SearchPostView;
- (void)SearchPostViewDidEndEditing:(SearchPostView *)SearchPostView;

@end







