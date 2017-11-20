//
//  MPCManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import MultipeerConnectivity


protocol CommunicatorDelegate : class {
 
    //discovering
    func didFoundUser(userID: String, userName: String)
    func didLostUser(userID: String)
    
    //error
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
   
}

protocol Communicator {
    func sendMessage(string: String, toUserID: String, completionHandler: ((_ success : Bool, _ error : Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? {get set}
    var online : Bool {get set}
}


class MultipeerCommunicator: NSObject, Communicator {

    private var sessions: [String: MCSession] = [:]
   
    private let serviceType = "tinkoff-chat"
    private let discoveryInfo = ["userName": "m.stegnienko"]
   
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    public let serviceBrowser : MCNearbyServiceBrowser
    public let serviceAdvertiser : MCNearbyServiceAdvertiser
  
    weak var delegate: CommunicatorDelegate?
    var online: Bool = true
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        self.serviceAdvertiser.startAdvertisingPeer()
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        
        self.sessions.forEach { (key : String , value: MCSession) in
            value.disconnect()
        }
        
    }
 
    func createSession(forUser userID: String) -> MCSession {
        if let session = sessions[userID] {
            return session
        } else {
            
            let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            sessions[userID] = session
            session.delegate = self
            return session
        }
    }
    
    
    // MARK - Communicator
    
    func sendMessage(string: String, toUserID: String, completionHandler: ((Bool, Error?) -> ())?) {
    
        if let session = sessions[toUserID] {
            if let message = createMessage(withText: string) {
                for peer in session.connectedPeers {
                    if peer != myPeerID {
                        do {
                            try session.send(message, toPeers: [peer], with: .reliable)
                            completionHandler?(true, nil)
                        } catch {
                            completionHandler?(false, error)
                        }
                    }
                }
            }
        }
    }

    func createMessage(withText text: String) -> Data? {
        let messageId = generateMessageId()
        let json = [
            "eventType" : "TextMessage",
            "messageId" : messageId,
            "text"      : text
        ]
    
        do {
            let messageData = try JSONSerialization.data(withJSONObject: json, options: [])
            return messageData
        } catch {
            print("Error : \(error.localizedDescription)")
            return nil
        }
    }

    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}

// MARK - MCNearbyServiceBrowserDelegate

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
  
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
         
        let session = createSession(forUser: peerID.displayName)
            let userName = info?["userName"] ?? "unknown User"
            if session.connectedPeers.contains(peerID) == false {
                browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            }
        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        sessions[peerID.displayName] = nil
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
       
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
}

// MARK - MCNearbyServiceAdvertiserDelegate

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
     
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
      
            let session = createSession(forUser: peerID.displayName)
                if !session.connectedPeers.contains(peerID) {
                    invitationHandler(true, session)
                } else {
                    invitationHandler(false, nil)
            }
        }
}

// MARK - MCSessionDelegate

extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
   
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [ String : String ] else {
                return
            }
            if json["eventType"] == "TextMessage" {
                if let messageText = json["text"] {
                    delegate?.didRecieveMessage(text: messageText, fromUser: peerID.displayName, toUser: UIDevice.current.name)
                }
            }
            
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // no implementation
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        // no implementation
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
         // no implementation
    }
    
}

