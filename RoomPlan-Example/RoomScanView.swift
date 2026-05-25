//
//  RoomScanView.swift
//  RoomPlan-Example
//
//  Created by 정홍섭 on 5/24/26.
//

import SwiftUI
import RoomPlan

struct RoomScanView: View {
    @StateObject private var viewModel = RoomScanViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoomCaptureViewRepresentable(viewModel: viewModel)
                .ignoresSafeArea()
            
            Button {
                if viewModel.isScanFinished {
                    dismiss()
                } else {
                    viewModel.stopSession()
                }
            } label: {
                Text(viewModel.isScanFinished ? "홈으로" : "스캔 종료")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isScanFinished ? .gray : .blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

#Preview {
    RoomScanView()
}
