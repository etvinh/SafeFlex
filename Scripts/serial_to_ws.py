import serial
import asyncio
import websockets
import json
import re
import time
import math

SERIAL_PORT = "/dev/cu.usbserial-110"
BAUD_RATE   = 115200
WS_PORT     = 8080

LINE_RE = re.compile(
    r"CAL\(sys:\d gyr:\d acc:\d mag:\d\)\s+\|\s+"
    r"GX:\s*([-\d.]+)\s+GY:\s*([-\d.]+)\s+GZ:\s*([-\d.]+)\s+\|\s+"
    r"FLEX:\s*([-\d]+)"
)

def parse(line):
    m = LINE_RE.search(line)
    if not m:
        return None
    gx = float(m.group(1))
    gy = float(m.group(2))
    gz = float(m.group(3))
    stability = round(math.sqrt(gx**2 + gy**2 + gz**2), 3)
    return {
        "timestamp": int(time.time()),
        "flex":      int(m.group(4)),
        "stability": stability,
    }

clients = set()

async def handler(websocket):
    clients.add(websocket)
    print(f"Client connected ({len(clients)} total)")
    try:
        await websocket.wait_closed()
    finally:
        clients.discard(websocket)
        print(f"Client disconnected ({len(clients)} total)")

async def read_serial():
    loop = asyncio.get_event_loop()
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    print(f"Reading serial from {SERIAL_PORT}")
    while True:
        line = await loop.run_in_executor(None, ser.readline)
        line = line.decode("utf-8", errors="ignore").strip()
        data = parse(line)
        if data and clients:
            msg = json.dumps(data)
            await asyncio.gather(*[ws.send(msg) for ws in clients])
            print(f"flex:{data['flex']:5d}  stability:{data['stability']:6.3f}")

async def main():
    async with websockets.serve(handler, "0.0.0.0", WS_PORT):
        print(f"WebSocket server running on ws://0.0.0.0:{WS_PORT}")
        await read_serial()

asyncio.run(main())
