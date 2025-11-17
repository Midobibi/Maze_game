import 'package:flutter/material.dart';

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
  int gridSize = 8; //default size
  List<List<int>> grid = []; //grid data

  int moves = 0;
  int mistakes = 0;

  @override
  void initState() {
    super.initState();
    resetGame(); //prepare grid
  }

  //movement logic
  void movePlayer(String direction) {
    //logic here
  }

  //maze generation placeholder
  void generateMaze() {
    //logic here
  }

  //reset grid and place demo tiles
  void resetGame() {
    //fresh empty grid
    grid = List.generate(
      gridSize,
          (i) => List.generate(gridSize, (j) => 0),
    );

    //demo tiles (only visual for now)
    grid[0][0] = 4; //player
    grid[1][1] = 1; //wall
    grid[2][2] = 2; //key
    grid[3][3] = 3; //exit
    grid[4][1] = 5; //kill trap
    grid[4][2] = 6; //return trap
    grid[4][3] = 7; //scramble trap

    moves = 0;
    mistakes = 0;

    setState(() {}); //refresh UI
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

          //grid size selector
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownMenu(
              width: 150,
              initialSelection: gridSize,
              onSelected: (value) {
                gridSize = value as int;
                resetGame(); //refresh grid
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 6, label: "6 x 6"),
                DropdownMenuEntry(value: 8, label: "8 x 8"),
                DropdownMenuEntry(value: 10, label: "10 x 10"),
                DropdownMenuEntry(value: 12, label: "12 x 12"),
              ],
            ),
          ),

          //maze grid
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
                  int tile = grid[row][col];
                  return _buildTile(tile);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          //counters
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Moves: $moves   ",
                style: const TextStyle(color: Color(0xff6bb397), fontSize: 18),
              ),
              Text(
                "Mistakes: $mistakes",
                style: const TextStyle(color: Color(0xff6bb397), fontSize: 18),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //movement buttons
          Column(
            children: [
              ElevatedButton(
                onPressed: () { movePlayer("up"); },
                child: const Icon(Icons.arrow_upward),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () { movePlayer("left"); },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () { movePlayer("right"); },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () { movePlayer("down"); },
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //restart
          ElevatedButton(
            onPressed: () { resetGame(); },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  //tile builder UI
  Widget _buildTile(int tile) {
    //player
    if (tile == 4) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xff6bb397),
          shape: BoxShape.circle,
        ),
      );
    }

    //kill trap
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

    //return trap
    if (tile == 6) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.refresh, color: Color(0xff6bb397), size: 20),
        ),
      );
    }

    //scramble trap
    if (tile == 7) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.shuffle, color: Color(0xffe6c34d), size: 20),
        ),
      );
    }

    //key
    if (tile == 2) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.vpn_key, color: Color(0xffe6c34d), size: 18),
        ),
      );
    }

    //exit
    if (tile == 3) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff2c2c2c),
          border: Border.all(color: const Color(0xff6bb397), width: 0.5),
        ),
        child: const Center(
          child: Icon(Icons.flag, color: Color(0xff6bb397), size: 18),
        ),
      );
    }

    //walls + empty tiles
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _getTileColor(tile),
        border: Border.all(color: const Color(0xff6bb397), width: 0.5),
      ),
    );
  }

  //tile colors
  Color _getTileColor(int tile) {
    switch (tile) {
      case 1:
        return const Color(0xff444444); //wall
      default:
        return const Color(0xff2c2c2c); //empty
    }
  }
}
