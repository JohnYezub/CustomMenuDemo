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
    
        
    init(withSelected itemIndex: Int) {
        super.init(frame: .zero)
        self.selectedItemIndex = itemIndex
        configure()
        setupSelectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: CustomSegmentControlDelegate?
    
    var passIndex: ((Int)->Void)?
    private let items = ["First", "Second", "Third", "Fourth"]
    private var itemButtons: [UIButton] = []
    private var selectedItemIndex: Int! {
        didSet {
            selectedItem(at: selectedItemIndex)
            passIndex?(selectedItemIndex)
        }
    }
    // MARK: UI
    private let contentStackView = UIStackView()
    private let tabSelectionMarkerView = UIView()
    
    private func configure() {
        backgroundColor = UIColor.lightGray
        
        itemButtons = items.enumerated().map { index, item in
            
            let button = UIButton()
            button.snp.makeConstraints { (make) in
                make.width.equalTo(40)
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
            
            button.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
            
            return button
            
        }
        
        configureStackView()
        
    }
    
    private func configureStackView() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 20
        
        itemButtons.forEach { contentStackView.addArrangedSubview($0) }
    }
//MARK: - Initial item setup
    
    /// set the button to be selected on initial load
    private func setupSelectionView() {
        guard items.count >= selectedItemIndex else {
            print("Index setup error")
            return
        }
        itemButtons[selectedItemIndex].backgroundColor = .green
    }
    
    @objc func btnClicked (_ sender:UIButton) {
        selectedItemIndex = sender.tag
        delegate?.itemSelected(at: selectedItemIndex)
        print(sender.tag)
    }
    
    private func selectedItem(at index: Int) {
        itemButtons.forEach(resetButtonView)
        let targetButton = itemButtons[index]
        UIView.animate(withDuration: 0.2) {
            targetButton.backgroundColor = .green
        }
    }
    
    private func resetButtonView(_ button: UIButton) {
        button.backgroundColor = .cyan
    }
    
}

