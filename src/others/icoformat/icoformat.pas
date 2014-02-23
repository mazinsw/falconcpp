unit icoformat;

//true color icon format unit for use on WinXP and later
// Only supports XP style 32 bit icons
// does not support PNG (Vista) icons
// written 18 Oct 2007 by Phil Hayward
// phil at pjhayward.net or http://pjhayward.net/

//How to use this unit:
//  define a color bitmap and alpha (transparency) bitmap for each icon resolution you want
//    i.e. 8x8, 16x16, 24x24, 32x32, 48x48, etc - you don't need them all, just one
//  Load in your color bitmap
//  Set the pixel format on your color bitmap to pf24bit, and
//    the pixel format on your alpha bitmap to pf8bit
//  The unit uses the color index of the alpha bitmap to determine transparency,
//    not the actual color.  color index 0 is completely transparent,
//    and color index 255 is completely opaque.  an example of how to use it:
//
// var row:PByteArray;
//    for i:=0 to alphabmp.Height-1 do begin
//      row:=AlphaBmp.ScanLine[i];
//      for j:=0 to alphabmp.Width-1 do
//        row^[j]:=128; //128 is halfway transparent
//    end;
//  Once you have your color and alpha bitmaps prepared, you have a couple options.
//  The quick and easy way is to call SaveBitmapsToIcon(ColorBmp,AlphaBmp,'filename.ico');
//    but that only gives you a single resolution icon.  To load in additional sizes:
//  Define a variable of type icon, i.e. var myicon:icon, then set it using
//    newicon.  i.e. myicon:=newIcon(ColorBmp,AlphaBmp);
//  Add any additional icon resolutions using AddBitmapsToIcon.
//    i.e. AddBitmapsToIcon(ColorBmp2,AlphaBmp2,myicon);
//  Save the icon file using SaveIcon, and check the return value for errors.
//    i.e. if SaveIcon(myicon,'your\icon\folder\and\file_name.ico') > 0 then do_something
//  Destroy the icon when you're done with it to clean up dynamically allocated memory
//    i.e. destroyIcon(myicon);

//  It's worth mentioning that destroyIcon doesn't destroy the variable itself.  After
//    a call to destroyIcon, the icon image data is gone, but you could add it back in
//    using AddBitmapsToIcon.  Saving an icon with no image data will return a result of 1

//  To check if an icon has image data, look in the icon.directory.idCount variable.
//  Naturally, that will only be valid if you only use the routines provided in this unit.

//  I only built in support for 32 bit icons, but the structures are valid for 4, 8, 16 and 24
//    bit icons as well.  instead of an 8 bit transparency channel, you will have a 1 bit
//    AND channel you'll need to create, which should be stored in the icAND property of the
//    icon image data. Maybe in a later release I'll add that functionality, but the way I see
//    it, 32 bit with full transparency control looks better.
//  If you decide to use 8bpp or less, you will need to generate a color table for that image.
//    I haven't looked up the color table format yet, but I imagine you could probably
//    pull it from your bitmap image, since the .ico format is so similar to .bmp

interface
uses Windows,Graphics,SysUtils;

type
  iconDirEntry=packed record
    bWidth:byte;
    bHeight:byte;
    bColorCount:byte;          // 0 if >=8bpp
    bReserved:byte;            //must be 0
    wPlanes:word;              //Color planes - must be 1
    wBitCount:word;            //bits per pixel
    dwBytesInRes:longword;     //how many bytes in this resource?
    dwImageOffset:longword;    //where in the file is this image?
  end;
  iconDir=packed record
    idReserved:word; //must be 0
    idType:word;     //should be 1 for icons
    idCount:word;    //number of entries in the file
    idEntries:array of iconDirEntry; //[0..idCount-1] not valid in Pascal, but that's what it is.
  end;
  iconImage=record
    icHeader:BitmapInfoHeader;    //DIB header
    icColors:PByteArray;    // color table    NULL for 16,24,32bpp
    icXOR:PByteArray;          // DIB bits for xor mask
    icAND:PByteArray;          // DIB bits for and mask NULL for 32bpp
  end;

  icon=record
    directory:iconDir;
    images:array of iconImage;
  end;

  TGrpIconDir = packed record
    idReserved: Word;           // Reserved (must be 0)
    idType: Word;               // Resource type (1 for icons)
    idCount: Word;              // How many images?
  end;

  TGrpIconDirEntry = packed record
    bWidth: Byte;               // Width, in pixels, of the image
    bHeight: Byte;              // Height, in pixels, of the image
    bColorCount: Byte;          // Number of colors in image (0 if >=8bpp)
    bReserved: Byte;            // Reserved
    wPlanes: Word;              // Color Planes
    wBitCount: Word;            // Bits per pixel
    dwBytesInRes: DWORD;        // how many bytes in this resource?
    nID: Word;                  // the ID
  end;

function LoadIconFromResource(const ResName: string; Dimension: Integer): TIcon;
procedure addBitmapsToIcon(bitmapImage,grayscaleAlpha:tBitmap;var workicon:icon);
procedure destroyIcon(var icondata:icon);
function newIcon(bitmapImage,grayscaleAlpha:tBitmap):icon;
function saveIcon(icondata:icon;filename:string):integer;
//exit codes:
//  0: success
//  1: no image data in icon
//  2: exception occured while saving

//shortcut routine that uses the others.
function saveBitmapsToIcon(bitmapImage,grayscaleAlpha:tBitmap;filename:string):integer;
//same exit codes as saveIcon, except exit code 1 should never happen...

implementation

uses
  Classes;

function LoadIconFromResource(const ResName: string; Dimension: Integer): TIcon;
var
  Rs, RsI: TResourceStream;
  Ms: TMemoryStream;
  I: Integer;
  dwOffset: Cardinal;
  GroupDir: TGrpIconDir;
  GroupDirEntry: TGrpIconDirEntry;  
  IconDir: TCursorOrIcon;
  IconDirEntry: TIconRec;
  Info: TBitmapInfoHeader;
begin
  Result := TIcon.Create;
  Rs := TResourceStream.Create(MainInstance, ResName, RT_GROUP_ICON);
  Rs.Read(GroupDir, SizeOf(TGrpIconDir));
  if not (GroupDir.idType in [RC3_STOCKICON, RC3_ICON]) then
  begin
    Rs.Free;
    Exit;
  end;
  I := 0;
  Ms := TMemoryStream.Create;
  while I < GroupDir.idCount do
  begin
    dwOffset := SizeOf(TGrpIconDir) + I * SizeOf(TGrpIconDirEntry);
    Rs.Seek(dwOffset, soFromBeginning);
    Rs.Read(GroupDirEntry, SizeOf(TGrpIconDirEntry));
    RsI := TResourceStream.CreateFromID(MainInstance, GroupDirEntry.nID, RT_ICON);
    RsI.Read(Info, SizeOf(TBitmapInfoHeader));
    if (Info.biWidth = Dimension) and (Info.biHeight div 2 = Dimension) then
    begin
      RsI.Seek(0, soFromBeginning);
      IconDir.Reserved := 0;
      IconDir.wType := RC3_ICON;
      IconDir.Count := 1;
      Ms.Write(IconDir, SizeOf(TCursorOrIcon));
      IconDirEntry.Width := Info.biWidth;
      IconDirEntry.Height := Info.biHeight div 2;
      IconDirEntry.Colors := Info.biBitCount div 8;
      IconDirEntry.Reserved1 := Info.biPlanes;
      IconDirEntry.Reserved2 := Info.biBitCount;
      IconDirEntry.DIBSize := GroupDirEntry.dwBytesInRes;
      IconDirEntry.DIBOffset := SizeOf(TCursorOrIcon) + SizeOf(TIconRec);
      Ms.Write(IconDirEntry, SizeOf(TIconRec));
      Ms.CopyFrom(RsI, RsI.Size);
      RsI.Free;
      Break;
    end;
    RsI.Free;
    Inc(I);
  end;
  Ms.Position := 0;
  Result.LoadFromStream(Ms);
  Ms.Free;
  Rs.Free;
end;

procedure addBitmapsToIcon(bitmapImage,grayscaleAlpha:tBitmap;var workicon:icon);
var
  index:integer;
  i,j:integer;
  ColorRow:PByteArray;
  Alpharow:PByteArray;
  offset:integer;
begin
  //set pixel formats, just in case
  bitmapImage.PixelFormat:=pf24bit;
  grayscaleAlpha.PixelFormat:=pf8bit;
  //we're going to ignore the actual colors of the alpha bitmap, and
  //use the color index as our alpha level 
  with workicon do begin
  index:=directory.idCount; //get current count - that'll be the index of the array after inc.
  inc(directory.idCount);
  SetLength(directory.idEntries,directory.idCount);
  with directory.idEntries[index] do begin
    bWidth:=bitmapImage.Width;
    bHeight:=bitmapImage.Height;
    bColorCount:=0; //0 for >=8bpp
    bReserved:=0;
    wPlanes:=1;  //always 1 plane for v3 BMP and all ICO
    wBitCount:=32;  //yay for true color!
    dwBytesInRes:=bWidth*bHeight*4+sizeof(BitmapInfoHeader); //total size of the bitmap resource
    //dwImageOffset set in saveIcon routine, after all bitmaps are added.
  end;
  SetLength(images,directory.idCount); //set up some storage space for the image
  with images[index].icHeader do begin //redundant but required bitmap header
    biSize:=40;
    biWidth:=bitmapImage.Width;
    // <32bpp icons have an XOR (color) mask followed by an AND bitmask of the same height.
    // so the biHeight parameter must be 2x actual size.
    biHeight:=bitmapImage.Height*2;
    biPlanes:=1;
    biBitCount:=32;
    biCompression:=0;
    biSizeImage:=biWidth*biHeight*2; //size of JUST the raw bitmap data
    biXPelsPerMeter:=0;
    biYPelsPerMeter:=0;
    biClrUsed:=0;
    biClrImportant:=0;
  end;
  GetMem(images[index].icXOR,bitmapImage.Width*bitmapImage.Height*4);
  with images[index] do
  for i:=0 to bitmapImage.Height-1 do begin
    //bitmaps are stored bottom-up, so we'll grab the bottom row first
    ColorRow:=bitmapImage.ScanLine[(bitmapImage.Height-1)-i];
    AlphaRow:=grayscaleAlpha.ScanLine[(bitmapImage.Height-1)-i];
    for j:=bitmapImage.Width-1 downto 0 do begin //pull the bitmap data over
      offset:=i*bitmapImage.Width*4+j*4;
      icXOR^[offset]:=ColorRow^[j*3];
      icXOR^[offset+1]:=ColorRow^[j*3+1];
      icXOR^[offset+2]:=ColorRow^[j*3+2];
      icXOR^[offset+3]:=AlphaRow^[j]; //alpha stored as byte 4 of each pixel
    end;
  end;
  end;
end;

procedure destroyIcon(var icondata:icon);
var
  i:integer;
begin
  for i:=0 to icondata.directory.idCount-1 do
    FreeMem(icondata.images[i].icXOR,icondata.images[i].icHeader.biSizeImage);
  SetLength(icondata.directory.idEntries,0);
  SetLength(icondata.images,0);
  icondata.directory.idCount:=0;
end;

function newIcon(bitmapImage,grayscaleAlpha:tBitmap):icon;
var
  localicon:icon;
begin
  localicon.directory.idReserved:=0; //always 0
  localicon.directory.idType:=1; //always 1 for icons
  localicon.directory.idCount:=0; //updated by Addbitmaps... procedure
  AddBitmapsToIcon(bitmapImage,grayscaleAlpha,localicon);
  newIcon:=localicon;
end;

function saveIcon(icondata:icon;filename:string):integer;
//exit codes:
//  0: success
//  1: no image data in icon
//  2: exception occured while saving
var
  i:integer;
  outfile:file;
begin
  //if there's no images in the icon, exit
  if icondata.directory.idCount > 0 then begin
  with icondata.directory do begin
    //set up the image offset for the first image
    idEntries[0].dwImageOffset:=sizeof(word)*3+Sizeof(iconDirEntry)*idCount;
    i:=1;
    while i < idCount do begin
      with idEntries[i-1] do //use previous image's offset + its size for new offset
        idEntries[i].dwImageOffset:=dwImageOffset+dwBytesInRes;
      inc(i);
    end;
  end;
  try
    assignfile(outfile,filename);
    rewrite(outfile,1);
    //write the icon directory data, minus the entries
    blockwrite(outfile,icondata.directory,sizeof(word)*3);
    //write the icon directory entries
    for i:=0 to icondata.directory.idCount-1 do
      blockwrite(outfile,icondata.directory.idEntries[i],sizeof(iconDirEntry));
    //write the images, header first then data
    for i:=0 to icondata.directory.idCount-1 do begin
      blockwrite(outfile,icondata.images[i].icHeader,sizeof(icondata.images[i].icHeader));
      blockwrite(outfile,icondata.images[i].icXOR^,icondata.images[i].icHeader.biSizeImage);
    end;
    result:=0; //exited ok;
  except
    //if it doesn't work, you'll get an exception dialog, but the program won't die.
    result:=2; //failed somehow
  end;
  closefile(outfile);
  end else
    result:=1; //no image data
end;

function saveBitmapsToIcon(bitmapImage,grayscaleAlpha:tBitmap;filename:string):integer;
var
  work:icon;
begin
  work:=NewIcon(bitmapImage,grayscaleAlpha);
  result:=saveIcon(work,filename);
  destroyIcon(work);
end;

end.
