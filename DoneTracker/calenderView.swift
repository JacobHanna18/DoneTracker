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
    
    func getDoneArray(){
        for i in 0 ..< 6{
            for j in 0 ..< 7{
                done[i][j] = Lists.selectedList[c[i,j]]
            }
        }
    }
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Button(action: {
                    (month, year) = c.next()
                    getDoneArray()
                    
                }, label: {
                    Image(systemName: "arrow.left").font(.title)
                })
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
                })
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
                            }, label: {
                                Image(systemName: done[i][j] ? Lists.selectedList.doneImageName : Lists.selectedList.undoneImageName).font(.title)
                            })
                        }
                        //dayView(doneImage: "checkmark.circle", unDoneImage: "circle", day: c[i, j])
                        Spacer()
                    }
                    
                }
                Spacer()
            }
        }.onAppear(perform: {
            getDoneArray()
        })
    }
}

struct calenderView_Previews: PreviewProvider {
    static var previews: some View {
        calenderView(month: Day().m, year: Day().y)
    }
}
