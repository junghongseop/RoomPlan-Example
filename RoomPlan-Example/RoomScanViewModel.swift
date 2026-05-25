//
//  RoomScanViewModel.swift
//  RoomPlan-Example
//
//  Created by 정홍섭 on 5/26/26.
//

import Foundation
import RoomPlan
import Combine

final class RoomScanViewModel: ObservableObject {
    @Published var isScanFinished = false
    
    var roomCaptureView: RoomCaptureView?
    var capturedRoom: CapturedRoom?
    
    func startSession() {
        guard let roomCaptureView else {
            return
        }
        
        isScanFinished = false
        
        let config = RoomCaptureSession.Configuration()
        roomCaptureView.captureSession.run(configuration: config)
    }
    
    func stopSession() {
        roomCaptureView?.captureSession.stop()
    }
    
    func saveCapturedRoom(_ room: CapturedRoom) {
        capturedRoom = room
        
        DispatchQueue.main.async {
            self.isScanFinished = true
        }
        
        print("스캔 결과 저장 완료:", room)
    }
}
