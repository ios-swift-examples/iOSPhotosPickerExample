//
//  ContentView.swift
//  iOSPhotosPickerExample
//
//  Created by 영준 이 on 2023/12/26.
//

import SwiftUI
import PhotosUI

/// https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app

struct ContentView: View {
    @State var selectedPhoto: PhotosPickerItem?{
        didSet{
            didFinishedPickingPhoto() // not working
        }
    }
    
    @State var selectedImage: Image?
    
    var body: some View {
        VStack {
            selectedImage?
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
            PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                         photoLibrary: .shared()) {
                Text("Select Photo")
            }.onChange(of: selectedPhoto) {
                didFinishedPickingPhoto()
            }
            
        }
        .padding()
    }
    
    func didFinishedPickingPhoto() {
        selectedPhoto?.loadTransferable(type: TransferableImage.self) { result in
            switch result {
            case .success(let image):
                selectedImage = image?.image
            case .failure(let error):
                debugPrint("Cannot read photo. error - \(error)")
                selectedImage = nil
            }
        }
    }
}

struct TransferableImage: Transferable  {
    let image: Image
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                fatalError()
            }
            
            let image = Image(uiImage: uiImage)
            return TransferableImage(image: image)
        }
    }
}

#Preview {
    ContentView()
}
