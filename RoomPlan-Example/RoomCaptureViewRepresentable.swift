//
//  RoomCaptureViewRepresentable.swift
//  RoomPlan-Example
//
//  Created by 정홍섭 on 5/26/26.
//

import SwiftUI
import RoomPlan

struct RoomCaptureViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: RoomScanViewModel
    
    func makeCoordinator() -> RoomCaptureCoordinator {
        RoomCaptureCoordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> RoomCaptureView {
        let captureView = RoomCaptureView(frame: .zero)
        
        captureView.delegate = context.coordinator
        captureView.captureSession.delegate = context.coordinator
        
        viewModel.roomCaptureView = captureView
        
        return captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {}
}

final class RoomCaptureCoordinator: NSObject, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    func encode(with coder: NSCoder) {}
    required init?(coder: NSCoder) { return nil }
    
    private let viewModel: RoomScanViewModel
    
    init(viewModel: RoomScanViewModel) {
        self.viewModel = viewModel
    }
    
    func captureView(
        shouldPresent roomDataForProcessing: CapturedRoomData,
        error: Error?
    ) -> Bool {
        if let error {
            print("스캔 데이터 처리 전 에러:", error)
        }
        
        return true
    }
    
    func captureView(
        didPresent processedResult: CapturedRoom,
        error: Error?
    ) {
        if let error {
            print("스캔 결과 표시 에러:", error)
            return
        }
        
        viewModel.saveCapturedRoom(processedResult)
    }
}
