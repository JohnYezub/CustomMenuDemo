//
//  CustomSegmentControl.swift
//  CustomSegmentControlDemo
//
//  Created by   admin on 31.07.2020.
//  Copyright © 2020 Evgeny Ezub. All rights reserved.
//

import UIKit
import SnapKit

protocol CustomSegmentControlDelegate: class {
    func itemSelected(at index: Int)
}

final class CustomSegmentControl: UIView {
    
     ///set index in init to display selected button. If index wrong, all buttons will be deselected
    init(withSelected itemIndex: Int) {
        super.init(frame: .zero)
        self.selectedItemIndex = itemIndex
        configure()
        setupSelectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak private var delegate: CustomSegmentControlDelegate?
    
    /// property to notify if the value was changed (i.e. index). Check it in ViewController.
    var passIndex: ((Int)->Void)?
    
    ///buttons names
    private let names = ["First", "Second", "Third", "Fourth"]
    
    private var itemButtons: [UIButton] = []
    
    ///observer fot selection
     var selectedItemIndex: Int! {
        didSet {
            print("didSet selectedItemIndex")
            selectedItem(at: selectedItemIndex)
            passIndex?(selectedItemIndex)
            
        }
    }
    // MARK: UI
    private let contentStackView = UIStackView()
 
    
    // MARK: - Setup the View and buttons
    
    private func configure() {
        backgroundColor = UIColor.lightGray
        
        itemButtons = names.enumerated().map { index, item in
            
            let button = UIButton()
            button.snp.makeConstraints { (make) in
                make.width.equalTo(60)
                make.height.equalTo(40)
            }
            
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
            button.setTitle(item, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.lightGray, for: .highlighted)
            button.backgroundColor = .cyan
            
            ///set the view to de-selected for all buttons on setup
            button.tag = index
            button.isUserInteractionEnabled = true
            
            button.addTarget(self, action: #selector(btnClicked(_:)), for: .touchDown)
            
            return button
            
        }
        setupStackView()
    }

    //MARK: - Setup StackView
    
    private func setupStackView() {
        ///add the appearence  of StackView
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        ///configure StackView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 20
        
        ///add all buttons to Stack View
        itemButtons.forEach { contentStackView.addArrangedSubview($0) }
    }
    
//MARK: - Initial item setup
    
    /// set the button to be selected on initial load
    private func setupSelectionView() {
        guard names.count >= selectedItemIndex else {
            print("Index setup error")
            return
        }
        //we set Green color only if selectedItemIndex < items.count
        itemButtons[selectedItemIndex].backgroundColor = .green
        
        print(#function)
    }
    
    ///once the button is clicked the selectedItemIndex will update with button tag
    @objc private func btnClicked (_ sender:UIButton) {
        selectedItemIndex = sender.tag
        delegate?.itemSelected(at: selectedItemIndex)
        print("Button index: \(sender.tag)")
    }
    
    /// select item and reset appearence for other buttons
    private func selectedItem(at index: Int) {
        itemButtons.forEach(resetButtonView)
        let targetButton = itemButtons[index]
    //    UIView.animate(withDuration: 0.2) {
            targetButton.backgroundColor = .green
        print(#function)
        
    //    }
    }
    
    /// set default color for the  sender button
    private func resetButtonView(_ button: UIButton) {
        button.backgroundColor = .cyan
    }
    
}

