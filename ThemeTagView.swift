//
//  ThemeTagView.swift
//  Populaw
//
//  Created by Gaurang on 16/09/21.
//

import UIKit

class ThemeTagView: UIView {

    var tagsArray:[String] = Array()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    func createTagCloud(withArray data:[AnyObject]) {

        for tempView in self.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        let icon = AppImages.crossCircle.image //23.0
        let iconWidth = icon.size.width
        var xPos:CGFloat = 0
        var ypos: CGFloat = 0
        let buttonWidth: CGFloat = 25.5
        let spacer: CGFloat = 13.0
        let leftPadding: CGFloat = 7
        var tag: Int = 1
        var contentHeight: CGFloat = 0
        for str in data  {
            let startstring = str as! String
            let width = startstring.widthOfString(usingFont: FontBook.extraLight.font(ofSize: 12))
            let checkWholeWidth = CGFloat(xPos) + CGFloat(width) + spacer + buttonWidth
            //13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
            if checkWholeWidth > self.bounds.size.width - 30.0 {
                //we are exceeding size need to change xpos
                xPos = 0
                ypos = ypos + 29.0 + 9.0
            }

            let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width: width + leftPadding + (buttonWidth + leftPadding) , height: 31))
            bgView.layer.cornerRadius = 5
            bgView.backgroundColor = .white
            bgView.layer.borderWidth = 1
            bgView.layer.borderColor = UIColor.themePrimary.cgColor
            bgView.tag = tag

            let textlable = UILabel(frame: CGRect(x: leftPadding, y: 0.0, width: width, height: bgView.frame.size.height))
            textlable.font = FontBook.extraLight.font(ofSize: 12)
            textlable.text = startstring
            textlable.textColor = UIColor.black
            bgView.addSubview(textlable)

            let button = UIButton(type: .custom)
            button.frame = CGRect(x: bgView.frame.size.width - leftPadding - iconWidth, y: 0, width: iconWidth, height: bgView.frame.height)
            button.backgroundColor = UIColor.white
            button.setImage(icon, for: .normal)
            button.tag = tag
            button.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)
            bgView.addSubview(button)
            xPos = CGFloat(xPos) + bgView.frame.width + 9
            self.addSubview(bgView)
            tag = tag  + 1
            contentHeight = bgView.frame.height + bgView.frame.origin.y
        }

        updateConstraint(attribute: .height, constant: contentHeight)
    }

    @objc func removeTag(_ sender: AnyObject) {
        tagsArray.remove(at: (sender.tag - 1))
        createTagCloud(withArray: tagsArray as [AnyObject])
    }

    func addTag(_ text: String) {
        if text.count != 0 {
            tagsArray.append(text)
            createTagCloud(withArray: tagsArray as [AnyObject])
        }
    }

}
