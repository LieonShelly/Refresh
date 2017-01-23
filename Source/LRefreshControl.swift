//
//  LRefreshControl.swift
//  Refresh
//
//  Created by lieon on 2017/1/15.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

private let contentOffsetY: CGFloat = 50.0
enum RefrehState {
    case normal
    case pulling
    case wilRefresh
}

public class LRefreshControl: UIView {
    public var refreshHandler: ( (Void) -> (Void))?
    fileprivate weak var scrollView: UIScrollView?
    fileprivate lazy var refreshView: RefreshView = RefreshView.refreView()
    
    public init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public func beginRefresh() {
        guard let sv = scrollView else { return  }
        refreshView.state = .wilRefresh
        var inset = sv.contentInset
        inset.top += contentOffsetY
        sv.contentInset = inset
        refreshHandler?()
    }
    
   public func endRefreshing() {
        if refreshView.state != .wilRefresh {
            return
        }
        guard let sv = scrollView else { return  }
        refreshView.state = .normal
        var inset = sv.contentInset
        inset.top -= contentOffsetY
        sv.contentInset = inset
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
            if height > contentOffsetY && refreshView.state == .normal {
                refreshView.state = .pulling
            } else if height <= contentOffsetY && refreshView.state == .pulling {
                refreshView.state = .normal
            }
        } else {
            if refreshView.state == .pulling  {
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
    fileprivate  func setupUI() {
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
}
