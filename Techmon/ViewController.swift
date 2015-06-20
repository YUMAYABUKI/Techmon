//
//  ViewController.swift
//  Techmon
//
//  Created by 矢吹祐真 on 2015/06/18.
//  Copyright (c) 2015年 矢吹祐真. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


     var timer: NSTimer!
     var enemyTimer: NSTimer!
     
     var enemy: Enemy!
     var player: Player!
     
     let util: TechDraUtility = TechDraUtility()
     
     @IBOutlet var backgroundImageView: UIImageView!
     @IBOutlet var attackButton: UIButton!
     
     @IBOutlet var enemyImageView: UIImageView!
     @IBOutlet var playerImageView: UIImageView!
     
     @IBOutlet var enemyHPBar: UIProgressView!
     @IBOutlet var playerHPBar: UIProgressView!
     
     @IBOutlet var enemyNameLabel: UILabel!
     @IBOutlet var playerNameLabel: UILabel!
     
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
          
          enemyHPBar.transform = CGAffineTransformMakeScale(1.0, 4.0)
          playerHPBar.transform = CGAffineTransformMakeScale(1.0, 4.0)
          initStatus()
          
          enemyTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(enemy.speed), target: self, selector: "enemyAttack", userInfo: nil, repeats: true)
          enemyTimer.fire()
          
     }
     
     func initStatus() {
          enemy = Enemy()
          player = Player()
          
          enemyNameLabel.text = enemy.name
          playerNameLabel.text = player.name
          
          enemyImageView.image = enemy.image
          playerImageView.image = player.image
          
          enemyHPBar.progress = enemy.currentHP / enemy.maxHP
          playerHPBar.progress = player.currentHP / player.maxHP
          
          cureHP()
          
          
     }
     
     override func viewDidAppear(animated: Bool) {
          util.playBGM("BGM_battle001")
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }
     
     @IBAction func playAttack() {
          TechDraUtility.damageAnimation(enemyImageView)
          util.playSE("SE_attack")
          
          enemy.currentHP = enemy.currentHP - player.attackPoint
          enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
          
          if enemy.currentHP <= 0.0 {
               finishBattle(enemyImageView, winPlayer: true)
          }
     }
     func enemyAttack() {
          TechDraUtility.damageAnimation(playerImageView)
          util.playSE("SE_attack")
          
          player.currentHP = player.currentHP - enemy.attackPoint
          playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
          
          if player.currentHP <= 0.0 {
               finishBattle(playerImageView, winPlayer:false)
          }
     }
     
     func finishBattle(vanishImageView: UIImageView, winPlayer: Bool){
          TechDraUtility.vanishAnimation(vanishImageView)
          util.stopBGM()
          timer.invalidate()
          enemyTimer.invalidate()
          
          var finishMessage: String!
          
          if attackButton.hidden != true {
               attackButton.hidden = true
          }
          
          if winPlayer == true {
               util.playSE("SE_fanfare")
               finishMessage = "Player's WIN"
          }else {
               util.playSE("SE_gameover")
               finishMessage = "Player's Lose"
          }
          
          var alert = UIAlertController(title: "Battle is Over", message: finishMessage, preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in self.dismissViewControllerAnimated(true, completion: nil)}))
          
          self.presentViewController(alert, animated: true, completion: nil)
          
     }
     
     func cureHP() {
          timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateHPValue", userInfo: nil, repeats: true)
          timer.fire()
     }
     
     func updateHPValue() {
          if enemy.currentHP < enemy.maxHP{
               enemy.currentHP = enemy.currentHP + enemy.defencePoint
               enemyHPBar.progress = player.currentHP / player.maxHP
          }
          
          if player.currentHP < player.maxHP {
               player.currentHP = player.currentHP + player.defencePoint
               playerHPBar.progress = player.currentHP / player.maxHP
          }
     }
     
     
}



