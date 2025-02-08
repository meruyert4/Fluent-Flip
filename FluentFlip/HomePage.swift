import SwiftUI
import FirebaseFirestore


struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomePageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Select a Language")
                    .font(.title2)
                    .padding()

                Picker("Language", selection: Binding(
                    get: { viewModel.selectedLanguage ?? viewModel.languages.first ?? "" },
                    set: { viewModel.selectedLanguage = $0 }
                )) {
                    ForEach(viewModel.languages, id: \.self) { language in
                        Text(language.capitalized).tag(language)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                if !viewModel.categories.isEmpty {
                    Text("Select a Category")
                        .font(.title2)
                        .padding()

                    Picker("Category", selection: Binding(
                        get: { viewModel.selectedCategory ?? viewModel.categories.first ?? "" },
                        set: { viewModel.selectedCategory = $0 }
                    )) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }

                if let selectedLanguage = viewModel.selectedLanguage,
                   let selectedCategory = viewModel.selectedCategory {
                    NavigationLink(destination: FlashcardView(language: selectedLanguage, category: selectedCategory)) {
                        Text("Start Learning")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchLanguages()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}




