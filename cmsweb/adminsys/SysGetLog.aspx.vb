Option Strict On
Option Explicit On 

Imports Unionsoft.Platform
Imports NetReusables


Namespace Unionsoft.Cms.Web


Partial Class SysGetLog
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

    Private Sub lbtnGetThisMonth_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbtnGetThisMonth.Click
        Try
            FileTransfer.DownloadLogFile(Response)
        Catch ex As Exception
            PromptMsg("", ex, True)
        End Try
    End Sub

End Class

End Namespace
