_lzss_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]

@tblcnt = 1000h

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_MemAlloc, 10000h*4+@tblcnt*2
	jc	@@9a
	push	eax
	mov	esi, [@@SB]
	xchg	edi, eax
	mov	ecx, 10000h
	lea	eax, [esi-@tblcnt-1]
	rep	stosd
	push	edi
	push	-80h
	mov	edi, [@@DB]
	xor	ebx, ebx
	push	edi	; @@L1
	cmp	[@@SC], ebx
	je	@@9
@@1:	stc
	call	@@3
	mov	al, [esi]
	stosb
	call	@@next
@@1a:	mov	ecx, [@@SC]
	cmp	ecx, 3
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	xchg	ebx, eax
	call	@@3a
	lea	eax, [ecx+esi-12h]
	sub	eax, [@@SB]
	lea	ecx, [ebx-3]
	shl	ah, 4
	add	ah, cl
	stosw
@@1b:	call	@@next
	dec	ebx
	jne	@@1b
	jmp	@@1a

@@9b:	call	@@3a
@@9:	cmp	byte ptr [@@L0], 80h
	jne	@@9b
	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3a:	clc
@@3:	mov	eax, [@@L0]
	rcr	al, 1
	jc	@@3c
	test	al, 3Fh
	jne	@@3b
	mov	[@@L1], edi
	inc	edi
@@3b:	mov	[@@L0], eax
	ret
@@3c:	mov	edx, [@@L1]
	mov	[edx], al
	mov	al, 80h
	jmp	@@3b

@@next:	dec	[@@SC]
	je	@@9
	mov	ecx, esi
	mov	edx, [@@M]
	movzx	eax, word ptr [esi]
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
	inc	esi
	ret

@@match PROC
	push	edi
	push	0	; D
	push	2	; C = min-1
	push	12h
	pop	ebx
	cmp	ecx, ebx
	jae	$+4
	mov	ebx, ecx
	mov	ecx, [ebp-4]
	movzx	eax, word ptr [esi]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	jmp	@@3

@@4:	xor	edx, edx
	lea	edi, [esi+ecx]
	inc	edx
@@5:	inc	edx
	cmp	edx, ebx
	jae	@@6
	mov	al, [esi+edx]
	cmp	[edi+edx], al
	je	@@5
@@6:	pop	eax
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -@tblcnt
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP
