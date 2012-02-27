<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_outbox, App_Web_nasjltov" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>发件箱-<%=ConfigHelper.SiteName %></title>
<style>
#switcher b{margin:0 10px;font-size:13px;}
#list th{text-align:center}
#list tbody td{text-align:left;border-bottom: 1px dashed #DDD;padding: 3px 3px 3px 0;}
.a{width:90px;}
.b{width:300px;}
.c{width:120px;}
.d{width:50px;}
#list button{padding:2px 8px;margin-right:10px;cursor:pointer;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
    int pageNo = 1;
    int.TryParse(Request.QueryString["p"], out pageNo);
    pageNo = pageNo > 0 ? pageNo : 1;
    var q=new QueryDocument("from", CurrentUser["_id"].AsObjectId.ToString());
    q.Add("from_del", BsonInt32.Create(0));
    MongoCursor<BsonDocument>  msgs = DAL.DAL.Query(BLL.CollectionInfo.MsgCollectionName, q);
     %>
<div class="q-head">
    <div id="switcher">共<b id="total">0</b>条</div>
    <div id="tabs">
        <a href="inbox.aspx?from=2">收件箱</a>
        <a href="inbox.aspx?from=0">系统消息</a>
        <a href="inbox.aspx?from=1">用户留言</a>
    	<a href="outbox.aspx" class="current">发件箱</a>
    </div>
</div>
<div style="clear:both;"></div>
<div class="article">
<%if(msgs.Count()>0){ %>
    <form method="post" action="outbox.aspx" id="form1">
    <table id="list"><thead>
    <tr><th class="a">收件人</th><th class="b">话题</th><th class="c">时间</th><th class="d">选择</th></tr></thead>
    <tbody>
    <%foreach(var msg in msgs){ %>
    <%
        var to = msg["to"].AsBsonArray[0].AsObjectId.ToString();
        var toUser=Cache[to] as BsonDocument;
        var content = msg["content"].AsString;
            %>
        <tr>
            <td class="a ignore"><a href='../fellow/profile.aspx?id=<%=to%>'><%=toUser["realname"].AsString%></a></td>
            <td class="b"><a class="anchor" href="send.aspx?d=send&id=<%=to%>&msgid=<%=msg["_id"].AsObjectId.ToString() %>"><%=content.Length>20?content.Substring(0,20)+"...":content %></a></td>
            <td class="ignore c"><%=msg["sendon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></td>
            <td class="d"><input type="checkbox" name="msg" value="<%=msg["_id"].AsObjectId.ToString() %>" /></td>
        </tr>
    <%} %>
    </tbody><tfoot><tr><td colspan="4"><button id="sall" type="button">全选</button><button id="call" type="button">全清</button><button id="del" type="submit">删除选中留言</button></td></tr></tfoot></table>
    </form>
<%}else{ %>
    <p class="ignore">消息为空</p>
<%} %>
</div>
<div class="aside"></div>
<script>
    $(function () {
        $('#total').html($('#list>tbody').children().length);
        $('#sall').click(function () {
            $('#list input').attr('checked', true);
        });
        $('#call').click(function () {
            $('#list input').attr('checked', false);
        });
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                $('#list input:checked').each(function () {
                    $(this.parentNode.parentNode).remove();
                });
            }
        });
    });
</script>
</asp:Content>

