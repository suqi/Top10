<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_inbox, App_Web_nasjltov" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>收件箱-<%=ConfigHelper.SiteName %></title>
<style>
#switcher b{margin:0 10px;font-size:13px;}
#list th{text-align:center}
#list tbody td{text-align:left;border-bottom: 1px dashed #DDD;padding: 3px 3px 3px 0;}
.a{width:90px;}
.b{width:300px;}
.c{width:120px;}
.d{width:50px;}
#list button{padding:2px 8px;margin-right:10px;cursor:pointer;}
.unread .anchor{font-weight:bold;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
	int pageNo = 1;
	int.TryParse(Request.QueryString["p"], out pageNo);
	pageNo = pageNo > 0 ? pageNo : 1;
	MongoCursor<BsonDocument> msgs = null;
	var q=new QueryDocument("to", CurrentUser["_id"].AsObjectId);
	q.Add("to_del", BsonInt32.Create(0));
	bool isAll = string.IsNullOrWhiteSpace(Request.QueryString["from"]) || Request.QueryString["from"] == "2";
	if (isAll)
	{
		msgs = DAL.DAL.Query(BLL.CollectionInfo.MsgCollectionName, q);
	}
	else if (Request.QueryString["from"] == "0")
	{
		q.Add("from", BsonString.Create("sys"));
		msgs = DAL.DAL.Query(BLL.CollectionInfo.MsgCollectionName, q);
	}
	else {
		q.Add("from", new BsonDocument("$ne",BsonString.Create("sys")));
		msgs = DAL.DAL.Query(BLL.CollectionInfo.MsgCollectionName, q);
	}
	var result=msgs.SetSortOrder(MongoDB.Driver.Builders.SortBy.Descending("sendon"));
	 %>
<div class="q-head">
	<div id="switcher">未读<b id="unread">0</b>条，共<b id="total">0</b>条</div>
	<div id="tabs">
		<a href="inbox.aspx?from=2&p=<%=pageNo %>" <%=isAll?" class='current'":"''" %>>收件箱</a>
		<a href="inbox.aspx?from=0&p=<%=pageNo %>" <%=Request.QueryString["from"] == "0"?" class='current'":"''" %>">系统消息</a>
		<a href="inbox.aspx?from=1&p=<%=pageNo %>" <%=Request.QueryString["from"] == "1"?" class='current'":"''" %>">用户留言</a>
		<a href="outbox.aspx">发件箱</a>
	</div>
</div>
<div style="clear:both;"></div>
<div class="article">
<%if (result.Count() > 0){ %>
	<form method="post" action="inbox.aspx" id="form1">
	<table id="list">
		<thead>
			<tr><th class="a">来自</th><th class="b">话题</th><th class="c">时间</th><th class="d">选择</th></tr>
		</thead>
	<tbody>
	<%foreach(var msg in result ){ %>
	<%
		var from = msg["from"].AsString;
		var fromUser=Cache[from] as BsonDocument;
		var to = msg["to"].AsBsonArray[0].AsObjectId.ToString();
		var content = Util.HtmlUtil.StripHtmlTags( msg["content"].AsString);
		bool isSys=from=="sys";
		bool isRead = msg["status"].AsInt32 == 1;
			%>
		<tr<%=isRead?" class='read'":" class='unread'" %>>
			<td class="ignore"><%=isSys?"系统消息":string.Format("<a href='../fellow/profile.aspx?id={0}'>{1}</a>",from,fromUser["realname"].AsString) %></td>
			<td>
			   <%if(isSys){%>
			   <a class="anchor" href="sysmsg.aspx?msgid=<%=msg["_id"].AsObjectId.ToString() %>"><%=content.Length>20?content.Substring(0,20)+"...":content %></a>
			   <%}else{%>
			   <a class="anchor" href="send.aspx?id=<%=from %>&msgid=<%=msg["_id"].AsObjectId.ToString() %>"><%=content.Length>20?content.Substring(0,20)+"...":content %></a>
			   <%}%></td>
			<td class="ignore"><%=msg["sendon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></td>
			<td><input type="checkbox" name="msg" value="<%=msg["_id"].AsObjectId.ToString() %>" /></td>
		</tr>
	<%} %>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4"><button id="sall" type="button">全选</button><button id="call" type="button">全清</button><button id="del" type="submit">删除选中留言</button></td>
		</tr>
	</tfoot></table>
	</form>
<%}else{ %>
	<p class="ignore">消息为空</p>
<%} %>
</div>
<div class="aside"></div>
<script>
	$(function () {
		$('#unread').html($('tr.unread').length);
		$('#total').html($('#list>tbody').children().length);
		$('#sall').click(function () {
			$('#list input').attr('checked', true);
		});
		$('#call').click(function () {
			$('#list input').attr('checked', false);
		});
		$('#del').click(function () {
			if ($('#list input:checked').length < 1) {
				return false;
			}
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

