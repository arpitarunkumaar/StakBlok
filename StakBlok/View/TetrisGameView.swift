//
//  TetrisGameView.swift
//  StakBlok
//
//  Created by Arpit Arun Kumaar on 2022-01-10.
//

import SwiftUI

struct TetrisGameView: View
{
    @ObservedObject var tetrisGame = TetrisGameViewModel()
    
    var body: some View
    {
        GeometryReader{(geometry : GeometryProxy) in
        self.drawBoard(bouncingRect: geometry.size)
        }
        .gesture(tetrisGame.getMoveGesture())
    }

    func drawBoard(bouncingRect:CGSize) -> some View
    {
        let columns = self.tetrisGame.numberOfColumns
        let rows = self.tetrisGame.numberOfRows
        let blockSize = min(bouncingRect.width/CGFloat(columns), bouncingRect.height/CGFloat(rows))
        let xoffset = (bouncingRect.width - blockSize*CGFloat(columns))/2  // horizontal padding
        let yoffset = (bouncingRect.height - blockSize*CGFloat(rows))/2 // vertical padding
        let gameBoard = self.tetrisGame.gameBoard
        
        return ForEach(0...columns-1, id: \.self) { (column:Int) in // iterating over all colns and rows
            ForEach(0...rows-1, id: \.self) { (row:Int) in
                
                Path { path in
                let x = xoffset + blockSize * CGFloat(column)
                let y = bouncingRect.height - yoffset - blockSize * CGFloat(row+1)
                let rect = CGRect(x:x, y:y, width:blockSize, height:blockSize)
                    path.addRect(rect)
                }
                .fill(gameBoard[column][row].color)
                .onTapGesture {
                    self.tetrisGame.squareOnClick(row: row, column: column)
                }
                
            }
            
        }
    }
}

struct TetrisGameView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisGameView()
    }
}
