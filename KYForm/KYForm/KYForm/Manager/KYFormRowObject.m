//
//  KYFormRowObject.m
//  KYForm
//
//  Created by mac on 2017/12/19.
//

#import "KYFormRowObject.h"
#import "KYFormViewController.h"

@implementation KYFormRowObject

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rowType:(NSString *)rowType {
    if (self = [self init]) {
        self.title = title;
        self.rowType = rowType;
        self.cellStyle = UITableViewCellStyleValue1;
    }
    
    return self;
}

+ (instancetype)formRowWithTitle:(NSString *)title {
    return [[self class] formRowWithTitle:title rowType:nil];
}

+ (instancetype)formRowWithTitle:(NSString *)title rowType:(NSString *)rowType {
    return [[[self class] alloc] initWithTitle:title rowType:rowType];
}

- (KYFormBaseCell *)cellForFormController:(KYFormViewController *)formController {
    if (!_baseCell) {
        id cellClass = self.cellClass ?: [KYFormViewController cellClassesForRowTypes][self.rowType];
        if ([cellClass isKindOfClass:[NSString class]]) {
            
        } else {
            _baseCell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        }
    }
    
    return _baseCell;
}

@end
