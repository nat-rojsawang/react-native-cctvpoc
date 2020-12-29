//
//  CCTVVC.swift
//  CCTVPOC
//
//  Created by Pathom S. on 23/11/2563 BE.
//

import EZOpenSDKFramework
import UIKit

class CCTVVC: UIViewController {
    @IBOutlet var playerView: UIView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var micButton: UIButton?
    @IBOutlet var rorateUpButton: UIButton?
    @IBOutlet var rorateDownButton: UIButton?
    @IBOutlet var rorateLeftButton: UIButton?
    @IBOutlet var rorateRightButton: UIButton?

    var player: EZPlayer?
    var cameraRotationSpeed: Int = 1
    var cameraNumber: Int = 1
    var deviceSerialNumber: String = "779952598"
    var verificationCode: String = "OCMRPH"
    var accessToken: String = "at.2f8luzy3b2gze7vc7xcwxoyc0gougg1u-5tph69kvf4-17hl6ah-ffy8euadl"
    var appKey: String = "e34d2f451c7043a98661e058ecf00369"
    var apiServerURL: String = ""
    var authServer: String = ""
    var cameraName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initiateConfigurations()
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

    func initiateConfigurations() {
        EZGlobalSDK.initLib(withAppKey: appKey)
        EZGlobalSDK.setAccessToken(accessToken)
        
//        EZGlobalSDK.setVideoLevel(deviceSerialNumber, cameraNo: cameraNumber, videoLevel: 3) { _ in
//        }

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        micButton!.addGestureRecognizer(longPress)

        let rorateUp = UILongPressGestureRecognizer(target: self, action: #selector(rorateUp(gesture:)))
        rorateUpButton!.addGestureRecognizer(rorateUp)
        let rorateDown = UILongPressGestureRecognizer(target: self, action: #selector(rorateDown(gesture:)))
        rorateDownButton!.addGestureRecognizer(rorateDown)
        let rorateLeft = UILongPressGestureRecognizer(target: self, action: #selector(rorateLeft(gesture:)))
        rorateLeftButton!.addGestureRecognizer(rorateLeft)
        let rorateRight = UILongPressGestureRecognizer(target: self, action: #selector(rorateRight(gesture:)))
        rorateRightButton!.addGestureRecognizer(rorateRight)

        preparePlayer()
    }
    
    func setTitle(title: String) {
        self.titleLabel?.text = title
    }

    func preparePlayer() {
        self.setTitle(title: cameraName)
        
        player = EZGlobalSDK.createPlayer(withDeviceSerial: deviceSerialNumber, cameraNo: cameraNumber)
        player?.delegate = self
        player?.setPlayVerifyCode(verificationCode)
        player?.setPlayerView(playerView)
        player?.startRealPlay()
    }

    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.micButton?.setImage(UIImage(named: "microphone_pressed"), for: .normal)
            player?.startVoiceTalk()
        } else if gesture.state == .ended {
            self.micButton?.setImage(UIImage(named: "microphone_default"), for: .normal)
            player?.stopVoiceTalk()
        }
    }

    @IBAction func captureScreen() {
        EZGlobalSDK.captureCamera(deviceSerialNumber, cameraNo: cameraNumber) { [self] urlString, _ in
            if urlString != nil, let url = URL(string: urlString!) {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
    }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Save Image callback

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)

        } else {
            print("Success")
        }
    }

    @objc func rorateUp(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .up, action: .start, speed: cameraRotationSpeed) { _ in }
        } else if gesture.state == .ended {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .up, action: .stop, speed: cameraRotationSpeed) { _ in }
        }
    }

    @objc func rorateDown(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .down, action: .start, speed: cameraRotationSpeed) { _ in }
        } else if gesture.state == .ended {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .down, action: .stop, speed: cameraRotationSpeed) { _ in }
        }
    }

    @objc func rorateLeft(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .left, action: .start, speed: cameraRotationSpeed) { _ in }
        } else if gesture.state == .ended {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .left, action: .stop, speed: cameraRotationSpeed) { _ in }
        }
    }

    @objc func rorateRight(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .right, action: .start, speed: cameraRotationSpeed) { _ in }
        } else if gesture.state == .ended {
            EZGlobalSDK.controlPTZ(deviceSerialNumber, cameraNo: cameraNumber, command: .right, action: .stop, speed: cameraRotationSpeed) { _ in }
        }
    }
}

extension CCTVVC: EZPlayerDelegate {
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        print("\(messageCode)")
    }

    func player(_ player: EZPlayer!, didPlayFailed error: Error!) {
        print("\(error.debugDescription)")
    }
}

class CCTVManager: NSObject {
    static let shared = CCTVManager()

    func openCCTV(accessToken: String, appKey: String, serialNumber: String, verificationCode: String, apiServerURL: String, authServer: String, cameraName: String) {
        
        guard let bundlePath = Bundle.main.path(forResource: "CCTVPOC", ofType: "bundle") else { return }
        let bundle = Bundle(path: bundlePath)
        
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "CCTV", bundle: bundle).instantiateViewController(withIdentifier: "CCTVVC") as! CCTVVC
            vc.setup(accessToken: accessToken, appKey: appKey, serialNumber: serialNumber, verificationCode: verificationCode, apiServerURL: apiServerURL, authServer: authServer, cameraName: cameraName)
            vc.modalPresentationStyle = .fullScreen
            
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        
    }
}
