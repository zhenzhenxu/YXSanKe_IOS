//
//  CollectionViewEqualSpaceFlowLayout.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CollectionViewEqualSpaceFlowLayout.h"

@implementation CollectionViewEqualSpaceFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 0; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = nil;
        if (i > 0) {
            prevLayoutAttributes = answer[i - 1];
        }
        if (currentLayoutAttributes.representedElementCategory != UICollectionElementCategoryCell ||
            prevLayoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if (currentLayoutAttributes.indexPath.section != prevLayoutAttributes.indexPath.section) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            currentLayoutAttributes.frame = frame;
            continue;
        }
        NSInteger maximumSpacing = self.minimumInteritemSpacing;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        CGRect frame = currentLayoutAttributes.frame;
        if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width + self.sectionInset.right < self.collectionViewContentSize.width) {
            frame.origin.x = origin + maximumSpacing;
        } else {
            frame.origin.x = self.sectionInset.left;
        }
        currentLayoutAttributes.frame = frame;
    }
    return answer;
}
@end
