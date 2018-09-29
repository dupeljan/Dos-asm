TPC16 - Turbo Pascal 7 compatible command line Pascal compiler
written in Turbo Pascal, Copyright (c) 2000,2009 Igor Funa

http://turbo51.com/compiler-design/tpc16-turbo-pascal-compiler-written-in-turbo-pascal

This folder contains files needed to compile the TPC16 - Turbo Pascal 7
compatible compiler. TPC16 is compatible with Borland Turbo Pascal 7 command
line compiler (TPC.EXE)
- on the input level (it compiles Turbo Pascal 7 source files);
- on the output level (it generates the same unit and executable files).

There are some minor differences between TPC16.EXE and TPC.EXE:
- TPC16.EXE file is bigger than TPC.EXE,
- TPC16 does not generate map file,
- TPC16 does not include debug info in the EXE file it generates,
- few other differences of minor importance.

Source Code
Source code files are best viewed with the Terminal font. This font includes
some special characters to draw lines which are used for comments before each
procedure and function. The best way to examine, modufy and compile TPC16 is
to use some advanced ASCII editor (IDE) like UltraEdit, MultiEdit, Notepad++,
PSPad, etc. One example of compiler integration with PSPad is dscribed at this
page http://turbo51.com/8051-editor-ide

TPC, BPC and TPC16 use the same compiler result output format so you will
easily adjust parameters for them.

Compiling the TPC16 compiler (without IDE):

- start a console (run cmd.exe)
- move to the compiler folder (either DEMO or TPC16)
- run compile.bat batch file
- you should get something similar to the text below:

- DEMO compilation, TPC16 normal compilation (no source file changed)

Borland Pascal  Version 7.0  Copyright (c) 1983,92 Borland International
TPC16.PAS(71)
71 lines, 149360 bytes code, 26648 bytes data.

- TPC16 compilation with /B option

Borland Pascal  Version 7.0  Copyright (c) 1983,92 Borland International
TOKENS.INC(126)
RESWORDS.PAS(308)
ERRORS.INC(388)
SYSOFS.INC(209)
CONSTYPE.INC(721)
COMMVARS.PAS(287)
OPCODES.INC(354)
SCANNER.PAS(1684)
IOUTILS.PAS(1019)
SCANNER.PAS(27)
SYMTABLE.PAS(949)
CODEGEN.PAS(1603)
CALC.PAS(1305)
SYSFUNC.PAS(1299)
EXPR.PAS(5152)
SYMTABLE.PAS(27)
TYPEDEFS.PAS(339)
SYMTABLE.PAS(27)
SYSPROC.PAS(1356)
ASMWORDS.INC(2138)
ASMTYPES.PAS(137)
ASMINST.PAS(2972)
STATMNTS.PAS(1007)
OMF.PAS(978)
LINKER.PAS(914)
PARSER.PAS(3289)
TPC16.PAS(71)
28680 lines, 149360 bytes code, 26648 bytes data.

DISCLAIMER

This Software and any support are provided “AS IS” and without warranty,
express or implied. Igor Funa specifically disclaims any implied warranties
of merchantability and fitness for a particular purpose. In no event will
Igor Funa be liable for any damages, including but not limited to any lost
profits, lost savings or any incidental or consequential damages, whether
resulting from impaired or lost data, software or computer failure or any
other cause, or for any other claim by the user or for any third party claim.