; 打印helloworld信息的主引导记录
org		7c00H																; BIOS读入MBR（Main Boot Record，主引导记录，位于磁盘最前的一段引导代码，所在扇区称为“引导扇区”）后，指示从内存中7c00H地址之后开始执行
; 下面通过制造10h中断来显示字符
mov		ax,	cs																; 因为专用寄存器之间传递数据需要借助通用寄存器，所以现将将代码段首地址装入ax寄存器
mov		es,	ax
mov		ax,	msg																; 字符串数据相对地址
mov		bp, ax																; es:bp，即 代码段地址+字符串数据相对地址=字符串数据的绝对地址
mov		cx, msgLen															; cx寄存器存放字符串长度
mov		ax, 1301H															; ah的内容决定向何种设备输出字符，13H表示TTY（Teletypes，电传打印机）；al的内容决定显示方式，01H表示不包含
mov		bx, 0006H															; bh的内容表示显示页，这里是第0页，bl的内容表示颜色（我不知道06H表示什么色，测了才懂）
mov		dx, 0a0fH															; dh的内容表示显示行，为了字符串尽量居中，这里我用第10行；dl的内容表示显示列，这里我用第15列
int		10H																	; 10H中断，显示字符串

; 字符串的内容
msg:	db "hello world, welcome to bunny-linux OS! The author is Bin Qu."	; 字符串内容
msgLen:	equ $ - msg															; 字符串长度，$表示当前位置对应的地址，msg表示msg数据的相对地址
times	510 - ($ - $$) db 0													; 使用0填充剩余部分，$$表示段开始位置对应的地址。由于目标磁盘扇区大小为512字节，所以需要填充满512字节，剩下两个字节用来放魔数
dw		0aa55H																; 魔数，告诉BIOS这个扇区是MBR