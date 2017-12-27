
Imports NetReusables
Imports Unionsoft.Workflow.Engine


Namespace Unionsoft.Workflow.Web


Partial Class processes
    Inherits UserPageBase

#Region " Web ������������ɵĴ��� "

    '�õ����� Web ���������������ġ�
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'ע��: ����ռλ�������� Web ���������������ġ�
    '��Ҫɾ�����ƶ�����

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: �˷��������� Web ����������������
        '��Ҫʹ�ô���༭���޸�����
        InitializeComponent()
    End Sub

#End Region

    Private dtWorkflowCategories As DataTable = WorkflowManager.GetWorkflowCategories()

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
    End Sub

    Protected Sub GenerateWorkflowCategories(ByVal CategoryId As Long)
        Dim rows() As DataRow = dtWorkflowCategories.Select("PId=" & CategoryId)
        For i As Integer = 0 To rows.Length - 1
            CategoryId = CLng(rows(i)("Id"))
            Dim dtWorkflowItems As DataTable = PermissionUtility.GetPermissionWorkflowItems(Me.CurrentUser.Code, CategoryId)
            If dtWorkflowItems.Rows.Count > 0 Then
                Response.Write("<tr height='20' colspan='3'><td class='biaoti1'>" & CStr(rows(i)("Descr")) & "</td></tr>" & vbCrLf)
                GenerateWorkflowItems(dtWorkflowItems, CategoryId)
            End If
            GenerateWorkflowCategories(CategoryId)
        Next
    End Sub

    Private Sub GenerateWorkflowItems(ByVal dtWorkflowItems As DataTable, ByVal CategoryId As Long)
        For i As Integer = 0 To dtWorkflowItems.Rows.Count - 1
            'Response.Write("<tr height='20'>" & vbCrLf)
            'If i < dtWorkflowItems.Rows.Count Then
            '    Response.Write("<td class='text1' width='33%'> &nbsp;&nbsp;&nbsp;<img src='images/org_arrow.gif' align='absmiddle'>&nbsp;&nbsp;<a href='../process/director.aspx?action=create&WorkflowId=" & CStr(dtWorkflowItems.Rows(i)("Id")) & "&url=2009/message.aspx'>" & CStr(dtWorkflowItems.Rows(i)("Name")) & "</a></td>" & vbCrLf)
            '    Response.Write("<td class='text1'>" & DbField.GetStr(dtWorkflowItems.Rows(i), "DESCR") & "</td>" & vbCrLf)
            'End If
            'Response.Write("</tr>" & vbCrLf)
            Response.Write("<tr  height='20'>" & vbCrLf)
            For j As Integer = 1 To 3
                If i < dtWorkflowItems.Rows.Count Then
                    Response.Write("<td class='text1'> &nbsp;&nbsp;&nbsp;<img src='images/org_arrow.gif' align='absmiddle'>&nbsp;&nbsp;<a href='../process/director.aspx?action=create&WorkflowId=" & CStr(dtWorkflowItems.Rows(i)("Id")) & "&url=2009/message.aspx'>" & CStr(dtWorkflowItems.Rows(i)("Name")) & "</td>" & vbCrLf)
                    If j < 3 Then i += 1
                Else
                    Response.Write("<td class='text1'>&nbsp;</td>" & vbCrLf)
                End If
            Next
            Response.Write("</tr>" & vbCrLf)
        Next
    End Sub

End Class

End Namespace