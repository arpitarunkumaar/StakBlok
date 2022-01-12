//
//  TetrisGameViewModel.swift
//  StakBlok
//
//  Created by Arpit Arun Kumaar on 2022-01-10.
//

import SwiftUI
import Combine

class TetrisGameViewModel: ObservableObject
{
    @Published var tetrisGameModel = TetrisGameModel()
    
    var numberOfRows: Int {tetrisGameModel.numberOfRows}
    var numberOfColumns: Int {tetrisGameModel.numberOfColumns}
    var gameBoard: [[TetrisBlock]]
    {
        var board = tetrisGameModel.gameBoard.map {$0.map(convertToSquare) }
        
        if let shadow = tetrisGameModel.Shadow
        {
            for blockLocation in shadow.blocks
            {
                board[blockLocation.Column + shadow.origin.Column][blockLocation.Row + shadow.origin.Row] = TetrisBlock(color: getShadowColor(blockType: shadow.blockType))
            }
        }
        
        if let tetromino = tetrisGameModel.tetromino
        {
            for blockLocation in tetromino.blocks
            {
                board[blockLocation.Column + tetromino.origin.Column][blockLocation.Row + tetromino.origin.Row] = TetrisBlock(color: getColor(blockType: tetromino.blockType))
            }
        }
        
        return board
    }
    
    var anyCancellable: AnyCancellable?
    var lastMoveLocation: CGPoint?
    
    init()
    {
        anyCancellable = tetrisGameModel.objectWillChange.sink
        {
            self.objectWillChange.send()
        }
    }
    
    func convertToSquare(block:TetrisGameBlock?) -> TetrisBlock
    {
        return TetrisBlock(color: getColor(blockType: block?.blocktype))
    }
    
    func getColor (blockType: BlockType?) -> Color
    {
        switch blockType
        {
        case .i:
            return .tetrisPurple
        case .j:
            return .tetrisOrange
        case .l:
            return .tetrisYellow
        case .o:
            return .tetrisDarkBlue
        case .s:
            return .tetrisGreen
        case .t:
            return .tetrisRed
        case .z:
            return .tetrisLightBlue
        case .none:
            return .tetrisBlack
        }
    }
    
    func getShadowColor (blockType: BlockType?) -> Color
    {
        switch blockType
        {
        case .i:
            return .tetrisPurpleShadow
        case .j:
            return .tetrisOrangeShadow
        case .l:
            return .tetrisYellowShadow
        case .o:
            return .tetrisDarkBlueShadow
        case .s:
            return .tetrisGreenShadow
        case .t:
            return .tetrisRedShadow
        case .z:
            return .tetrisLightBlueShadow
        case .none:
            return .tetrisBlack
        }
    }
    

    func squareOnClick(row: Int, column: Int)
    {
        tetrisGameModel.blockClicked(row: row, column: column)
    }
    
    func getMoveGesture() -> some Gesture
    {
        return DragGesture()
        .onChanged(onMoveChange(value:))
        .onEnded(onMoveEnded(_:))
    }
    
    func onMoveChange(value: DragGesture.Value)
    {
        guard let start = lastMoveLocation else
        {
            lastMoveLocation = value.location
            return
        }
        
        let xDiff = value.location.x - start.x
        if xDiff > 10 //when swiped right
        {
            print("moving right!!")
            let _ = tetrisGameModel.moveTetrominoRight()
            lastMoveLocation = value.location
            return
        }
        
        if xDiff < -10 //when swiped left
        {
            print("moving right!!")
            let _ = tetrisGameModel.moveTetrominoLeft()
            lastMoveLocation = value.location
            return
        }
        
        let yDiff = value.location.y - start.y
        if yDiff > 10 //when swiped down
        {
            print("moving down!!")
            let _ = tetrisGameModel.moveTetrominoDown()
            lastMoveLocation = value.location
            return
        }
        
        if yDiff < -10 //drag up to drop all the way down
        {
            print("dropping!!")
            tetrisGameModel.dropTetromino()
            lastMoveLocation = value.location
            return
        }
    }
    
    func onMoveEnded(_: DragGesture.Value) //when finger taken off the screen, reset value to nil
    {
        lastMoveLocation = nil
    }
}

struct TetrisBlock
{
     var color: Color
}
