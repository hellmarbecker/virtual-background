import asyncio

# do something that takes delays. set global state
async def fizzbuzz(msg, delay):
    global state
    while True:
        print(msg)
        state = msg
        await asyncio.sleep(delay)

# use global state, no delay
async def dottie():
    global state
    while True:
        print(f"{state}.", end="", flush=True)
        await asyncio.sleep(0)

async def main():
    await asyncio.gather(
            fizzbuzz("Fizz", 3),
            fizzbuzz("Buzz", 5),
            fizzbuzz("Fizzbuzz", 15),
            dottie())

if __name__ == '__main__':
    asyncio.run(main())

