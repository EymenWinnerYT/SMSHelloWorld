# Checksum is needed for Usa and Europe BIOSes, or BIOS will show "software error"
# Checksum in SMS is low word of sum of first 32.752 bytes of ROM, little endian

with open("helloworld.sms", "r+b") as f:    # replace file name with your exact file
    f.seek(0x0000)                          # read first 32.752 bytes to a buffer
    data = f.read(0x7FEF - 0x0000 + 1)

    checksum = sum(data) & 0xFFFF           # calculate sum
    print(f"Caclulated checksum: {checksum:04X}")
    f.seek(0x7FFA)
    f.write(bytes([checksum & 0xFF]))       # write low byte
    f.seek(0x7FFB)
    f.write(bytes([(checksum >> 8) & 0xFF]))#write high byte
    print("Checksum is written")
