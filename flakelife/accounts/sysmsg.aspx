<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_sysmsg, App_Web_nasjltov" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>系统留言-<%=ConfigHelper.SiteName %></title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
    var msgid=MongoDB.Bson.BsonObjectId.Create(Request.QueryString["msgid"]);
    var olgMsg = DAL.DAL.FindOneById(BLL.CollectionInfo.MsgCollectionName, msgid);
    DAL.DAL.UpdateById(BLL.CollectionInfo.MsgCollectionName, msgid,
        new UpdateDocument("$set", new BsonDocument("status", BsonInt32.Create(1))));
    %>
    <div class="q-head">
    <div id="switcher"><h1>查看留言</h1></div>
    <div id="tabs">
        <a href="inbox.aspx?from=2">全部留言</a>
        <a href="inbox.aspx?from=0" class="current">系统留言</a>
        <a href="inbox.aspx?from=1">用户留言</a>
    	<a href="outbox.aspx">已发送</a>
    </div>
</div>
<div style="clear:both;"></div>
<div class="article">
    <form method="post" action="send.aspx?action=send&id=<%=Request.QueryString["id"] %><%= string.IsNullOrWhiteSpace(Request["msgid"])?"":"&msgid="+Request["msgid"]%>" id="form1">
        <div class="item">
            <b>系统</b><span class="ignore" style="margin:0 20px"><%=olgMsg["sendon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></span>对我说：
            <div style="padding-left:30px;" class="ignore"><%=olgMsg["content"].AsString %></div>
        </div>
    </form>
</div>
<div class="aside"></div>
</asp:Content>

