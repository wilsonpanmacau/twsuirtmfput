Imports Unionsoft.Workflow.Engine
Imports Unionsoft.Workflow.Platform


Namespace Unionsoft.Workflow.Web


Partial Class proxymain
    Inherits UserPageBase

#Region " Web 窗体设计器生成的代码 "

    '该调用是 Web 窗体设计器所必需的。
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    '注意: 以下占位符声明是 Web 窗体设计器所必需的。
    '不要删除或移动它。

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: 此方法调用是 Web 窗体设计器所必需的
        '不要使用代码编辑器修改它。
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Me.IsPostBack Then Return

        BindData()

    End Sub

    Protected Sub btnClearSettings_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        ProxyManager.DeleteEmployee(CurrentUser.Code)
        BindData()
    End Sub


    Private Sub BindData()
        Repeater1.DataSource = ProxyManager.GetProxyEmployees(CurrentUser.Code)
        Repeater1.DataBind()
    End Sub

    Private Sub Repeater1_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles Repeater1.ItemCommand
        If e.CommandName = "delete" Then
            ProxyManager.DeleteEmployee(CurrentUser.Code, CStr(e.CommandArgument))
        End If
        BindData()
    End Sub
End Class

End Namespace
