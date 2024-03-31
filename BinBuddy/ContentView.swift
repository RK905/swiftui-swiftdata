import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isPresentingAddItemView = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("ID: \(item.idescription)")
                                .font(.subheadline)
                            Text("Qty: \(item.quantity)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item") {
                        isPresentingAddItemView = true
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddItemView(isPresented: $isPresentingAddItemView, modelContext: modelContext)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                modelContext.delete(items[index])
            }
        }
    }
}

struct AddItemView: View {
    @Binding var isPresented: Bool
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var locationOfStorage: String = ""
    @State private var quantity: Int = 1
    // Additional states for other properties as needed
    var modelContext: ModelContext

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Location", text: $locationOfStorage)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                    // Add other fields as necessary
                }
                
                Section(header: Text("Item Image")) {
                    HStack {
                        Spacer()
                        Image(uiImage: image ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                self.showingImagePicker = true
                            }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addItem()
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    func addItem() {
        let newItem = Item(image: inputImage?.jpegData(compressionQuality: 0.8) ?? Data(), name: name, idescription: description, locationOfStorage: locationOfStorage, quantity: quantity, gpsCoords: "0,0")
        modelContext.insert(newItem)
        // Handle the insertion of the new item into the database
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = inputImage
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }
    }
}
