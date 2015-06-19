//
//  ViewController.swift
//  Techmon
//
//  Created by 矢吹祐真 on 2015/06/18.
//  Copyright (c) 2015年 矢吹祐真. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer:NSTimer!
    var enemyTimer:NSTimer!
    
    var enemy:Enemy!
    var player:Player!
    
    @IBOutlet var backgroundImageVIew:UIImageView!
    @IBOutlet var attackButton:UIButton!
    
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBOutlet var enemyHPBar: UIProgressView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    
    let util: TechDraUtility = TechDraUtility()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enemyHPBar.transform = CGAffineTransformMakeScale(1.0,4.0)
        
        playerHPBar.transform = CGAffineTransformMakeScale(1.0,4.0)
        
        initStatus()
        
        enemyTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(enemy.speed), target: self, selector: "enemyAttack", userInfo: nil, repeats: true)
     
        enemyTimer.fire()
     
        // Do any additional setup after loading the view, typically from a nib.
    }
     

     func initStatus(){
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     @IBAction func playerAttack(){
          TechDraUtility.damageAnimation(enemyImageView)
          util.playSE("Se_Attack")
          
          enemy.currentHP = enemy.currentHP - player.attackPoint
          enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
          
          if player.currentHP <= 0.0{
               finishBattle(playerImageView, winPlayer: false)
          }
     }
     
     func finishBattle(vanishImageView: UIImageView, winPlayer: Bool){
          TechDraUtility.vanishAnimation(vanishImageView)
          util.stopBGM()
          timer.invalidate()
          enemyTimer.invalidate()
          
          var finishedMessage: String!
          
          if attackButton.hidden != true{
               attackButton.hidden = true
          }
          
          if winPlayer == true{
               util.playSE("SE_fanfare")
               finishedMessage="playerの勝利"
          } else {
               util.playSE("SE_gameover")
               finishedMessage="playerの敗北"
          }
          
          var alert = UIAlertController(title: "バトル終了", message: finishedMessage, preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { action in self.dismissViewControllerAnimated(true, completion: nil)}))
          self.presentViewController(alert, animated: true, compltion: nil)
     }
     }
}

