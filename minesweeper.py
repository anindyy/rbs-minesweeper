# minesweeper
from math import inf

class minesweeper():
    def __init__(self, size, bombs):
        self.size = size # integer
        self.bombs = bombs # list of tuple
        self.flagged = [] # list of tuple
        self.probed = [] # list of tuple
        self.board = [[0 for _ in range(size)] for _ in range(size)] # integer matrix
        self.losing = False
        self.mapbombs()

    def mapbombs(self):
        for x, y in self.bombs:
            self.board[x][y] = inf
            self.mark(x, y)

    def mark(self, x, y):
        for i in range(x-1, x+2):
          for j in range(y-1, y+2):
            if (i >= 0 and j >= 0):
              self.board[i][j] += 1
        
    def print(self):
        # print top index
        c = 'a'
        print('    ', end='')
        for i in range(self.size):
            print(c, end=' ')
            c = chr(ord(c) + 1)
        print()
        print('  +-', end='')
        for i in range(self.size):
            print('--', end='')
        print()

        # print side index + cells
        for i in range(self.size):
            print(i, end=' | ')
            for j in range(self.size):
                if (i, j) in self.flagged:
                    print('F', end=' ')
                elif (i, j) in self.probed:
                    v = self.board[i][j]
                    if v == 0:
                        print(' ', end=' ')
                    else:
                        print(v, end=' ')
                elif self.losing and (i, j) in self.bombs:
                    print('b', end=' ')
                else:
                    print('·', end=' ')
            print()

    def flag(self, x, y):
        self.flagged.append((x, y))
        return x, y

    def proberec(self, x, y):
        new = []
        if (x > self.size - 1) or (y > self.size - 1) or (x < 0) or (y < 0):
            return []
        elif (x, y) in self.probed:
            return  []
        elif (self.board[x][y] > 0):
            self.probed += [(x, y)]
            return [(x,y)]
        else:
            new = new + [(x, y)]
            self.probed +=[(x, y)]
            new = new + self.proberec(x+1, y)
            new = new + self.proberec(x, y+1)
            new = new + self.proberec(x-1, y)
            new = new + self.proberec(x, y-1)
            return new

    def probe(self, x, y):
        if (x, y) in self.probed or (x, y) in self.flagged:
            raise Exception("Invalid move")

        if (x, y) in self.bombs:
            self.losing = True
            raise Exception("You lose :)")
        
        new = self.proberec(x, y)
        return new
        
    def checkwin(self):
        for i in range(self.size):
            for j in range(self.size):
                if (i, j) not in self.flagged and (i, j) not in self.probed:
                    return False
        return True