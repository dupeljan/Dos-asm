                                                                                                                             {
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Turbo Pascal Compiler                                                                                                   บ
บ                                                                                                                         บ
บ TPC16 Version 1.0, 16-bit command line compiler compatible with Borland Turbo Pascal 7 TPC.EXE                          บ
บ                                                                                                                         บ
บ Copyright (C) 2000,2009 Igor Funa                                                                                       บ
บ                                                                                                                         บ
ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บ TPC16                                                                                                                   บ
ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บ                                                                                                                         บ
บ Turbo Pascal Compiler (16-bit) - Compatible with Borland Turbo Pascal 7 command line compiler TPC.EXE                   บ
บ                                                                                                                         บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ  }

Program TPC16;

Uses
  Strings,
  Parser,
  Scanner,
  IOUtils,
  ResWords,
  CommVars;

begin
  Writeln (GreetingString);
  CmdPtr := Ptr (PrefixSeg, $80);
  CmdPtr [Byte (CmdPtr [0]) + 1] := #0;
  CmdPtr [0] := ' ';
  CfgPtr := FileBuffer;
  Get_TPL_CFG_Directory;
  Read_TPC_CFG;
  CompilerModeOptions := [cmoCreateExeFile, cmoCompileToDisk];
  LinkerOptions := [];
  CommandLineConditionalDefines := InitialConditionalDefines;
  StartOfSourceFileStructures := @FileStructure;
  ProcessCompilerParameters;
  StrCopy (TempStr, GlobalModuleData^.LibraryName);
  CurrentFileName := TempStr;
  FindFilePath (TempStr, Dir_TPL_CFG or Ext_Original);
  LoadLibrary;
  Case LastError of
    FileNotFound: Writeln ('Warning: ', TempStr, ' not found.');
    NoError:
    else WriteCompilationErrorAndHalt;
  end;
  With GlobalModuleData^ do
    begin
      InitialEnvironmentFlags := EnvironmentFlags;
      InitialCompilerSwitches := CompilerSwitches;
      ModuleStack   := Stack;
      ModuleHeapMin := HeapMin;
      ModuleHeapMax := HeapMax;
    end;
  CurrentFileName := MainFileName;
  FindFilePath (CurrentFileName, Dir_None or Ext_PAS);
  StartCounter := InterruptCounter;
  CompilationInProgress := True;
  Compile;
  CompilationInProgress := False;
  StopCounter := InterruptCounter;
  If LastError <> NoError then WriteCompilationErrorAndHalt;
  If cmoFindError in CompilerModeOptions then
    begin
      FindAndWriteSourceLine;
      WriteCompilationErrorAndHalt;
    end;
  WriteCompilationStatus;
end.
