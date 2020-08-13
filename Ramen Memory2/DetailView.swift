//
//  DetailView.swift
//  Ramen Memory2
//
//  Created by Yusuke Tomatsu on 2020/08/02.
//  Copyright © 2020 Yusuke Tomatsu. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let ramen: Ramen
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack(alignment: .bottomTrailing){
                    Text(self.ramen.genre ?? "謎の味")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y:-5)
                }
                Text(self.ramen.shop ?? "謎のラーメン屋")
                                       .font(.title)
                                       .foregroundColor(.secondary)
                                   
                                   Text(self.ramen.review ?? "レビューなし")
                                   .padding()
                                   
                                   RatingView(rating: .constant(Int(self.ramen.rating)))
                                       .font(.largeTitle)
                                   
                                   Spacer()
            }
            
        }
        .navigationBarTitle(Text(ramen.name ?? "謎のラーメン"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Ramen"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteRamen()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    func deleteRamen(){
        moc.delete(ramen)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    
    
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
               let ramen = Ramen(context: moc)
               ramen.name = "Test Ramen"
               ramen.shop = "Test Ramenshop"
               ramen.genre = "豚骨"
               ramen.rating = 4
               ramen.review = "This was a great book; I really enjoyed it."
//               ramen.date = "12.24, 2020"

        
        
        return NavigationView{
            DetailView(ramen: ramen)
            }
        }
    }
