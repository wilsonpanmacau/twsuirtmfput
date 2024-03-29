<%@ Page Language="vb" AutoEventWireup="false" Inherits="Unionsoft.Workflow.Web.RedirectEmployeeSelect" CodeFile="副本 RedirectEmployeeSelect.aspx.vb" CodeFileBaseClass="Unionsoft.Workflow.Web.UserPageBase" %>
<%@ Register TagPrefix="iewc" Namespace="Microsoft.Web.UI.WebControls" Assembly="Microsoft.Web.UI.WebControls, Version=1.0.2.116, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>RedirectEmployeeSelect</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="../css/flowstyle.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" align="left" style="BORDER-RIGHT:1px solid; BORDER-LEFT:1px solid">
				<tr>
					<td>
						<iewc:TreeView id="tvwEmployees" runat="server" Expanded="true" SystemImagesPath="../webctrl_client/1_0/treeimages/"></iewc:TreeView>
					</td>
				</tr>
				<tr>
					<td align="center" class="ToolBar">
						<asp:Button id="btnOK" runat="server" Text="确定"></asp:Button>
						<asp:Button id="btnCancel" runat="server" Text="取消"></asp:Button>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
