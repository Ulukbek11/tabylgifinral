import SwiftUI

struct CheckInBottomSheetView: View {
    let location: LocationPoint
    @Environment(\.dismiss) private var dismiss
    @State private var isClaimed: Bool = false
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            AppTheme.obsidian.opacity(0.3).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    meaningBlock
                    legendBlock
                    if !location.healingProperties.isEmpty {
                        healingBlock
                    }
                    claimButton
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }

            if showConfetti {
                GlowBurst()
                    .allowsHitTesting(false)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(AppTheme.obsidianElevated)
                        .frame(width: 56, height: 56)
                        .overlay(Circle().strokeBorder(AppTheme.neonEmber.opacity(0.7), lineWidth: 1.2))
                    Image(systemName: location.badgeSymbol)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AppTheme.goldGradient)
                }
                .addNeonGlow(color: AppTheme.neonEmber, radius: 16, intensity: 0.8)

                VStack(alignment: .leading, spacing: 3) {
                    Text(location.heritageEra.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .kerning(2)
                        .foregroundStyle(AppTheme.heritageGold)
                    Text(location.name)
                        .font(.system(size: 26, weight: .heavy, design: .serif))
                        .foregroundStyle(AppTheme.textPrimary)
                }
                Spacer()
            }

            NomadicBorder()
                .frame(height: 10)
                .opacity(0.6)
        }
    }

    private var meaningBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NAME MEANING")
                .font(.system(size: 10, weight: .bold))
                .kerning(3)
                .foregroundStyle(AppTheme.neonEmber)
            Text(location.nameMeaning)
                .font(.system(size: 16, weight: .medium, design: .serif))
                .italic()
                .foregroundStyle(AppTheme.textPrimary)
                .lineSpacing(4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }

    private var legendBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppTheme.heritageGold)
                Text("CULTURAL LEGEND")
                    .font(.system(size: 10, weight: .bold))
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
            }
            Text(location.culturalLegend)
                .font(.callout)
                .foregroundStyle(AppTheme.textSecondary)
                .lineSpacing(4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }

    private var healingBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppTheme.neonEmber)
                Text("HEALING PROPERTIES")
                    .font(.system(size: 10, weight: .bold))
                    .kerning(3)
                    .foregroundStyle(AppTheme.neonEmber)
            }
            FlowLayout(spacing: 8) {
                ForEach(location.healingProperties, id: \.self) { prop in
                    Text(prop)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(AppTheme.obsidianElevated)
                                .overlay(Capsule().strokeBorder(AppTheme.heritageGold.opacity(0.4), lineWidth: 1))
                        )
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }

    private var claimButton: some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isClaimed = true
            }
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                showConfetti = false
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isClaimed ? "checkmark.seal.fill" : "flame.fill")
                    .font(.system(size: 18, weight: .black))
                Text(isClaimed ? "Petroglyph Claimed" : "Claim Petroglyph Badge")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .kerning(1)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .black))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(isClaimed ? AppTheme.goldGradient : AppTheme.emberGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .addNeonGlow(
            color: isClaimed ? AppTheme.heritageGold : AppTheme.neonEmber,
            radius: 22,
            intensity: 1.0
        )
        .disabled(isClaimed)
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > maxWidth {
                x = 0
                y += rowH + spacing
                rowH = 0
            }
            x += s.width + spacing
            rowH = max(rowH, s.height)
        }
        return CGSize(width: maxWidth, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowH: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX {
                x = bounds.minX
                y += rowH + spacing
                rowH = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing
            rowH = max(rowH, s.height)
        }
    }
}

// MARK: - Claim celebration

private struct GlowBurst: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<14, id: \.self) { i in
                Circle()
                    .fill(i % 2 == 0 ? AppTheme.neonEmber : AppTheme.heritageGold)
                    .frame(width: 10, height: 10)
                    .offset(
                        x: cos(Double(i) / 14 * 2 * .pi) * (animate ? 180 : 0),
                        y: sin(Double(i) / 14 * 2 * .pi) * (animate ? 180 : 0)
                    )
                    .opacity(animate ? 0 : 1)
                    .addNeonGlow(color: i % 2 == 0 ? AppTheme.neonEmber : AppTheme.heritageGold, radius: 8)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.8)) {
                animate = true
            }
        }
    }
}

#Preview {
    CheckInBottomSheetView(location: MockData.manjylyAta)
}
