import asyncio
import pyperclip

# Переменная для отслеживания буфера (чтобы клиент не отправлял то, что сам же и вставил)
current_clip = ""

async def client():
    global current_clip
    while True:
        try:
            # Получаем текст из буфера обмена
            text = pyperclip.paste()
            if text and text != current_clip:
                print(f"[Client] Обнаружен новый текст: {text[:20]}...")
                
                # Подключаемся к серверу
                reader, writer = await asyncio.wait_for(
                    asyncio.open_connection("192.168.31.144", 5001),
                    timeout=3.0
                )
                
                writer.write(text.encode("utf-8"))
                await asyncio.wait_for(writer.drain(), timeout=3.0)
                
                writer.close()
                await writer.wait_closed()
                
                # Обновляем локальный буфер, чтобы избежать зацикливания
                current_clip = text
        except Exception as e:
            print(f"[Client] Ошибка: {e}")
            
        await asyncio.sleep(1)

async def handle_server_client(reader, writer):
    global current_clip
    try:
        data = await reader.read(4096)  # Читаем данные асинхронно
        if data:
            text = data.decode("utf-8")
            if text != current_clip:
                print(f"[Server] Получено: {text[:20]}...")
                
                current_clip = text  # Запоминаем, чтобы клиент не отправлял это обратно
                pyperclip.copy(text)
    except Exception as e:
        print(f"[Server] Ошибка при обработке: {e}")
    finally:
        writer.close()
        await writer.wait_closed()

async def server():
    # Запускаем полностью асинхронный сервер
    server = await asyncio.start_server(handle_server_client, "0.0.0.0", 5001)
    print("[Server] Запущен и ожидает подключений...")
    async with server:
        await server.serve_forever()

async def main():
    await asyncio.gather(client(), server())

if __name__ == "__main__":
    asyncio.run(main())
