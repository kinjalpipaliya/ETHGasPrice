//
//  ContentView.swift
//  GasPriceWidget
//
//  Created by Kinjal Pipaliya on 28/09/21.
//

import SwiftUI
import Foundation
import MobileCoreServices
import Network
import UIKit
import WidgetKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Appdelegate called!!")
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 11/255, green: 102/255, blue: 201/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        return true
    }
}

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}


struct ContentView: View {

    @State var gasData: JSONModel
    @State var text: String = "0x3A1428Ff5b5A81AC520Ce9630A4Ff4127ff0a345"
    @State var animate = false
    @ObservedObject var monitor = NetworkMonitor()
    @State var gasTime: TimeModel
    @State var showAlert = false
    
   // var address: String
    var body: some View {
        NavigationView {
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    getData { (gas) in
                        checkStatus()
                        getTime { (time) in
                            self.gasTime = time
                        }
                        self.gasData = gas
                    }
                    if #available(iOS 14, *) {
                        WidgetCenter.shared.reloadAllTimelines()
                        print("Reloading widget..")
                    } else {
                        print("This code only runs on iOS 13 and lower")
                    }
                }
                   
            ZStack {
                Color(UIColor.appColor(.gray))
                    .ignoresSafeArea()
                VStack(spacing: 100) {
                    VStack(spacing: 10) {
                        Text("You can add widget of ETH Gas Fees on your home screen to directly view the gas prices.")
                            .multilineTextAlignment(.center)
                            .padding(.leading,15)
                            .padding(.trailing,15)
                            .font(.system(size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .center)
                            .foregroundColor(Color.gray)
                        HStack(spacing: UIScreen.main.bounds.width/21) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .frame(width: (UIScreen.main.bounds.width/2)-30, height: getRectengleHight())
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Fast")
                                        .foregroundColor(Color(red: 29/255, green: 206/255, blue: 121/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-20))
                                    Text("\(rounded(value: gasData.result.fastGasPrice ?? "0"))")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~15 seconds")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .frame(width: (UIScreen.main.bounds.width/2)-30, height: getRectengleHight())
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Medium")
                                        .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-20))
                                    Text("\(rounded(value: gasData.result.proposeGasPrice ?? "0"))")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~1 minute")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                        }
                        HStack(spacing: UIScreen.main.bounds.width/21) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .frame(width: (UIScreen.main.bounds.width/2)-30, height: getRectengleHight())
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Safe")
                                        .foregroundColor(Color(red: 254/255, green: 155/255, blue: 7/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-20))
                                    Text("\(rounded(value: gasData.result.safeGasPrice ?? "0"))")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~3 minutes")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .frame(width: (UIScreen.main.bounds.width/2)-30, height: getRectengleHight())
                                VStack(alignment: .center,spacing: 5) {
                                    Text("Slow")
                                        .foregroundColor(Color(red: 121/255, green: 121/255, blue: 121/255, opacity: 1))
                                        .font(.system(size: getSmallWidgetFontSize()-20))
                                    Text("\(roundedBase(value: gasData.result.suggestBaseFee))")
                                        .font(.system(size: getSmallWidgetFontSize()))
                                        .bold()
                                    Text("~10 minutes")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                       // .foregroundColor(Color(red: 7/255, green: 126/255, blue: 254/255, opacity: 0.08))
                                }
                            }
                        }.padding()
                        Text("Powered by Etherscan")
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color.gray)
                    }
                    .padding()
                    ZStack {
                        Rectangle()
                            .fill(Color(.appColor(.green)))
                            .frame(width: UIScreen.main.bounds.width, height: 170)
                        VStack(alignment: .center, spacing: 15) {
                            Text("I am an individual developer. Support me by donating ETH/USDT/USDC on my ERC-20 address given below to recover the API cost:")
                                .padding(.leading,15)
                                .padding(.trailing,15)
                                .font(.system(size: 14))
                                .foregroundColor(Color(.appColor(.textColor)))
                                .multilineTextAlignment(.center)
                            VStack(spacing: 15) {
                                TextField("0x3A1428Ff5b5A81AC520Ce9630A4Ff4127ff0a345", text: $text).foregroundColor(.gray)
                                    .padding(7)
                                    .allowsHitTesting(false)
                                    .background(RoundedRectangle(cornerRadius: 6)
                                                    .fill(Color(red: 217/255, green: 245/255, blue: 219/255, opacity: 1))
                                                    .frame(width: UIScreen.main.bounds.width-45, height: 34))
    //                                                .padding(.leading,15)
    //                                                .padding(.trailing,15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.clear, lineWidth: 1)
                                        )
                                    .font(.system(size: 12))
                                    .frame(width: UIScreen.main.bounds.width-10, height: 34)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                        print("Button pressed!:\(UIPasteboard.general.string = self.text)")
                                        UIPasteboard.general.string = self.text
                                    self.showAlert = true
                                        
                                            }, label: {
                                                HStack {
                                                    Image("Copy")
                                                    Text("Copy")
                                                        .foregroundColor(Color.white)
                                                        .font(.system(size: 13))
                                           
                                                }
                                            }).alert(isPresented: $showAlert) {
                                                Alert(title: Text("Alert"), message: Text("Copied to clipboard"), dismissButton: .default(Text("Ok")))
                                            }
                                .background(RoundedRectangle(cornerRadius: 6)
                                                            .fill(Color(red: 59/255, green: 189/255, blue: 111/255, opacity: 1))
                                                            .frame(width: 150, height: 34))
                            }
                        }.padding()
                    }
                }
                if animate {
                    ZStack {
                        Color(.systemBackground)
                            .ignoresSafeArea()
                            .opacity(0.8)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(3)
                    }
                }
            }
            .navigationTitle("ETH Gas Fees")
            .navigationBarTitleDisplayMode(.inline)
            }.coordinateSpace(name: "pullToRefresh")
    }
        .onAppear() {
            getData { (gas) in
                checkStatus()
                getTime { (time) in
                    self.gasTime = time
                    
                }
                self.gasData = gas
            }
            if #available(iOS 14, *) {
                WidgetCenter.shared.reloadAllTimelines()
                print("Reloading widget..")
            } else {
                print("This code only runs on iOS 13 and lower")
            }
        }
    }
    
    func checkStatus() {
        if monitor.isConnected {
            animate = false
        }else {
            animate = true
        }
    }
    
    func getSmallWidgetFontSize() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 41.0
            case CGSize(width: 414, height: 896):
                return 40.0
            case CGSize(width: 414, height: 736):
                return 40.0
            case CGSize(width: 390, height: 844):
                return 39.0
            case CGSize(width: 375, height: 812):
                return 35.0
            case CGSize(width: 375, height: 667):
                return 34.0
            case CGSize(width: 360, height: 780):
                return 35.0
            case CGSize(width: 320, height: 568):
                return 31.0
            default:
                return 35.0
            }
        }
    
    func getRectengleHight() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 170.0
            case CGSize(width: 414, height: 896):
                return 133.0
            case CGSize(width: 414, height: 736):
                return 123.0
            case CGSize(width: 390, height: 844):
                return 122.0
            case CGSize(width: 375, height: 812):
                return 118.0
            case CGSize(width: 375, height: 667):
                return 111.0
            case CGSize(width: 360, height: 780):
                return 118.0
            case CGSize(width: 320, height: 568):
                return 105.0
            default:
                return 118.0
            }
        }
    
    func getSpacing() -> CGFloat {
        switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return 150.0
            case CGSize(width: 414, height: 896):
                return 85.0
            case CGSize(width: 414, height: 736):
                return 84.0
            case CGSize(width: 390, height: 844):
                return 83.0
            case CGSize(width: 375, height: 812):
                return 80.0
            case CGSize(width: 375, height: 667):
                return 60.0
            case CGSize(width: 360, height: 780):
                return 60.0
            case CGSize(width: 320, height: 568):
                return 60.0
            default:
                return 85.0
            }
        }
    
    func roundedBase(value: String) -> Int {
        return Int((Double(value) ?? 0).rounded())
    }
    
    func rounded(value: String) -> Int{
        return Int(Double(value) ?? 0)
    }
    
    func getIntTime(value: String?, price: String?) -> Int {
        if let timeValue = value {
            if let priceValue = price {
                let timeInt = Int(timeValue) ?? 111
                let priceInt = Int(priceValue) ?? 111
                return timeInt*priceInt
            }else {
                return 365
            }
        }else {
            return 365
        }
    }
    
    func getData(completion: @escaping (JSONModel) -> ()) {
        
        animate = true
        
        let url = "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=BQ21QV6UQRZIJ2TG5FTAS2W19J2C3RNI7V"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                
                print("getting error:\(err!.localizedDescription)")
                
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                do {
                    let jsonData = try JSONDecoder().decode(JSONModel.self, from: data!)
                    print("My json data:\(jsonData)")
                    completion(jsonData)
                }
                catch {
                    print("catch calling:\(error.localizedDescription)")
                }
                animate = false
            }
        }.resume()
    }
    func getTime(completion: @escaping (TimeModel) -> ()) {
        let url = "https://api.etherscan.io/api?module=gastracker&action=gasestimate&apikey=BQ21QV6UQRZIJ2TG5FTAS2W19J2C3RNI7V"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                
                print("getting error:\(err!.localizedDescription)")
                
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                do {
                    let jsonData = try JSONDecoder().decode(TimeModel.self, from: data!)
                    print("My time data:\(jsonData)")
                    completion(jsonData)
                }
                catch {
                    print("catch calling:\(error.localizedDescription)")
                }
            }
        }.resume()
    }
}


struct TextFieldModifier: ViewModifier {
    let color: Color
    let padding: CGFloat // <- space between text and border
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .overlay(RoundedRectangle(cornerRadius: padding)
                        .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    func customTextField(color: Color = .secondary, padding: CGFloat = 3, lineWidth: CGFloat = 1.0) -> some View { // <- Default settings
        self.modifier(TextFieldModifier(color: color, padding: padding, lineWidth: lineWidth))
    }
}
