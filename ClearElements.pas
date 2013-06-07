{
Copyright (C) 2006-2013 Matteo Salvi

Website: http://www.salvadorsoftware.com/

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit ClearElements;

interface

uses
  Forms, StdCtrls, ExtCtrls, VirtualTrees, GTForm, AppConfig, Vcl.Controls, SysUtils,
  System.Classes;

type
  TfrmClearElements = class(TGTForm)
    lbClearElements: TLabel;
    cbBackup: TCheckBox;
    cbCache: TCheckBox;
    cbRecents: TCheckBox;
    btnClear: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    cbMFU: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure ClearCache(Sender: TBaseVirtualTree; Node: PVirtualNode;
                         Data: Pointer; var Abort: Boolean);
    procedure ClearMFU(Sender: TBaseVirtualTree; Node: PVirtualNode;
                       Data: Pointer; var Abort: Boolean);
    procedure ClearMRU(Sender: TBaseVirtualTree; Node: PVirtualNode;
                       Data: Pointer; var Abort: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClearElements: TfrmClearElements;

implementation   

uses
  Main, ulTreeView, ulNodeDataTypes, ulFileFolder, ulEnumerations, udImages;

{$R *.dfm}

procedure TfrmClearElements.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClearElements.btnClearClick(Sender: TObject);
begin
  //Clear MRU
  if cbRecents.Checked then
  begin
    MRUList.Clear;
    frmMain.vstList.IterateSubtree(nil, ClearMRU, nil, [], True);
  end;
  //Clear MFU
  if cbMFU.Checked then
  begin
    MFUList.Clear;
    frmMain.vstList.IterateSubtree(nil, ClearMFU, nil, [], True);
  end;
  //Clear Backup
  if cbBackup.Checked then
    DeleteFiles(SUITE_BACKUP_PATH, APP_NAME + '_*' + EXT_SQLBCK);
  //Clear Cache
  if cbCache.Checked then
  begin
    frmMain.vstList.IterateSubtree(nil, ClearCache, nil, [], True);
    ImagesDM.GetChildNodesIcons(frmMain.vstList, nil, frmMain.vstList.RootNode);
    frmMain.vstList.FullCollapse;
  end;
  RefreshList(frmMain.vstList);
  Close;
end;

procedure TfrmClearElements.ClearCache(Sender: TBaseVirtualTree; Node: PVirtualNode;
                            Data: Pointer; var Abort: Boolean);
var
  CurrentNodeData : TvCustomRealNodeData;
begin
  CurrentNodeData := TvCustomRealNodeData(PBaseData(Sender.GetNodeData(Node)).Data);
  if CurrentNodeData.DataType <> vtdtSeparator then
  begin
    CurrentNodeData.CacheID      := -1;
    CurrentNodeData.CacheLargeID := -1;
  end;
end;

procedure TfrmClearElements.ClearMRU(Sender: TBaseVirtualTree; Node: PVirtualNode;
                            Data: Pointer; var Abort: Boolean);
var
  NodeData : TvCustomRealNodeData;
begin
  NodeData := TvCustomRealNodeData(PBaseData(Sender.GetNodeData(Node)).Data);
  NodeData.MRUPosition := -1;
  NodeData.Changed := True;
end;

procedure TfrmClearElements.ClearMFU(Sender: TBaseVirtualTree; Node: PVirtualNode;
                            Data: Pointer; var Abort: Boolean);
var
  NodeData : TvCustomRealNodeData;
begin
  NodeData := TvCustomRealNodeData(PBaseData(Sender.GetNodeData(Node)).Data);
  NodeData.ClickCount := 0;
  NodeData.Changed := True;
end;

end.
