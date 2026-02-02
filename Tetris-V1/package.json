import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import Game from './components/Game';
import { createTetris } from "./tetris/Tetris";

const tetris = createTetris();
tetris.start();

document.addEventListener("keydown", (event) => {
    const keyName = event.key;
    if (tetris.isRunning()) {
        if (keyName === "ArrowUp") {
            tetris.rotateCurrentPiece();
        } else if (keyName === "ArrowDown") {
            tetris.tick();
        } else if (keyName === "ArrowLeft") {
            tetris.moveLeft();
        } else if (keyName === "ArrowRight") {
            tetris.moveRight();
        } else if (keyName === " ") {
            tetris.pause();
        }
    } else {
        if (keyName === " ") {
            if (tetris.isPaused()) {
                tetris.resume();
            } else {
                tetris.start();
            }
        }
    }
});

// React 18 createRoot API
const container = document.getElementById('root');
const root = createRoot(container); 
root.render(
    <React.StrictMode>
        <Game tetris={tetris}/>
    </React.StrictMode>
);
