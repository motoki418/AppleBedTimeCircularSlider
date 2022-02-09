//
//  Home.swift
//  AppleBedTimeCircularSlider
//
//  Created by nakamura motoki on 2022/02/09.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    //月、時計ボタンの向きとサークルの開始位置と終了位置を指定する4つの状態変数
    @State var startAngle: Double = 0
    // Since our to progress is 0.5
    // 0.5 * 360 = 180
    // 進捗が0.5ずつ
    // 月と時計を魔反対に配置するために初期値を180にする
    @State var toAngle: Double = 180
    //サークルの開始位置
    @State var startProgress: CGFloat = 0
    //サークルの終了位置
    @State var toProgress: CGFloat = 0.5
    
    var body: some View {
        VStack{
            //画面上部のテキストとボタンを横並び
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Text("Today")
                        .font(.title.bold())
                    
                    Text("Good Morning! Justine")
                        .foregroundColor(.gray)
                }//VStack
                //テキストの幅を可能な限り広げる
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button{
                    
                }label: {
                    Image("girl")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }//Button
            }//HStack
            //スライダーを表示
            SleepTimeSlider()
            // スライダーの上を50空ける
                .padding(.top, 50)
            
            Button{
                
            }label: {
                Text("Start Sleep")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,40)
                    .background(Color("Blue"), in: Capsule())
            }//Start Sleep Button
            .padding(.top,45)
            
            HStack(spacing:25){
                VStack(alignment: .leading, spacing: 8){
                    
                    Label{
                        Text("Bedtime")
                            .foregroundColor(.black)
                    }icon: {
                        Image(systemName: "moon.fill")
                            .foregroundColor(Color("Blue"))
                    }
                    .font(.callout)
                    //月ボタンが位置している時間の表示
                    Text(getTime(angle:startAngle).formatted(date: .omitted, time: .shortened))
                        .font(.title2.bold())
                }
                //BedtimeとWakeupを均等に配置するための指定
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 8){
                    
                    Label{
                        Text("Wakeup")
                            .foregroundColor(.black)
                    }icon: {
                        Image(systemName: "alarm")
                            .foregroundColor(Color("Blue"))
                    }
                    .font(.callout)
                    //時計ボタンが位置している時間の表示
                    Text(getTime(angle:toAngle).formatted(date: .omitted, time: .shortened))
                        .font(.title2.bold())
                }
                //BedtimeとWakeupを均等に配置するための指定
                .frame(maxWidth: .infinity, alignment: .center)
            }//HStack  Bedtime Wakeup
            .padding()
            .background(.black.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
            .padding(.top,35)
            
        }//VStack
        .padding()
        // Moving To Top Without Spacer
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: Sleep time Circular Slider
    @ViewBuilder
    func SleepTimeSlider() -> some View {
        GeometryReader{ proxy in
            
            let width = proxy.size.width
            //円の上に縁を重ねることでスライダーを作成
            ZStack{
                
                // MARK: Clock Design
                // 時計の針を作成
                // ForEach文を利用して変数indexに1から60までの数値を順番に入れていく
                ZStack{
                    ForEach(1...60, id: \.self) { index in
                        Rectangle()
                        //　分数が5の倍数の針だけ色を黒にしている
                            .fill(index % 5 == 0 ? .black : .gray )
                        //Each hour will have big Line
                        // indexに格納されている数値を5で割った時の余りが0の時は針の長さを15にする
                        // indexに格納されている数値を5で割った時の余りが0ではない時は針の長さを5にする
                        //　つまりここで分数が5の倍数の針だけ針の長さを変えている
                        // 60/5 = 12
                        // 12Hours
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                        // Setting into entire Circle
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                    }// ForEach
                    
                    // MARK: Clock Text
                    // 時計の12時,3時、6時、9時を表示
                    let texts = [6,9,12,3]
                    ForEach(texts.indices,id: \.self){ index in
                        
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                        //　数字の向きを変更
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                        // 360/4 = 90
                        // 時計の12時,3時、6時、9時を均等に配置
                            .rotationEffect(.init(degrees: Double(index) * 90))
                    }
                }//ZStack
                
                Circle()
                //円を切り抜く
                    .stroke(.black.opacity(0.06), lineWidth: 40)
                
                // Allowing Revrese Swiping
                // 反時計回りにも対応するための定数
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360): 0
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                    .stroke(Color("Blue"),style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                //Slider Buttons (月)
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white,in: Circle())
                // Moving To Right & Rotating
                // サークルの開始位置に合わせる　0時の位置
                    .offset(x: width / 2)
                // 時計ボタンと反対の位置に配置する
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value, fromSlider: true)
                            })
                        
                    )
                    .rotationEffect(.init(degrees: -90))
                
                //Slider Buttons (時計)
                Image(systemName: "alarm")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                // Rotaiting Image inside the Circle
                    .background(.white,in: Circle())
                // Moving To Right & Rotating
                // 時計の向きを変更
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white, in: Circle())
                // サークルの開始位置に合わせる　0時の位置
                    .offset(x: width / 2)
                // To the Current Angle
                // 月ボタンと反対の位置に配置する
                    .rotationEffect(.init(degrees: toAngle))
                // For more About Circular Slider
                // Check out my Circular Slider Video
                // Link in Bio
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                // MARK: Hour Text
                VStack(spacing: 6){
                    Text("\(getTimeDifference().0)hr")
                        .font(.largeTitle.bold())
                    
                    Text("\(getTimeDifference().1)min")
                        .foregroundColor(.gray)
                }//VStack
                .scaleEffect(1.1)
            }
        }
        //スライダーの画面幅
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }//SleepTimeSlider
    
    // 月と時計ボタンの動作をまとめたメソッド
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false){
        
        // MARK: Converting Translation into Angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // Removing the Button Radius
        // Button Diameter = 30
        // Radius = 15
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        // Converting into Angle
        var angle = radians * 180 / .pi
        if angle < 0{angle = 360 + angle}
        
        // Progress
        let progress = angle / 360
        
        if fromSlider{
            
            // Update From Values
            self.startAngle = angle
            self.startProgress = progress
        }else{
            
            // Update To Values
            self.toAngle = angle
            self.toProgress = progress
        }
    }//onDrag
    
    // MARK: Returning Time based on Drag
    func getTime(angle: Double) -> Date{
        let progress = angle / 30
        // It will be 6.05
        // 6 is Hour
        // 0.5 is Minutes
        let hour = Int(progress)
        
        // Why 12
        // Since we're goingto update time for each 5 minutes not for each minute
        // 0.1 = 5 minute
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 60).rounded()
        
        var minute = remainder * 5
        // This is because minutes are returnig 60 (12*5)
        // avoiding that to get perfect time
        // 時間の表記方法
        minute = (minute > 55 ? 55 : minute)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        
        if let date = formatter.date(from: "\(hour):\(Int(remainder)):00"){
            return date
        }
        return .init()
    }//getTime()
        
    //Sliderの中の時間表示についてまとめたメソッド
    func getTimeDifference() -> (Int, Int){
        let calender = Calendar.current
        
        let result = calender.dateComponents([.hour,.minute], from: getTime(angle: startAngle), to: getTime(angle: toAngle))
        
        return (result.hour ?? 0, result.minute ?? 0)
    }
       
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Extentions
extension View{
    
    //MARK: Screen Bounds Extention
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
