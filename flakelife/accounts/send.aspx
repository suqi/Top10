<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_send, App_Web_nasjltov" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>消息-<%=ConfigHelper.SiteName %></title>
<style>
div.item{margin-bottom:10px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
    var msgid=MongoDB.Bson.BsonObjectId.Create(Request.QueryString["msgid"]);
    var sender = DAL.DAL.FindOneById(BLL.CollectionInfo.AccountCollectionName, MongoDB.Bson.BsonObjectId.Create(Request.QueryString["id"]));
    if (sender == null)
        Response.End();
    BsonDocument olgMsg = null;
    if (string.IsNullOrWhiteSpace(Request["msgid"]) == false)
        olgMsg = DAL.DAL.FindOneById(BLL.CollectionInfo.MsgCollectionName, msgid);
    //设置为已读
    if (olgMsg != null && olgMsg["to"].AsBsonArray[0] == CurrentUser["_id"])
    {
        DAL.DAL.UpdateById(BLL.CollectionInfo.MsgCollectionName, msgid, new UpdateDocument("$set", new BsonDocument("status", BsonInt32.Create(1))));
    }

     %>
<div class="q-head">
    <div id="switcher"></div>
    <div id="tabs">
        <a href="inbox.aspx?from=2">收件箱</a>
        <a href="inbox.aspx?from=0">系统消息</a>
        <a href="inbox.aspx?from=1"<%=string.IsNullOrEmpty(Request["d"])?" class='current'":"" %>>用户留言</a>
    	<a href="outbox.aspx"<%=!string.IsNullOrEmpty(Request["d"])?" class='current'":"" %> >发件箱</a>
    </div>
</div>
<div style="clear:both;"></div>
<div class="article">
    <form method="post" action="send.aspx?action=send&id=<%=Request.QueryString["id"] %><%= string.IsNullOrWhiteSpace(Request["msgid"])?"":"&msgid="+Request["msgid"]%>" id="form1">
    <%if(olgMsg!=null){ %>
        <%if(string.IsNullOrWhiteSpace(Request["d"])){ %>
        <div class="item">
            <b><%=sender["realname"].AsString %></b><span class="ignore" style="margin:0 20px"><%=olgMsg["sendon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></span>对我说：
            <div style="padding-left:30px;" class="ignore"><%=olgMsg["content"].AsString %></div>
        </div>
        <%}else{ %>
            <div class="item">
            我<span class="ignore" style="margin:0 20px"><%=olgMsg["sendon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></span>对<b style="margin:0 20px;"><%=sender["realname"].AsString %></b>说：
                <div style="padding-left:30px;" class="ignore"><%=olgMsg["content"].AsString %></div>
        </div>
        <%} %>
        <input type="hidden" value="<%=olgMsg["content"].AsString%>"  name="old" />
    <%}else{ %>
        <div class="item"><label>收件人</label><div><b style="margin-left:20px;"><%=sender["realname"].AsString %></b></div></div>
    <%} %>
     <%if(string.IsNullOrWhiteSpace(Request["d"])){ %>
    <div class="item"><label>内容</label><div><textarea name="new" style="width:100%;height:120px;padding:2px;overflow:hidden;"></textarea></div></div>
    <div class="item"><input type="submit" value="立刻发送" class="btn-submit" id="btn_send" /></div>
    <%} %>
    </form>
</div>
<div class="aside"></div>
<script>
    $(function () {
        $('#btn_send').click(function () {
            $(this).val('正在发送...').attr('disabled', true);
        });
        $("#form1").ajaxStart(function () {
            $('#btn_send').val('正在发送...');
            $('#btn_send').attr('disabled', true);
        });
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                window.location.href = 'outbox.aspx';
            }
            else if (r && r.status != 200) {
                $('#btn_send').val('立刻发送').removeAttr('disabled');
                alert(r.detail);
            }
        });
    });
</script>
</asp:Content>

