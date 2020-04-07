//
//  ViewController.swift
//  retoMasterMind
//
//  Created by Frida Gutiérrez Mireles on 27/02/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewButtons: UIView! //container holding mini views
    @IBOutlet var colorButtons: [UIButton]! //array of buttons
    @IBOutlet weak var btIniciar: UIButton! //button for reset game
    @IBOutlet weak var btProbar: UIButton! //button for trial
    @IBOutlet var colorViews: [UIView]! //array of mini views
    @IBOutlet var redWhiteViews: [UIView]! //array of whiteRed views
    @IBOutlet var historial: [UIView]! //array of colors history
    @IBOutlet var redWhiteHistorial: [UIView]! //array redWhite history
    
    var colorArray = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.cyan, UIColor.orange, UIColor.magenta] //array of 6 colors
    var indexColor = 0 //pointer to move on array of colors
    var counter = 0//counter for attempts
    var (ganar,volverGanar,grises) = (false,false,false) //validations for alerts
    
    func randomBegin(){ //shuffle initial colors of mini views. Start buttons with default color gray
        colorArray.shuffle()
        colorViews[0].backgroundColor = colorArray[0]
        colorViews[1].backgroundColor = colorArray[1]
        colorViews[2].backgroundColor = colorArray[2]
        colorViews[3].backgroundColor = colorArray[3]
        for button in colorButtons{
            button.backgroundColor = UIColor.darkGray
        }
    }
    
    func showAlertIntentos(){ //warning telling user the amount of possible trials before losing
        let alert = UIAlertController(title: "ATENCIÓN", message: "Tienes 8 intentos para decifrar y ganar \n Da click en los cuadros grises para elegir un color.", preferredStyle: .alert)
              let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alert.addAction(action)
              present(alert, animated: true, completion: nil)
    }
    
    func showAlert(){ //warning when two colors duplicate
           let alert = UIAlertController(title: "ERROR", message: "No se puede jugar con colores repetidos", preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
    }
    
    func showAlertJugarConGris(){//warning when not choosing a color for the buttons
        let alert = UIAlertController(title: "ERROR", message: "Elige un color para todos los cuadros.", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alert.addAction(action)
         present(alert, animated: true, completion: nil)
    }
    
    func showAlertWinning(attempts: Int){ //warning when winning. Also to tell user to restart the game whenever he wons and decides not to start a new game but still clicks on the 'probar' button
        var (mensajeUno, mensajeDos) : (String?, String?)
            if(volverGanar){
                mensajeUno = "INICIA JUEGO NUEVO"
                mensajeDos = "Ya ganaste. \n ¿Quieres jugar de nuevo?"
            }else{
                mensajeUno = "GANASTE \n Te tomó \(attempts) intentos!"
                mensajeDos = "¿Quieres jugar de nuevo?"
            }
        let alert = UIAlertController(title: mensajeUno, message: mensajeDos, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: {(action) in self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertLosing(){ //warning when user exceeds the 8 attempts avaialble to win
        let alert = UIAlertController(title: "PERDISTE!", message: "Excediste el número de intentos \n ¿Quieres jugar de nuevo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: {(action) in self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkDuplicateColors() -> Bool { //check if two buttons duplicate colors
        return colorButtons[0].backgroundColor == colorButtons[1].backgroundColor || colorButtons[0].backgroundColor == colorButtons[2].backgroundColor || colorButtons[0].backgroundColor == colorButtons[3].backgroundColor || colorButtons[1].backgroundColor == colorButtons[2].backgroundColor || colorButtons[1].backgroundColor == colorButtons[3].backgroundColor || colorButtons[2].backgroundColor == colorButtons[3].backgroundColor
    }
    
    func checkDefaultColor() -> Bool { //check if a button hasn't a color applied to it
        for button in colorButtons{
            if button.backgroundColor == UIColor.darkGray{
                grises = true
            }
        }
        return grises
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
    
    func resetGame() {//clear variables
        counter = 0
        (ganar,volverGanar,grises) = (false,false,false)
        for view in redWhiteViews{
            view.backgroundColor = .clear
        }
        for history in historial{
            history.backgroundColor = .clear
        }
        for redWhite in redWhiteHistorial{
            redWhite.backgroundColor = .clear
        }
        randomBegin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        randomBegin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlertIntentos()
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {//hide or unhide views on segment choice. New game when segment choice changes
        if sender.selectedSegmentIndex == 0{
            resetGame()
            viewButtons.isHidden = true
        }else{
            resetGame()
            viewButtons.isHidden = false
        }
    }
   
    func historialIntentos(botones:[UIButton], contador: Int) {//show historial of button colors and redWhite views
        
        let hist = (contador-1)*4 //where to start
        let inicial = hist
        for i in hist...hist+3 {
            historial[i].backgroundColor = colorButtons[i-inicial].backgroundColor
            redWhiteHistorial[i].backgroundColor = redWhiteViews[i-inicial].backgroundColor
        }
    }
    
    //all buttons share the same action
    @IBAction func changeBackground(_ sender: UIButton) {//change color of buttons
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
        if checkDefaultColor() { //buttons with no colors assigns
            showAlertJugarConGris()
            grises = false
        }else{
            if checkDuplicateColors() { //buttons with duplicate colors
                showAlert()
            }else{
                var (pos,col) : (Int, Int)
                counter += 1
                (pos,col) = checkRight()
                if pos == 4 && col == 0 { //user has won
                    ganar = true
                    showAlertWinning(attempts: counter)
                    volverGanar = true
                }else{
                    if(ganar){//user had won, didn't restart game and still clicks the 'probar' button
                        showAlertWinning(attempts: counter)
                    }else{
                        if counter >= 8 { //user exceeds the attempts of trials
                            showAlertLosing()
                        }else{ //show historial, user still has attemps available to win
                            shuffleRedWhite(position: &pos, color: &col)
                            historialIntentos(botones: historial as! [UIButton], contador: counter)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btClearGame(_ sender: UIButton) {//start new game when 'iniciar' button is clicked
        resetGame()
    }
}
