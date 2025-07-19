with open("helloworld.sms", "r+b") as f:
    f.seek(0x0000)
    data = f.read(0x7FEF - 0x0000 + 1)

    checksum = sum(data) & 0xFFFF
    print(f"Caclulated checksum: {checksum:04X}")
    f.seek(0x7FFA)
    f.write(bytes([checksum & 0xFF]))
    f.seek(0x7FFB)
    f.write(bytes([(checksum >> 8) & 0xFF]))
    print("Checksum is written")