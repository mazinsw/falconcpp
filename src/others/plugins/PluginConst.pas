unit PluginConst;

interface

const
  {* Commands *}
  Cmd_Create           = $0001;
  Cmd_Get              = $0002;
  Cmd_SetProperty      = $0003;
  Cmd_SetEvent         = $0004;
  Cmd_Call             = $0005;

  {* Properties *}
  Prop_Text            = $0001;
  Prop_Size            = $0002;

  {* Widgets *}
  Wdg_Menu             = $0001;
  Wdg_SubMenu          = $0002;
  Wdg_PageControl      = $0003;
  Wdg_Sheet            = $0004;
  Wdg_Edit             = $0005;
  Wdg_Button           = $0006;
  Wdg_CheckBox         = $0007;
  Wdg_GroupBox         = $0008;
  Wdg_RadioGroup       = $0009;
  Wdg_List             = $000A;
  Wdg_ListView         = $000B;
  Wdg_TreeView         = $000C;
  Wdg_ModerPageControl = $000D;
  Wdg_ModerSheet       = $000E;


  cannotLoadPlugin = 'Can''t load plugin %s.';
  functionNotFound = 'Function %s not found.';
  invalidPlugin = 'Invalid plugin.';
  failedToInitializePlugin = 'Failed to initialize plugin: error code %d.';
  pluginNotInitialized = 'Plugin not initialized.';

implementation

end.
