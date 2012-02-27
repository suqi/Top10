<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="zxc_q, App_Web_cpi4dwra" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
thead th{text-align:center;font-weight:bold;}
thead tr,tfoot tr{border-bottom:1px solid #eee;}
tfoot th,tbody th{text-align:left;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1>管理全部帖子</h1>
<%
    int pageNo = string.IsNullOrWhiteSpace(Request["p"]) ? 1 : int.Parse(Request["p"]);
    int pagecount=0,total=0;
    var q = BLL.Question.GetQuestions("", "", pageNo, 30, out pagecount, out total);
     %>
<form action="q.aspx?action=delete" method="post" id="form1">
<table>
    <col width="50px" />
    <col width="500px" />
    <col width="180px" />
    <col width="120px" />
    <thead>
        <tr><th>选择</th><th>标题</th><th>时间</th><th>作者</th></tr>
    </thead>
    <tbody>
        <%foreach(var item in q){ %>
         <%
              var uid=item["userid"].AsObjectId;
              var user=Cache[uid.ToString()] as MongoDB.Bson.BsonDocument; 
                  %>
        <tr><th><input type="checkbox" name="del"  value="<%=item["_id"].AsObjectId.ToString() %>"/></th>
        <th><a target="_blank" href="../qa/question.aspx?id=<%=item["_id"].AsObjectId.ToString() %>"><%=item["title"].AsString %></a></th><th><%=Util.DateTimeUtil.FormatDate(item["createon"].AsDateTime) %></th>
        <th><a href="../fellow/profile.aspx?id=<%=uid.ToString() %>" target="_blank"><%=user["realname"].AsString%></a></th></tr>
        <%} %>
    </tbody>
    <tfoot>
        <tr><th colspan="4"><button type="submit">删除</button></th></tr>
    </tfoot>
</table>
</form>
<script>
    $('#form1').ajaxForm(function (r) {
        if (r && r.status == 200) {
            $('input:checked').each(function () {
                $(this).parents('tr').remove();
            });
        }
    });
</script>
</asp:Content>

