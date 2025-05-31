package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"runtime"
	"time"
)

const (
	width  = 10
	height = 20
)

var board [height][width]int
var shapes = [][][]int{
	{{1, 1, 1, 1}},         // I
	{{1, 1}, {1, 1}},       // O
	{{0, 1, 0}, {1, 1, 1}}, // T
	{{1, 1, 0}, {0, 1, 1}}, // S
	{{0, 1, 1}, {1, 1, 0}}, // Z
	{{1, 0, 0}, {1, 1, 1}}, // L
	{{0, 0, 1}, {1, 1, 1}}, // J
}

type Tetromino struct {
	shape [][]int
	x, y  int
}

func clearScreen() {
	switch runtime.GOOS {
	case "windows":
		cmd := exec.Command("cmd", "/c", "cls")
		cmd.Stdout = os.Stdout
		cmd.Run()
	default:
		cmd := exec.Command("clear")
		cmd.Stdout = os.Stdout
		cmd.Run()
	}
}

func drawBoard() {
	clearScreen()
	for i := 0; i < height; i++ {
		for j := 0; j < width; j++ {
			if board[i][j] == 0 {
				fmt.Print(". ")
			} else {
				fmt.Print("# ")
			}
		}
		fmt.Println()
	}
}

func canPlace(t Tetromino) bool {
	for i := 0; i < len(t.shape); i++ {
		for j := 0; j < len(t.shape[i]); j++ {
			if t.shape[i][j] == 1 {
				newX, newY := t.x+j, t.y+i
				if newX < 0 || newX >= width || newY >= height || board[newY][newX] == 1 {
					return false
				}
			}
		}
	}
	return true
}

func placeTetromino(t Tetromino) {
	for i := 0; i < len(t.shape); i++ {
		for j := 0; j < len(t.shape[i]); j++ {
			if t.shape[i][j] == 1 {
				board[t.y+i][t.x+j] = 1
			}
		}
	}
}

func removeFullLines() {
	for i := height - 1; i >= 0; i-- {
		full := true
		for j := 0; j < width; j++ {
			if board[i][j] == 0 {
				full = false
				break
			}
		}
		if full {
			for k := i; k > 0; k-- {
				board[k] = board[k-1]
			}
			board[0] = [width]int{}
			i++ // Recheck the same line
		}
	}
}

func main() {
	rand.Seed(time.Now().UnixNano())
	current := Tetromino{shape: shapes[rand.Intn(len(shapes))], x: width / 2, y: 0}

	for {
		if canPlace(current) {
			drawBoard()
			time.Sleep(500 * time.Millisecond)
			current.y++
		} else {
			current.y--
			placeTetromino(current)
			removeFullLines()
			current = Tetromino{shape: shapes[rand.Intn(len(shapes))], x: width / 2, y: 0}
			if !canPlace(current) {
				fmt.Println("Game Over!")
				break
			}
		}
	}
}
