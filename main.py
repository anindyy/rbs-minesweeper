import clips

env = clips.Environment()


position = """
(defclass POSITION (is-a USER)
  (pattern-match reactive)
  (slot x)
  (slot y))
"""
env.build(position)

# instance = env.make_instance('(instance-name of POSITION (x 1) (y 1))')

# for row in range(4):
#   for col in range(4):
#     instance['x'] = row
#     instance['y'] = col
#     for x, y in instance:
#       print(x, end=" ")
#       print(y)

for row in range(4):
  for col in range(4):
    s = '(instance-name of POSITION (x ' + str(row) + ') (y ' + str(col) +'))'
    env.make_instance(s)
    # for x, y in env.make_instance(s):
    #   print(x, end=" ")
    #   print(y)


# ini referensi san yang lebih jelas mungkin
# https://www.csie.ntu.edu.tw/~sylee/courses/clips/class.htm
# tapi ini buat di clipsnya gituu buat bikin syntax clips