//
//  EventView.swift
//  App-BDE-iOS
//
//  Created by Nicolas Barbosa on 07/03/2021.
//

import SwiftUI

struct EventView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: EventViewModel
    @State private var showModal: Bool = false
    
    var body: some View {
        
        GeometryReader { gr in
            ScrollView {
                HStack(alignment: .bottom) {
                    ZStack {
                        TitleShape(radius: 20)
                            .fill(Color.blueToBlack)
                        TitleCustom(title: L10n.Event.title, font: .custom("TabacBigSans-SemiBoldIt", size: 25), textColor: .white, shadowColor: .bdeGreen)
                    }
                    .frame(width: 250, height: 40)
                    .shadow(radius: 6)
                    Spacer()
                }
                VStack(spacing: 10) {
                    ForEach(viewModel.eventList, id: \._id) { event in
                        EventItem(event: event)
                            .shadow(radius: 5)
                            .transition(.scale)
                    }
                }
                .padding(.horizontal)
                .frame(width: gr.size.width)
                .animation(.default)
            }
            .background(
                ZStack {
                    Color.whiteToBlue
                    Image(Asset.backgroundEvent.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(colorScheme == .dark ? 0.2 : 1)
                    
                }
                .ignoresSafeArea(edges: .top))
            .onAppear(perform: viewModel.requestEvents)
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ViewProvider.event()
            ViewProvider.event()
                .previewDevice("iPhone 12 Pro Max")
        }
    }
}
