//
//  ViewController.swift
//  retoMasterMind
//
//  Created by Frida Gutiérrez Mireles on 27/02/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet var colorButtons: [UIButton]! //array of buttons
    @IBOutlet weak var btIniciar: UIButton!
    @IBOutlet weak var btProbar: UIButton!
    @IBOutlet var colorViews: [UIView]! //array of views

    
    let colorArray = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.cyan, UIColor.orange, UIColor.magenta] //array of colors
    var indexesColors = [0,1,2,3,4,5] //array of numbers
    
    func randomBegin(){ //shuffle initial colors of views
        indexesColors.shuffle()
        colorViews[0].backgroundColor = colorArray[indexesColors[0]]
        colorViews[1].backgroundColor = colorArray[indexesColors[1]]
        colorViews[2].backgroundColor = colorArray[indexesColors[2]]
        colorViews[3].backgroundColor = colorArray[indexesColors[3]]
        
        colorButtons[0].backgroundColor = colorArray[indexesColors[4]]
        colorButtons[1].backgroundColor = colorArray[indexesColors[5]]
        colorButtons[2].backgroundColor = colorArray[indexesColors[0]]
        colorButtons[3].backgroundColor = colorArray[indexesColors[1]]
    }
    
    func showAlert(){ //warning when two colors duplicate
           let alert = UIAlertController(title: "Error", message: "No se puede jugar con dos colores del mismo color", preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
    }
    
    func checkDuplicateColors() -> Bool { //check if two buttons duplicate colors
        return colorButtons[0].backgroundColor == colorButtons[1].backgroundColor || colorButtons[0].backgroundColor == colorButtons[2].backgroundColor || colorButtons[0].backgroundColor == colorButtons[3].backgroundColor || colorButtons[1].backgroundColor == colorButtons[2].backgroundColor || colorButtons[1].backgroundColor == colorButtons[3].backgroundColor || colorButtons[2].backgroundColor == colorButtons[3].backgroundColor
    }
    
   func checkWinGame() -> Bool { //check proper color matching between miniViews and buttons
        return colorViews[0].backgroundColor == colorButtons[0].backgroundColor && colorViews[1].backgroundColor == colorButtons[1] && colorViews[2].backgroundColor == colorButtons[2].backgroundColor && colorViews[3].backgroundColor == colorButtons[3].backgroundColor
    }
    
    func checkRight () -> (Int,Int) {
        var (rightColors, rightPosition, i) = (0,0,0)
        for button in colorButtons {
            if button.backgroundColor == colorViews[i].backgroundColor{
                rightPosition+=1
            }
            else {
                for view in colorViews {
                    if button.backgroundColor == view.backgroundColor {
                        rightColors+=1
                    }
                }
            }
            i+=1
        }
        return (rightPosition, rightColors)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        randomBegin()
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            viewButtons.isHidden = true
        }else{
            viewButtons.isHidden = false
        }
    }
   
    //all buttons share the same action
    var indexColor = 0
    @IBAction func changeBackground(_ sender: UIButton) {
        if indexColor == colorArray.count{
            indexColor = 0 //point to the beginning of array
        }
        for button in colorButtons {
            if button.tag == sender.tag {
                button.backgroundColor = colorArray[indexColor]
                indexColor+=1
            }
        }
    }
    
    var counter = 0 //counter of attemps before winning
    @IBAction func jugando(_ sender: Any) {
        if checkDuplicateColors() {
            showAlert()
        }else if checkWinGame(){
            print("ya ganaste")
        }else{
            var (pos,color) : (Int, Int)
            counter += 1
            (pos,color) = checkRight()
            print(pos,color)
        }
    }
}
