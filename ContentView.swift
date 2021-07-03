//
//  ContentView.swift
//  animations
//
//  Created by Hisham on 30/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
            polygon()
        }
    }





struct polygon: View {
    @State private var sides: Double = 4 // state to update the view when the value changes
    var body: some View {
        VStack{
            polygonShape(sides: sides)
                .stroke(Color.pink, lineWidth: (sides < 3) ? 15 : (sides < 7 ? 5:2))
                .padding(20)
                .animation(.easeInOut(duration: 3.0))
                .layoutPriority(1)
            Text("\(Int(sides)) sides 📐")
            Slider(value: $sides , in: 0...30).accentColor(Color.pink)
        }
    }
    
}
        
struct polygonShape: Shape {
    
    var sides : Double // no of sides for the polygon
    var animatableData: Double
    { get {sides}
        set{
            sides = newValue
        }
    } // this is the var which indicates what values in my view that will be animated upon change
    
    func path(in rect: CGRect) -> Path {
        
        let h = Double(rect.size.width/2.0)
        let c = CGPoint(x:rect.size.width / 2.0 , y: rect.size.height / 2.0)
        var path = Path()
        let extra: Int =  sides != Double(Int(sides)) ? 1:0
        var vertex :[CGPoint] = []
        
        for i in 0..<Int(sides) + extra {
            let theta = ( Double(i) * (360.0 / sides)) * (Double.pi / 180)
            let pt = CGPoint(x: c.x + CGFloat(cos(theta) * h), y: c.y + CGFloat(sin(theta) * h))
            vertex.append(pt)
            if i == 0{
                path.move(to: pt) // if it is the first point in the vertex array we should make the path move to it
            }else{
                path.addLine(to: pt) // else we should draw a line to this point
            }
        }
        path.closeSubpath()
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        // by now we have drawn the sides
        // lets write a function to draw the vertex lines which are in red
        
        return path
     }
    // this will be a recusive function i highly recommend you to trace it in the 4 sides case to fully understand it // contact me if you have any questions regarding this function
    func drawVertexLines ( path : inout Path , vertex : [CGPoint] , n:Int){
        // the first thing we have to do in any recursive function is the exit condtion
        // a recursive function without an exit condition is an infinite loop
        if (vertex.count - n) < 3 {return}
        // what this condtion does is to check if there are more vertex lines to draw or not
        
        // now let's trace this loop when n is 0
                 // 2            //3
        for i in (n+2)..<min(n+(vertex.count-1), vertex.count) {
            // i = 2
            path.move(to: vertex[n])  // we will move to vertex of ZER0 which is this one
            path.addLine(to: vertex[i]) // then we will add a line to vertex [2] which is this one
            // by doing that we now draw our first vertex line and ext....
            // now lets run and see the result
            // MAGIC RIGHT ?? 
        }
        drawVertexLines(path: &path, vertex: vertex, n: n+1 )
    }
    
    
}
