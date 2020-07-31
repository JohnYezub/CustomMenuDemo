//
//  CustomSegmentControl.swift
//  CustomSegmentControlDemo
//
//  Created by   admin on 31.07.2020.
//  Copyright © 2020 Evgeny Ezub. All rights reserved.
//

import UIKit
import SnapKit

protocol ASTabIndicatorViewDelegate: class {
  func itemSelected(at index: Int)
}

final class ASTabIndicatorView: UIView {

  // MARK: Init and deinit
  init(_ items: [String]) {
    super.init(frame: .zero)
    configure(with: items)

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Properties
  weak var delegate: ASTabIndicatorViewDelegate?
  private var items = [String]()
  private var itemLabels = [UILabel]()
  private var selectedItemIndex = 0 {
    didSet {
      selectedItem(at: selectedItemIndex)
    }
  }
  
  // MARK: UI
  private let contentStackView = UIStackView()
  private let tabSelectionMarkerView = UIView()

  // MARK: Functions
  private func configure(with items: [String]) {
    self.items = items
    itemLabels = items.enumerated().map { idx, item in
      let label = UILabel()
      label.text = item
      label.font = UIFont.systemFont(ofSize: 12)
      label.textColor = .white
      label.textAlignment = .center
      label.backgroundColor = .clear
      label.isUserInteractionEnabled = true
      label.tag = idx

      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemLabelTap))
      label.addGestureRecognizer(tapGesture)

      return label
    }

    configureStackView()
    setupSelectionView()
    backgroundColor = UIColor.darkGray
    selectedItemIndex = 0
  }

  private func configureStackView() {
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    contentStackView.axis = .horizontal
    contentStackView.distribution = .fillEqually
    itemLabels.forEach { contentStackView.addArrangedSubview($0) }
  }

  private func setupSelectionView() {
    addSubview(tabSelectionMarkerView)
    tabSelectionMarkerView.snp.makeConstraints { (make) in
      make.edges.equalTo(itemLabels.first!.snp.edges)
    }
    sendSubviewToBack(tabSelectionMarkerView)
    tabSelectionMarkerView.layer.backgroundColor = UIColor(hexString: "189e02").cgColor
    tabSelectionMarkerView.layer.setAffineTransform(shearTransform(CGAffineTransform(scaleX: 1.1, y: 1), x: 0.5, y: 0))
  }

  private func shearTransform(_ transform: CGAffineTransform, x: CGFloat, y: CGFloat) -> CGAffineTransform {
    var transform = transform
    transform.c = -x
    transform.b = y
    return transform
  }

   @objc private func itemLabelTap(_ tapGesture: UITapGestureRecognizer) {
    if let view = tapGesture.view {
      selectedItemIndex = view.tag
      delegate?.itemSelected(at: selectedItemIndex)
    }
  }

  private func selectedItem(at index: Int) {
    itemLabels.forEach(resetFontOnLabel)
    let targetLabel = itemLabels[index]
    targetLabel.font = UIFont.boldSystemFont(ofSize: 12)
    UIView.animate(withDuration: 0.2) {
      self.tabSelectionMarkerView.center = targetLabel.center
    }
  }

  private func resetFontOnLabel(_ label: UILabel) {
    label.font = UIFont.systemFont(ofSize: 12)
  }

  public func setItemSelected(_ index: Int) {
    guard items.count >= index else {
      return
    }
    selectedItemIndex = index
  }
}
