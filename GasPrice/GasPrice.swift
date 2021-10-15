//
//  GasPrice.swift
//  GasPrice
//
//  Created by Kinjal Pipaliya on 28/09/21.
//

import WidgetKit
import SwiftUI

struct Model: TimelineEntry {
    var date : Date
    var widgetData : JSONModel
}

struct JSONModel : Decodable, Hashable {
    static func == (lhs: JSONModel, rhs: JSONModel) -> Bool {
        return lhs.message == rhs.message && rhs.result == lhs.result && rhs.status == lhs.status
    }

    var status, message: String
    var result: GasResult
}

struct TimeModel: Codable {
    let status, message, result: String?
}

struct GasResult: Decodable, Hashable {
    let lastBlock, safeGasPrice, proposeGasPrice, fastGasPrice: String
    let suggestBaseFee, gasUsedRatio: String

    enum CodingKeys: String, CodingKey {
        case lastBlock = "LastBlock"
        case safeGasPrice = "SafeGasPrice"
        case proposeGasPrice = "ProposeGasPrice"
        case fastGasPrice = "FastGasPrice"
        case suggestBaseFee, gasUsedRatio
    }
}

struct WidgetView : View {
    @Environment(\.widgetFamily) var family
    var data : Model
        var body: some View {
            
            switch family {
            case .systemSmall:
                
                ZStack {
                    VStack(alignment: .leading, spacing: getSmallWidgetSize()/15) {
                                Text("ETH Gas")
                                    .bold()
                                    .font(.system(size: 17))
                                HStack(spacing: 28) {
                                    VStack(alignment: .leading,spacing: 2) {
                                            Text("Fast")
                                                .foregroundColor(Color(red: 29/255, green: 206/255, blue: 121/255, opacity: 1))
                                                .font(.system(size: getSmallWidgetFontSize()-9))
                                        Text("\(data.widgetData.result.fastGasPrice)")
                                                .font(.system(size: getSmallWidgetFontSize()))
                                                .bold()
                                    }
                                    VStack(alignment: .leading,spacing: 2) {
                                            Text("Medium")
                                                .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 1))
                                                .font(.system(size: getSmallWidgetFontSize()-9))
                                            Text("\(data.widgetData.result.proposeGasPrice)")
                                                .font(.system(size: getSmallWidgetFontSize()))
                                                .bold()
                                        }
                                }
                            HStack(spacing: 28) {
                                VStack(alignment: .leading,spacing: 2) {
                                        Text("Safe")
                                            .foregroundColor(Color(red: 254/255, green: 155/255, blue: 7/255, opacity: 1))
                                            .font(.system(size: getSmallWidgetFontSize()-9))
                                        Text("\(data.widgetData.result.safeGasPrice)")
                                            .font(.system(size: getSmallWidgetFontSize()))
                                            .bold()
                                }
                                VStack(alignment: .leading,spacing: 2) {
                                        Text("Slow")
                                            .foregroundColor(Color(red: 121/255, green: 121/255, blue: 121/255, opacity: 1))
                                            .font(.system(size: getSmallWidgetFontSize()-9))
                                    Text("\(roundedBase(value: data.widgetData.result.suggestBaseFee))")
                                            .font(.system(size: getSmallWidgetFontSize()))
                                            .bold()
                                }
                            }
                        }
                    .padding()
                }

            case .systemMedium:
                ZStack {
                    VStack(alignment: .center, spacing: getSmallWidgetSize()/17) {
                        Text("ETH Gas")
                        .bold()
                        .font(.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: getMediumWidgetWidth()/23) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.appColor(.gray)))
                                    .frame(width: 70, height: 84)
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Fast")
                                        .foregroundColor(Color(red: 29/255, green: 206/255, blue: 121/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-9))
                                    Text("\(data.widgetData.result.fastGasPrice)")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~15 seconds")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.appColor(.gray)))
                                    .frame(width: 70, height: 84)
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Medium")
                                        .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-9))
                                    Text("\(data.widgetData.result.proposeGasPrice)")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~1 minute")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.appColor(.gray)))
                                    .frame(width: 70, height: 84)
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Safe")
                                        .foregroundColor(Color(red: 254/255, green: 155/255, blue: 7/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-9))
                                    Text("\(data.widgetData.result.safeGasPrice)")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~3 minutes")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.appColor(.gray)))
                                    .frame(width: 70, height: 84)
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Slow")
                                        .foregroundColor(Color(red: 121/255, green: 121/255, blue: 121/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-9))
                                    Text("\(roundedBase(value: data.widgetData.result.suggestBaseFee))")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~10 minutes")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                        }
                        Text("Powered by Etherscan")
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color.gray)
                            //.accentColor(Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.4))
                    }
                    .padding()
                }
            case .systemLarge:
                Text("Large")
            default:
                Text("Some other WidgetFamily in the future.")
            }
        }
    
    func getSmallWidgetSize() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 170.0
            case CGSize(width: 414, height: 896):
                return 169.0
            case CGSize(width: 414, height: 736):
                return 159.0
            case CGSize(width: 390, height: 844):
                return 158.0
            case CGSize(width: 375, height: 812):
                return 155.0
            case CGSize(width: 375, height: 667):
                return 148.0
            case CGSize(width: 360, height: 780):
                return 155.0
            case CGSize(width: 320, height: 568):
                return 141.0
            default:
                return 155.0
            }
        }
    func getSmallWidgetFontSize() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 24.0
            case CGSize(width: 414, height: 896):
                return 23.0
            case CGSize(width: 414, height: 736):
                return 23.0
            case CGSize(width: 390, height: 844):
                return 22.0
            case CGSize(width: 375, height: 812):
                return 19.0
            case CGSize(width: 375, height: 667):
                return 18.0
            case CGSize(width: 360, height: 780):
                return 19.0
            case CGSize(width: 320, height: 568):
                return 15.0
            default:
                return 19.0
            }
        }
    func getMediumWidgetWidth() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 364.0
            case CGSize(width: 414, height: 896):
                return 360.0
            case CGSize(width: 414, height: 736):
                return 348.0
            case CGSize(width: 390, height: 844):
                return 338.0
            case CGSize(width: 375, height: 812):
                return 329.0
            case CGSize(width: 375, height: 667):
                return 200.0
            case CGSize(width: 360, height: 780):
                return 329.0
            case CGSize(width: 320, height: 568):
                return 292.0
            default:
                return 329.0
            }
        }
    }

@main
struct MainWidget : Widget {
    
    var body: some WidgetConfiguration {
      //  WidgetCenter.shared.reloadAllTimelines()
        StaticConfiguration(kind: "GasPrice", provider: Provider()) { (data) in
            WidgetView(data: data)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("ETH Gas price")
        .description("Track eth gas prices for transaction easily adding widget.")
    }
}

struct Provider : TimelineProvider {
    func placeholder(in context: Context) -> Model {
        Model(date: Date(), widgetData: JSONModel(status: "", message: "", result: GasResult(lastBlock: "last", safeGasPrice: "safe", proposeGasPrice: "propose", fastGasPrice: "fast", suggestBaseFee: "suggest", gasUsedRatio: "gas")))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        let loadingData = Model(date: Date(), widgetData: JSONModel(status: "Success", message: "Ok", result: GasResult(lastBlock: "20", safeGasPrice: "20", proposeGasPrice: "20", fastGasPrice: "30", suggestBaseFee: "20", gasUsedRatio: "40")))
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        getData { (modelData) in
            let date = Date()

            let data = Model(date: date, widgetData: modelData)

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: date)
            print("Api called!")
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
}

func roundedBase(value: String) -> Int {
    return Int((Double(value) ?? 0).rounded())
}

func getData(completion: @escaping (JSONModel) -> ()) {
    let url = "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=BQ21QV6UQRZIJ2TG5FTAS2W19J2C3RNI7V"
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: URL(string: url)!) { (data, _, err) in
        
        if err != nil {
            
            print("getting error:\(err!.localizedDescription)")
            
            return
        }

        do{
            let jsonData = try JSONDecoder().decode(JSONModel.self, from: data!)
            print("json data:\(jsonData)")
            completion(jsonData)
        }
        catch {
            print("catch calling:\(error.localizedDescription)")
        }
    }.resume()
}

func getEstimatedTime(completion: @escaping (TimeModel) -> ()) {
    let url = "https://api.etherscan.io/api?module=gastracker&action=gasestimate&apikey=BQ21QV6UQRZIJ2TG5FTAS2W19J2C3RNI7V"
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: URL(string: url)!) { (data, _, err) in
        
        if err != nil {
            
            print("getting error:\(err!.localizedDescription)")
            
            return
        }

        do{
            let jsonData = try JSONDecoder().decode(TimeModel.self, from: data!)
            print("json data:\(jsonData)")
            completion(jsonData)
        }
        catch {
            print("catch calling:\(error.localizedDescription)")
        }
    }.resume()
}


