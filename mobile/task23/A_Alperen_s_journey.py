t = int(input())
for _ in range(t):
    n = int(input())
    s = input().strip()
    x, y = 0,0
    flag = False
    for step in s:
        if step == 'L':
            x -= 1
        elif step == 'R':
            x += 1
        elif step == 'U':
            y += 1
        elif step == 'D':
            y -= 1
        if x == 1 and y == 1:
            flag = True
            break
    print("YES" if flag else "NO")
