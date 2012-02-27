<%@ control language="C#" autoeventwireup="true" inherits="ascxs_questions, App_Web_2hyfrruf" %>
<%
    var count = 0;
    string baseUrl = ResolveUrl("~");
     %>
<div id="questions">
    <div id="el-list">
        <%if(Questions!=null){ %>
        <%foreach(var doc in Questions){ %>
        <%
            count++;
            var tags = doc["tags"].AsBsonArray;
            var createBy = doc["userid"].AsObjectId.ToString();
            var user=Cache[createBy] as MongoDB.Bson.BsonDocument;
            if(user==null)
                continue;
            MongoDB.Bson.BsonValue avatar =user["avatar"];
            string id = doc["_id"].AsObjectId.ToString();
            string content=Util.HtmlUtil.StripHtmlTags(doc["content"].AsString);
            content=content.Length>100?content.Substring(0,100)+"...":content;
               %>
        <div class="el" id="<%= id%>">
            <div class="left">
                <div class="reply"><b><%=doc["replyno"].AsInt32 %></b><div class="ignore">回答</div></div>
                <%if(string.Compare(Request.QueryString["sort"],"stars",true)!=0){ %>
                <div class="int"><b><%=doc["voteno"].AsInt32 %></b><div class="ignore">投票</div></div>
                <%}else{ %>
                <div class="int"><b><%=doc["starno"].AsInt32 %></b><div class="ignore">收藏</div></div>
                <%} %>
            </div>
            <div class="right">
                <div class="title"><a href="<%=baseUrl %>qa/question.aspx?id=<%=id %>" class="anchor"><%=doc["title"].AsString %></a></div>
                <div class="ignore content"><%= content%></div>
                <table style="width:100%;">
                    <tr>
                        <td class="tags"><%foreach(var tag in tags) {%><a href="<%=baseUrl %>qa/<%=PageName %>.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a><%} %></td>
                        <td class="info">
                            <div class="user-info">
                                <a href="<%=baseUrl %>fellow/profile.aspx?id=<%=createBy%>" target="_blank">
                                    <%=doc["realname"].AsString %>
                                </a><%=Util.DateTimeUtil.FormatDate(doc["createon"].AsDateTime) %>
                            </div>
                            <div class="avatar"><a title="<%=doc["realname"].AsString %>" href="<%=baseUrl %>fellow/profile.aspx?id=<%=createBy %>" target="_blank"><img alt="头像" src="<%=baseUrl %>avatar/<%=avatar!=ConfigHelper.DefaultIconName?createBy+avatar.AsString:ConfigHelper.DefaultIconName %>" /></a></div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <%} %>
        <%} %>
    </div>
    <div style="clear:both;"></div>
    <div class="fix-ie6">
   <%if(Questions!=null&&count>0){ %>
    <div id="q-more">加载更多问题</div><div id="q-loading"></div><div id="q-none" style="cursor:text;">没有更多的问题了</div>
    <%}else{ %>
    <div class="nodata">还没有相关问题</div>
    <%} %>
    </div>
</div>