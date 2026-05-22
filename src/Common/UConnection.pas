unit UConnection;

interface

uses
  System.SysUtils, System.IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.IOUtils;

type
  TConnection = class
  private
    class var FConnection: TFDConnection;
    class var FDriverLink: TFDPhysFBDriverLink;
    class function CreateConnection: TFDConnection;
  public
    class function GetConnection: TFDConnection;
    class destructor Destroy;
  end;

implementation

{ TConnection }

class function TConnection.CreateConnection: TFDConnection;
var
  LIni: TIniFile;
  LPathIni: string;
begin
  LPathIni := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');
  if not FileExists(LPathIni) then
    raise Exception.Create('Arquivo config.ini não encontrado em: ' + LPathIni);

  LIni := TIniFile.Create(LPathIni);
  try
    Result             := TFDConnection.Create(nil);
    Result.DriverName  := 'FB';
    Result.LoginPrompt := False;

    Result.Params.Clear;
    Result.Params.Add('DriverID=FB');
    Result.Params.Add('Database=' + LIni.ReadString('Database', 'Database', ''));
    Result.Params.Add('User_Name=SYSDBA');
    Result.Params.Add('Password=Admin@PSBios2022');
    Result.Params.Add('Server=' + LIni.ReadString('Database', 'Server', 'localhost'));
    Result.Params.Add('Port=' + LIni.ReadString('Database', 'Port', '3050'));
    Result.Params.Add('CharacterSet=UTF8');

    // Configurar Client Library se informada
    if LIni.ReadString('Database', 'ClientLibrary', '') <> '' then
    begin
      if not Assigned(FDriverLink) then
        FDriverLink := TFDPhysFBDriverLink.Create(nil);

      FDriverLink.VendorLib := LIni.ReadString('Database', 'ClientLibrary', '');
    end;

      Result.Connected := True;
  finally
    LIni.Free;
  end;
end;

class destructor TConnection.Destroy;
begin
  if Assigned(FConnection) then
    FConnection.Free;

  if Assigned(FDriverLink) then
    FDriverLink.Free;
end;

class function TConnection.GetConnection: TFDConnection;
begin
  if not Assigned(FConnection) then
    FConnection := CreateConnection;

  Result := FConnection;
end;

end.
