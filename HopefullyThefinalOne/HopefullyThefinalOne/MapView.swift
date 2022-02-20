//
//  ContentView.swift
//  HopefullyThefinalOne
//
//  Created by Umar Hassan on 2022-02-19.
//


import SwiftUI
import MapKit


struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    //    let annotations: Place
    
    
    var body: some View {
        let  annos = viewModel.pointsOI
        GeometryReader { geometry in
            ZStack{
                Map(
                    coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: annos ,
                    annotationContent: {place in
                        MapAnnotation(coordinate: place.coordinate) {
                            if (place.icon == .yourself){
                                MyMarkerView()
                            } else{
                                if (place.icon == .parking){
                                    HStack{
                                        ParkingMarkerView()
                                    }
                                    .frame(maxWidth: 100)
                                    
                                    
                                } else {
                                    HStack{
                                        TransitMarkerView()
                                    }
                                    .frame(maxWidth: 100)
                                }
                            }
                        }
                    }
                )
                
                SlideOverView{
                    
                    VStack(alignment: .leading) {
                        Text("Parking and Transport")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.leading)
                        
                        ScrollView {
                            VStack(alignment: .leading){
                                ForEach(viewModel.pointsOI){ point in
                                    if (point.icon != .yourself){
                                        PlaceRow(place: point)
                                    }
                                        
                                    
                                }
                                
                                
                                Spacer()
                                    .frame(width: 100, height: 100)
                                
                            }
                            .frame(width: geometry.size.width)
                            
                        }
                        .frame( alignment: .leading)
                    }
                }
                
            }
        }
        
        .ignoresSafeArea()
        .onAppear{
            viewModel.checkLocationEnabled()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        MapView()
        //        ParkingMarkerView()
        //        TransitMarkerView()
        PlaceRow(place: Place(
            name: "You",
            coordinate:  CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.8911054),
            icon: .yourself
        ))
    }
}


struct MyMarkerView: View {
    var body: some View {
        ZStack{
            Circle()
                .strokeBorder(Color.blue)
                .background(Circle().fill(Color.blue))
                .opacity(0.1)
                .frame(width: 40, height: 40)
            
            Circle().stroke(Color.blue)
                .frame(width: 20, height: 20)
            
        }
    }
}

struct ParkingMarkerView: View {
    var body: some View {
        VStack{
            Image(systemName: "parkingsign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .font(.headline)
                .foregroundColor(.white)
                .padding( 6)
                .background(.blue)
                .clipShape(Circle())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 5, height: 5)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -9)
                .padding(.bottom, 15)
        }
    }
}

struct TransitMarkerView: View {
    var body: some View {
        VStack{
            Image(systemName: "tram.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .font(.headline)
                .foregroundColor(.white)
                .padding( 6)
                .background(.red)
                .clipShape(Circle() )
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: 5, height: 5)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -9)
                .padding(.bottom, 15)
        }
    }
}

struct PlaceRow : View {
    let place: Place
    
    var body: some View {
        
        HStack( ){
            Text(place.name)
                .font(.callout)
                .fontWeight(.bold)
                .lineLimit(nil)
                .padding(.all)
                
                
            Spacer()
            Image(systemName: "map.fill")
                .resizable()
                .scaledToFit()
                .padding(6)
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
                .background(place.icon == .parking ? .blue : .red)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height:10)))
                .padding(10)
                .onTapGesture {
                    let url = URL(string: "maps://?saddr=&daddr=\(place.coordinate.latitude),\(place.coordinate.longitude)")
                    
                    if UIApplication.shared.canOpenURL(url!) {
                          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }
        }
        .frame( maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        
        .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(place.icon == .parking ? .blue : .red, lineWidth:0.3)
            )
        .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
        .foregroundColor(place.icon == .parking ? .blue : .red)
        
        
        
        
    }
}

