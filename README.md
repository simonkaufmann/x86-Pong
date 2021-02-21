# x86-Pong

Pong in Bootsector of x86 PC

## How to use

Make sure **nasm** and **genisoimage** are installed.  

Execute:  
``make all``  

File **boot.iso** will have been created.

Burn ISO image onto CD or add to virtual machine as
Boot Disc (e.g. VirtualBox)

## Useful links

https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders  
https://stackoverflow.com/questions/6542160/variable-target-in-a-makefile  
https://stackoverflow.com/questions/34268518/creating-a-bootable-iso-image-with-custom-bootloader  
https://en.wikipedia.org/wiki/X86_instruction_listings  

Cdecl calling convention:
https://en.wikipedia.org/wiki/X86_calling_conventions  

NASM manual:
https://www.nasm.us/doc/  

Reading keyboard:
http://www.ctyme.com/intr/int-16.htm
http://www.ctyme.com/intr/rb-1754.htm

Setting video mode:
http://vitaly_filatov.tripod.com/ng/asm/asm_023.1.html

