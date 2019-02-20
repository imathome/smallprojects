//
//  NSMenu.h
//  demotable
//
//  Created by Samuel Colak on 19/02/2019.
//  Copyright © 2019 Im-At-Home BV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMenuCell : UITableViewCell {
	
	UILabel				*_menuLabel;
	
}
	
	@property (nonatomic, retain, getter=getText, setter=setText:) NSString *text;
	@property (nonatomic, assign, getter=getIndent, setter=setIndent:) NSUInteger indent;

@end


@interface NSMenu : UITableView {
	
}
	
	@property (readonly, getter=getMenuItems) NSArray *menuItems;
	@property (readonly, getter=getSelectedIndex) NSUInteger selectedIndex;
	
	@property (nonatomic, strong) id target;
	@property (nonatomic, unsafe_unretained) SEL eventSelector;

	- (void) setupMenuWithOptions:(NSArray*)options withTarget:(id)target andCallback:(SEL)selector;
	
@end

NS_ASSUME_NONNULL_END
