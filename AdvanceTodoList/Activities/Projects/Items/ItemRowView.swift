//
//  ItemRowView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var item: Item

    var body: some View {
        NavigationLink {
            EditItemView(item: item)
        } label: {
            Text(item.itemTitle)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
            .previewLayout(.sizeThatFits)
    }
}
