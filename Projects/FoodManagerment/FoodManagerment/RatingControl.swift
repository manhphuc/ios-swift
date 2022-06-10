//
//  RatingControl.swift
//  FoodManagerment
//
//  Created by CNTT on 4/15/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    @IBInspectable private var ratingValue:Int = 0{
        didSet {
            updateButtonState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    @IBInspectable private var starCount:Int = 5 {
        didSet {
            initialization()
        }
    }
    @IBInspectable private var starSize:CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet{
            initialization()
        }
    }
    
    //MARK: Contructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    //MARK : initialization of rating control
    private func initialization() {
        //Clear the old buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        //Load the star image
        let bundle = Bundle(for: type(of: self))
        let normalStar = UIImage(named: "normalStar", in: bundle, compatibleWith: self.traitCollection)
        let pressedStar = UIImage(named: "pressedStar", in: bundle, compatibleWith: self.traitCollection)
        let selectedStar = UIImage(named: "selectedStar", in: bundle, compatibleWith: self.traitCollection)
        //Creation of rating buttons
        for _ in 0..<starCount{
            let btnRating = UIButton()
            //Settup properties for the rating buttons
            //btnRating.backgroundColor = UIColor.darkGray
            
            //Set star Images
            btnRating.setImage(normalStar, for: .normal)
            btnRating.setImage(pressedStar, for: .highlighted)
            btnRating.setImage(selectedStar, for: .selected)
            
            btnRating.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            btnRating.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            //Event Processing
            btnRating.addTarget(self, action: #selector(ratingButtonPressed(button:)), for: .touchUpInside)
            //Add the created button to the StackView
            addArrangedSubview(btnRating)
            //Add the button to array of button
            //ratingButtons += [btnRating]
            ratingButtons.append(btnRating)
        }
        //Update button state
        updateButtonState()
    }
    //MARK: ratingbutton 's Action
    @objc private func ratingButtonPressed(button:UIButton) {
        //print("Called")
        if let index = ratingButtons.firstIndex(of: button){
            if index  + 1  == ratingValue {
                ratingValue -= 1
            }
            else {
                ratingValue = index + 1
            }
        }
        //Update button state
        updateButtonState()
        //print("vi tri la : \(index!)")
    }
    private func updateButtonState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < ratingValue
        }
    }
    func getratingValue() -> Int {
        return ratingValue
    }
    func setratingValue(ratingValue: Int) {
        self.ratingValue = ratingValue
    }
}
