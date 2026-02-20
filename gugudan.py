# -*- coding: utf-8 -*-
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def print_gugudan():
    for dan in range(2, 10):
        print(f"+{'='*20}+")
        print(f"|      {dan}단{' '*14}|")
        print(f"+{'-'*20}+")
        for i in range(1, 10):
            result = dan * i
            print(f"|  {dan} x {i} = {result:<5}          |")
        print(f"+{'='*20}+")
        print()

if __name__ == "__main__":
    print_gugudan()
