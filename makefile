.PHONY: clean
core.bin: core.s 
	nasm -f bin core.s -o core.bin
kernel.bin: *.s
	nasm -f bin kernel.s -o kernel.bin
p1.bin: p1.s
	nasm -f bin p1.s -o p1.bin
pizdos.iso: p1.bin core.bin kernel.bin
	dd if=core.bin of=pizdos.iso bs=512
	dd if=kernel.bin of=pizdos.iso bs=512 seek=1
	dd if=p1.bin of=pizdos.iso bs=512 seek=3
	rm *.bin
clean:
	rm *.bin
