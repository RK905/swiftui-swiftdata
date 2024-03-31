import SwiftUI

struct ItemDetailView: View {
    var item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Directly attempt to create a UIImage from item.image
                let uiImage = UIImage(data: item.image)
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Fallback image if the data doesn't represent a valid image
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(height: 200)
                }

                // The rest of your view content...
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
