//
//  LRefreshControl.swift
//  Refresh
//
//  Created by lieon on 2017/1/15.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

private let contentOffsetY: CGFloat = 50.0

public class LRefreshControl: UIView {
    public var refreshHandler: ( (Void) -> (Void))?
    fileprivate weak var scrollView: UIScrollView?
    fileprivate lazy var refreshView: RefreshView = RefreshView.refreView()
    fileprivate lazy var shineView: ShineView = {
        let shineView = ShineView()
        return shineView
    }()

    fileprivate var state: RefrehState = .normal {
        didSet {
            shineView.state = state
            refreshView.state = state
        }
    }
    
    public init() {
        super.init(frame: CGRect())
        addNormamRefesh()
        addShineView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addNormamRefesh()
        addShineView()
    }
    
    public func beginRefresh() {
        guard let sv = scrollView else { return  }
        state = .wilRefresh
        var inset = sv.contentInset
        inset.top += contentOffsetY
        sv.contentInset = inset
        refreshHandler?()
    }
    
   public func endRefreshing() {
        if state != .wilRefresh {
            return
        }
        guard let sv = scrollView else { return  }
        state = .normal
        var inset = sv.contentInset
        inset.top -= contentOffsetY
        sv.contentInset = inset
    }
    
    public func needToShine(text: String) {
        shineView.isHidden = false
        refreshView.isHidden = true
        shineView.text = text
    }
}

extension LRefreshControl {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else { return  }
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else { return  }
        let height = -(sv.contentInset.top + sv.contentOffset.y )
        if height < 0 {
            return
        }
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        if sv.isDragging {
            if height > contentOffsetY && state == .normal {
                state = .pulling
            } else if height <= contentOffsetY && state == .pulling {
                state = .normal
            }
        } else {
            if state == .pulling  {
                beginRefresh()
                
            }
        }
    }
    
    override public func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
}
extension LRefreshControl {
    fileprivate  func addNormamRefesh() {
        backgroundColor = superview?.backgroundColor
        addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
    
    fileprivate func addShineView() {
        backgroundColor = superview?.backgroundColor
        addSubview(shineView)
        shineView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: shineView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: shineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: shineView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: UIScreen.main.bounds.width))
        shineView.isHidden = true
    }
}
