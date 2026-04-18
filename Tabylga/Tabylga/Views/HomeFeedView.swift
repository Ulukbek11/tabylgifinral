import SwiftUI

struct HomeFeedView: View {
    @Environment(AppViewModel.self) var appViewModel: AppViewModel
    @State private var viewModel = RouteViewModel()
    @State private var showCalendarDetail = false
    @State private var showFullCycle = false
    @State private var showAllRoutes = false
    @State private var selectedRoute: Route?

    var body: some View {
        ZStack {
            EthnoOrnamentBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    greeting
                    calendarHeader
                    calendarCardButton
                    routesSection
                    loreSection
                        .padding(.bottom, 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $showCalendarDetail) {
            CalendarDetailView(month: viewModel.calendarMonth, loc: appViewModel.loc)
        }
        .sheet(isPresented: $showFullCycle) {
            NomadicCycleView(loc: appViewModel.loc)
        }
        .sheet(isPresented: $showAllRoutes) {
            AllRoutesView(routes: viewModel.routes, loc: appViewModel.loc) { route in
                selectedRoute = route
                showAllRoutes = false
            }
        }
        .sheet(item: $selectedRoute) { route in
            RouteDetailView(route: route, loc: appViewModel.loc) {
                viewModel.select(route)
                appViewModel.openRouteTab()
            }
        }
    }

    private var greeting: some View {
        HStack(alignment: .top) {
            @Bindable var appViewModel = appViewModel
            VStack(alignment: .leading, spacing: 6) {
                Text(appViewModel.loc.greeting)
                    .font(.caption)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
                Text(appViewModel.loc.greetingSubtitle)
                    .font(.system(size: 28, weight: .heavy, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            Spacer()
            
            HStack(spacing: 12) {
                // Language Selector
                Menu {
                    ForEach(AppViewModel.Language.allCases) { lang in
                        Button {
                            appViewModel.selectedLanguage = lang
                        } label: {
                            HStack {
                                Text(lang.rawValue)
                                if appViewModel.selectedLanguage == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(AppTheme.obsidianElevated)
                            .frame(width: 44, height: 44)
                            .overlay(Circle().strokeBorder(AppTheme.glassStroke, lineWidth: 1))
                        Text(appViewModel.selectedLanguage == .english ? "EN" : (appViewModel.selectedLanguage == .russian ? "RU" : "KG"))
                            .font(.system(size: 14, weight: .black))
                            .foregroundStyle(AppTheme.heritageGold)
                    }
                }

                // Notification (Original)
                ZStack {
                    Circle()
                        .fill(AppTheme.obsidianElevated)
                        .frame(width: 44, height: 44)
                        .overlay(Circle().strokeBorder(AppTheme.glassStroke, lineWidth: 1))
                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppTheme.heritageGold)
                    Circle()
                        .fill(AppTheme.neonEmber)
                        .frame(width: 8, height: 8)
                        .offset(x: 12, y: -12)
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 6)
                }
            }
        }
    }

    private var calendarHeader: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppTheme.heritageGold)
                Text(appViewModel.loc.nomadicCalendar)
                    .font(.caption2)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
            }
            Spacer()
            
            Button {
                showFullCycle = true
            } label: {
                HStack(spacing: 6) {
                    Text(appViewModel.loc.fullCycle)
                        .font(.system(size: 10, weight: .bold))
                        .kerning(1)
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 12))
                }
                .foregroundStyle(AppTheme.neonEmber)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(AppTheme.neonEmber.opacity(0.12)))
                .overlay(Capsule().strokeBorder(AppTheme.neonEmber.opacity(0.3), lineWidth: 1))
            }
        }
    }

    private var calendarCardButton: some View {
        Button {
            showCalendarDetail = true
        } label: {
            calendarCard
        }
        .buttonStyle(.plain)
    }

    private var calendarCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                Text(viewModel.calendarMonth.gregorianEquivalent.uppercased())
                    .font(.caption2)
                    .kerning(2)
                    .foregroundStyle(AppTheme.textTertiary)
            }

            HStack(alignment: .top, spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(AppTheme.heritageGold.opacity(0.4), lineWidth: 1)
                        .frame(width: 72, height: 72)
                    Circle()
                        .stroke(AppTheme.neonEmber.opacity(0.35), lineWidth: 1)
                        .frame(width: 52, height: 52)
                    Image(systemName: viewModel.calendarMonth.glyph)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(AppTheme.goldGradient)
                        .addNeonGlow(color: AppTheme.heritageGold, radius: 12, intensity: 0.8)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.calendarMonth.kyrgyzName)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(viewModel.calendarMonth.traditionalMeaning)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Divider().overlay(AppTheme.glassStroke)

            VStack(alignment: .leading, spacing: 10) {
                CalendarRow(
                    icon: "sparkles",
                    tint: AppTheme.heritageGold,
                    title: appViewModel.loc.celestial,
                    text: viewModel.calendarMonth.celestialEvent
                )
                CalendarRow(
                    icon: "leaf.fill",
                    tint: AppTheme.neonEmber,
                    title: appViewModel.loc.season,
                    text: viewModel.calendarMonth.seasonalActivity
                )
            }
        }
        .padding(20)
        .deepGlass(cornerRadius: 24)
    }

    private var routesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(AppTheme.neonEmber)
                        .frame(width: 18, height: 2)
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 6, intensity: 0.7)
                    Text(appViewModel.loc.routesForged)
                        .font(.caption)
                        .kerning(3)
                        .foregroundStyle(AppTheme.neonEmber)
                }
                Spacer()
                
                Button {
                    showAllRoutes = true
                } label: {
                    Text(appViewModel.loc.seeAll)
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.routes) { route in
                        RouteCard(route: route) {
                            selectedRoute = route
                        }
                        .frame(width: 300)
                        .visualEffect { content, proxy in
                            content
                                .scaleEffect(scale(proxy: proxy))
                                .opacity(opacity(proxy: proxy))
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }

    nonisolated private func scale(proxy: GeometryProxy) -> CGFloat {
        let centerX = proxy.bounds(of: .scrollView)?.midX ?? 0
        let itemX = proxy.frame(in: .scrollView).midX
        let distance = abs(centerX - itemX)
        let scale = 1.0 - (distance / 1200)
        return max(0.85, scale)
    }

    nonisolated private func opacity(proxy: GeometryProxy) -> Double {
        let centerX = proxy.bounds(of: .scrollView)?.midX ?? 0
        let itemX = proxy.frame(in: .scrollView).midX
        let distance = abs(centerX - itemX)
        let opacity = 1.0 - (distance / 1000)
        return max(0.6, opacity)
    }

    private var loreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.heritageGold)
                    .frame(width: 18, height: 2)
                Text(appViewModel.loc.todayLore)
                    .font(.caption)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(appViewModel.loc.loreTitle)
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                Text(appViewModel.loc.loreContent)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                    .lineSpacing(3)
            }
            .padding(20)
            .glassCard(cornerRadius: 22)
        }
    }
}

// MARK: - Components

struct CalendarRow: View {
    let icon: String
    let tint: Color
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 22, height: 22)
                .background(Circle().fill(tint.opacity(0.12)))
            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .kerning(2)
                    .foregroundStyle(AppTheme.textTertiary)
                Text(text)
                    .font(.caption)
                    .foregroundStyle(AppTheme.textPrimary.opacity(0.88))
                    .lineSpacing(2)
            }
        }
    }
}

struct RouteCard: View {
    let route: Route
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        colors: [
                            AppTheme.neonEmber.opacity(0.35),
                            AppTheme.heritageGold.opacity(0.18),
                            AppTheme.obsidian
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 150)

                    Image(systemName: route.heroSymbol)
                        .font(.system(size: 110, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.08))
                        .offset(x: 140, y: -20)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            ForEach(route.tags.prefix(2), id: \.self) { tag in
                                Text(tag.uppercased())
                                    .font(.system(size: 9, weight: .black))
                                    .kerning(1.5)
                                    .foregroundStyle(AppTheme.textPrimary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.black.opacity(0.35))
                                            .overlay(Capsule().strokeBorder(AppTheme.heritageGold.opacity(0.4), lineWidth: 0.8))
                                    )
                            }
                            Spacer()
                        }
                        Spacer()
                        Text(route.region.uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .kerning(2)
                            .foregroundStyle(AppTheme.heritageGold)
                    }
                    .padding(16)
                    .frame(height: 150, alignment: .top)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(route.title)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(route.subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 14) {
                        Label("\(Int(route.distanceKm)) km", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                            .labelStyle(.titleAndIcon)
                        Label(route.durationLabel, systemImage: "clock")
                    }
                    .font(.caption2)
                    .foregroundStyle(AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
            .glassCard(cornerRadius: 22)
            .softGlow(color: AppTheme.neonEmber.opacity(0.25), radius: 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Views

struct AllRoutesView: View {
    let routes: [Route]
    let loc: AppStrings
    let onSelect: (Route) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.obsidian.ignoresSafeArea()
            EthnoOrnamentBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text(loc.allRoutes)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.textPrimary)
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(routes) { route in
                            RouteCard(route: route) {
                                onSelect(route)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct RouteDetailView: View {
    let route: Route
    let loc: AppStrings
    let onStartTrip: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.obsidian.ignoresSafeArea()
            EthnoOrnamentBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    HStack {
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(route.region.uppercased())
                            .font(.system(size: 12, weight: .bold))
                            .kerning(3)
                            .foregroundStyle(AppTheme.heritageGold)
                        
                        Text(route.title)
                            .font(.system(size: 36, weight: .heavy, design: .serif))
                            .foregroundStyle(AppTheme.textPrimary)
                        
                        Text(route.subtitle)
                            .font(.title3)
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    HStack(spacing: 24) {
                        StatItem(icon: "point.topleft.down.to.point.bottomright.curvepath", value: "\(Int(route.distanceKm)) km", label: loc.distance)
                        StatItem(icon: "clock", value: route.durationLabel, label: loc.time)
                        StatItem(icon: "map.fill", value: "\(route.locations.count)", label: loc.waypoints)
                    }
                    .padding(20)
                    .glassCard(cornerRadius: 22)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "tent.fill")
                                .foregroundStyle(AppTheme.neonEmber)
                            Text(loc.routeLegend)
                                .font(.system(size: 10, weight: .black))
                                .kerning(2)
                                .foregroundStyle(AppTheme.neonEmber)
                        }
                        
                        Text(route.legend)
                            .font(.body)
                            .foregroundStyle(AppTheme.textPrimary.opacity(0.9))
                            .lineSpacing(6)
                    }
                    .padding(24)
                    .deepGlass(cornerRadius: 24)

                    VStack(alignment: .leading, spacing: 16) {
                        Text(loc.keyLocations)
                            .font(.system(size: 10, weight: .black))
                            .kerning(2)
                            .foregroundStyle(AppTheme.heritageGold)
                        
                        ForEach(route.locations) { location in
                            HStack(spacing: 16) {
                                Image(systemName: location.badgeSymbol)
                                    .font(.title2)
                                    .foregroundStyle(AppTheme.heritageGold)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(AppTheme.heritageGold.opacity(0.1)))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(location.name)
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Text(location.shortSummary)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.textSecondary)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(AppTheme.textTertiary)
                            }
                            .padding(14)
                            .glassCard(cornerRadius: 16)
                        }
                    }

                    Button {
                        onStartTrip()
                        dismiss()
                    } label: {
                        HStack {
                            Text(loc.startTrip)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(AppTheme.emberGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 12)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.heritageGold)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(label.uppercased())
                .font(.system(size: 8, weight: .black))
                .foregroundStyle(AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CalendarDetailView: View {
    let month: NomadicCalendarMonth
    let loc: AppStrings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.obsidian.ignoresSafeArea()
            EthnoOrnamentBackground()
            
            VStack(alignment: .leading, spacing: 32) {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(AppTheme.heritageGold.opacity(0.3), lineWidth: 1)
                                .frame(width: 100, height: 100)
                            Image(systemName: month.glyph)
                                .font(.system(size: 44))
                                .foregroundStyle(AppTheme.goldGradient)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(month.kyrgyzName)
                                .font(.system(size: 32, weight: .heavy, design: .serif))
                                .foregroundStyle(AppTheme.textPrimary)
                            Text(month.gregorianEquivalent.uppercased())
                                .font(.caption)
                                .kerning(2)
                                .foregroundStyle(AppTheme.heritageGold)
                        }
                    }
                    
                    Text(month.traditionalMeaning)
                        .font(.body)
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineSpacing(4)
                }

                VStack(alignment: .leading, spacing: 24) {
                    DetailRow(title: loc.celestialEventLabel, value: month.celestialEvent, icon: "sparkles")
                    DetailRow(title: loc.seasonalActivity, value: month.seasonalActivity, icon: "leaf.fill")
                    DetailRow(title: loc.nomadicWisdom, value: "During \(month.kyrgyzName), the ancestors watched the stars and the movement of the herds. It was a time of connection between the earth and the high heavens.", icon: "quote.opening")
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

struct NomadicCycleView: View {
    @Environment(\.dismiss) private var dismiss
    let loc: AppStrings
    private let months = MockData.calendarYear
    @State private var selectedMonth: NomadicCalendarMonth

    init(loc: AppStrings) {
        self.loc = loc
        _selectedMonth = State(initialValue: MockData.currentMonth)
    }

    private let monthColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    private let dayColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)

    var body: some View {
        ZStack {
            AppTheme.obsidian.ignoresSafeArea()
            EthnoOrnamentBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MÜCHEL")
                            .font(.system(size: 10, weight: .black))
                            .kerning(3)
                            .foregroundStyle(AppTheme.heritageGold)
                        Text("Traditional Cycle")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(24)
                
                ScrollView {
                    VStack(spacing: 32) {
                        LazyVGrid(columns: monthColumns, spacing: 12) {
                            ForEach(months) { month in
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selectedMonth = month
                                    }
                                } label: {
                                    VStack(spacing: 10) {
                                        Image(systemName: month.glyph)
                                            .font(.system(size: 24))
                                            .foregroundStyle(selectedMonth.id == month.id ? AppTheme.neonEmber : AppTheme.heritageGold)
                                        
                                        Text(month.kyrgyzName.components(separatedBy: " ").first ?? "")
                                            .font(.system(size: 11, weight: .bold, design: .serif))
                                            .foregroundStyle(selectedMonth.id == month.id ? AppTheme.textPrimary : AppTheme.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(selectedMonth.id == month.id ? AppTheme.neonEmber.opacity(0.12) : AppTheme.obsidianElevated.opacity(0.4))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .strokeBorder(selectedMonth.id == month.id ? AppTheme.neonEmber.opacity(0.6) : AppTheme.glassStroke, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Text("\(selectedMonth.kyrgyzName) Days")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(AppTheme.textPrimary)
                                Spacer()
                                Image(systemName: "moon.phase.full.moon.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppTheme.heritageGold)
                            }
                            
                            LazyVGrid(columns: dayColumns, spacing: 12) {
                                ForEach(1...30, id: \.self) { day in
                                    let type = dayType(for: day)
                                    ZStack {
                                        Circle()
                                            .fill(type.color.opacity(type == .normal ? 0.05 : 0.2))
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(type.color.opacity(type == .normal ? 0.1 : 0.9), lineWidth: type == .normal ? 1 : 2)
                                            )
                                        
                                        Text("\(day)")
                                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                                            .foregroundStyle(type == .normal ? AppTheme.textSecondary : type.color)
                                            .fixedSize()
                                    }
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .shadow(color: type.color.opacity(type == .normal ? 0 : 0.5), radius: 6)
                                }
                            }
                            
                            Divider().overlay(AppTheme.glassStroke)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(loc.calendarLegend)
                                    .font(.system(size: 10, weight: .black))
                                    .kerning(2)
                                    .foregroundStyle(AppTheme.textTertiary)
                                
                                HStack(spacing: 24) {
                                    LegendItem(color: AppTheme.heritageGold, label: loc.fullMoon)
                                    LegendItem(color: AppTheme.neonEmber, label: loc.sacredRite)
                                    LegendItem(color: Color.cyan, label: loc.celestialEvent)
                                }
                            }
                        }
                        .padding(28)
                        .glassCard(cornerRadius: 32)
                        .padding(.horizontal, 24)
                        .id(selectedMonth.id)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(selectedMonth.traditionalMeaning)
                                .font(.system(size: 16))
                                .foregroundStyle(AppTheme.textSecondary)
                                .lineSpacing(5)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
    }
    
    enum DayHighlight {
        case normal, fullMoon, ritual, celestial
        var color: Color {
            switch self {
            case .normal: return Color.white
            case .fullMoon: return AppTheme.heritageGold
            case .ritual: return AppTheme.neonEmber
            case .celestial: return Color.cyan
            }
        }
    }
    
    private func dayType(for day: Int) -> DayHighlight {
        if day == 14 || day == 15 { return .fullMoon }
        if day == 1 || day == 21 { return .ritual }
        if day == 9 || day == 25 { return .celestial }
        return .normal
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.system(size: 10, weight: .bold)).foregroundStyle(AppTheme.textSecondary)
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(AppTheme.heritageGold)
                .frame(width: 44, height: 44)
                .background(Circle().fill(AppTheme.heritageGold.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(.caption2)
                    .kerning(2)
                    .foregroundStyle(AppTheme.heritageGold)
                Text(value)
                    .font(.callout)
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineSpacing(2)
            }
        }
    }
}

#Preview {
    HomeFeedView()
        .environment(AppViewModel())
}
