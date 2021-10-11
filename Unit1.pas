unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}




function EncodeBase64(Value: String): String;
const
 b64alphabet: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  pad: PChar = '====';

  function EncodeChunk(const Chunk: String): String;
  var
    W: LongWord;
    i, n: Byte;
  begin
    n := Length(Chunk); W := 0;
    for i := 0 to n - 1 do
      W := W + Ord(Chunk[i + 1]) shl ((2 - i) * 8);
    Result := b64alphabet[(W shr 18) and $3f] +
              b64alphabet[(W shr 12) and $3f] +
              b64alphabet[(W shr 06) and $3f] +
              b64alphabet[(W shr 00) and $3f];
    if n <> 3 then
      Result := Copy(Result, 0, n + 1) + Copy(pad, 0, 3 - n);   //add padding when out len isn't 24 bits
  end;

begin
  Result := '';
  while Length(Value) > 0 do
  begin
    Result := Result + EncodeChunk(Copy(Value, 0, 3));
    Delete(Value, 1, 3);
  end;
end;


function DecodeBase64(Value: String): String;
const b64alphabet: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  function DecodeChunk(const Chunk: String): String;
  var
    W: LongWord;
    i: Byte;
  begin
    W := 0; Result := '';
    for i := 1 to 4 do
      if Pos(Chunk[i], b64alphabet) <> 0 then
        W := W + Word((Pos(Chunk[i], b64alphabet) - 1)) shl ((4 - i) * 6);
    for i := 1 to 3 do
      Result := Result + Chr(W shr ((3 - i) * 8) and $ff);
  end;
begin
  Result := '';
  if Length(Value) mod 4 <> 0 then Exit;
  while Length(Value) > 0 do
  begin
    Result := Result + DecodeChunk(Copy(Value, 0, 4));
    Delete(Value, 1, 4);
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);

begin
memo1.Text:=EncodeBase64(memo1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
memo1.Text:=DecodeBase64(memo1.Text);
end;

end.
