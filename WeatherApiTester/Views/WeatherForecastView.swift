//  WeatherForecastView.swift
//  WeatherApiTester
//
//  Created by Teboho Mohale on 2023/07/31.
//
import SwiftUI

struct WeatherForecastView: View {
    @State private var ripple = false
    @State private var bigDrop = false
    var dropSpeed = 0.3
    var dropInterval = 0.2
    
    @StateObject private var viewModel = WeatherForecastViewModel()
    
    @State private var savedCities: [String] = []

    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("pic102")
                        .resizable()
                        .opacity(0.7)
                        .ignoresSafeArea()
                        .blur(radius: 5)
                    
                    Circle()
                        .fill(Color(#colorLiteral(red: 1, green: 2, blue: 1, alpha: 1)))
                        .frame(width: 10, height: 10)
                        .offset(x: 0, y: bigDrop ? 0 : -420)
                        .animation(.linear(duration: dropSpeed).delay(dropInterval).repeatForever(autoreverses: false))
                        .onAppear() {
                            bigDrop.toggle()
                        }
                    ZStack(alignment: .center) {
                        Circle()
                            .stroke(lineWidth: ripple ? 0 : 30)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .frame(width: 300, height: 300)
                            .scaleEffect(ripple ? 1 : 0)
                            .animation(Animation.easeOut(duration: (dropSpeed + dropInterval)).repeatForever(autoreverses: false).delay(dropSpeed + dropInterval))
                    }
                    .rotation3DEffect(
                        .degrees(65),
                        axis: (x: 1.0, y: 0.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    .onAppear() {
                        ripple.toggle()
                    }
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                Spacer()
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)
                                        .font(.title)
                                    
                                    TextField("Search", text: $viewModel.searchText, onEditingChanged: { isEditing in
                                        viewModel.isShowingSuggestions = isEditing
                                    }, onCommit: {
                                        viewModel.getWeatherForecast(city: viewModel.searchText)
                                    })
                                    .padding(.horizontal)
                                    .foregroundColor(.black)
                                    .frame(height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    .padding(.trailing, 10)
                                    .shadow(radius: 20)
                                }
                                .frame(maxWidth: 400)
                                
                                if let data = viewModel.weatherForecastAPI?.data {
                                    VStack(spacing: 15) {
                                        Text(" \(data.request?[0].query ?? "")")
                                            .font(.title3)
                                            .multilineTextAlignment(.center)
                                        Text("Today")
                                            .font(.title.bold())
                                            .multilineTextAlignment(.center)
                                        HStack {
                                            if let weatherIconURL = data.currentCondition?[0].weatherIconURL?.first?.value,
                                               let url = URL(string: weatherIconURL),
                                               let data = try? Data(contentsOf: url),
                                               let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(30)
                                                    .padding()
                                            }
                                            
                                            Text("\(data.currentCondition?[0].tempC ?? "")°C")
                                            
                                        }
                                        Text("Weather: \(data.currentCondition?[0].weatherDesc?.first?.value ?? "")")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        Spacer(minLength: 10)
                                        HStack (spacing: 30){
                                            VStack {
                                                RoundedRectangle(cornerRadius: 40)
                                                    .fill(Color.white)
                                                    .frame(width: 50, height: 50)
                                                    .shadow(color: Color(.purple).opacity(0.3), radius: 0.9)
                                                    .overlay(
                                                        Image(systemName: "wind")
                                                            .resizable()
                                                            .frame(width: 25, height: 20)
                                                            .foregroundColor(Color.blue)
                                                    )
                                                VStack {
                                                    Text("Wind: \(data.currentCondition?[0].windspeedKmph ?? "") km/h")
                                                        .font(.caption.bold())
                                                }
                                            }
                                            
                                            VStack {
                                                RoundedRectangle(cornerRadius: 40)
                                                    .fill(Color.white)
                                                    .frame(width: 50, height: 50)
                                                    .shadow(color: Color(.purple).opacity(0.3), radius: 0.9)
                                                    .overlay(
                                                        Image(systemName: "humidity")
                                                            .resizable()
                                                            .frame(width: 25, height: 20)
                                                            .foregroundColor(Color.blue)
                                                    )
                                                Text("UV Index: \(data.currentCondition?[0].uvIndex ?? "")")
                                                    .font(.caption.bold())
                                                
                                            }
                                            
                                            VStack {
                                                RoundedRectangle(cornerRadius: 40)
                                                    .fill(Color.white)
                                                    .frame(width: 50, height: 50)
                                                    .shadow(color: Color(.purple).opacity(0.3), radius: 0.9)
                                                    .overlay(
                                                        Image(systemName: "cloud.rain")
                                                            .resizable()
                                                            .frame(width: 25, height: 20)
                                                            .foregroundColor(Color.blue)
                                                    )
                                                Text("Precipitation: \(data.currentCondition?[0].precipMM ?? "")")
                                                    .font(.caption.bold())
                                            }
                                        }
                                    }
                                    .foregroundColor(.primary)
                                    .font(.title3)
                                    .padding(.horizontal)
                                    .padding(20)
                                    .background(RoundedRectangle(cornerRadius: 30).fill(Color.clear))
                                    .shadow(radius: 10)
                                    .frame(width: 380, height: 400)
                                    Spacer()
                                    
                                    Text("Daily forecast for: \(viewModel.searchText)")
                                        .font(.callout)
                                        .multilineTextAlignment(.center)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                    
                                    if let hourlyData = data.weather?.first?.hourly {
                                        Text(" ")
                                            .font(.title)
                                            .padding(.horizontal)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 16) {
                                                ForEach(hourlyData.prefix(12), id: \.time) { hourly in
                                                    VStack {
                                                        Text(viewModel.formatTime(hourly.time ?? ""))
                                                            .font(.headline)
                                                            .foregroundColor(Color("primaryColor"))
                                                        
                                                        Text(viewModel.weatherConditionToEmoji(hourly.weatherDesc?.first?.value ?? ""))
                                                            .font(.largeTitle)
                                                            .padding(.top, 5)
                                                        
                                                        Text("\(hourly.tempC ?? "")°C")
                                                            .font(.title)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(Color("primaryColor"))
                                                    }
                                                    .padding()
                                                    .foregroundColor(.primary)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                                    .shadow(radius: 5)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    
                                    Spacer()
                                        .padding()
                                    
                                    Text("Weekly forecast for: \(viewModel.searchText)")
                                        .font(.callout)
                                        .padding(.horizontal)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    
                                    ForEach(data.weather ?? [], id: \.self) { weatherElement in
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 370, height: 70)
                                            .shadow(radius: 10)
                                            .padding(5)
                                            .overlay(
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        Text(viewModel.formatDateToDay(weatherElement.date ?? ""))
                                                            .font(.headline)
                                                            .foregroundColor(Color("primaryColor"))
                                                        Spacer()
                                                        
                                                        Image(systemName: "thermometer.sun")
                                                            .foregroundColor(.orange)
                                                        Text("\(weatherElement.maxtempC ?? "")°C  | ")
                                                            .foregroundColor(Color("primaryColor"))
                                                        Text("\(weatherElement.mintempC ?? "")°C")
                                                            .foregroundColor(Color("primaryColor"))
                                                        Image(systemName: "thermometer.snowflake")
                                                            .foregroundColor(.blue)
                                                        Spacer()
                                                    }
                                                }
                                                    .multilineTextAlignment(.leading)
                                                    .padding(30)
                                                    .foregroundColor(.primary)
                                                    .shadow(radius: 10)
                                                    .padding(.horizontal)
                                                    .frame(width: 600)
                                            )
                                    }
                                }
                                
                                List {
                                    ForEach(viewModel.savedCities, id: \.self) { city in
                                        HStack {
                                            Text(city)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Button(action: {
                                                viewModel.removeCity(city)
                                            }) {
                                                Image(systemName: "minus.circle")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                    }
                                    .onDelete(perform: viewModel.removeCities)
                                }
                                .listStyle(PlainListStyle())
                            }
                            .onAppear {
                                viewModel.getWeatherForecast(city: viewModel.searchText)
                            }
                        }
                        .navigationBarTitle("Focus Forecast", displayMode: .inline)
                        .navigationBarItems(
                            leading: Button(action: {
                                if let city = viewModel.weatherForecastAPI?.data?.request?.first?.query {
                                    viewModel.addCity(city)
                                }
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(Color("primaryColor"))
                            },
                            trailing: Button(action: {
                                viewModel.navigateToCityListView()
                            }) {
                                Image(systemName: "list.dash")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primaryColor"))
                            })
                    }
                }
            }
            .environmentObject(viewModel)
        }
    }
    
}

extension WeatherElement: Hashable {
    static func == (lhs: WeatherElement, rhs: WeatherElement) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}
