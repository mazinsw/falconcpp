{
  Red-black tree class, based on the STL tree implementation of
  gcc-3.4.4 (/libstdc++-v3/include/bits/stl_tree.h and
  /libstdc++-v3/src/tree.cc) of which the insertion and deletion
  algorithms are based on those in Cormen, Leiserson and Rivest,
  Introduction to Algorithms (MIT Press, 1990).
  
  This unit should work ok with Borland Delphi and Free Pascal (I used
  fpc-2.0.0 with the -Sd commandline switch).
  
  USAGE
  The TRBTree class behaves somewhat like a TList: it stores strings
  and uses the same comparison function as TList.Sort (TListSortCompare).
  Functions Clear, Add, Delete, First and Last are equivalent,
  except that First and Last return a PRBNode instead of its Key so they
  can be used for comparisons in loops. All values occur only once in the
  tree: when the same value is added twice, the second one is not stored.
  
  To be able to manage the tree, the Create constructor has a argument
  specifying the comparison function that should be used.
  
  The function Find can be used to find a value that was put in the tree,
  it searches for the given string using the comparison function given
  at time of object creation. It returns a PRBNode.
  
  The functions RBInc and RBDec can be used to "walk" through the tree:
  given a PRBNode x, RBInc returns the PRBNode with the smallest Key that
  is larger than x, RBDec returns the PRBNode with the largest Key that is
  smaller than x. RBInc(tree.Last) and RBDec(tree.First) are not defined.
  
  EXAMPLE
  An example for usage of this unit can be found at
  http://www.vanwal.nl/rbtree/example.dpr
  
  COMPLEXITY
  Create, First and Last are done in constant time.
  Find, Add, Delete, RBInc and RBDec take O(log n) time, where n is the
  number of items in the tree.
  Destroy and Clear take O(n) time.
  
  
  AUTHOR
  Written (or "translated" ;-)) by Freek van Walderveen, November 2005.
  Includes bug fixes by Jani Mátyás, July 2008.
  
  LICENCE
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.
  See http://www.gnu.org/copyleft/gpl.html
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  As a special exception, you may use this file as part of a free software
  library without restriction.  Specifically, if you compile
  this file and link it with other files to produce an executable, this
  file does not by itself cause the resulting executable to be covered by
  the GNU General Public License.  This exception does not however
  invalidate any other reasons why the executable file might be covered by
  the GNU General Public License.
}

unit rbtree;

interface

uses
  Classes;

type  
  TRBColor = (rbRed, rbBlack);
  TStringsSortCompare = function(const s1, s2: string): Integer;
  PRBNode = ^TRBNode;
  TRBNode = record
    Key: string;
    Data: Pointer;
    Left, Right, Parent: PRBNode;
    Color: TRBColor;
  end;
  
  TRBTree = class
    private
      FRoot: PRBNode;
      FLeftMost: PRBNode;
      FRightMost: PRBNode;
      FCompareFunc: TStringsSortCompare;
      FCount: Integer;
      
      procedure RotateLeft(var x: PRBNode);
      procedure RotateRight(var x: PRBNode);
      function Minimum(var x: PRBNode): PRBNode;
      function Maximum(var x: PRBNode): PRBNode;

      function FindKey(const Key: string): Pointer;
      procedure SetDataKey(const Key: string; Data: Pointer);

    public
      constructor Create();
      destructor Destroy(); override;

      procedure Clear();

      function Find(Key: string): PRBNode;
      function Add(const Key: string; Data: Pointer): PRBNode;
      procedure Delete(z: PRBNode); overload;
      procedure Delete(const Key: string); overload;
      property First: PRBNode read FLeftMost;
      property Last: PRBNode read FRightMost;
      property Count: Integer read FCount;
      property Items[const Key: string]: Pointer read FindKey write SetDataKey;
   end; { class TRBTree }

procedure RBInc(var x: PRBNode);
procedure RBDec(var x: PRBNode);

implementation

uses SysUtils;

function StringsCompare(const s1, s2: string): Integer;
begin
  Result := CompareText(s1, s2);
end;

constructor TRBTree.Create();
begin
  inherited Create;
  FCompareFunc := StringsCompare;
  FRoot := nil;
  FLeftMost := nil;
  FRightMost := nil;
end;

destructor TRBTree.Destroy();
begin
  Clear();
  inherited Destroy;
end;

procedure fast_erase(x: PRBNode);
begin
  if (x^.Left <> nil) then  fast_erase(x^.Left);
  if (x^.Right <> nil) then fast_erase(x^.Right);
  dispose(x);
end;

procedure TRBTree.Clear();
begin
  if (FRoot <> nil) then
    fast_erase(FRoot);
  FRoot := nil;
  FLeftMost := nil;
  FRightMost := nil;
  FCount := 0;
end;

function TRBTree.Find(Key: string): PRBNode;
var
  cmp: integer;
begin
  Result := FRoot;
  while (Result <> nil) do begin
    cmp := FCompareFunc(Result^.Key, Key);
    if cmp < 0 then begin
      Result := Result^.Right;
    end else if cmp > 0 then begin
      Result := Result^.Left;
    end else begin
      break;
    end;
  end;
end;

procedure TRBTree.RotateLeft(var x: PRBNode);
var
  y: PRBNode;
begin
  y := x^.Right;
  x^.Right := y^.Left;
  if (y^.Left <> nil) then begin
    y^.Left^.Parent := x;
  end;
  y^.Parent := x^.Parent;
  if (x = FRoot) then begin
    FRoot := y;
  end else if (x = x^.Parent^.Left) then begin
    x^.Parent^.Left := y;
  end else begin
    x^.Parent^.Right := y;
  end;
  y^.Left := x;
  x^.Parent := y;
end;

procedure TRBTree.RotateRight(var x: PRBNode);
var
  y: PRBNode;
begin
  y := x^.Left;
  x^.Left := y^.Right;
  if (y^.Right <> nil) then begin
    y^.Right^.Parent := x;
  end;
  y^.Parent := x^.Parent;
  if (x = FRoot) then begin
    FRoot := y;
  end else if (x = x^.Parent^.Right) then begin
    x^.Parent^.Right := y;
  end else begin
    x^.Parent^.Left := y;
  end;
  y^.Right := x;
  x^.Parent := y;
end;

function TRBTree.Minimum(var x: PRBNode): PRBNode;
begin
  Result := x;
  while (Result^.Left <> nil) do
    Result := Result^.Left;
end;

function TRBTree.Maximum(var x: PRBNode): PRBNode;
begin
  Result := x;
  while (Result^.Right <> nil) do
    Result := Result^.Right;
end;

function TRBTree.Add(const Key: string; Data: Pointer): PRBNode;
var
  x, y, z, zpp: PRBNode;
  cmp: Integer;
begin
  z := New(PRBNode);
  { Initialize fields in new node z }
  z^.Key := Key;
  z^.Data := Data;
  z^.Left := nil;
  z^.Right := nil;
  z^.Color := rbRed;
  
  Result := z;
  
  { Maintain FLeftMost and FRightMost nodes }
  if ((FLeftMost = nil) or (FCompareFunc(Key, FLeftMost^.Key) < 0)) then begin
    FLeftMost := z;
  end;
  if ((FRightMost = nil) or (FCompareFunc(FRightMost^.Key, Key) < 0)) then begin
    FRightMost := z;
  end;
  
  { Insert node z }
  y := nil;
  x := FRoot;
  while (x <> nil) do begin
    y := x;
    cmp := FCompareFunc(Key, x^.Key);
    if (cmp < 0) then begin
      x := x^.Left;
    end else if (cmp > 0) then begin
      x := x^.Right;
    end else begin
      { Value already exists in tree. }
      Result := x;
      dispose(z);
      exit;
    end;
  end;
  z^.Parent := y;
  if (y = nil) then begin
    FRoot := z;
  end else if (FCompareFunc(Key, y^.Key) < 0) then begin
    y^.Left := z;
  end else begin
    y^.Right := z;
  end;

  { Rebalance tree }
  while ((z <> FRoot) and (z^.Parent^.Color = rbRed)) do begin
    zpp := z^.Parent^.Parent;
    if (z^.Parent = zpp^.Left) then begin
      y := zpp^.Right;
      if ((y <> nil) and (y^.Color = rbRed)) then begin
        z^.Parent^.Color := rbBlack;
        y^.Color := rbBlack;
        zpp^.Color := rbRed;
        z := zpp;
      end else begin
        if (z = z^.Parent^.Right) then begin
          z := z^.Parent;
          rotateLeft(z);
        end;
        z^.Parent^.Color := rbBlack;
        zpp^.Color := rbRed;
        rotateRight(zpp);
      end;
    end else begin
      y := zpp^.Left;
      if ((y <> nil) and (y^.Color = rbRed)) then begin
        z^.Parent^.Color := rbBlack;
        y^.Color := rbBlack;
        zpp^.Color := rbRed;
        z := zpp;
      end else begin
        if (z = z^.Parent^.Left) then begin
          z := z^.Parent;
          rotateRight(z);
        end;
        z^.Parent^.Color := rbBlack;
        zpp^.Color := rbRed;
        rotateLeft(zpp);
      end;
    end;
  end;
  FRoot^.Color := rbBlack;
  Inc(FCount);
end;


procedure TRBTree.Delete(z: PRBNode);
var
  w, x, y, x_parent: PRBNode;
  tmpcol: TRBColor;
begin
  y := z;
  x := nil;
  x_parent := nil;

  if (y^.Left = nil) then begin    { z has at most one non-null child. y = z. }
    x := y^.Right;     { x might be null. }
  end else begin
    if (y^.Right = nil) then begin { z has exactly one non-null child. y = z. }
      x := y^.Left;    { x is not null. }
    end else begin
      { z has two non-null children.  Set y to }
      y := y^.Right;   {   z's successor.  x might be null. }
      while (y^.Left <> nil) do begin
        y := y^.Left;
      end;
      x := y^.Right;
    end;
  end;
  
  if (y <> z) then begin
    { "copy y's sattelite data into z" }
    { relink y in place of z.  y is z's successor }
    z^.Left^.Parent := y; 
    y^.Left := z^.Left;
    if (y <> z^.Right) then begin
      x_parent := y^.Parent;
      if (x <> nil) then begin
        x^.Parent := y^.Parent;
      end;
      y^.Parent^.Left := x;   { y must be a child of Left }
      y^.Right := z^.Right;
      z^.Right^.Parent := y;
    end else begin
      x_parent := y;
    end;
    if (FRoot = z) then begin
      FRoot := y;
    end else if (z^.Parent^.Left = z) then begin
      z^.Parent^.Left := y;
    end else begin
      z^.Parent^.Right := y;
    end;
    y^.Parent := z^.Parent;
    tmpcol := y^.Color;
    y^.Color := z^.Color;
    z^.Color := tmpcol;
    y := z;
    { y now points to node to be actually deleted }
  end else begin                        { y = z }
    x_parent := y^.Parent;
    if (x <> nil)  then begin
      x^.Parent := y^.Parent;
    end;   
    if (FRoot = z) then begin
      FRoot := x;
    end else begin
      if (z^.Parent^.Left = z) then begin
        z^.Parent^.Left := x;
      end else begin
        z^.Parent^.Right := x;
      end;
    end;
	  if (FLeftMost = z) then begin
	    if (z^.Right = nil) then begin      { z^.Left must be null also }
	      FLeftMost := z^.Parent;
	    end else begin
	      FLeftMost := minimum(x);
      end;
    end;
	  if (FRightMost = z) then begin
	    if (z^.Left = nil) then begin       { z^.Right must be null also }
	      FRightMost := z^.Parent;  
	    end else begin                     { x == z^.Left }
	      FRightMost := maximum(x);
      end;
    end;
  end;
  
  { Rebalance tree }
  if (y^.Color = rbBlack)  then begin 
    while ((x <> FRoot) and ((x = nil) or (x^.Color = rbBlack))) do begin
      if (x = x_parent^.Left)  then begin
          w := x_parent^.Right;
          if (w^.Color = rbRed)  then begin
            w^.Color := rbBlack;
            x_parent^.Color := rbRed;
            rotateLeft(x_parent);
            w := x_parent^.Right;
          end;
          if (((w^.Left = nil) or 
               (w^.Left^.Color = rbBlack)) and
              ((w^.Right = nil) or 
               (w^.Right^.Color = rbBlack)))  then begin
            w^.Color := rbRed;
            x := x_parent;
            x_parent := x_parent^.Parent;
          end else begin
            if ((w^.Right = nil) or (w^.Right^.Color = rbBlack)) then begin
              w^.Left^.Color := rbBlack;
              w^.Color := rbRed;
              rotateRight(w);
              w := x_parent^.Right;
            end;
            w^.Color := x_parent^.Color;
            x_parent^.Color := rbBlack;
            if (w^.Right <> nil)  then begin
              w^.Right^.Color := rbBlack;
            end;
            rotateLeft(x_parent);
            x := FRoot; { break; }
         end
      end else begin   
        { same as above, with Right <^. Left. }
        w := x_parent^.Left;
        if (w^.Color = rbRed)  then begin
          w^.Color := rbBlack;
          x_parent^.Color := rbRed;
          rotateRight(x_parent);
          w := x_parent^.Left;
        end;
        if (((w^.Right = nil) or 
             (w^.Right^.Color = rbBlack)) and
            ((w^.Left = nil) or 
             (w^.Left^.Color = rbBlack)))  then begin
          w^.Color := rbRed;
          x := x_parent;
          x_parent := x_parent^.Parent;
        end else begin
          if ((w^.Left = nil) or (w^.Left^.Color = rbBlack)) then begin
            w^.Right^.Color := rbBlack;
            w^.Color := rbRed;
            rotateLeft(w);
            w := x_parent^.Left;
          end;
          w^.Color := x_parent^.Color;
          x_parent^.Color := rbBlack;
          if (w^.Left <> nil) then begin
            w^.Left^.Color := rbBlack;
          end;
          rotateRight(x_parent);
          x := FRoot; { break; }
        end;
      end;
    end;
    if (x <> nil) then begin
      x^.Color := rbBlack;
    end;
  end;
  dispose(y);
  Dec(FCount);
end;

{ Pre: x <> last }
procedure RBInc(var x: PRBNode);
var
  y: PRBNode;
begin
  if (x^.Right <> nil) then begin
    x := x^.Right;
    while (x^.Left <> nil) do begin
      x := x^.Left;
    end;
  end else begin
    y := x^.Parent;
    while (x = y^.Right) do begin
      x := y;
      y := y^.Parent;
    end;
    if (x^.Right <> y) then
      x := y;
  end
end;

{ Pre: x <> first }
procedure RBDec(var x: PRBNode);
var
  y: PRBNode;
begin
  if (x^.Left <> nil)  then begin
    y := x^.Left;
    while (y^.Right <> nil) do begin
      y := y^.Right;
    end;
    x := y;
  end else begin
    y := x^.Parent;
    while (x = y^.Left) do begin
      x := y;
      y := y^.Parent;
    end;
    x := y;
  end
end;

function TRBTree.FindKey(const Key: string): Pointer;
var
  Node: PRBNode;
begin
  Node := Find(Key);
  if Node <> nil then
    Result := Node^.Data
  else
    Result := nil;
end;

procedure TRBTree.SetDataKey(const Key: string; Data: Pointer);
var
  Node: PRBNode;
begin
  Node := Find(Key);
  if Node <> nil then
  begin
    if Key <> Node^.Key then
      Node^.Key := Key;
    Node^.Data := Data
  end
  else
    Add(Key, Data);
end;

procedure TRBTree.Delete(const Key: string);
var
  Node: PRBNode;
begin
  Node := Find(Key);
  if Node <> nil then
    Delete(Node);
end;

end.

