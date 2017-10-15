//
//  LETextField.m
//  LemonLive
//
//  Created by chenzy on 2017/4/28.
//  Copyright © 2017年 Qingning Science & Technology Development Co.,Ltd. All rights reserved.
//

#import "LETextField.h"
#import "FJCourseClassifyDefine.h"

@implementation LETextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.leftViewOffset = 10;
        self.tintColor = kFJSegmentedTitleSelectedColor;
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = kFJSegmentedTitleNormalColor;
        self.font = kFJSegmentedTitleFontSize;
        
        
        [self setValue:kFJSegmentedTitleHighlightColor
                        forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:kFJSegmentedTitleFontSize
                        forKeyPath:@"_placeholderLabel.font"];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        searchImageView.image = [UIImage imageNamed:@"icon_search.png"];
        self.leftView = searchImageView;
        self.leftViewMode = UITextFieldViewModeAlways;//一直出现
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号编辑时出现时候显示
        self.returnKeyType = UIReturnKeySearch;//标有Search的蓝色按钮
        
        self.layer.cornerRadius = 15.0f;
        self.layer.borderWidth = 0;;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return self;
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect clearButtonRect = [super clearButtonRectForBounds:bounds];
    clearButtonRect.origin.x -= 3;
    return clearButtonRect;
}
//leftView偏移量
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += self.leftViewOffset;
    return iconRect;
}

//  重写占位符的x值
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x += 1;
    return placeholderRect;
}

//  重写文字输入时的X值
- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 7;
    return editingRect;
}

//  重写文字显示时的X值
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 7;
    return textRect;
}

//rightView偏移量
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

@end
