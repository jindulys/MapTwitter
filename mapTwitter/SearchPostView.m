//
//  SearchPostView.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-31.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "SearchPostView.h"
#import "IOS7CorrectedTextView.h"

@interface SearchPostView()

@property (nonatomic, strong) UINavigationItem *oldNavigationItem;

@end

@implementation SearchPostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        self.backgroundColor = [UIColor colorWithRed:47.0f/255.0f green:121.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
        self.borderImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"note-reply-field"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)]];
        _borderImageView.frame = CGRectMake(10.0f, 10.0f, width - 20.0f, height - 20.0f);
        _borderImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_borderImageView];
        
        UIFont *font = [UIFont systemFontOfSize:SearchTextFormFontSize];
        
        self.textView = [[IOS7CorrectedTextView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, width - 30.f, height - 30.f)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textView.font = font;
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        
        self.requireText = YES;
        
        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, width-50.0f, 20.0f)];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [UIColor grayColor];
        _promptLabel.font = [UIFont systemFontOfSize:SearchTextFormFontSize];
        [self addSubview:_promptLabel];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        frame = _activityView.frame;
        frame.origin.x = (width / 2.0f) - (frame.size.width / 2.0f);
        frame.origin.y = (height / 2.0f) - (frame.size.height / 2.0f);
        _activityView.frame = frame;
        _activityView.hidesWhenStopped = YES;
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_activityView];
    }
    return self;
}

- (void)didMoveToWindow {
    [self updateNavItem];
}

- (NSString *)text {
    return _textView.text;
}

- (void)setText:(NSString *)text {
    _promptLabel.hidden = (_textView.isFirstResponder || [text length] > 0) ? YES: NO;
    _textView.text = text;
}

- (void)enableForm:(BOOL)enabled {
    _textView.editable = enabled;
    if (self.requireText) {
        _sendButton.enabled = (([_textView.text length] > 0) && enabled);
    }else {
        _sendButton.enabled = enabled;
    }
    
    if (enabled) {
        _textView.backgroundColor = [UIColor whiteColor];
    }else {
        _textView.backgroundColor = [UIColor grayColor];
    }
}

- (void)updateNavItem {
    if (!_navigationItem) return;
    
    [self configureNavItem];
    
    if (!self.window) {
        self.navigationItem.titleView = self.oldNavigationItem.titleView;
        self.navigationItem.leftBarButtonItem = self.oldNavigationItem.leftBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.oldNavigationItem.rightBarButtonItem;
        self.oldNavigationItem = nil;
        return;
    }
    
    self.navigationItem.titleView = _hearderView;
    self.navigationItem.leftBarButtonItems = @[_cancelButton];
    self.navigationItem.rightBarButtonItems = @[_sendButton];
}

- (void)configureNavItem {
    if (!_oldNavigationItem) {
        self.oldNavigationItem = [[UINavigationItem alloc] init];
        _oldNavigationItem.titleView = self.navigationItem.titleView;
        _oldNavigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems;
        _oldNavigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    }
    
    if (!_hearderView) {
        CGFloat y = UIInterfaceOrientationIsPortrait([[[UIApplication sharedApplication] keyWindow] rootViewController].interfaceOrientation) ? 6.0f : 0.0f;
        self.hearderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, 200.0f, 32.0f)];
        _hearderView.backgroundColor = [UIColor clearColor];
        _hearderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 18.0f)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_hearderView addSubview:_titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 18.0f, 200.0f, 14.0f)];
        _detailLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _detailLabel.textColor = [UIColor whiteColor];
        [_hearderView addSubview:_detailLabel];
    }
    
    if (!_sendButton) {
        self.sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(handleSendButtonTapped:)];
        self.sendButton.enabled = [self shouldEnableSendButton];
    }
    
    if (!_cancelButton) {
        self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelButtonTapped:)];
    }
}

- (void)dismiss {
    if ([_delegate respondsToSelector:@selector(SearchPostViewShouldDismiss:)]) {
        [self.delegate SearchPostViewShouldDismiss:self];
    }
}

- (void)handleSendButtonTapped:(id)sender {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(SearchPostViewWillSend:)]) {
        [self.delegate SearchPostViewWillSend:self];
    }
}

- (void)handleCancelButtonTapped:(id)sender {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(SearchPostViewDidCancel:)]) {
        [self.delegate SearchPostViewDidCancel:self];
    }
}

- (BOOL)shouldEnableSendButton {
    return (([_textView.text length] > 0) || !_requireText);
}

# pragma mark - UITextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _promptLabel.hidden = YES;
    
    _sendButton.enabled = [self shouldEnableSendButton];
    
    if ([_delegate respondsToSelector:@selector(SearchPostViewDidBeginEditting:)]) {
        [_delegate SearchPostViewDidBeginEditting:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    _sendButton.enabled = [self shouldEnableSendButton];
    
    if ([_delegate respondsToSelector:@selector(SearchPostViewDidChange:)]) {
        [_delegate SearchPostViewDidChange:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _promptLabel.hidden = ([_textView.text length] > 0) ? YES : NO;
    
    if ([_delegate respondsToSelector:@selector(SearchPostViewDidEndEditing:)]) {
        [_delegate SearchPostViewDidEndEditing:self];
    }
}

@end
