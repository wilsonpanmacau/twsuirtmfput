Option Strict On
Option Explicit On 

Imports Unionsoft.Platform


Namespace Unionsoft.Cms.Web


Partial Class DepartmentMove
    Inherits CmsPage

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
    End Sub

    Protected Overrides Sub CmsPageSaveParametersToViewState()
        MyBase.CmsPageSaveParametersToViewState()
    End Sub

    Protected Overrides Sub CmsPageInitialize()
    End Sub

    Protected Overrides Sub CmsPageDealFirstRequest()
    End Sub

    Protected Overrides Sub CmsPageDealPostBack()
    End Sub

    Private Sub btnConfirm_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
        Try
            Dim lngMovingDepID As Long = RLng("tmpdepid")
            Dim lngSelDepID As Long = RLng("depid")
            If lngMovingDepID = lngSelDepID Then
                PromptMsg("不能移动部门至本身之下！")
                Return
            End If

            Dim strDepChildren As String = OrgFactory.DepDriver().GetDepChildren(CmsPass, lngMovingDepID)
            If strDepChildren.IndexOf("," & lngSelDepID & ",") >= 0 Then
                PromptMsg("不能移动部门至自己的子部门之下！")
                Return
            End If

            If OrgFactory.DepDriver.IsVirtualDep(CmsPass, lngSelDepID) = True Then
                PromptMsg("不能移动部门至虚拟部门下！")
                Return
            End If

            OrgFactory.DepDriver().MoveDep(CmsPass, lngMovingDepID, lngSelDepID)
            Response.Redirect(VStr("PAGE_BACKPAGE"), False)
        Catch ex As Exception
            PromptMsg("", ex, True)
        End Try
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Response.Redirect(VStr("PAGE_BACKPAGE"), False)
    End Sub
End Class

End Namespace
