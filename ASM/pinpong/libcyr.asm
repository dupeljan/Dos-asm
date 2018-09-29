.xlist
 ;Макрос для инициализации различных графических режимов.
 initgraph macro mode
  mov ax, mode
  int 10h
 endm
 ;Макрос для позиционирования курсора.
 pose macro x, y 
  push dx 
  push ax 
  push bx  
  mov dh, x 
  mov dl, y
  mov ah, 2  
  mov bh, 0          
  int 10h               
  pop bx                   
  pop ax                              
  pop dx                 
 endm                                
 ;Макрос для вывода текста. 
 write macro text
  push ax                                              
  push dx 
  mov ah, 9 
  lea dx, text
  int 21h 
  pop dx                                          
  pop ax                                                    
 endm                     
 ;Макрос для вывода текста по координатам.
 print   macro   text, x, y      
  pose x, y        
  write text           
 endm
 ;Параметры в процедуры передаём через стек. 
 ;Макрос для вызова процедуры отрисовки точки.
 extrn _plot:far
 plot macro x, y, color
  push x
  push y
  push color
  call _plot
 endm
 ;Макрос для вызова процедуры отрисовки линии по двум точкам.
 extrn _line:far
 line macro x1, y1, x2, y2, color
  push y1
  push x1
  push y2
  push x2
  push color
  call _line
 endm
 ;Макрос для вызова процедуры отрисовки прямоугольника по двум точкам.
 extrn _rect:far
 rect macro x1, y1, x2, y2, color1, color2
  push x1
  push y1
  push x2
  push y2
  ;Цвет контура.
  push color1
  ;Цвет заливки.
  push color2
  call _rect
 endm
 ;Макрос для вызова процедуры отрисовки окружности.
 extrn _circle:far
 circle macro r, x, y, color1, color2
  push r
  push y
  push x
  push color1
  push color2
  call _circle
 endm
.list