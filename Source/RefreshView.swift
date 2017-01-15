//
//  RefreshView.swift
//  Refresh
//
//  Created by lieon on 2017/1/15.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit


class RefreshView: UIView {

    @IBOutlet weak var pullArrow: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var loadingView: UIImageView!
    var state: RefrehState = .normal {
        didSet {
            switch state {
            case .normal:
                textLabel.text = "继续使劲拉"
                pullArrow.isHidden = false
                loadingView.isHidden = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullArrow.transform = CGAffineTransform.identity
                })
            case .pulling:
                textLabel.text = "放手就刷新"
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullArrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.0001))
                })
            case .wilRefresh:
                textLabel.text = "正在刷新中..."
                loadingView.isHidden = false
                pullArrow.isHidden = true
            }
        }
    }
    
    class func refreView() -> RefreshView {
        let nib = UINib(nibName: "RefreshView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil)[0] as? RefreshView else { return RefreshView() }
        return view
    }


}
