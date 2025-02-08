import SwiftUI
import FirebaseFirestore

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomePageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Select a Language")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 40)

                    Picker("Language", selection: Binding(
                        get: { viewModel.selectedLanguage ?? viewModel.languages.first ?? "" },
                        set: { viewModel.selectedLanguage = $0 }
                    )) {
                        ForEach(viewModel.languages, id: \ .self) { language in
                            Text(language.capitalized).tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                    if !viewModel.categories.isEmpty {
                        Text("Select a Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top, 10)
                        
                        Picker("Category", selection: Binding(
                            get: { viewModel.selectedCategory ?? viewModel.categories.first ?? "" },
                            set: { viewModel.selectedCategory = $0 }
                        )) {
                            ForEach(viewModel.categories, id: \ .self) { category in
                                Text(category.capitalized).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    if let selectedLanguage = viewModel.selectedLanguage,
                       let selectedCategory = viewModel.selectedCategory {
                        NavigationLink(destination: FlashcardView(language: selectedLanguage, category: selectedCategory)) {
                            Text("Start Learning")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.horizontal, 30)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchLanguages()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
