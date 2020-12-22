//
//  calenderView.swift
//  DoneTracker
//
//  Created by Jacob Hanna on 22/12/2020.
//

import SwiftUI

struct calenderView: View {
    @State var month : Int
    @State var year : Int
    var c : Calender{
        return Calender(month: month, year: year)
    }
    @State var done : [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: 7), count: 6)
    var color = Color(Lists.selectedList.color)
    var selected : Int{
        didSet{
            doneImage = Lists.selectedList.doneImageName
            undoneImage = Lists.selectedList.undoneImageName
            color = Color(Lists.selectedList.color)
        }
    }
    var doneImage : String = Lists.selectedList.doneImageName
    var undoneImage : String = Lists.selectedList.undoneImageName
    @State var monthCount : Int = 0
    
    func getDoneArray(){
        monthCount = 0
        for i in 0 ..< 6{
            for j in 0 ..< 7{
                done[i][j] = Lists.selectedList[c[i,j]]
                if c[i,j].m == month{
                    monthCount += done[i][j] ? 1 : 0
                }
            }
        }
    }

    var body: some View {
        VStack{
            Text("Month count: \(monthCount)").padding()
            HStack{
                Button(action: {
                    (month, year) = c.next()
                    getDoneArray()
                    
                }, label: {
                    Image(systemName: "arrow.left").font(.title)
                }).padding()
                Spacer()
                VStack {
                    Text(Calender.months[month-1])
                    Text("\(year.toString)").font(.system(size: 12))
                }
                Spacer()
                Button(action: {
                    (month, year) = c.prev()
                    getDoneArray()
                }, label: {
                    Image(systemName: "arrow.right").font(.title)
                }).padding()
            }
            Spacer()
            HStack {
                Spacer()
                ForEach(0 ..< 7){ j in
                    Text(Calender.dayTitles[j])
                    Spacer()
                }
                
            }
            
            Spacer()
            ForEach(0 ..< c.dayRows){ i in
                HStack {
                    Spacer()
                    ForEach(0 ..< 7){ j in
                        VStack{
                            Text("\(c[i,j].d)")
                            Button(action: {
                                done[i][j].toggle()
                                Lists.selectedList[c[i,j]] = done[i][j]
                                monthCount += done[i][j] ? 1 : -1
                            }, label: {
                                Image(systemName: done[i][j] ? doneImage : undoneImage).font(.title)
                            })
                        }.opacity(c[i,j].m == month ? 1 : 0.6)
                        Spacer()
                    }
                    
                }
                Spacer()
            }
        }.onAppear(perform: {
            getDoneArray()
        }).onChange(of: selected, perform: { value in
            getDoneArray()
        }).accentColor(color)
    }
}
