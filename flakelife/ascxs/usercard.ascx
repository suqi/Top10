<%@ control language="C#" autoeventwireup="true" inherits="ascxs_usercard, App_Web_2hyfrruf" %>
<%
    if (UserItem == null)
        return;
    string baseUrl = ResolveUrl("~");
    string userid = UserItem["_id"].AsObjectId.ToString();
    string realname=UserItem["realname"].AsString;
    string gender = UserItem["gender"].AsString;
    string avatar = UserItem["avatar"].AsString;
     %>
<div class="userinfo">
    <div class="realname"><h2><a title="提出此问题的人" href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid %>" class="<%=gender=="男"?"boy":"girl" %>"><%=realname%></a></h2></div>
    <div class="ul">
        <a href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid %>">
        <img alt="头像" title="<%=realname %>的头像" src="<%=baseUrl %>avatar/<%=avatar==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:(userid+avatar) %>" /></a>
    </div>
    <div class="ur">
        <div class="ignore">性别：<%=gender%></div>
        <div class="ignore">学校：<%=UserItem["university"].AsString %></div>
        <div class="ignore">生日：<%=UserItem["birthday"].AsString %></div>
        <div class="ignore" title="找老乡">家乡：<%=UserItem["province"].AsString %>-<%=UserItem["city"].AsString %></div>
    </div>
</div> 