import asyncio

async def fizzbuzz(msg, delay):
    while True:
        print(msg)
        await asyncio.sleep(delay)

async def main():
    await asyncio.gather(
            fizzbuzz("fizz", 3),
            fizzbuzz("buzz", 5),
            fizzbuzz("fizzbuzz", 15))

if __name__ == '__main__':
    asyncio.run(main())

