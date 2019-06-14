//
//  HmPhoneNum.m
//  电话按键-Demo
//
//  Created by 侯猛 on 2017/3/14.
//  Copyright © 2017年 Jack. All rights reserved.
//

// @" " or @"-"
#define placeholderSpace @" "

#import "HmPhoneTextField.h"

@interface HmPhoneTextField ()<UITextFieldDelegate>

@end

@implementation HmPhoneTextField

- (NSString *)plainBackCardNum {
    return [self _noneSpaseString:self.text];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *phStr = placeholderSpace;
    unichar phChar = ' ';
    if (phStr.length) phChar = [phStr characterAtIndex:0];
    NSString* text = textField.text;
    //删除
    if ([string isEqualToString:@""]) {
        
        //删除一位
        if (range.length == 1) {
            //最后一位,遇到空格则多删除一次
            if (range.location == text.length - 1) {
                if ([text characterAtIndex:text.length - 1] == phChar) {
                    [textField deleteBackward];
                }
                return YES;
            } else{
                NSInteger offset = range.location;
                if (range.location < text.length && [text characterAtIndex:range.location] == phChar && [textField.selectedTextRange isEmpty]) {
                    [textField deleteBackward];
                    offset --;
                }
                [textField deleteBackward];
                textField.text = [self _parseString:textField.text];
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                return NO;
            }
        } else if (range.length > 1) {
            BOOL isLast = NO;
            //如果是从最后一位开始
            if(range.location + range.length == textField.text.length ){
                isLast = YES;
            }
            [textField deleteBackward];
            textField.text = [self _parseString:textField.text];
            
            NSInteger offset = range.location;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            if (isLast) {
                //光标直接在最后一位了
            } else {
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            }
            
            return NO;
        } else{
            return YES;
        }
    } else if (string.length >0) {
        
        if ((self.plainBackCardNum.length + string.length - range.length > 11)) return NO;
        
        if (![self _isNum:string]) return NO;
        
        [textField insertText:string];
        textField.text = [self _parseString:textField.text];
        
        NSInteger offset = range.location + string.length;
        if (range.location == 3 || range.location  == 8) {
            offset ++;
        }
        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        return NO;
    } else {
        return YES;
    }
    return YES;
}

- (NSString*)_parseString:(NSString*)string {
    
    if (!string) return nil;
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:placeholderSpace withString:@""]];
    if (mStr.length > 3) {
        [mStr insertString:placeholderSpace atIndex:3];
    }
    if (mStr.length > 8) {
        [mStr insertString:placeholderSpace atIndex:8];
        
    }
    
    return  mStr;
    
}

/** 获取正常电话号码（去掉空格） */
- (NSString*)_noneSpaseString:(NSString*)string {
    
    return [string stringByReplacingOccurrencesOfString:placeholderSpace withString:@""];
    
}

- (BOOL)_isNum:(NSString *)checkedNumString {
    
    if (!checkedNumString) return NO;
    
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if (checkedNumString.length > 0) return NO;
    
    return YES;
    
}


@end
