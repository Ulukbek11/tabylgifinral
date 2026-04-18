import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0
    @State private var glyphRotate: Double = 0
    @State private var tagOpacity: Double = 0

    var body: some View {
        ZStack {
            EthnoOrnamentBackground()

            Circle()
                .stroke(AppTheme.heritageGold.opacity(0.15), lineWidth: 1)
                .frame(width: 320, height: 320)
                .rotationEffect(.degrees(glyphRotate))
            Circle()
                .stroke(AppTheme.neonEmber.opacity(0.25), lineWidth: 1)
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-glyphRotate * 1.4))

            VStack(spacing: 28) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(AppTheme.emberGradient)
                    .addNeonGlow(color: AppTheme.neonEmber, radius: 22, intensity: 1.0)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                VStack(spacing: 8) {
                    Text("TABYLGA")
                        .font(.system(size: 42, weight: .black, design: .serif))
                        .kerning(8)
                        .foregroundStyle(AppTheme.textPrimary)
                        .opacity(logoOpacity)

                    NomadicBorder()
                        .frame(width: 140)
                        .opacity(logoOpacity * 0.8)

                    Text("Nomad's Path")
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .italic()
                        .kerning(3)
                        .foregroundStyle(AppTheme.heritageGold)
                        .opacity(tagOpacity)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.6)) {
                logoOpacity = 1
                logoScale = 1
            }
            withAnimation(.easeIn(duration: 1.2).delay(0.4)) {
                tagOpacity = 1
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                glyphRotate = 360
            }
        }
    }
}

#Preview {
    SplashView()
}
