//
// StatsTab.swift
// PlayHub
//

import SwiftUI
import Charts


struct StatsTab: View {


    @StateObject private var vm =
    StatsVM()



    private var gamePerformance: [GamePerformance] {


        GameMode.allCases.map { mode in


            GamePerformance(
                mode: mode,
                score: vm.sessions
                    .filter { $0.mode == mode }
                    .map(\.score)
                    .max() ?? 0
            )


        }


    }



    private var averageScore: Int {


        guard !vm.sessions.isEmpty else {

            return 0

        }


        return vm.sessions
            .map(\.score)
            .reduce(0, +) / vm.sessions.count


    }



    private var favoriteGame: GameMode? {


        GameMode.allCases.max { first, second in


            vm.sessions
                .filter { $0.mode == first }
                .count
            <
            vm.sessions
                .filter { $0.mode == second }
                .count


        }


    }





    var body: some View {


        NavigationStack {


            ZStack {


                background



                ScrollView(
                    showsIndicators: false
                ) {


                    VStack(
                        alignment: .leading,
                        spacing: 20
                    ) {


                        pageTitle


                        heroCard


                        summaryGrid



                        if vm.sessions.isEmpty {


                            emptyState


                        }
                        else {


                            chartCard


                            scoreList


                            historyButton


                        }


                    }

                    .padding(.horizontal, 20)

                    .padding(.top, 12)

                    .padding(.bottom, 35)


                }


            }


            .toolbar(.hidden, for: .navigationBar)


        }


        .onAppear {


            vm.load()


        }


        .onReceive(
            NotificationCenter.default.publisher(
                for: .gameHistoryCleared
            )
        ) { _ in


            vm.load()


        }


    }





    // MARK: - Page Title


    private var pageTitle: some View {


        HStack {


            VStack(
                alignment: .leading,
                spacing: 5
            ) {


                Text("Stats")

                    .font(
                        .system(
                            size: 36,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                    .foregroundStyle(.white)



                Text("Track your PlayHub performance")

                    .font(.subheadline)

                    .foregroundStyle(
                        .white.opacity(0.58)
                    )


            }



            Spacer()



            Image(
                systemName: "chart.xyaxis.line"
            )

            .font(
                .system(
                    size: 20,
                    weight: .bold
                )
            )

            .foregroundStyle(.white)

            .frame(
                width: 48,
                height: 48
            )

            .background(
                .white.opacity(0.12),
                in: Circle()
            )

            .overlay {


                Circle()

                    .stroke(
                        .white.opacity(0.12),
                        lineWidth: 1
                    )


            }


        }

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )


    }





    // MARK: - Background


    private var background: some View {


        ZStack {


            LinearGradient(
                colors: [
                    PlayHubTheme.navy,
                    PlayHubTheme.navyLight
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )



            Circle()

                .fill(
                    Color.white.opacity(0.12)
                )

                .frame(
                    width: 280,
                    height: 280
                )

                .blur(
                    radius: 90
                )

                .offset(
                    x: -150,
                    y: -320
                )



            Circle()

                .fill(
                    Color.white.opacity(0.06)
                )

                .frame(
                    width: 280,
                    height: 280
                )

                .blur(
                    radius: 100
                )

                .offset(
                    x: 170,
                    y: 330
                )


        }

        .ignoresSafeArea()


    }





    // MARK: - Hero Card


    private var heroCard: some View {


        VStack(
            alignment: .leading,
            spacing: 16
        ) {


            HStack {


                Label(
                    "YOUR PROGRESS",
                    systemImage: "sparkles"
                )

                .font(
                    .caption.weight(.bold)
                )

                .tracking(1)

                .foregroundStyle(
                    .white.opacity(0.75)
                )



                Spacer()



                Image(
                    systemName:
                        "chart.line.uptrend.xyaxis"
                )

                .font(
                    .title2.weight(.bold)
                )

                .foregroundStyle(.white)

                .frame(
                    width: 44,
                    height: 44
                )

                .background(
                    .white.opacity(0.16),
                    in: Circle()
                )


            }



            Text(
                vm.sessions.isEmpty
                ? "Your next high score starts here."
                : "Keep the momentum going."
            )

            .font(
                .title2.weight(.bold)
            )

            .foregroundStyle(.white)



            HStack(
                alignment: .lastTextBaseline,
                spacing: 8
            ) {


                Text("\(vm.bestScore)")

                    .font(
                        .system(
                            size: 42,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                    .foregroundStyle(.white)



                Text("personal best")

                    .font(
                        .subheadline.weight(.medium)
                    )

                    .foregroundStyle(
                        .white.opacity(0.78)
                    )


            }


        }

        .padding(22)

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

        .background(
            LinearGradient(
                colors: [
                    PlayHubTheme.navyLight,
                    PlayHubTheme.blue
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )

        .shadow(
            color: .white.opacity(0.14),
            radius: 18,
            y: 10
        )


    }





    // MARK: - Summary Grid


    private var summaryGrid: some View {


        HStack(
            spacing: 12
        ) {


            metricCard(
                title: "Games played",
                value: "\(vm.totalGames)",
                icon: "gamecontroller.fill",
                color: .white
            )



            metricCard(
                title: "Average score",
                value: "\(averageScore)",
                icon: "scope",
                color: .white
            )



            metricCard(
                title: "Favourite",
                value:
                    favoriteGame?.rawValue ?? "—",
                icon: "heart.fill",
                color: .white,
                compactValue: true
            )


        }


    }





    private func metricCard(
        title: String,
        value: String,
        icon: String,
        color: Color,
        compactValue: Bool = false
    ) -> some View {


        VStack(
            alignment: .leading,
            spacing: 14
        ) {


            Image(
                systemName: icon
            )

            .font(
                .subheadline.weight(.bold)
            )

            .foregroundStyle(color)

            .frame(
                width: 30,
                height: 30
            )

            .background(
                color.opacity(0.16),
                in: Circle()
            )



            Text(value)

                .font(
                    compactValue
                    ? .subheadline.weight(.bold)
                    : .title2.weight(.bold)
                )

                .lineLimit(1)

                .minimumScaleFactor(0.65)

                .foregroundStyle(.white)



            Text(title)

                .font(.caption)

                .foregroundStyle(
                    .white.opacity(0.58)
                )


        }

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

        .padding(14)

        .background(
            .white.opacity(0.09),
            in: RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )

        .overlay {


            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )

            .stroke(
                .white.opacity(0.1),
                lineWidth: 1
            )


        }


    }





    // MARK: - Chart Card


    private var chartCard: some View {


        VStack(
            alignment: .leading,
            spacing: 18
        ) {


            HStack {


                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {


                    Text("High-score board")

                        .font(
                            .headline.weight(.bold)
                        )

                        .foregroundStyle(.white)



                    Text(
                        "Your best score in each game"
                    )

                    .font(.caption)

                    .foregroundStyle(
                        .white.opacity(0.58)
                    )


                }



                Spacer()



                Image(
                    systemName: "chart.bar.fill"
                )

                .foregroundStyle(.white)


            }



            Chart(
                gamePerformance
            ) { item in


                BarMark(
                    x: .value(
                        "Score",
                        item.score
                    ),
                    y: .value(
                        "Game",
                        item.mode.rawValue
                    )
                )

                .foregroundStyle(
                    color(
                        for: item.mode
                    ).gradient
                )

                .cornerRadius(7)

                .annotation(
                    position: .trailing
                ) {


                    Text("\(item.score)")

                        .font(
                            .caption.weight(.bold)
                        )

                        .foregroundStyle(
                            .white.opacity(0.8)
                        )


                }


            }

            .chartXAxis(.hidden)

            .chartYAxis {


                AxisMarks { value in


                    AxisValueLabel {


                        if let game =
                            value.as(String.self) {


                            Text(game)

                                .font(
                                    .caption.weight(.medium)
                                )

                                .foregroundStyle(
                                    .white.opacity(0.75)
                                )


                        }


                    }


                }


            }

            .frame(height: 185)


        }

        .padding(20)

        .glassCard()


    }





    // MARK: - Score List


    private var scoreList: some View {


        VStack(
            alignment: .leading,
            spacing: 12
        ) {


            Text("Game records")

                .font(
                    .headline.weight(.bold)
                )

                .foregroundStyle(.white)



            ForEach(
                gamePerformance
            ) { item in


                HStack(
                    spacing: 14
                ) {


                    Image(
                        systemName: item.mode.icon
                    )

                    .font(.headline)

                    .foregroundStyle(
                        color(
                            for: item.mode
                        )
                    )

                    .frame(
                        width: 44,
                        height: 44
                    )

                    .background(
                        color(
                            for: item.mode
                        ).opacity(0.16),
                        in: RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )



                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {


                        Text(
                            item.mode.rawValue
                        )

                        .font(
                            .subheadline.weight(.semibold)
                        )

                        .foregroundStyle(.white)



                        Text(
                            item.score == 0
                            ? "No score yet"
                            : "Highest score"
                        )

                        .font(.caption)

                        .foregroundStyle(
                            .white.opacity(0.55)
                        )


                    }



                    Spacer()



                    Text(
                        "\(item.score)"
                    )

                    .font(
                        .title3.weight(.bold)
                    )

                    .foregroundStyle(
                        item.score == 0
                        ? .white.opacity(0.45)
                        : .white
                    )


                }

                .padding(14)

                .background(
                    .white.opacity(0.07),
                    in: RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )


            }


        }


    }





    // MARK: - History Button


    private var historyButton: some View {


        NavigationLink {


            PlayerHistoryView()


        } label: {


            Label(
                "View full history",
                systemImage:
                    "clock.arrow.circlepath"
            )

            .font(.headline)

            .frame(
                maxWidth: .infinity
            )

            .padding(
                .vertical,
                16
            )

            .foregroundStyle(.white)

            .background(
                .white.opacity(0.13),
                in: RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
            )


        }


    }





    // MARK: - Empty State


    private var emptyState: some View {


        VStack(
            spacing: 14
        ) {


            Image(
                systemName:
                    "chart.bar.xaxis"
            )

            .font(
                .system(
                    size: 44,
                    weight: .light
                )
            )

            .foregroundStyle(.white)



            Text(
                "No games played yet"
            )

            .font(
                .title3.weight(.bold)
            )

            .foregroundStyle(.white)



            Text(
                "Play your first challenge to build your dashboard."
            )

            .font(.subheadline)

            .multilineTextAlignment(
                .center
            )

            .foregroundStyle(
                .white.opacity(0.62)
            )


        }

        .frame(
            maxWidth: .infinity
        )

        .padding(
            .vertical,
            42
        )

        .glassCard()


    }





    // MARK: - Game Colors


    private func color(
        for mode: GameMode
    ) -> Color {


        switch mode {


        case .tapFrenzy:

            return .white



        case .lightItUp:

            return .white



        case .quizRush:

            return .white


        }


    }


}





private extension View {


    func glassCard() -> some View {


        background(
            .ultraThinMaterial,
            in: RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )

        .overlay {


            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )

            .stroke(
                .white.opacity(0.11),
                lineWidth: 1
            )


        }


    }


}





private struct GamePerformance:
Identifiable {


    let id =
    UUID()


    let mode:
    GameMode


    let score:
    Int


}
