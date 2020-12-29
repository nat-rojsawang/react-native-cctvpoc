//
//  CCTVPOC.swift
//  react-native-cctvpoc
//
//  Created by Thanakorn Amnajsatit on 17/12/2563 BE.
//

import Foundation

@objc(CCTVPOC)
class CCTVPOC: NSObject {
    @objc
    func openCCTVPOC(_ accessToken: String, appKey: String, serialNumber: String, verificationCode: String, apiServerURL: String, authServer: String, cameraName: String) {
        CCTVManager.shared.openCCTV(accessToken: accessToken, appKey: appKey, serialNumber: serialNumber, verificationCode: verificationCode, apiServerURL: apiServerURL, authServer: authServer, cameraName: cameraName)
    }
}
