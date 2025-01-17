//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView<Header: View, Footer: View>: View {
    @StateObject var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer

    @State var searchText = ""
    
    public var body: some View {
        
        #if os(macOS)
        if #available(macOS 13.0, *) {
            if viewModel.allowSearching {
                filterableFeaturesList
                    .searchable(text: $searchText)
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
            } else {
                featuresList
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        } else {
            if viewModel.allowSearching {
                filterableFeaturesList
                    .searchable(text: $searchText)
            } else {
               featuresList
            }
        }
        #else
        if viewModel.allowSearching {
           if #available(iOS 16.0, *) {
               filterableFeaturesList
                   .scrollContentBackground(.hidden)
                   .listStyle(.plain)
                   .searchable(text: $searchText)
           } else {
               filterableFeaturesList
                   .listStyle(.plain)
                   .searchable(text: $searchText)
           }
       } else {
           if #available(iOS 16.0, *) {
               featuresList
                   .scrollContentBackground(.hidden)
                   .listStyle(.plain)
           } else {
               featuresList
                   .listStyle(.plain)
           }
       }
        #endif
    }
    
    var featuresList: some View {
        List {
            header
            ForEach(viewModel.features) { feature in
                if #available(macOS 13.0, *) {
                RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                    .listRowSeparator(.hidden)
                } else {
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                }
            }
            footer
        }
    }
    
    var filterableFeaturesList: some View {
        List {
            header
            ForEach(viewModel.features.filter { searchText.isEmpty ? true : $0.featureTitle.lowercased().contains(searchText.lowercased()) } ) { feature in
                if #available(macOS 13.0, *) {
                RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                    .listRowSeparator(.hidden)
                } else {
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                }
            }
            footer
        }
    }

}

public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView())
    }
}

public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView())
    }
}

public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer())
    }
}

public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer())
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sample())
    }
}
