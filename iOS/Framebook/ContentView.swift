import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Job?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title.isEmpty ? "Untitled" : item.title)
                                    .font(Theme.titleFont)
                                    .foregroundStyle(.white)
                                Text("\(item.width)")
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.accent2)
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("itemList")
            }
            .navigationTitle("Frame Book")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Job
    let onSave: (Job) -> Void
    private let isNew: Bool

    init(item: Job?, onSave: @escaping (Job) -> Void) {
        _draft = State(initialValue: item ?? Job())
        self.onSave = onSave
        self.isNew = item == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Piece title", text: $draft.title)
                        .accessibilityIdentifier("field_title")
                    HStack {
                        Text("Width (in)")
                        Spacer()
                        TextField("Width (in)", value: $draft.width, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_width")
                    }
                    HStack {
                        Text("Height (in)")
                        Spacer()
                        TextField("Height (in)", value: $draft.height, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_height")
                    }
                    TextField("Mat size (in)", text: $draft.matSize)
                        .accessibilityIdentifier("field_matSize")
                    TextField("Molding style", text: $draft.molding)
                        .accessibilityIdentifier("field_molding")
                    TextField("Glass type", text: $draft.glassType)
                        .accessibilityIdentifier("field_glassType")
                }
            }
            .navigationTitle(isNew ? "New Job" : "Edit Job")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
