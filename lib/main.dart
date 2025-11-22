import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MazePage(),
    );
  }
}

class MazePage extends StatefulWidget {
  const MazePage({super.key});

  @override
  State<MazePage> createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> {
  int gridSize = 8;

  List<List<int>> grid = [];

  int moves = 0;
  int mistakes = 0;

  int playerRow = 0;
  int playerCol = 0;

  bool hasKey = false;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    grid = List.generate(
      gridSize,
          (i) => List.generate(gridSize, (j) => 0),
    );

    moves = 0;
    mistakes = 0;
    hasKey = false;

    // starting position
    playerRow = 0;
    playerCol = 0;

    grid[playerRow][playerCol] = 4; //player

    // demo layout
    grid[1][1] = 1; //wall
    grid[2][2] = 2; //key
    grid[3][3] = 3; //exit
    grid[4][1] = 5; //kill trap
    grid[4][2] = 6; //return trap
    grid[4][3] = 7; //scramble trap

    setState(() {});
  }

  void movePlayer(String direction) {
    int newRow = playerRow;
    int newCol = playerCol;

    if (direction == "up") newRow--;
    if (direction == "down") newRow++;
    if (direction == "left") newCol--;
    if (direction == "right") newCol++;

    if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) {
      return;
    }

    int tile = grid[newRow][newCol];

    // walls block
    if (tile == 1) {
      mistakes++;
      setState(() {});
      return;
    }

    // kill trap
    if (tile == 5) {
      mistakes++;
      _respawnPlayer();
      return;
    }

    // return trap
    if (tile == 6) {
      mistakes++;
      _respawnPlayer();
      return;
    }

    // scramble trap
    if (tile == 7) {
      mistakes++;
      _scrambleMaze();
      return;
    }

    // pick key
    if (tile == 2) {
      hasKey = true;
    }

    // exit
    if (tile == 3) {
      if (hasKey) {
        _showWinDialog();
        return;
      } else {
        mistakes++;
        setState(() {});
        return;
      }
    }

    // move player
    grid[playerRow][playerCol] = 0;
    playerRow = newRow;
    playerCol = newCol;
    grid[playerRow][playerCol] = 4;

    moves++;

    setState(() {});
  }

  void _respawnPlayer() {
    grid[playerRow][playerCol] = 0;

    playerRow = 0;
    playerCol = 0;

    grid[playerRow][playerCol] = 4;
    setState(() {});
  }

  void _scrambleMaze() {
    List<int> specialTiles = [1, 2, 3, 5, 6, 7];
    List<int> tileList = [];

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (specialTiles.contains(grid[r][c])) {
          tileList.add(grid[r][c]);
        }
        grid[r][c] = 0;
      }
    }

    tileList.shuffle(Random());

    int index = 0;
    for (var tile in tileList) {
      int r = index ~/ gridSize;
      int c = index % gridSize;
      grid[r][c] = tile;
      index++;
    }

    playerRow = 0;
    playerCol = 0;
    grid[playerRow][playerCol] = 4;

    setState(() {});
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("You Escaped!"),
          content: Text("Moves: $moves\nMistakes: $mistakes"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      appBar: AppBar(
        title: const Text(
          "Maze Escape Mini Game",
          style: TextStyle(color: Color(0xff6bb397)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1e1e1e),
        foregroundColor: const Color(0xff6bb397),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownMenu(
              width: 150,
              initialSelection: gridSize,
              onSelected: (value) {
                gridSize = value as int;
                resetGame();
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 6, label: "6 x 6"),
                DropdownMenuEntry(value: 8, label: "8 x 8"),
                DropdownMenuEntry(value: 10, label: "10 x 10"),
                DropdownMenuEntry(value: 12, label: "12 x 12"),
              ],
            ),
          ),

          // grid
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 320,
              height: 320,
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ gridSize;
                  int col = index % gridSize;
                  return _buildTile(grid[row][col]);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Moves: $moves   ",
                  style: const TextStyle(color: Color(0xff6bb397), fontSize: 18)),
              Text("Mistakes: $mistakes",
                  style: const TextStyle(color: Color(0xff6bb397), fontSize: 18)),
            ],
          ),

          const SizedBox(height: 20),

          Column(
            children: [
              ElevatedButton(
                onPressed: () => movePlayer("up"),
                child: const Icon(Icons.arrow_upward),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => movePlayer("left"),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => movePlayer("right"),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () => movePlayer("down"),
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: resetGame,
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int tile) {
    if (tile == 4) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xff6bb397),
          shape: BoxShape.circle,
        ),
      );
    }

    if (tile == 5) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Text("💀", style: TextStyle(fontSize: 20)),
        ),
      );
    }

    if (tile == 6) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child:
        const Center(child: Icon(Icons.refresh, color: Color(0xff6bb397))),
      );
    }

    if (tile == 7) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.shuffle, color: Color(0xffe6c34d)),
        ),
      );
    }

    if (tile == 2) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.vpn_key, color: Color(0xffe6c34d)),
        ),
      );
    }

    if (tile == 3) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.flag, color: Color(0xff6bb397)),
        ),
      );
    }

    // wall / empty
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: tile == 1 ? const Color(0xff444444) : const Color(0xff2c2c2c),
        border: Border.all(color: const Color(0xff6bb397), width: 0.5),
      ),
    );
  }
}
