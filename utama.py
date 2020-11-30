import clips
from minesweeper import minesweeper

size = int(input())
n = int(input())
bombs = []

for i in range(n):
  x = int(input())
  y = int(input())
  bombs.append((x, y))

env = clips.Environment()
game = minesweeper(size, bombs)

size = 5
bombs = [(0, 0), (2, 2)]
m = minesweeper(size, bombs)
m.print()

# env.load("./minesweeper.clp")
env.reset()

# Masukkan semua koordinat kotak yang belum terbuka
# Variabel koordinat akan menampung semua position
# dari seluruh kotak yang belum terbuka
# koordinat = []
# for i in range(size):
  # for j in range(size):
    # do something here
    # koordinat.append()
    # pass

finish = False
while (not finish):
  x, y, move = 0, 0, ''
  env.run()
  
  for f in env.facts():
    if (f.template.name == 'move'):
      if f['move'] == 'flag':
        game.flag(f['x'], f['y'])
      elif f['move'] == 'probe':
        new = game.probe(f['x'], f['y'])
        # assert new facts (opened cells)
      game.print()

  if (game.checkwin()):
    finish = True
    print("You win! :)")

  if (game.losing):
    finish = True
    print("You lose! :(")
    # Kayanya losenya pake exception but ok