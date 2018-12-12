; multi-segment executable file template.

data segment
    ; add your data here! 
    numbers db 5, 1, 4, 2, 8
    length  db 5   
    swap db 0
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
      
loop1:  
    mov swap, 0 
    mov bx, 0
    mov ch, 1   
    loop2:  
         mov ah, [numbers+bx]
         mov al, [numbers+bx+1] 
         cmp ah, al
         jge end1 
         mov swap, 1
         mov [numbers+bx], al
         mov [numbers+bx+1], ah
    end1:
         inc bx
         inc ch
         cmp length, ch
         jg loop2
    cmp swap, 0h
    jnz loop1
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
