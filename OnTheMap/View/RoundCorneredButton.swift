//
//  RoundCorneredButton.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-30.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class RoundCorneredButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = frame.height/8
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
