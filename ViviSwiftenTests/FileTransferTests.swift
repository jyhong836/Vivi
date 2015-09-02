//
//  FileTransferTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviSwiften

class FileTransferTests: XCTestCase, VSFileTransferManagerDelegate, VSFileTransferDelegate {
    
    let testData = "test string"
    let testFile = "test.txt"
    
    var state: SWFileTransferStateType?
    var inTransfer: SWIncomingFileTransfer?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            try testData.writeToFile(testFile, atomically: true, encoding: NSUnicodeStringEncoding)
        } catch {
            print("\(error)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        do {
            try NSFileManager.defaultManager().removeItemAtPath(testFile)
        } catch {
            print("\(error)")
        }
    }
    
    private func createClient(index: Int) -> SWClient {
        let c =  SWClientFactory.createClient(index)
        c.fileTransferManager.delegate = self
        return c
    }
    
    var clientConnectExpectation: XCTestExpectation?

    func testSendFile() {
        let client1 = createClient(0)
        let client2 = createClient(1)
        SWClientFactory.eventLoop.start()
        
        clientConnectExpectation = self.expectationWithDescription("test client connecting")
        
        client1.connectWithHandler { (err) -> Void in
            print("connected client1")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
        clientConnectExpectation = self.expectationWithDescription("test client connecting")
        client2.connectWithHandler { (err) -> Void in
            print("connected client2")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
        
        // FIXME: sometims maybe disconencted unexpectly.
        
        // test sending
        var hasCatchError = false
        do {
            try client1.fileTransferManager.sendFileTo(client2.account, filename: "test_empty.txt", desciption: "test.txt file")
        } catch {
            let nserror = error as NSError
            XCTAssertEqual(nserror.domain, VSFTManagerErrorDomain, "unexpected error")
            if nserror.domain == VSFTManagerErrorDomain {
                hasCatchError = true
            }
        }
        clientConnectExpectation = self.expectationWithDescription("test client sending file")
        var transfer: SWOutgoingFileTransfer? = nil
        do {
            transfer = try client1.fileTransferManager.sendFileTo(client2.account, filename: testFile, desciption: "test.txt file")
            transfer!.delegate = self
            transfer!.start()
        } catch {
            print("\(error)")
        }
        XCTAssertTrue(hasCatchError, "should throw not found error")
        waitForExpectationsWithTimeout(50, handler: nil)
        
        clientConnectExpectation = self.expectationWithDescription("waiting for finishing")
        waitForExpectationsWithTimeout(60, handler: nil)
        
        transfer?.cancel()
        
        // disconnect
        clientConnectExpectation = self.expectationWithDescription("test client disconnecting")
        client1.disconnectWithHandler { (err) -> Void in
            print("client1 disconnected")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
        clientConnectExpectation = self.expectationWithDescription("test client disconnecting")
        client2.disconnectWithHandler { (err) -> Void in
            print("client2 disconnected")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    func testSendMutipleFiles() {
        
    }
    
    func fileTransferManager(manager: SWFileTransferManager!, getIncomingTransfer transfer: SWIncomingFileTransfer!) {
        NSLog("Received file: \(transfer.filename) from: \(transfer.sender.accountString) to: \(transfer.recipient.accountString)")
        transfer.acceptAsFile(transfer.filename+".temp")
        // :IMPORTANT: store transfer to avoid auto release.
        inTransfer = transfer
        clientConnectExpectation?.fulfill()
    }
    
    func fileTransfer(filetransfer: SWFileTransfer!, finishedWithError errorCode: Int32) {
        print("finished")
        if state != .Canceled {
            clientConnectExpectation?.fulfill()
        }
    }
    
    func fileTransfer(filetransfer: SWFileTransfer!, processedBytes bytes: Int) {
        print("processed bytes: \(bytes)")
    }
    
    func fileTransfer(filetransfer: SWFileTransfer!, stateChanged stateCode: Int32) {
        state = SWFileTransferStateType(rawValue: stateCode)
        print("state: \(state)")
    }

}
