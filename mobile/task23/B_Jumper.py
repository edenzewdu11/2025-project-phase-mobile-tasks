t = int(input())
for _ in range(t):
    s = input().strip()
    s = 'R' + s + 'R'
    max_L = 0
    curr = 0
    for ch in s:
        if ch == 'L':
            curr += 1
            max_L = max(max_L, curr)
        else:
            curr = 0
    print(max_L + 1)
