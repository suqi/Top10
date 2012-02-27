<%@ control language="C#" autoeventwireup="true" inherits="ascxs_friends, App_Web_2hyfrruf" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%if (UserItem == null) { return; } %>
<%
    var follow = UserItem["follow"].AsBsonArray;
    var fans = UserItem["fans"].AsBsonArray;
    string baseUrl = ResolveUrl("~");
    int display = 0;
     %>
<h2>关注</h2>
<div class="line"></div>
<div class="user-head">
<%foreach(var item in follow){ %>
<% 
      var userid = item.AsObjectId;
      var user = Cache[userid.ToString()] as BsonDocument;
      display++;
      if (display > 10)
          break;
       %>
      <%if(user!=null){ %>
        <a href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid.ToString() %>" title="<%=user["university"].AsString %>" ">
            <img src="<%=baseUrl %>avatar/<%=user["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:userid.ToString()+user["avatar"].AsString %>" alt="头像" />
            <div class="<%=user["gender"].AsString=="男"?"boy":"girl" %>"><%=user["realname"].AsString%></div>
        </a>
      <%} %>
<%} %>
<%if(display==0){ %>
<div class="ignore">还有关注任何人</div>
<% }%>
</div>
<h2>粉丝</h2>
<div class="line"></div>
<div class="user-head">
<%display = 0; %>
<%foreach(var item in fans){ %>
<% 
      var userid = item.AsObjectId;
      var user = Cache[userid.ToString()] as BsonDocument;
      display++;
      if (display > 10)
          break;
       %>
      <%if(user!=null){ %>
        <a href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid.ToString() %>" title="<%=user["university"].AsString %>" ">
            <img src="<%=baseUrl %>avatar/<%=user["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:userid.ToString()+user["avatar"].AsString %>" alt="头像" />
            <div class="<%=user["gender"].AsString=="男"?"boy":"girl" %>"><%=user["realname"].AsString%></div>
        </a>
      <%} %>
<%} %>
<%if(display==0){ %>
<div class="ignore">还没有粉丝</div>
<% }%>
</div>
