<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="fellow_destiny, App_Web_z1hjc4it" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>推荐-猜你喜欢这些人-<%=ConfigHelper.SiteName %></title>
<style>
#user-list td{vertical-align:top;}
td.avatar{width:120px;text-align:center;}
.avatar img{width:100px;height:100px;}
.school a{margin-right:10px;}
.info{width:570px;white-space: nowrap;padding-left:10px;border:2px solid #FFF;}
.info div{margin-bottom:3px;}
.ops a{margin-top:6px; display:block;padding:3px 8px;font-weight:bold;color:#3FA156;background-color:#e8f4e8;text-decoration:none;border-radius:4px;outline:none;}
.pink{border:2px solid #FCF;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="follow.aspx" id="nav-follow"  title="我关注的朋友">关注</a>
    <a href="fans.aspx" id="nav-fans" title="关注我的人">粉丝</a>
    <a href="destiny.aspx"  id="nav-guess" title="猜你可能喜欢这些人" class="youarehere">推荐</a>
</div>
<div style="clear:both;height:5px;"></div>
<div class="q-head">
    <div id="switcher"><h1>推荐用户</h1></div>
    <div id="tabs">
        <a href="destiny.aspx?key=tags" <%=(string.IsNullOrEmpty(Request.QueryString["key"])||string.Compare(Request.QueryString["key"],"tags",true)==0)?"class='current'":"" %> title="和我拥有相同标签的朋友">按标签</a>
        <a href="destiny.aspx?key=university" <%=string.Compare(Request.QueryString["key"],"university",true)==0?"class='current'":"" %> title="和我同一学校的朋友">按学校</a>
    	<a href="destiny.aspx?key=city" <%=string.Compare(Request.QueryString["key"],"city",true)==0?"class='current'":"" %> title="我的老乡" >按家乡</a>
        <a href="destiny.aspx?key=realname" <%=string.Compare(Request.QueryString["key"],"realname",true)==0?"class='current'":"" %> title="和我同名的人">按名字</a>
    	<a href="destiny.aspx?key=birthday" <%=string.Compare(Request.QueryString["key"],"birthday",true)==0?"class='current'":"" %> title="和我同年同月同日生的人">按生日</a>
    </div>
</div>
<div style="clear:both;"></div>
<%
    var hash = new HashSet<string>(new string[] { "tags", "university", "city", "realname", "birthday" });
    string key = hash.Contains(Request.QueryString["key"]) ? Request.QueryString["key"] : "tags";
    MongoCursor<BsonDocument> users=null;
    var q = new QueryDocument("_id",new BsonDocument("$ne",CurrentUser["_id"]));
    if (key != "tags")
    {
        q.Add(key, CurrentUser[key]);
        users = DAL.DAL.Query(BLL.CollectionInfo.AccountCollectionName, q);
    }
    else
    {
        var orQuery = new BsonArray();
        var mytags=CurrentUser["self_tags"].AsBsonArray;
        foreach (var tag in mytags)
        {
            orQuery.Add(new BsonDocument("tag", tag));
        }
        if(mytags.Count>0)
            q.Add("$or", orQuery);
        users = DAL.DAL.Query(BLL.CollectionInfo.AccountCollectionName,q);
    }
     %>
<div id="user-list">
<table>
    <tbody>
    <%if (users.Count() != 0){%>
    <%foreach (var creator in users) { %>
    <%
        string cid = creator["_id"].AsObjectId.ToString();
            %>
    <tr>
        <td class="avatar"><a title="查看他（她）的公开资料" class="anchor" href="profile.aspx?id=<%=cid%>" id="view"><img src="../avatar/<%=creator["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:cid+creator["avatar"].AsString %>" alt="头像" /></a></td>
        <td class="info<%=creator["gender"].AsString=="男"?" boy":" girl" %>">
            <div class="ignore">姓名：<a href="profile.aspx?id=<%=cid%>" title="查看他（她）的公开资料"><%=creator["realname"].AsString%></a></div>
            <div class="ignore school">学校：
            <a title="查看与此学校相关的问题" href="../qa/questions.aspx?tag=<%=Server.UrlEncode(creator["university"].AsString) %>"><%=creator["university"].AsString%></a>
            </div>
            <div class="ignore">生日：<%=creator["birthday"].AsString %></div>
            <div class="ignore" >家乡：<%=creator["province"].AsString %>-<%=creator["city"].AsString %></div>
            <div class="tags ignore">标签：
                <%foreach(var tag in creator["self_tags"].AsBsonArray){ %>
                <a title="查看与此标签相关的问题" href="../qa/questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
                <%} %>
            </div>
        </td>
    </tr>
    <%} %>

<%}else{ %>
 <%     
    var creator = DAL.DAL.FindOne(BLL.CollectionInfo.AccountCollectionName, new QueryDocument("_id",new BsonDocument("$ne",CurrentUser["_id"])));
    if (creator == null)
        return;
    string cid = creator["_id"].AsObjectId.ToString();
            %>
    <tr>
        <th colspan="2" style="text-align:left;font-size:14px;font-weight:bold;color:#666;">木有匹配的结果。此用户由系统随机推荐（随机也是一种缘分）</th>
    </tr>
    <tr>
        <td class="avatar"><a title="查看他（她）的公开资料" class="anchor" href="profile.aspx?id=<%=cid%>"><img src="../avatar/<%=creator["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:cid+creator["avatar"].AsString %>" alt="头像" /></a></td>
        <td class="info<%=creator["gender"].AsString=="男"?" boy":" girl" %>">
            <div class="ignore">姓名：<a href="profile.aspx?id=<%=cid%>" title="查看他（她）的公开资料"><%=creator["realname"].AsString%></a></div>
            <div class="ignore school">学校：
            <a title="查看与此学校相关的问题" href="../qa/questions.aspx?tag=<%=Server.UrlEncode(creator["university"].AsString) %>"><%=creator["university"].AsString%></a>
            </div>
            <div class="ignore">生日：<%=creator["birthday"].AsString %></div>
            <div class="ignore" >家乡：<%=creator["province"].AsString %>-<%=creator["city"].AsString %></div>
            <div class="tags ignore">标签：
                <%foreach(var tag in creator["self_tags"].AsBsonArray){ %>
                <a title="查看与此标签相关的问题" href="../qa/questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
                <%} %>
            </div>
        </td>
    </tr>
<%} %>
    </tbody>
</table>
</div>
<script>
    $(function () {
        $('td.girl').mouseover(function () {
            $(this).addClass('pink').attr('title', '这是一位美女哦');
        });
    });
</script>
</asp:Content>

