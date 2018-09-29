macro GoGraph
	push	ax
	mov	ax, 0013h
	int	10h
	pop	ax
endm
macro GoText
	push	ax
	mov	ax, 0003h
	int	10h
        pop	ax
endm