//
//  ContentView.swift
//  RoomPlan-Example
//
//  Created by 정홍섭 on 5/24/26.
//

import SwiftUI
import AVFoundation
import RoomPlan

struct ContentView: View {
    @State private var isScanPresented = false
    @State private var showPermissionAlert = false
    
    private var isRoomPlanSupported: Bool {
        RoomCaptureSession.isSupported
    }
    
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isScanPresented = true
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isScanPresented = true
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
            
        case .denied, .restricted:
            showPermissionAlert = true
            
        @unknown default:
            showPermissionAlert = true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("RoomPlan Example")
                    .font(.largeTitle)
                    .bold()
                
                Text("방을 스캔해서 3D 구조를 확인합니다.")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if isRoomPlanSupported {
                    Button {
                        requestCameraPermission()
                    } label: {
                        Text("시작하기")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 12)
                } else {
                    VStack(spacing: 8) {
                        Text("이 기기에서는 RoomPlan을 사용할 수 없습니다.")
                            .font(.headline)
                            .foregroundStyle(.gray.opacity(0.7))
                        Text("LiDAR 센서를 지원하는\niPhone 또는 iPad에서 사용할 수 있습니다.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.vertical, 90)
            .navigationDestination(isPresented: $isScanPresented) {
                RoomScanView()
            }
            .alert("카메라 권한이 필요합니다", isPresented: $showPermissionAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("RoomPlan을 사용하려면 카메라 권한을 허용해야 합니다.")
            }
        }
    }
}

#Preview {
    ContentView()
}
