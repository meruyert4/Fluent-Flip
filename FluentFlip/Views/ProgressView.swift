import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Progress")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Track your flashcard learning by language and category.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ProgressCircleView(learnedCards: profileViewModel.currentUser?.learnedcards ?? 0)

            Spacer()
        }
        .padding()
    }
}

struct ProgressCircleView: View {
    let learnedCards: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0.0, to: min(CGFloat(learnedCards) / 100, 1.0))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [.blue, .green]), center: .center),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0), value: learnedCards)

            VStack {
                Text("\(learnedCards)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Flashcards Learned")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 200, height: 200)
        .padding()
    }
}
