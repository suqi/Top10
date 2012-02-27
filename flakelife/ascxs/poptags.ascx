<%@ control language="C#" autoeventwireup="true" inherits="ascxs_poptags, App_Web_2hyfrruf" %>
<%
    var tags = DAL.DAL.Query(BLL.CollectionInfo.TagCollectionName, new MongoDB.Driver.QueryDocument())
        .SetSortOrder(MongoDB.Driver.Builders.SortBy.Descending("no","laston")).SetSkip(0).SetLimit(8);
    string baseUrl = ResolveUrl("~");
     %>
<h2>热门标签</h2><div class="tags"><%foreach(var doc in tags){ %><a href="<%=baseUrl %>qa/questions.aspx?tag=<%=Server.UrlEncode(doc["tag"].AsString)%>"><%=doc["tag"].AsString %></a><br /><%} %></div>