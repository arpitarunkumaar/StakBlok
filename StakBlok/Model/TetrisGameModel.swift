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
    @Published var tetromino: Tetromino?
    
    var timer: Timer?
    var speed: Double

    init(numberOfRows: Int = 23, numberOfColumns: Int = 10)
    {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        gameBoard = Array(repeating: Array(repeating: nil, count: numberOfRows), count: numberOfColumns)
        tetromino = Tetromino(origin: BlockLocation(Row: 22, Column: 4), blockType: .i)
        
        speed = 0.1
        resumeGame()
        
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
    
    func resumeGame()
    {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: runEngine)
    }
    
    func pauseGame()
    {
        timer?.invalidate()
    }
    
    func runEngine (timer: Timer)
    {
        // spawn a new block when needed
        guard let currentTetromino = tetromino else
        {
            print("spawning new tertominos!")
            tetromino = Tetromino(origin: BlockLocation(Row: 22, Column: 4), blockType: .i)
            return
        }
        
        
        // see about moving blocks down
        
        let newTetromino = currentTetromino.moveBy(row: -1, column: 0)
        if isValidTetromino(testTetromino: newTetromino)
        {
            print("moving tetromino down!")
            tetromino = newTetromino
            return
        }
        
        // check if we need to place the block
    }
    
    func isValidTetromino(testTetromino: Tetromino) -> Bool
    {
        for block in testTetromino.blocks
        {
            let row = testTetromino.origin.Row + block.Row
            if row < 0 || row >= numberOfRows
            {
                return false
            }
            
            let column = testTetromino.origin.Column + block.Column
            if column < 0 || column >= numberOfColumns
            {
                return false
            }
            
            if gameBoard[column][row] != nil
            {
                return false
            }
        }
        return true
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

struct Tetromino
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
    
    func moveBy(row: Int, column: Int) -> Tetromino
    {
        let newOrigin = BlockLocation(Row: origin.Row + row, Column: origin.Column + column)
        return Tetromino(origin: newOrigin, blockType: blockType)
    }
}

struct BlockLocation
{
    var Row: Int
    var Column: Int
}
