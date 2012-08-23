unit TokenConst;

interface

uses
  TokenList;

const
  TokenHintPrev: array[TTkType] of string = (
    'class',
    'func',
    'func',
    'constructor',
    'destructor',
    'inc',
    'def',
    'var',
    'type',
    'type',
    'struct',
    'struct',
    'enum',
    'enum',
    'union',
    'union',
    'namespace',
    'const',
    '',
    '',
    //********
    '',
    '',
    '',
    '',
    '',
    // root
    '',
    '',
    '',
    '',
    ''
    );

  CompletionNames: array[0..17] of string = (
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkClass
    '\color{%s}function \column{}\style{+B}\color{clBlack}', //tkFunction
    '\color{%s}function \column{}\style{+B}\color{clBlack}', //tkPrototype
    '\color{%s}constructor \column{}\style{+B}\color{clBlack}', //constructor
    '\color{%s}destructor \column{}\style{+B}\color{clBlack}', //destructor
    '\color{%s}include \column{}\style{+B}\color{clBlack}', //tkInclude
    '\color{%s}preprocessor \column{}\style{+B}\color{clBlack}', //tkDefine
    '\color{%s}var \column{}\style{+B}\color{clBlack}', //tkVariable
    '\color{%s}typedef \column{}\style{+B}\color{clBlack}', //tkTypedef
    '\color{%s}typedef \column{}\style{+B}\color{clBlack}', //tkTypedefProto
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkStruct
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkTypeStruct
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkEnum
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkTypeEnum
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkUnion
    '\color{%s}type \column{}\style{+B}\color{clBlack}', //tkTypeUnion
    '\color{%s}namespace \column{}\style{+B}\color{clBlack}', //namespace
    '\color{%s}constant \column{}\style{+B}\color{clBlack}' //constant
    );

  TokenNames: array[TTkType] of string = (
    'tkClass',
    'tkFunction',
    'tkPrototype',
    'tkConstructor',
    'tkDestructor',
    'tkInclude',
    'tkDefine',
    'tkVariable',
    'tkTypedef',
    'tkTypedefProto',
    'tkStruct',
    'tkTypeStruct',
    'tkEnum',
    'tkTypeEnum',
    'tkUnion',
    'tkTypeUnion',
    'tkNamespace',
    'tkEnumItem',
    'tkForward',
    'tkUnknow',
    //********
    'tkIncludeList',
    'tkDefineList',
    'tkTreeObjList',
    'tkVarConsList',
    'tkFuncProList',
    //*******
    'tkRoot',
    'tkParams',
    'tkScope',
    'tkScopeClass',
    'tkUsing'
    );

  LetterChars: set of Char = ['A'..'Z', 'a'..'z', '_'];
  DigitChars: set of Char = ['0'..'9'];
  HexChars: set of Char = ['A'..'F', 'a'..'f'];
  SpaceChars: set of Char = [' ', #9];
  LineChars: set of Char = [#13, #10];
  ArithmChars: set of Char = ['.', '+', '-', '*', '/', '%'];
  OpenBraceChars: set of Char = ['(', '{', '<', '['];
  CloseBraceChars: set of Char = [')', '}', '>', ']'];
  BraceChars: set of Char = ['(', '{', '<', '[', ')', '}', '>', ']'];
  ReservedBraceWords: array[0..15] of string = (
    'while', 'for', 'switch', 'sizeof', 'if', 'catch', 'return',
      //extern
    'char', 'int', 'long', 'float', 'short', 'signed', 'unsigned',
    'void', 'double'
    );
  ReservedTypes: array[0..9] of string = (
    'char', 'int', 'long', 'float', 'short', 'signed', 'unsigned',
    'void', 'double', 'register'
    );
  ScopeNames: array[0..2] of string = (
    'public', 'private', 'protected'
    );

type
  TCompletionColors = array[TTkType] of string;
  TScopeClass = (scPrivate, scProtected, scPublic, scNone);
  TScopeClassState = set of TScopeClass;

implementation

end.
