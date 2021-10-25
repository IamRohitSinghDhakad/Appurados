//
//  OrderPlacedViewController.swift
//  Appurados
//
//  Created by Rohit Dhakad on 11/10/21.
//

import UIKit
import AudioToolbox
import AVFoundation

class OrderPlacedViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    var orderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let soundURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "mpeg")!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL as URL)
            
        }catch {
            print("there was some error. The error was \(error)")
        }
        self.audioPlayer.play()
        
        UIDevice.vibrate()
    }
    

    @IBAction func btnOnBackTOHome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackOrderViewController")as! TrackOrderViewController
        vc.strOrderID = self.orderID
        self.navigationController?.pushViewController(vc, animated: true)
      // pushVc(viewConterlerId: "TrackOrderViewController")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
