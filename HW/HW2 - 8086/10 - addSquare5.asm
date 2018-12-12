; multi-segment executable file template.

data segment
    ; add your data here! 
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
    mov ax, 10;n
    mov bx, 0 ;sum
    mov cx, 5 ;to multiply
    mov dx, ax 
loop_begin:  
    mov ax, cx   
    mul al 
    add bx, ax       
    add cx, 5
    cmp dx, cx
    jge loop_begin 
               

            
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
