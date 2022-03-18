//
//  ContentView.swift
//  Connect Four
//
//  Created by Dwayne Reinaldy on 3/16/22.
//

import SwiftUI

struct ContentView: View {
    enum Pieces {
        case empty, player1, player2
    }
    var player1Color = Color.yellow
    var player2Color = Color.red

    @State private var piece = Array(repeating: Pieces.empty, count: 42)
    @State private var turn = "Player 1"
    @State private var winner = ""
    @State private var done = false
    @State private var connect : [Int] = []
    @State private var winning : Bool = false
    @State private var player1Win : Int = 0
    @State private var player2Win : Int = 0
    @State private var player1Piece: Int = 21
    @State private var player2Piece: Int = 21
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Text("Connect Four")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Image("athlete1")
                        .resizable()
                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                    VStack {
                        HStack {
                            Text("Player 1")
                                .font(.headline)
                            Spacer()
                            Text("Player 2")
                                .font(.headline)
                        }
                        HStack {
                            Text("\(player1Win)")
                            Spacer()
                            Text("VS")
                                .font(.headline)
                            Spacer()
                            Text("\(player2Win)")
                        }
                        HStack{
                            Text("Piece left : \(player1Piece)")
                            Spacer()
                            Text("Piece left : \(player2Piece)")
                        }
                    }
                    Image("athlete2")
                        .resizable()
                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                }
                let col = Array(repeating: GridItem(), count: 7)
                LazyVGrid(columns: col) {
                    ForEach(piece.indices) { index in
                        switch piece[index] {
                        case .empty:
                            Circle()
                                .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    if (turn == "Player 1") {
                                        playerTurn(index: index)
                                        player1Piece-=1
                                        done = checkDone()
                                        if (done) {
                                            winner = "Player 1"
                                            player1Win += 1
                                        }
                                        else if(player1Piece==0){
                                                winner = "Draw"
                                        }
                                        else {
                                                turn = "Player 2"
                                        }
                                        
                                    }
                                    else{
                                        player2Turn(index: index)
                                        done = checkDone()
                                        player2Piece-=1
                                        if (done) {
                                            winner = "Player 2"
                                            player2Win += 1
                                        }
                                        else if(player2Piece==0){
                                                winner = "Draw"
                                        }
                                        else {
                                                turn = "Player 1"
                                        }
                                    }
                                }
                        case .player1:
                            if connect.contains(index) {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().fill(player1Color))
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                            }
                            else {
                                Circle()
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                    .foregroundColor(player1Color)
                            }
                        case .player2:
                            if connect.contains(index) {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().fill(player2Color))
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                            }
                            else {
                                Circle()
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                    .foregroundColor(player2Color)
                            }
                        }
                    }
                }
                .padding()
                .background(.blue)
                .cornerRadius(15)
                .padding(.bottom)
                HStack{
                    if(winner == "Player 1" || winner == "Player 2"){
                        Text("\(winner) win!!")
                            .bold()
                    }
                    else if(winner == "Draw"){
                        Text("\(winner)!!")
                            .bold()
                    }
                    else{
                        Text("\(turn)'s turn")
                            .bold()
                    }
                    
                }
                if (winner != "" && player1Win<5 && player2Win<5) {
                    HStack {
                        Spacer()
                        Button {
                            piece = Array(repeating: Pieces.empty, count: 42)
                            player1Piece=21
                            player2Piece=21
                            turn = "Player 1"
                            done = false
                            winner = ""
                            connect = []
                        } label: {
                            Text("Next Round")
                                .bold()
                                .font(.largeTitle)
                        }
                        Spacer()
                    }
                    .padding(8)
                    .background(Color(red: 209/255, green: 231/255, blue: 255/255))
                    .cornerRadius(15)
                }
                if(player1Win==5 || player2Win==5){
                    VStack {
                        Spacer()
                        if(player1Win==5){
                            Text("Congrats Player 1!")
                                .bold()
                        }
                        else{
                            Text("Congrats Player 2!")
                                .bold()
                        }
                        Spacer()
                        Button {
                            piece = Array(repeating: Pieces.empty, count: 42)
                            turn = "Player 1"
                            done = false
                            player1Win = 0
                            player2Win = 0
                            winner = ""
                            connect = []
                        } label: {
                            Text("Restart")
                                .bold()
                                .font(.largeTitle)
                        }
                        
                    }
                    .padding(8)
                    .background(Color(red: 209/255, green: 231/255, blue: 255/255))
                    .cornerRadius(15)
                }
                Spacer()
            }
            .padding()
            
        }
    }
    func playerTurn(index: Int) { // player1 turn
        var idx = index
        while (idx+7 <= 41 && self.piece[idx+7] == Pieces.empty) {
            idx += 7
        }
        self.piece[idx] = Pieces.player1
    }
    
    func player2Turn(index: Int) { // player 2 turn
        var idx = index
        while (idx+7 <= 41 && self.piece[idx+7] == Pieces.empty) {
            idx += 7
        }
        self.piece[idx] = Pieces.player2
    }
    func checkDone() -> Bool {  //check if the game is done (one of two player wins)
        for row in 0...2 {
            for col in 0...3 {
                if (self.piece[7*row+col] != Pieces.empty
                    && self.piece[7*row+col] == self.piece[7*row+col+8]
                    && self.piece[7*row+col+8] == self.piece[7*row+col+16]
                    && self.piece[7*row+col+16] == self.piece[7*row+col+24]) {
                    connect.append(7*row+col)
                    connect.append(7*row+col+8)
                    connect.append(7*row+col+16)
                    connect.append(7*row+col+24)
                    return true
                }
            }
        }
        for row in 0...2 {
            for col in 0...3 {
                if (self.piece[7*row+3+col] != Pieces.empty
                    && self.piece[7*row+3+col] == self.piece[7*row+3+col+6]
                    && self.piece[7*row+3+col+6] == self.piece[7*row+3+col+12]
                    && self.piece[7*row+3+col+12] == self.piece[7*row+3+col+18]) {
                    connect.append(7*row+3+col)
                    connect.append(7*row+3+col+6)
                    connect.append(7*row+3+col+12)
                    connect.append(7*row+3+col+18)
                    return true
                }
            }
        }
        for row in 0...2 {
            for col in 0...6 {
                if (self.piece[7*row+col] != Pieces.empty
                    && self.piece[7*row+col] == self.piece[7*row+col+7]
                    && self.piece[7*row+col+7] == self.piece[7*row+col+14]
                    && self.piece[7*row+col+14] == self.piece[7*row+col+21]) {
                    connect.append(7*row+col)
                    connect.append(7*row+col+7)
                    connect.append(7*row+col+14)
                    connect.append(7*row+col+21)
                    return true
                }
            }
        }
        for row in 0...5 {
            for col in 0...3 {
                if (self.piece[7*row+col+1] != Pieces.empty
                    && self.piece[7*row+col] == self.piece[7*row+col+1]
                    && self.piece[7*row+col+1] == self.piece[7*row+col+2]
                    && self.piece[7*row+col+2] == self.piece[7*row+col+3]) {
                    connect.append(7*row+col)
                    connect.append(7*row+col+1)
                    connect.append(7*row+col+2)
                    connect.append(7*row+col+3)
                    return true
                }
            }
        }
        return false
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
