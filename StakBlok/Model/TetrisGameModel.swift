//
//  TetrisGameModel.swift
//  StakBlok
//
//  Created by Arpit Arun Kumaar on 2022-01-11.
//

import SwiftUI

class TetrisGameModel: ObservableObject
{
    var numberOfRows: Int
    var numberOfColumns: Int
    @Published var gameBoard: [[TetrisGameBlock?]]

    init(numberOfRows: Int = 23, numberOfColumns: Int = 10)
    {
         self.numberOfRows = numberOfRows
         self.numberOfColumns = numberOfColumns
         gameBoard = Array(repeating: Array(repeating: nil, count: numberOfRows), count: numberOfColumns)
    }
    
    func blockClicked(row: Int, column: Int)
    {
        print("Column: \(column), Row: \(row)")
        if gameBoard[column][row] == nil
        {
            gameBoard[column][row] = TetrisGameBlock(blocktype: BlockType.allCases.randomElement()!)
        } else
        {
            gameBoard[column][row] = nil
        }
    }
}

struct TetrisGameBlock
{
    var blocktype: BlockType
}

enum BlockType: CaseIterable
{
    case i,o,t,j,l,s,z
}
