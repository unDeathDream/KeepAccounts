//
//  AccountCell.swift
//  KeepAccounts
//
//  Created by admin on 16/3/10.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
typealias presentVCResponder = (UIViewController, Bool, (()->Void)?)->Void
class AccountCell: UITableViewCell {

    @IBOutlet weak var dayCost: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var iconTitle: UILabel!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var botmLine: UIView!
    @IBOutlet weak var dayIndicator: UIImageView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    private var isHiddenSubview = false
    
    var cellID:Int?
    var presentVCBlock:presentVCResponder?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func clickIcon(sender: AnyObject) {
        showSubView(!isHiddenSubview)
        showBtns(isHiddenSubview)
        isHiddenSubview = !isHiddenSubview
        UIView.animateWithDuration(0.3, animations: {() in
            self.showSubView(!self.isHiddenSubview)
            self.showBtns(self.isHiddenSubview)
        })
    }
    
    @IBAction func clickEditBtn(sender: AnyObject) {
        let model = ChooseItemModel()
        let item = AccoutDB.selectDataWithID(cellID ?? 0)
        model.mode = "edit"
        model.dataBaseId = item.ID
        model.costBarMoney = item.money
        model.costBarTitle = item.iconTitle
        model.costBarIconName = item.iconName
        model.costBarTime = NSTimeInterval(item.date)
        model.topBarRemark = item.remark
        model.topBarPhotoName = item.photo
        
        let editChooseItemVC = ChooseItemVC(model: model)
        if let block = presentVCBlock{
            block(editChooseItemVC, true, nil)
        }
    }
    @IBAction func clickDeleteBtn(sender: AnyObject) {
        let alertView = UIAlertController(title: "删除账目", message: "您确定要删除吗？", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "确定", style: .Default){(action) in
            if let ID = self.cellID{
                AccoutDB.deleteDataWith(ID)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeDataSource", object: self)
        })
        if let block = presentVCBlock{
            block(alertView, true, nil)
        }
    }
    private func showSubView(bool:Bool){
        let alpha:CGFloat = bool ? 1 : 0
        photoView.alpha = alpha
        iconTitle.alpha = alpha
        itemCost.alpha = alpha
        remark.alpha = alpha
        deleteBtn.center = bool ? self.icon.center : CGPointMake(60, self.icon.center.y)
        editBtn.center = bool ? self.icon.center : CGPointMake(self.frame.width - 60, self.icon.center.y)
    }
    private func showBtns(bool:Bool){
        let alpha:CGFloat = bool ? 1 : 0
        deleteBtn.alpha = alpha
        editBtn.alpha = alpha
        deleteBtn.center = bool ? CGPointMake(60, self.icon.center.y) : self.icon.center
        editBtn.center = bool ? CGPointMake(self.frame.width - 60, self.icon.center.y) :self.icon.center
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        dayCost.text = ""
        date.text = ""
        photoView.image = nil
        itemCost.text = ""
        iconTitle.text = ""
        remark.text = ""
        botmLine.hidden = false
        topLine.hidden = false
        dayIndicator.hidden = true
        icon.setImage(nil, forState: .Normal)
        showSubView(true)
        showBtns(false)
        isHiddenSubview = false
    }
}

extension AccountCell{
    func configAccountCell(){
        
    }
}
