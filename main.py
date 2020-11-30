import clips
import logging
from minesweeper import minesweeper


# input size of board and number of bombs
size = int(input())
n = int(input())
bombs = []

for i in range(n):
  x, y = map(int,input().split(','))
  bombs.append((x, y))

env = clips.Environment()
game = minesweeper(size, bombs)

env.load("./minesweeper.clp")

# Masukin fact size + jumlah bomb
s = "(defglobal MAIN $*size* " + str(size) + ")"
env.assert_string(s)

s = "(defglobal MAIN $*bomb-count* " + str(n) + ")"
env.assert_string(s)

# Masukin fact posisi
for i in range(size):
  for j in range(size):
    s = "(position (x " + str(i) + ") (y " + str(j) + "))"
    env.assert_string(s)

# first move
newprobes = game.probe(0, 0)
game.print()
print(newprobes)
for (x, y) in newprobes:
  s = "(probed (pos (assert (position (x " + str(x) + ") (y " + str(y) + ")))) (value " + str(game.board[x][y]) + "))"
  print("asserting " + s)
  fact = env.assert_string(s)

finish = False
while (not finish):
  x, y, move = 0, 0, ''
  env.reset()
  env.run()
  
  for f in env.facts():
    if (f.template.name == 'move'):
      if f['move'] == 'flag':
        game.flag(f['x'], f['y'])

      elif f['move'] == 'probe':
        new = game.probe(f['x'], f['y'])
        for (x, y) in new:
          s = "(probed (pos (assert (position (x " + str(x) + ") (y " + str(y) + ")))) (value " + str(game.board[x][y]) + "))"
          fact = env.assert_string(s)
          print("assert " + s)

      game.print()

  if (game.checkwin()):
    finish = True
    print("You win! :)")
