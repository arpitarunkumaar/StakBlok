//
//  TetrisGameViewModel.swift
//  StakBlok
//
//  Created by Arpit Arun Kumaar on 2022-01-10.
//

import SwiftUI

class TetrisGameViewModel: ObservableObject {
     var numberOfRows: Int
     var numberOfColumns: Int
     @Published var gameBoard: [[TetrisBlock]]

     init(numberOfRows: Int = 23, numberOfColumns: Int = 10) {
          self.numberOfRows = numberOfRows
          self.numberOfColumns = numberOfColumns
          gameBoard = Array(repeating: Array(repeating: TetrisBlock(color:Color.tetrisBlack), count: numberOfRows), count: numberOfColumns)
     }


func squareOnClick(row: Int, column: Int) {
    print("Column: \(column), Row: \(row)")
        if gameBoard[column][row].color == Color.tetrisBlack {
            gameBoard[column][row].color = Color.tetrisRed
        }   else {
            gameBoard[column][row].color = Color.tetrisBlack
        }
    }

}

struct TetrisBlock {
     var color: Color
}
