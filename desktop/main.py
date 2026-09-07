import socket

HOST = "0.0.0.0"
PORT = 5000

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))
server.listen(1)

print(f"Listening on port {PORT}...")


while True:
    conn, addr = server.accept()
    print(f"Connected: {addr}")
    data = conn.recv(1024)

    # if not data:
    #     break

    print("Received:", data.decode())

conn.close()
server.close()