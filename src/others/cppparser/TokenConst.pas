unit TokenConst;

interface

uses
  TokenList;

const
  TokenHintPrev: array[TTkType] of string = (
    'class',
    'func',
    'func',
    'operator',
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
    '',
    '',
    '',
    ''
    );

  CompletionNames: array[0..18] of string = (
    '\style{-B}\color{clBlack}', //tkClass
    '\style{-B}\color{clBlack}', //tkFunction
    '\style{-B}\color{clBlack}', //tkPrototype
    '\style{-B}\color{clBlack}', //constructor
    '\style{-B}\color{clBlack}', //destructor
    '\style{-B}\color{clBlack}', //tkInclude
    '\style{-B}\color{clBlack}', //tkDefine
    '\style{-B}\color{clBlack}', //tkVariable
    '\style{-B}\color{clBlack}', //tkTypedef
    '\style{-B}\color{clBlack}', //tkTypedefProto
    '\style{-B}\color{clBlack}', //tkStruct
    '\style{-B}\color{clBlack}', //tkTypeStruct
    '\style{-B}\color{clBlack}', //tkEnum
    '\style{-B}\color{clBlack}', //tkTypeEnum
    '\style{-B}\color{clBlack}', //tkUnion
    '\style{-B}\color{clBlack}', //tkTypeUnion
    '\style{-B}\color{clBlack}', //namespace
    '\style{-B}\color{clBlack}', //constant
    '\style{-B}\color{$00AE7A00}'  //code template
    );

  TokenNames: array[TTkType] of string = (
    'tkClass',
    'tkFunction',
    'tkPrototype',
    'tkOperator',
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
    'tkUsing',
    'tkValue',
    'tkTemplate',
    'tkCodeTemplate'
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

const
  TreeTokens = [tkClass, tkTypeStruct, tkStruct, tkUnion, tkTypeUnion];
  RetTypeTokens = [tkVariable, tkFunction, tkPrototype];

implementation

end.
