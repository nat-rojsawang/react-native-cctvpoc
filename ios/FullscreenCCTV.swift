//
//  FullscreenCCTV.swift
//  CCTVPOC
//
//  Created by Pathom S. on 3/12/2563 BE.
//

import UIKit
import EZOpenSDKFramework

class FullscreenCCTV: UIViewController {
    @IBOutlet var playerView: UIView?

    var player: EZPlayer?
    var cameraNumber: Int = 1
    var deviceSerialNumber: String = ""
    var verificationCode: String = ""
    var accessToken: String = ""
    var appKey: String = ""
    var apiServerURL: String = ""
    var authServer: String = ""
    var cameraName: String = ""
    
    var isMuted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss(animated:completion:)), name: NSNotification.Name(rawValue: "CloseCCTV"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpPlayer()
    }

    func setUpPlayer() {
        player = EZGlobalSDK.createPlayer(withDeviceSerial: deviceSerialNumber, cameraNo: cameraNumber)
        player?.delegate = self
        player?.setPlayVerifyCode(verificationCode)
        player?.setPlayerView(self.playerView)
        player?.startRealPlay()
        self.checkMuteSelection()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    func setup(accessToken: String, appKey: String, serialNumber: String, verificationCode: String, apiServerURL: String, authServer: String, cameraName: String) {
        
        if accessToken.count > 0 {
            self.accessToken = accessToken
        }
        
        if appKey.count > 0 {
            self.appKey = appKey
        }
        
        if serialNumber.count > 0 {
            self.deviceSerialNumber = serialNumber
        }
        
        if verificationCode.count > 0 {
            self.verificationCode = verificationCode
        }
        
        if apiServerURL.count > 0 {
            self.apiServerURL = apiServerURL
        }
        
        if authServer.count > 0 {
            self.authServer = authServer
        }
        
        if cameraName.count > 0 {
            self.cameraName = cameraName
        }
    }

    @IBAction func close() {
        self.dismiss(animated: true) {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    @IBAction func mute(sender: UIButton) {
        if self.isMuted == false {
            self.isMuted = true
            sender.isSelected = true
            self.player?.closeSound()
            
        }else {
            self.isMuted = false
            sender.isSelected = false
            self.player?.openSound()
        }
    }
    
    func checkMuteSelection() {
        if self.isMuted == true {
            self.player?.closeSound()
        }else {
            self.player?.openSound()
        }
    }
    
    @IBAction func selectQuality() {
        print("selectQualityFull")
        let options = UIAlertController(title: "Video Quality", message: nil, preferredStyle: .alert)
        let option1 = UIAlertAction(title: "Smooth", style: .default) { (action) in
            self.setVideoQuality(qualityInt: 0)
        }
        
        let option2 = UIAlertAction(title: "Balanced", style: .default) { (action) in
            self.setVideoQuality(qualityInt: 1)
        }
        
        let option3 = UIAlertAction(title: "HD", style: .default) { (action) in
            self.setVideoQuality(qualityInt: 2)
        }
        
        let option4 = UIAlertAction(title: "Ultra Clear", style: .default) { (action) in
            self.setVideoQuality(qualityInt: 3)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in

        }
        
        options.addAction(option1)
        options.addAction(option2)
        options.addAction(option3)
        options.addAction(option4)
        options.addAction(cancel)
        self.present(options, animated: true, completion: nil)
    }
    
    func setVideoQuality(qualityInt: Int) {
        EZGlobalSDK.setVideoLevel(deviceSerialNumber, cameraNo: cameraNumber, videoLevel: qualityInt) { (error) in
        }
    }
    
    @IBAction func openNomalScreenCCTV() {
        self.dismiss(animated: true) {
            self.openCCTV(accessToken: self.accessToken, appKey: self.appKey, serialNumber: self.deviceSerialNumber, verificationCode: self.verificationCode, apiServerURL: self.apiServerURL, authServer: self.authServer, cameraName: self.cameraName)
        }

    }
    
    func openCCTV(accessToken: String, appKey: String, serialNumber: String, verificationCode: String, apiServerURL: String, authServer: String, cameraName: String) {
        
        print("openCCTV-full");
        guard let bundlePath = Bundle.main.path(forResource: "CCTVPOC", ofType: "bundle") else { return }
        let bundle = Bundle(path: bundlePath)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        

        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "CCTV", bundle: bundle).instantiateViewController(withIdentifier: "CCTVVC") as! CCTVVC
            vc.setup(accessToken: accessToken, appKey: appKey, serialNumber: serialNumber, verificationCode: verificationCode, apiServerURL: apiServerURL, authServer: authServer, cameraName: cameraName)
            vc.modalPresentationStyle = .fullScreen
            
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        
    }
}

extension FullscreenCCTV: EZPlayerDelegate {
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        print("\(messageCode)")
    }

    func player(_ player: EZPlayer!, didPlayFailed error: Error!) {
        print("\(error.debugDescription)")
    }
}
