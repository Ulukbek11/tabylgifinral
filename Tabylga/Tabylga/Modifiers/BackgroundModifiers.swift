import SwiftUI

/// Ambient ornamental glyphs drifting in the background — ethno-graffiti texture layer.
struct EthnoOrnamentBackground: View {
    var body: some View {
        ZStack {
            AppTheme.obsidianGradient
                .ignoresSafeArea()

            // Radial ember wash at top-left
            RadialGradient(
                colors: [AppTheme.neonEmber.opacity(0.18), .clear],
                center: .topLeading,
                startRadius: 4,
                endRadius: 340
            )
            .blur(radius: 30)
            .ignoresSafeArea()

            // Gold wash at bottom-right
            RadialGradient(
                colors: [AppTheme.heritageGold.opacity(0.08), .clear],
                center: .bottomTrailing,
                startRadius: 6,
                endRadius: 400
            )
            .blur(radius: 40)
            .ignoresSafeArea()

            // Grain overlay
            Color.black.opacity(0.15)
                .ignoresSafeArea()
        }
    }
}

struct OrnamentShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: 0, y: h / 2))
        p.addCurve(
            to: CGPoint(x: w, y: h / 2),
            control1: CGPoint(x: w * 0.25, y: 0),
            control2: CGPoint(x: w * 0.75, y: h)
        )
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5, y: h))
        return p
    }
}

/// A decorative nomadic border — thin gold lines reminiscent of yurt embroidery.
struct NomadicBorder: View {
    var color: Color = AppTheme.heritageGold.opacity(0.5)

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 4, height: 4)
            Rectangle().fill(color).frame(height: 1)
            Circle().fill(color).frame(width: 6, height: 6)
                .overlay(Circle().stroke(color, lineWidth: 1).scaleEffect(1.8))
            Rectangle().fill(color).frame(height: 1)
            Circle().fill(color).frame(width: 4, height: 4)
        }
    }
}
