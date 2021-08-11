//
//  ViewController.swift
//  ScrollViewController
//
//  Created by Windy on 06/08/21.
//

import UIKit

class ViewController: UIViewController {

    private var containerView: ContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView = ContainerView(frame: view.bounds)
        view.addSubview(containerView)
        
        let imageView = UIImageView()
        imageView.backgroundColor = .red

        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .largeTitle)
        title.font = .boldSystemFont(ofSize: 34)
        title.numberOfLines = 0
        title.text = "This is title"
        
        let subtitle = UILabel()
        subtitle.text = "Created on 12/12/12"
        subtitle.font = .preferredFont(forTextStyle: .subheadline)

        let description = UILabel()
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eu tincidunt tortor aliquam nulla facilisi. A iaculis at erat pellentesque. Nullam vehicula ipsum a arcu cursus. Lobortis scelerisque fermentum dui faucibus in ornare quam viverra. Accumsan lacus vel facilisis volutpat est velit egestas dui id. Mauris in aliquam sem fringilla ut. Ultrices tincidunt arcu non sodales neque sodales ut etiam sit. Lacus vestibulum sed arcu non odio euismod lacinia. Nascetur ridiculus mus mauris vitae. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eu tincidunt tortor aliquam nulla facilisi. A iaculis at erat pellentesque. Nullam vehicula ipsum a arcu cursus. Lobortis scelerisque fermentum dui faucibus in ornare quam viverra. Accumsan lacus vel facilisis volutpat est velit egestas dui id. Mauris in aliquam sem fringilla ut. Ultrices tincidunt arcu non sodales neque sodales ut etiam sit. Lacus vestibulum sed arcu non odio euismod lacinia. Nascetur ridiculus mus mauris vitae"
        description.numberOfLines = 0

        containerView.addSubviews([
            (title, [.horizontal(16), .top(16), .bottom(8)]),
            (imageView, [.horizontal(0), .top(16)]),
            (subtitle, [.horizontal(16), .top(8)]),
            (description, [.horizontal(16), .top(16), .bottom(16)]),
        ])

        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }

}

enum ContainerMarginType {
    
    case top(CGFloat = 0)
    case bottom(CGFloat = 0)
    case horizontal(CGFloat = 0)
    
    var value: CGFloat {
        switch self {
        case .top(let value):
            return value
        case .bottom(let value):
            return value
        case .horizontal(let value):
            return value
        }
    }
    
    var sequenceValue: Int {
        switch self {
        case .top:
            return 0
        case .horizontal:
            return 1
        case .bottom:
            return 2
        }
    }
    
}

class ContainerView: UIView {
    
    private var scrollView: UIScrollView!
    private var mainStack: UIStackView!
    
    func addSubviews(
        _ views: [(
            view: UIView,
            margins: [ContainerMarginType]
        )]
    ) {
        views.forEach({ child in
            
            let view = child.view
            let margins = child.margins.sorted(by: { $0.sequenceValue < $1.sequenceValue })
            
            guard !margins.isEmpty else {
                mainStack.addArrangedSubview(view)
                return
            }
                        
            margins.forEach { margin in
                switch margin {
                case .top(let value):
                    let topMargin = SpacingEmptyView(sizeHeight: value)
                    mainStack.addArrangedSubview(topMargin)
                case .horizontal(let value):
                    
                    if value != 0 {
                        
                        let leftView = UIView()
                        let rightView = UIView()
                        let hStack = UIStackView(arrangedSubviews: [leftView, view, rightView])
                        
                        mainStack.addArrangedSubview(hStack)
                        
                        leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                        NSLayoutConstraint.activate([
                            leftView.widthAnchor.constraint(equalToConstant: value),
                            rightView.widthAnchor.constraint(equalToConstant: value)
                        ])
                        
                    } else {
                        mainStack.addArrangedSubview(view)
                    }
                case .bottom(let value):
                    let bottomMargin = SpacingEmptyView(sizeHeight: value)
                    mainStack.addArrangedSubview(bottomMargin)
                }
            }
            
            
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollViewStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollViewStack() {
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        scrollView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
}

class SpacingEmptyView: UIView {
    
    convenience init(sizeHeight: CGFloat) {
        self.init()
        heightAnchor.constraint(equalToConstant: sizeHeight).isActive = true
    }
    
}

// MARK: AutoLayout
extension UIView {
    
    enum Constraint {
        case top(NSLayoutYAxisAnchor, CGFloat = 0)
        case bottom(NSLayoutYAxisAnchor, CGFloat = 0)
        case leading(NSLayoutXAxisAnchor, CGFloat = 0)
        case trailing(NSLayoutXAxisAnchor, CGFloat = 0)
        case centerX(NSLayoutXAxisAnchor, CGFloat = 0)
        case centerY(NSLayoutYAxisAnchor, CGFloat = 0)
        case centerOf(UIView)
        case width(CGFloat = 0)
        case equalWidthTo(NSLayoutDimension)
        case height(CGFloat = 0)
        case equalHeightTo(NSLayoutDimension)
        case equalTo(UIView, CGFloat = 0)
        case horizontal(UIView, CGFloat = 0)
        case vertical(UIView, CGFloat = 0)
    }
    
    func configureConstraints(constraints: [Constraint]) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.forEach { constraint in
            switch constraint {
            case .top(let anchor, let constant):
                self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .bottom(let anchor, let constant):
                self.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .leading(let anchor, let constant):
                self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .trailing(let anchor, let constant):
                self.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .centerX(let anchor, let constant):
                self.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .centerY(let anchor, let constant):
                self.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
            case .width(let constant):
                self.widthAnchor.constraint(equalToConstant: constant).isActive = true
            case .height(let constant):
                self.heightAnchor.constraint(equalToConstant: constant).isActive = true
            case .centerOf(let parent):
                self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
                self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            case .equalTo(let parent, let constant):
                self.topAnchor.constraint(equalTo: parent.topAnchor, constant: constant).isActive = true
                self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -constant).isActive = true
                self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: constant).isActive = true
                self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -constant).isActive = true
            case .horizontal(let view, let constant):
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
            case .vertical(let view, let constant):
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
            case .equalWidthTo(let anchor):
                self.widthAnchor.constraint(equalTo: anchor).isActive = true
            case .equalHeightTo(let anchor):
                self.heightAnchor.constraint(equalTo: anchor).isActive = true
            }
        }
    }
    
}
