<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="fellow_friends, App_Web_z1hjc4it" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<%@ Import Namespace="MongoDB.Driver.Builders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>寻找有缘人-<%=ConfigHelper.SiteName %></title>
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
<%
    var filterDict = new Dictionary<string, string>() { { "realname", "realname" }, { "gender", "gender" }, { "gz", "hs_name" }
    ,{"school","university"},{"birthday","birthday"},{"tag","self_tags"},{"province","province"},{"city","city"}};
    if (string.IsNullOrEmpty(Request.QueryString["key"])==false&&filterDict.ContainsKey(Request.QueryString["key"]) == false)
    {
        Response.Write("<div class='error'>不合法的查询条件</div>");
        Response.End();
    }
    var queryDoc = new QueryDocument();
    if (string.IsNullOrEmpty(Request.QueryString["key"]) == false)
    {
        if (string.Compare(Request.QueryString["key"], "school", true) != 0)
            queryDoc.Add(filterDict[Request.QueryString["key"]], BsonString.Create(Request.QueryString["value"]));
        else
        {
            var list=new List<BsonDocument>(4);
            list.Add(new BsonDocument("hs_name",Request.QueryString["value"]));
            list.Add(new BsonDocument("university",Request.QueryString["value"]));
            list.Add(new BsonDocument("yjs_school",Request.QueryString["value"]));
            list.Add(new BsonDocument("bs_school",Request.QueryString["value"]));
            queryDoc.Add("$or", BsonArray.Create(list));
        }
    }
    var accounts = DAL.DAL.Query(BLL.CollectionInfo.AccountCollectionName, queryDoc).SetSortOrder(SortBy.Ascending("createon"));
     %>
<h1>找到<%=accounts.Count() %>个有缘人</h1>
<div id="user-list">
<table>
    <tbody>
    <%foreach(var creator in accounts){ %>
    <%
        BsonValue gz = null, bk = null, yjs = null, bs = null;
        creator.TryGetValue("hs_name", out gz);
        creator.TryGetValue("university", out bk);
        creator.TryGetValue("yjs_school", out yjs);
        creator.TryGetValue("bs_school", out bs);
        string cid = creator["_id"].AsObjectId.ToString();
            %>
    <tr>
        <td class="avatar"><a title="查看他（她）的公开资料" class="anchor" href="profile.aspx?id=<%=cid%>" id="view"><img src="../avatar/<%=creator["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:cid+creator["avatar"].AsString %>" alt="头像" /></a></td>
        <td class="info<%=creator["gender"].AsString=="男"?" boy":" girl" %>">
            <div class="ignore">姓名：<a href="../fellow/friends.aspx?key=realname&value=<%=creator["realname"].AsString %>" title="找到同名同姓的有缘人"><%=creator["realname"].AsString%></a></div>
            <div class="ignore school">学校：
            <%if(gz!=null){ %>
            <a href="../fellow/friends.aspx?key=school&value=<%=creator["hs_name"].AsString %>"><%=creator["hs_name"].AsString%></a>
            <%} %>
            <%if(bk!=null){ %>
            <a href="../fellow/friends.aspx?key=school&value=<%=creator["university"].AsString %>"><%=creator["university"].AsString%></a>
            <%} %>
            <%if(yjs!=null){ %>
            <a href="../fellow/friends.aspx?key=school&value=<%=creator["yjs_school"].AsString %>"><%=creator["yjs_school"].AsString%></a>
            <%} %>
            <%if(bs!=null){ %>
            <a href="../fellow/friends.aspx?key=school&value=<%=creator["bs_school"].AsString %>"><%=creator["bs_school"].AsString%></a>
            <%} %>
            </div>
            <div class="ignore">生日：<a href="../fellow/friends.aspx?key=birthday&value=<%=creator["birthday"].AsString %>" title="找到同年同月同日生的有缘人"><%=creator["birthday"].AsString %></a></div>
            <div class="ignore" >家乡：<a title="找老乡" href="../fellow/friends.aspx?key=province&value=<%=creator["province"].AsString %>"><%=creator["province"].AsString %></a>-<a title="找老乡" href="../fellow/friends.aspx?key=city&value=<%=creator["city"].AsString %>"><%=creator["city"].AsString %></a></div>
            <div class="tags ignore">标签：
                <%foreach(var tag in creator["self_tags"].AsBsonArray){ %>
                <a href="friends.aspx?key=tag&value=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
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
            $(this).addClass('pink').attr('title','这是一个女生');
        });
    });
</script>
</asp:Content>
