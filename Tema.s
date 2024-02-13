.data
matrice: .zero 1600
copie: .zero 1600
columnIndex: .space 4
lineIndex: .space 4
m: .space 4
n: .space 4
p: .space 4
index: .space 4
i: .space 4
j: .space 4
k: .space 4
ev: .space 4
formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld "
newLine: .asciz "\n"
.text
.global main 

main:
    pushl $m
    pushl $formatScanf
    call scanf
    addl $8, %esp		
    incl m			

    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp
    incl n

    pushl $p
    pushl $formatScanf
    call scanf
    addl $8, %esp

    movl $0, index
et_for:
    movl index, %ecx
    cmp %ecx, p
    je et_cit_k

    pushl $i
    pushl $formatScanf
    call scanf
    addl $8, %esp

    pushl $j
    pushl $formatScanf
    call scanf
    addl $8, %esp

    incl i
    incl j

    movl i, %eax
    movl $0, %edx
    mull n			
    addl j, %eax
    lea matrice, %edi
    

    movl $1, (%edi, %eax, 4)
    incl index
    jmp et_for

et_cit_k:
    pushl $k
    pushl $formatScanf
    call scanf
    addl $8, %esp

    mov $copie, %esi
    movl $0, ev
et_for_evol:
    movl ev, %ecx
    cmp %ecx, k
    je et_afis_matr
    
 et_logica_conway:
    mov $1, lineIndex
    conway_for_lin:
    	movl lineIndex, %ebx
    	cmp %ebx, m
    	je et_cop_inapoi
    
	movl $1, columnIndex    
    	conway_for_col:
    		movl columnIndex, %ebx
    		cmp %ebx, n
    		je sfarsit_col
    		
    		movl lineIndex, %eax
    		xor %edx, %edx
    		mull n
    		addl columnIndex, %eax
    		xor %ebx, %ebx		
    		
    		subl n, %eax
    		decl %eax
    		addl (%edi, %eax, 4), %ebx
    		incl %eax
    		addl (%edi, %eax, 4), %ebx
    		incl %eax
    		addl (%edi, %eax, 4), %ebx
    		addl n, %eax
    		addl (%edi, %eax, 4), %ebx
    		subl $2, %eax
    		addl (%edi, %eax, 4), %ebx
    		addl n, %eax
    		addl (%edi, %eax, 4), %ebx
    		incl %eax
    		addl (%edi, %eax, 4), %ebx
    		incl %eax
    		addl (%edi, %eax, 4), %ebx
    		decl %eax
    		sub n, %eax
    					
    		cmp $2, %ebx	
    		jl celula_moarta
    		cmp $3, %ebx	
    		jg celula_moarta	
    		je celula_vie
    					
    		mov (%edi, %eax, 4), %ecx
    		mov %ecx, (%esi, %eax, 4)
    		jmp sfarsit_celula
    		
    		celula_moarta:
    			mov $0, (%esi, %eax, 4)
    			jmp sfarsit_celula
    		celula_vie:
    			mov $1, (%esi, %eax, 4)
    		
    		sfarsit_celula:
    		incl columnIndex
    		jmp conway_for_col
    	sfarsit_col:
    	incl lineIndex
    	jmp conway_for_lin
    	
	et_cop_inapoi:
		lea matrice, %edi
		lea copie, %esi
		movl $400, %ecx
	for_copie:
		mov (%esi, %ecx, 4), %eax
		mov %eax, (%edi, %ecx, 4)
		loop for_copie		
    incl ev
    jmp et_for_evol

et_afis_matr:
    movl $1, lineIndex
for_lines:
    movl lineIndex, %ecx
    cmp %ecx, m
    je et_exit

    movl $1, columnIndex
for_columns:
    movl columnIndex, %ecx
    cmp %ecx, n
    je cont
    movl lineIndex, %eax
    movl $0, %edx
    mull n				
    addl columnIndex, %eax
    lea matrice, %edi
    movl (%edi, %eax, 4), %ebx

    pushl %ebx
    pushl $formatPrintf
    call printf
    addl $8, %esp		

    pushl $0
    call fflush
    popl %ebx

    incl columnIndex
    jmp for_columns

cont:
    pushl $newLine		
    call printf
    addl $4, %esp

    incl lineIndex
    jmp for_lines
et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
