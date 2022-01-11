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
        if let tetrimino = tetrisGameModel.tetrimino
        {
            for blockLocation in tetrimino.blocks
            {
                board[blockLocation.Column + tetrimino.origin.Column][blockLocation.Row + tetrimino.origin.Row] = TetrisBlock(color: getColor(blockType: tetrimino.blockType))
            }
        }
        return board
    }
    
    var anyCancellable:AnyCancellable?
    
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

    func squareOnClick(row: Int, column: Int)
    {
        tetrisGameModel.blockClicked(row: row, column: column)
    }
}

struct TetrisBlock
{
     var color: Color
}
