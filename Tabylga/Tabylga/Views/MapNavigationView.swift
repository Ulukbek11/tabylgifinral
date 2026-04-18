import SwiftUI
import MapKit

struct MapNavigationView: View {
    @Environment(AppViewModel.self) var appViewModel: AppViewModel
    @State private var viewModel = MapViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack(alignment: .top) {
            Map(position: $viewModel.cameraPosition) {
                ForEach(viewModel.route.locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        NeonMapPin(
                            symbol: location.badgeSymbol,
                            isActive: viewModel.selectedLocation?.id == location.id
                        )
                        .onTapGesture {
                            viewModel.select(location)
                        }
                    }
                }
                Annotation("You", coordinate: viewModel.userCoordinate) {
                    UserPulsePin()
                }

                if viewModel.showRouteOverlay, let selectedLoc = viewModel.selectedLocation {
                    MapPolyline(points: [
                        MKMapPoint(viewModel.userCoordinate),
                        MKMapPoint(selectedLoc.coordinate)
                    ])
                    .stroke(AppTheme.neonEmber, lineWidth: 4)
                }
            }
            .mapStyle(.standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll))
            .ignoresSafeArea()
            .overlay(
                LinearGradient(
                    colors: [.black.opacity(0.55), .clear, .clear, .black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
                .ignoresSafeArea()
            )
            .colorScheme(.dark)

            VStack(spacing: 0) {
                if viewModel.isShowingNearestBanner {
                    nearestRouteBanner
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                topHeader
            }

            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    nearestPlaceButton
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    addPlaceButton
                        .padding(.trailing, 20)
                }
                .padding(.bottom, viewModel.selectedLocation != nil ? 20 : 110)

                if let _ = viewModel.selectedLocation {
                    if viewModel.showRouteOverlay {
                        transportTypeSelector
                    } else {
                        locationActionOverlay
                    }
                }
            }
            .animation(.spring(), value: viewModel.selectedLocation)
            .animation(.spring(), value: viewModel.showRouteOverlay)
        }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if let loc = viewModel.selectedLocation {
                CheckInBottomSheetView(location: loc)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(32)
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $viewModel.showAddPlaceSheet) {
            SubmitPlaceView(loc: appViewModel.loc)
                .presentationDetents([.large])
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(32)
                .presentationDragIndicator(.visible)
        }
    }

    private var nearestRouteBanner: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(AppTheme.neonEmber)
                .frame(width: 6, height: 6)
                .pulsingGlow(color: AppTheme.neonEmber, radius: 6)
            
            Text(appViewModel.loc.nearestRouteBanner)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AppTheme.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(AppTheme.obsidianElevated.opacity(0.8))
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(AppTheme.neonEmber.opacity(0.5), lineWidth: 1))
        .padding(.top, 12)
        .padding(.bottom, 4)
    }

    private var topHeader: some View {
        HStack(spacing: 12) {
            if !viewModel.searchText.isEmpty || viewModel.selectedLocation != nil {
                Button {
                    withAnimation(.spring(response: 0.35)) {
                        viewModel.clearSearch()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .frame(width: 42, height: 42)
                        .glassCard(cornerRadius: 14)
                }
                .transition(.scale.combined(with: .opacity))
            }

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppTheme.heritageGold)
                
                TextField(appViewModel.loc.searchPlaceholder, text: $viewModel.searchText)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                    .tint(AppTheme.neonEmber)
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 42)
            .glassCard(cornerRadius: 14)

            Button {} label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(width: 42, height: 42)
                    .glassCard(cornerRadius: 14)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var addPlaceButton: some View {
        Button {
            viewModel.showAddPlaceSheet = true
        } label: {
            ZStack {
                Circle()
                    .fill(AppTheme.emberGradient)
                    .frame(width: 60, height: 60)
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            }
            .addNeonGlow(color: AppTheme.neonEmber, radius: 12)
        }
        .buttonStyle(.plain)
    }

    private var nearestPlaceButton: some View {
        Button {
            viewModel.selectNearest()
        } label: {
            ZStack {
                Circle()
                    .fill(AppTheme.obsidianElevated.opacity(0.8))
                    .frame(width: 60, height: 60)
                    .overlay(Circle().strokeBorder(AppTheme.heritageGold.opacity(0.5), lineWidth: 1.5))
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(AppTheme.goldGradient)
            }
            .addNeonGlow(color: AppTheme.heritageGold, radius: 10)
        }
        .buttonStyle(.plain)
    }

    private var locationActionOverlay: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppTheme.neonEmber)
                        .frame(width: 8, height: 8)
                        .pulsingGlow(color: AppTheme.neonEmber, radius: 8)
                    Text(appViewModel.loc.selectedLocation)
                        .font(.caption2)
                        .kerning(3)
                        .foregroundStyle(AppTheme.neonEmber)
                }
                Spacer()
                Button {
                    viewModel.cancelRoute()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }

            Text(viewModel.selectedLocationName)
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.textPrimary)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(String(format: "%.1f", viewModel.distanceToSelected)) km")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(AppTheme.goldGradient)
                Text(appViewModel.loc.crowsDistance)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.textTertiary)
            }

            HStack(spacing: 12) {
                Button {
                    viewModel.isSheetPresented = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                        Text(appViewModel.loc.details)
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.obsidianElevated)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(AppTheme.glassStroke, lineWidth: 1))
                }

                Button {
                    viewModel.startRoute()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text(appViewModel.loc.buildRoute)
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.emberGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .addNeonGlow(color: AppTheme.neonEmber, radius: 10)
                }
            }
        }
        .padding(20)
        .deepGlass(cornerRadius: 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 110)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var transportTypeSelector: some View {
        VStack(spacing: 16) {
            HStack {
                Text(appViewModel.loc.transportMode)
                    .font(.caption2)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
                Spacer()
                Button {
                    withAnimation { viewModel.showRouteOverlay = false }
                } label: {
                    Text(appViewModel.loc.back)
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }
            
            HStack(spacing: 12) {
                TransportOptionButton(icon: "car.fill", label: appViewModel.loc.car, type: .automobile, current: viewModel.transportType) {
                    viewModel.transportType = .automobile
                }
                TransportOptionButton(icon: "bicycle", label: appViewModel.loc.cycle, type: .walking, current: viewModel.transportType) {
                    viewModel.transportType = .walking
                }
                TransportOptionButton(icon: "figure.walk", label: appViewModel.loc.walk, type: .walking, current: viewModel.transportType) {
                    viewModel.transportType = .walking
                }
            }
        }
        .padding(20)
        .deepGlass(cornerRadius: 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 110)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// MARK: - Helper Components

struct TransportOptionButton: View {
    let icon: String
    let label: String
    let type: MKDirectionsTransportType
    let current: MKDirectionsTransportType
    let action: () -> Void
    
    var isSelected: Bool { type == current }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(isSelected ? .white : AppTheme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? AppTheme.neonEmber.opacity(0.3) : Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? AppTheme.neonEmber : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Submit Place View

struct SubmitPlaceView: View {
    let loc: AppStrings
    @Environment(\.dismiss) private var dismiss
    @State private var description: String = ""
    @State private var geoTag: String = ""
    @State private var isSubmitting: Bool = false
    @State private var showSuccess: Bool = false

    var body: some View {
        ZStack {
            AppTheme.obsidian.ignoresSafeArea()
            EthnoOrnamentBackground()
            
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.discovery)
                            .font(.system(size: 10, weight: .black))
                            .kerning(3)
                            .foregroundStyle(AppTheme.heritageGold)
                        Text(loc.newHeritageSite)
                            .font(.system(size: 28, weight: .heavy, design: .serif))
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(loc.discoveryDesc)
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                            .lineSpacing(4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Label(loc.description, systemImage: "pencil.and.outline")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(2)
                                .foregroundStyle(AppTheme.heritageGold)
                            
                            TextEditor(text: $description)
                                .frame(height: 120)
                                .padding(12)
                                .scrollContentBackground(.hidden)
                                .background(AppTheme.obsidianElevated.opacity(0.6))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(AppTheme.glassStroke, lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Label(loc.geolocation, systemImage: "mappin.and.ellipse")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(2)
                                .foregroundStyle(AppTheme.heritageGold)
                            
                            TextField("e.g. 42.123, 77.456", text: $geoTag)
                                .padding(16)
                                .background(AppTheme.obsidianElevated.opacity(0.6))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(AppTheme.glassStroke, lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Label(loc.photos, systemImage: "camera.fill")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(2)
                                .foregroundStyle(AppTheme.heritageGold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Button {
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(systemName: "plus")
                                                .font(.title2)
                                            Text(loc.add)
                                                .font(.system(size: 10, weight: .bold))
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(AppTheme.heritageGold.opacity(0.1))
                                        .cornerRadius(16)
                                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(AppTheme.heritageGold.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [4])))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        Button {
                            submit()
                        } label: {
                            HStack {
                                if isSubmitting {
                                    ProgressView().tint(.white)
                                } else {
                                    Text(loc.sendToKeepers)
                                        .font(.system(size: 18, weight: .bold))
                                    Spacer()
                                    Image(systemName: "paperplane.fill")
                                }
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.emberGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .addNeonGlow(color: AppTheme.neonEmber, radius: 10)
                        }
                        .disabled(description.isEmpty || isSubmitting)
                        .opacity(description.isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding(24)
            
            if showSuccess {
                SuccessOverlay(loc: loc)
            }
        }
    }
    
    private func submit() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            withAnimation { showSuccess = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                dismiss()
            }
        }
    }
}

struct SuccessOverlay: View {
    let loc: AppStrings
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundStyle(AppTheme.heritageGold)
                .addNeonGlow(color: AppTheme.heritageGold, radius: 20)
            
            Text(loc.knowledgeReceived)
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.textPrimary)
            
            Text(loc.verifySite)
                .font(.callout)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.obsidian.opacity(0.95))
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Other Components

struct NeonMapPin: View {
    let symbol: String
    var isActive: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.obsidian)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .strokeBorder(AppTheme.neonEmber, lineWidth: 1.5)
                )
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppTheme.goldGradient)
        }
        .addNeonGlow(
            color: AppTheme.neonEmber,
            radius: isActive ? 20 : 14,
            intensity: isActive ? 1.0 : 0.8
        )
        .scaleEffect(isActive ? 1.15 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActive)
    }
}

struct UserPulsePin: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.heritageGold.opacity(0.2))
                .frame(width: pulse ? 46 : 22, height: pulse ? 46 : 22)
                .opacity(pulse ? 0 : 0.7)
            Circle()
                .fill(AppTheme.heritageGold)
                .frame(width: 14, height: 14)
                .overlay(Circle().strokeBorder(.white, lineWidth: 2))
        }
        .addNeonGlow(color: AppTheme.heritageGold, radius: 10, intensity: 0.8)
        .onAppear {
            withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

#Preview {
    MapNavigationView()
        .environment(AppViewModel())
}
