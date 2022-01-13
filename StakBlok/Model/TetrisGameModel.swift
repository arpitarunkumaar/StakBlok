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
    
    var Shadow: Tetromino? // block drop location hint
    {
        guard var lastShadow = tetromino else { return nil }
        var testShadow = lastShadow
        while (isValidTetromino(testTetromino: testShadow))
        {
            lastShadow = testShadow
            testShadow = lastShadow.moveBy(row: -1, column: 0)
        }
        
        return lastShadow
    }

    init(numberOfRows: Int = 23, numberOfColumns: Int = 11)
    {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        gameBoard = Array(repeating: Array(repeating: nil, count: numberOfRows), count: numberOfColumns)
        
        speed = 0.5
        resumeGame()
        
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
        // check if there is a need to clear a line
        if clearLines()
        {
            print("*** Line Cleared! ***")
            return
        }
        
        // spawn a new block when needed
        guard tetromino != nil else
        {
            print("spawning new tertominos!")
            tetromino = Tetromino.createNewTetromino(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
            
            if !isValidTetromino(testTetromino: tetromino!)
            {
                print("****** GAME OVER! ******")
                pauseGame()
            }
            return
        }
        
        
        // see about moving blocks down
        
        if moveTetrominoDown()
        {
            print("moving tetromino down!")
            return
        }
        
        // check if we need to place the block
        
        print("placing tetrominos!")
        placeTetromino()
    }
    
    func dropTetromino()
    {
        while(moveTetrominoDown()) { }
    }
    
    func moveTetrominoRight() -> Bool
    {
        return moveTetromino(rowOffset: 0, columnOffset: 1)
    }
    
    func moveTetrominoLeft() -> Bool
    {
        return moveTetromino(rowOffset: 0, columnOffset: -1)
    }
    
    func moveTetrominoDown() -> Bool
    {
        return moveTetromino(rowOffset: -1, columnOffset: 0)
    }
    
    func moveTetromino(rowOffset: Int, columnOffset: Int) -> Bool
    {
        guard let currentTetromino = tetromino else {return false}
        
        let newTetromino = currentTetromino.moveBy(row: rowOffset, column: columnOffset)
        if isValidTetromino(testTetromino: newTetromino)
        {
            print("moving tetrominos down!")
            tetromino = newTetromino
            return true
        }
        return false
    }
    
    func rotateTetromino(clockwise: Bool)
    {
        guard let currentTetromino = tetromino else
        {
            return
        }
        
        let newTetromino = currentTetromino.rotate(clockwise: clockwise)
        
        if isValidTetromino(testTetromino: newTetromino)
        {
            tetromino = newTetromino
        }
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
    
    func placeTetromino()
    {
        guard let currentTetromino = tetromino else
        {
            return
        }
        
        for block in currentTetromino.blocks
        {
            let row = currentTetromino.origin.Row + block.Row
            if row < 0 || row >= numberOfRows {continue}
            
            let column = currentTetromino.origin.Column + block.Column
            if column < 0 || column >= numberOfColumns {continue}
            
            gameBoard[column][row] = TetrisGameBlock(blocktype: currentTetromino.blockType)
        }
        tetromino = nil
    }
    
    func clearLines() -> Bool
    {
        var newBoard: [[TetrisGameBlock?]] = Array(repeating: Array(repeating: nil, count: numberOfRows), count: numberOfColumns)
        var boardUpdated = false
        var nextRowToCopy = 0
        
        for row in 0...numberOfRows-1
        {
            var clearLine = true
            
            for column in 0...numberOfColumns-1
            {
                clearLine = clearLine && gameBoard[column][row] != nil
            }
            
            if !clearLine
            {
                for column in 0...numberOfColumns-1
                {
                    newBoard[column][nextRowToCopy] = gameBoard[column][row]
                }
                
                nextRowToCopy += 1
            }
            
            boardUpdated = boardUpdated || clearLine
        }
        
        if boardUpdated
        {
            gameBoard = newBoard
        }
        
        return boardUpdated
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
    var rotation: Int
    var blocks: [BlockLocation]
    {
        return Tetromino.getBlocks(blockType: blockType, rotation: rotation)
    }
    
    func moveBy(row: Int, column: Int) -> Tetromino
    {
        let newOrigin = BlockLocation(Row: origin.Row + row, Column: origin.Column + column)
        return Tetromino(origin: newOrigin, blockType: blockType, rotation: rotation)
    }
    
    func rotate (clockwise: Bool) -> Tetromino
    {
        return Tetromino(origin: origin, blockType: blockType, rotation: rotation + (clockwise ? 1 : -1))
    }
    
    static func getBlocks(blockType: BlockType, rotation: Int = 0) -> [BlockLocation]
    {
        let allBlocks = getAllBlocks(blockType: blockType)
        var index = rotation % allBlocks.count
        
        if (index < 0)
        {
            index += allBlocks.count
        }
        
        return allBlocks[index]
    }
    
    static func getAllBlocks(blockType: BlockType) -> [[BlockLocation]]
    {
        switch blockType {
                case .i:
            return [[BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 0, Column: 2)],
                    [BlockLocation(Row: -1, Column: 1), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 1, Column: 1), BlockLocation(Row: -2, Column: 1)],
                    [BlockLocation(Row: -1, Column: -1), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: -1, Column: 1), BlockLocation(Row: -1, Column: 2)],
                    [BlockLocation(Row: -1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 1, Column: 0), BlockLocation(Row: -2, Column: 0)]]
                case .o:
            return [[BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 1, Column: 1), BlockLocation(Row: 1, Column: 0)]]
                case .t:
            return [[BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 1, Column: 0)],
                    [BlockLocation(Row: -1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 1, Column: 0)],
                    [BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: -1, Column: 0)],
                    [BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 1, Column: 0), BlockLocation(Row: -1, Column: 0)]]
                case .j:
            return [[BlockLocation(Row: 1, Column: -1), BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: 1, Column: 1)],
                    [BlockLocation(Row: -1, Column: 1), BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: -1, Column: -1)]]
                case .l:
            return [[BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 1, Column: 1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: -1, Column: 1)],
                    [BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: -1, Column: -1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: 1, Column: -1)]]
                case .s:
            return [[BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 1, Column: 1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: -1, Column: 1)],
                    [BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: -1, Column: -1)],
                    [BlockLocation(Row: 1, Column: -1), BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0)]]
                case .z:
            return [[BlockLocation(Row: 1, Column: -1), BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: 1)],
                    [BlockLocation(Row: 1, Column: 1), BlockLocation(Row: 0, Column: 1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0)],
                    [BlockLocation(Row: 0, Column: -1), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: -1, Column: 0), BlockLocation(Row: -1, Column: 1)],
                    [BlockLocation(Row: 1, Column: 0), BlockLocation(Row: 0, Column: 0), BlockLocation(Row: 0, Column: -1), BlockLocation(Row: -1, Column: -1)]]
                }
    }
    
    static func createNewTetromino(numberOfRows: Int, numberOfColumns: Int) -> Tetromino
    {
        let blockType = BlockType.allCases.randomElement()!
        var maxRow = 0
        
        for block in getBlocks(blockType: blockType)
        {
            maxRow = max(maxRow, block.Row)
        }
        
        let origin = BlockLocation(Row: numberOfRows - 1 - maxRow, Column: (numberOfColumns - 1)/2)
        return Tetromino(origin: origin, blockType: blockType, rotation: 0)
    }
}

struct BlockLocation
{
    var Row: Int
    var Column: Int
}
