//
//  NavigationBarDelegate.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

private extension Constants.Digits {
    static let maxHorizontalAlignmentCount = 2
    static let horizontalInsideItemsSpacing: CGFloat = 22
    static let verticalInsideItemsSpacing: CGFloat = 41
}

extension Constants.Colors {
    static let gradient = [
        UIColor.tertiarySystemBackground.withAlphaComponent(.zero),
        UIColor.tertiarySystemBackground.withAlphaComponent(0.6),
        UIColor.tertiarySystemBackground.withAlphaComponent(0.9),
        UIColor.tertiarySystemBackground.withAlphaComponent(0.95),
        UIColor.tertiarySystemBackground.withAlphaComponent(0.95),
        UIColor.tertiarySystemBackground.withAlphaComponent(0.95),
        .tertiarySystemBackground
    ]
}

class AlertView: UIView, OnControllerPresentable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var textHeaderGradientView: GradientView!
    @IBOutlet weak var textFooterGradientView: GradientView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionsStackView: UIStackView!
    
    private(set) var title: String = .empty
    private(set) var content: String = .empty
    
    private var actions: [AlertViewAction] = []
    
    private var isLandscapeMode: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    public func loadNib() -> UIView {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: type(of: self).description().components(separatedBy: ".").last!, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    fileprivate func setupNib() {
        let view = self.loadNib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics:nil, views: bindings))
    }
    
    convenience init(withTitle title: String, andContent content: String) {
        let screenBounds = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.bounds ?? .zero
        
        self.init(frame: screenBounds)
        
        self.title = title
        self.content = content
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constructAndFillElements()
        updateItemsAccording(toLandscapeModeIsNow: isLandscapeMode)
    }
    
    @objc private func rotated() {
        updateItemsAccording(toLandscapeModeIsNow: isLandscapeMode)
    }
    
    @objc private func actionSelected(_ sender: UILabel) {
        let index = sender.tag
        guard actions.indices.contains(index) else {
            return
        }
        
        let actionCompletion = actions[index].completion
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.alpha = .zero
        },
                       completion: { [actionCompletion] _ in
                        self.removeFromSuperview()
                        actionCompletion?()
        })
    }
}

private extension AlertView {
    var stackViewSpacing: CGFloat {
        return Constants.Digits.horizontalInsideItemsSpacing
    }
    
    func constructAndFillElements() {
        titleLabel.text = title
        
        updateTextViewData()
        updateStackViewContent()
    }
    
    func updateStackViewContent() {
        guard actions.count != 0 else {
            return
        }
        
        let item = actions[.zero]
        let itemHeight = item.style.font.pointSize
        let isHorizontalAlignment = actions.count <= Constants.Digits.maxHorizontalAlignmentCount
        
        actionsStackView.spacing = stackViewSpacing
        actionsStackView.axis = isHorizontalAlignment ? .horizontal : .vertical
        
        actionsStackView.alignment = .fill
        actionsStackView.distribution = .fill
        
        actionsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            actionsStackView.removeArrangedSubview($0)
        }
        
        if isHorizontalAlignment && actions.count != 1 {
            let dummyItem = UIButton() // for adding space on the right side
            dummyItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
            actionsStackView.addArrangedSubview(dummyItem)
        }
        
        actions.enumerated().map {
            $0.element.toButton(withTag: $0.offset)
        }.forEach {
            $0.addTarget(self, action: #selector(actionSelected), for: .touchUpInside)
            $0.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
            
            actionsStackView.addArrangedSubview($0)
        }
        
        stackViewHeightConstraint.constant = CGFloat(actions.count) * itemHeight + stackViewSpacing * CGFloat(actions.count - 1)
        actionsStackView.layoutIfNeeded()
    }
    
    func updateTextViewData() {
        contentTextView.text = content
        
        contentTextView.textContainerInset = .zero
        contentTextView.contentInset = .zero
        contentTextView.textContainer.lineFragmentPadding = .zero
        
        contentTextView.clipsToBounds = false
    }
    
    func updateItemsAccording(toLandscapeModeIsNow flag: Bool) {
        contentTextView.isScrollEnabled = false // it forces recalculation of content
        contentTextView.isScrollEnabled = true
        
        textViewHeightConstraint.constant = contentTextView.contentSize.height
        
        textHeaderGradientView.gradienColors = Constants.Colors.gradient.reversed()
        textFooterGradientView.gradienColors = Constants.Colors.gradient
    }
}

extension AlertView {
    func set(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    func add(_ action: AlertViewAction) {
        actions.append(action)
    }
}
