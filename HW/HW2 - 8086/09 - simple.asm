; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment 

subr9 proc near 
    mov dx, 0B000h
    in ax, dx 
    and ax, 0010h
    jz return 
    pop bx ; pop ip  
    push ax; push data
    push bx; push ip
return:     
    ret
subr9 endp
      
start:       
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
    
    call subr9
         
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
