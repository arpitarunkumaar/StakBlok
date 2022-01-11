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
    @Published var tetrimino: Tetrimino?

    init(numberOfRows: Int = 23, numberOfColumns: Int = 10)
    {
         self.numberOfRows = numberOfRows
         self.numberOfColumns = numberOfColumns
         gameBoard = Array(repeating: Array(repeating: nil, count: numberOfRows), count: numberOfColumns)
        tetrimino = Tetrimino(origin: BlockLocation(Row: 22, Column: 4), blockType: .i)
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

struct Tetrimino
{
    var origin: BlockLocation
    var blockType: BlockType
    var blocks: [BlockLocation]
    {
        [
            BlockLocation(Row: 0, Column: -1),
            BlockLocation(Row: 0, Column: 0),
            BlockLocation(Row: 0, Column: 1),
            BlockLocation(Row: 0, Column: 2),
        ]
    }
}

struct BlockLocation
{
    var Row: Int
    var Column: Int
}
