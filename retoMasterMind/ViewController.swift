//
//  ViewController.swift
//  retoMasterMind
//
//  Created by Frida Gutiérrez Mireles on 27/02/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewButtons: UIView! //container of mini views
    @IBOutlet var colorButtons: [UIButton]! //array of buttons
    @IBOutlet weak var btIniciar: UIButton!
    @IBOutlet weak var btProbar: UIButton!
    @IBOutlet var colorViews: [UIView]! //array of mini views
    @IBOutlet var redWhiteViews: [UIView]!
    @IBOutlet var historial: [UIView]! //array of historial
    
    var colorArray = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.cyan, UIColor.orange, UIColor.magenta] //array of 6 colors
  //  var indexesColors = [0,1,2,3,4,5] //array of numbers representing
    var indexColor = 0 //pointer to move on array of colors
    var (counter,fast) = (0,1) //counter for attempts before winning
    //var historial: [[UIView]] = [] //matrix to show attempts
    
    func randomBegin(){ //shuffle initial colors of views and buttons
        colorArray.shuffle()
        colorViews[0].backgroundColor = colorArray[0]
        colorViews[1].backgroundColor = colorArray[1]
        colorViews[2].backgroundColor = colorArray[2]
        colorViews[3].backgroundColor = colorArray[3]
        colorButtons[0].backgroundColor = colorArray[4]
        colorButtons[1].backgroundColor = colorArray[0]
        colorButtons[2].backgroundColor = colorArray[5]
        colorButtons[3].backgroundColor = colorArray[1]
    }
    
    func showAlert(){ //warning when two colors duplicate
           let alert = UIAlertController(title: "ERROR", message: "No se puede jugar con colores repetidos", preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
    }
    
    func showAlertWinning(attempts: Int){ //warning when winning, choose to play again or not
        let alert = UIAlertController(title: "GANASTE \n Te tomó \(attempts) intentos!", message: "¿Quieres jugar de nuevo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: {(action) in self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkDuplicateColors() -> Bool { //check if two buttons duplicate colors
        return colorButtons[0].backgroundColor == colorButtons[1].backgroundColor || colorButtons[0].backgroundColor == colorButtons[2].backgroundColor || colorButtons[0].backgroundColor == colorButtons[3].backgroundColor || colorButtons[1].backgroundColor == colorButtons[2].backgroundColor || colorButtons[1].backgroundColor == colorButtons[3].backgroundColor || colorButtons[2].backgroundColor == colorButtons[3].backgroundColor
    }
    
    
    func checkRight () -> (Int,Int) { //check buttons in right color position or buttons with right color but wrong position
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
    
    //paint red and white views and then shuffle them
    func shuffleRedWhite( position: inout Int, color: inout Int) {
        for view in redWhiteViews{
            view.backgroundColor = .clear
        }
        var redWhite = 0 //index to color red and white squares
        while position > 0 {
            redWhiteViews[redWhite].backgroundColor = UIColor.red
            redWhite+=1
            position-=1
        }
        while color > 0 {
            redWhiteViews[redWhite].backgroundColor = UIColor.white
            redWhite+=1
            color-=1
        }
        redWhiteViews.shuffle()
    }
    
    func resetGame() { //clear variables
        for view in redWhiteViews{
            view.backgroundColor = .clear
        }
        for history in historial{
            history.backgroundColor = .clear
        }
        randomBegin()
        (counter,fast) = (0,1)
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
   
    func historialIntentos(botones:[UIButton], contador: Int) {
        
        let hist = (contador-fast)*4 //where to start
        let inicial = hist
        for i in hist...hist+3 {
            historial[i].backgroundColor = colorButtons[i-inicial].backgroundColor
        }
        if contador%5==0{ //to restart
          fast+=5
        }
    }
    
    //all buttons share the same action
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
    
    @IBAction func jugando(_ sender: UIButton) {
        if checkDuplicateColors() {
            showAlert()
        }else{
            var (pos,col) : (Int, Int)
            counter += 1
            (pos,col) = checkRight()
            if pos == 4 && col == 0 {
                showAlertWinning(attempts: counter)
            }else{
                shuffleRedWhite(position: &pos, color: &col)
                historialIntentos(botones: historial as! [UIButton], contador: counter)
            }
        }
    }
    
    @IBAction func btClearGame(_ sender: UIButton) {
        resetGame()
    }
}
