// +----------------------------------------------------------------------+
// |    chsdet - Charset Detector Library                                 |
// +----------------------------------------------------------------------+
// | Copyright (C) 2006, Nick Yakowlew     http://chsdet.sourceforge.net  |
// +----------------------------------------------------------------------+
// | Based on Mozilla sources     http://www.mozilla.org/projects/intl/   |
// +----------------------------------------------------------------------+
// | This library is free software; you can redistribute it and/or modify |
// | it under the terms of the GNU General Public License as published by |
// | the Free Software Foundation; either version 2 of the License, or    |
// | (at your option) any later version.                                  |
// | This library is distributed in the hope that it will be useful       |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of       |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                 |
// | See the GNU Lesser General Public License for more details.          |
// | http://www.opensource.org/licenses/lgpl-license.php                  |
// +----------------------------------------------------------------------+
//
// $Id: chsdIntf.pas,v 1.5 2013/04/23 19:47:10 ya_nick Exp $

unit chsdIntf;

interface

uses
  nsCore;

	procedure chsdet_Reset; stdcall;
  function  chsdet_HandleData(aBuf: pAnsiChar; aLen: integer): integer; stdcall;
  function  chsdet_Done: boolean; stdcall;
  procedure chsdet_DataEnd; stdcall;
  function  chsdet_GetDetectedCharset: rCharsetInfo; stdcall;
  // "overload" version for .net
  procedure chsdet_GetDetectedCharsetInfo(out CharsetInfo: rCharsetInfo); stdcall;
  function  chsdet_GetKnownCharsets(out KnownCharsets: WideString): integer; stdcall;
  procedure chsdet_GetAbout(out About: rAboutHolder); stdcall;
  function  chsdet_GetDetectedBOM: eBOMKind; stdcall;
  function  chsdet_GetBOMLength(BOM: eBOMKind): integer; stdcall;
  procedure chsdet_DisableCharsetCP(CodePage: integer); stdcall;


implementation
uses
	nsUniversalDetector;

var
  Detector: TnsUniversalDetector = nil;

procedure chsdet_Reset; stdcall;
begin
	Detector.Reset;
end;

function chsdet_HandleData(aBuf: pAnsiChar; aLen: integer): integer; stdcall;
begin
	Result := Detector.HandleData(aBuf, aLen);
end;

function chsdet_Done: boolean; stdcall;
begin
	Result := Detector.Done;
end;

procedure chsdet_DataEnd; stdcall;
begin
	Detector.DataEnd;
end;

function chsdet_GetDetectedCharset: rCharsetInfo; stdcall;
begin
  Result := Detector.GetDetectedCharsetInfo;
end;

procedure chsdet_GetDetectedCharsetInfo(out CharsetInfo: rCharsetInfo); stdcall;
begin
  CharsetInfo := Detector.GetDetectedCharsetInfo;
end;

function chsdet_GetKnownCharsets(out KnownCharsets: WideString): integer; stdcall;
begin
  Result := Detector.GetKnownCharset(KnownCharsets);
end;

procedure chsdet_GetAbout(out About: rAboutHolder); stdcall;
begin
  Detector.GetAbout(About);
end;

function chsdet_GetDetectedBOM: eBOMKind; stdcall;
begin
  Result := Detector.BOMDetected;
end;

function  chsdet_GetBOMLength(BOM: eBOMKind): integer; stdcall;
begin
  Result := KNOWN_BOM[BOM].Length;
end;

procedure chsdet_DisableCharsetCP(CodePage: integer); stdcall;
begin
  Detector.DisableCharset(CodePage);
end;

initialization
  Detector := TnsUniversalDetector.Create;

finalization
  if Detector <> nil then
  	Detector.Free;

end.

