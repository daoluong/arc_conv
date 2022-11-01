
_arc_ism PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	imul	ebx, [esi], 40h
	lea	edi, [ebx+10h]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	eax, ' MSI'
	stosd
	mov	eax, 'HCRA'
	stosd
	mov	eax, 'DEVI'
	stosd
	movsd
	mov	word ptr [edi-2], 1
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 38h, dword ptr [esi+4]
	add	edi, 34h

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd

	xor	eax, eax
	stosd
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
