import SwiftUI

struct NeonGlowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat
    var intensity: Double

    func body(content: Content) -> some View {
        content
            .background(
                content
                    .blur(radius: radius * 0.45)
                    .opacity(intensity * 0.6)
            )
            .shadow(color: color.opacity(intensity * 0.9), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.55), radius: radius * 2, x: 0, y: radius * 0.3)
            .shadow(color: color.opacity(intensity * 0.3), radius: radius * 3.5, x: 0, y: radius * 0.5)
    }
}

extension View {
    /// Street-art neon glow — layered shadows plus a blurred self-backing pass.
    /// Use on buttons, badges, pins, and hero symbols.
    func addNeonGlow(color: Color = AppTheme.neonEmber, radius: CGFloat = 14, intensity: Double = 1.0) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius, intensity: intensity))
    }

    /// Soft ambient glow without the blurred self-pass — lighter, for ambient highlights.
    func softGlow(color: Color = AppTheme.neonEmber, radius: CGFloat = 12) -> some View {
        self
            .shadow(color: color.opacity(0.55), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.25), radius: radius * 2.5, x: 0, y: 0)
    }
}

/// Pulsing glow driver — useful for "live" elements (active pins, recording badges).
struct PulsingGlow: ViewModifier {
    @State private var pulse = false
    var color: Color
    var radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(pulse ? 0.85 : 0.35), radius: pulse ? radius * 1.6 : radius, x: 0, y: 0)
            .shadow(color: color.opacity(pulse ? 0.5 : 0.2), radius: pulse ? radius * 3.0 : radius * 1.8, x: 0, y: 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
    }
}

extension View {
    func pulsingGlow(color: Color = AppTheme.neonEmber, radius: CGFloat = 12) -> some View {
        modifier(PulsingGlow(color: color, radius: radius))
    }
}
