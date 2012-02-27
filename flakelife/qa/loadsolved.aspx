<%@ page language="C#" autoeventwireup="true" inherits="qa_loadsolved, App_Web_wdpwwatm" %><!DOCTYPE html>
<%
    //AJAX加载更多问题
    int pageNo = 1;
    int.TryParse(Request.QueryString["p"], out pageNo);
    pageNo = pageNo > 0 ? pageNo : 1;
    int pagecount=1;
    int totalCount = 0;
    int retCount = 0;
    //string qtag = string.IsNullOrEmpty(Request.QueryString["tag"]) ? "" : ("&tag=" + Request.QueryString["tag"]);
    var questions = BLL.Question.GetSolvedQuestions(Request.QueryString["sort"],Server.UrlDecode(Request.QueryString["tag"]),pageNo, 15, out pagecount,out totalCount);
         %>
    <%foreach(var doc in questions){ %>
    <%
        retCount++;
        var interestDoc = doc["interest"].AsBsonArray;
        var tags = doc["tags"].AsBsonArray;
        var createBy = doc["userid"].AsString;
        MongoDB.Bson.BsonValue avatar = null;
        doc.TryGetValue("avatar", out avatar);
        string id = doc["_id"].AsObjectId.ToString();
        string content=Util.HtmlUtil.StripHtmlTags(doc["content"].AsString);
        content=content.Length>100?content.Substring(0,100)+"...":content;
           %><div class="el" id="<%= id%>">
        <div class="left">
            <div class="answer"><b><%=doc["replyno"].AsInt32 %></b><div class="ignore">回答</div></div>
            <div class="int"><b><%=interestDoc.Count %></b><div class="ignore">关注</div></div>
        </div>
        <div class="right">
            <div class="title"><a href="question.aspx?id=<%=id %>" class="anchor"><%=doc["title"].AsString %></a></div>
            <div class="ignore content"><%= content%></div>
            <table style="width:100%;">
                <tr>
                    <td class="tags"><%foreach(var tag in tags) {%><a href="questions.aspx?tag=<%=tag.AsString %>"><%=tag.AsString %></a><%} %></td>
                    <td class="info">
                        <div class="user-info">
                            <a href="../fellow/profile.aspx?id=<%=createBy%>" target="_blank" <%= (doc["gender"].AsString=="男")?"class='boy'":"class='girl'" %>>
                                <%=doc["realname"].AsString %>
                            </a>发表于<%=doc["createon"].AsDateTime.ToShortDateString() %>
                        </div>
                        <div class="avatar"><a title="<%=doc["realname"].AsString %>" href="../fellow/profile.aspx?id=<%=createBy %>" target="_blank"><img alt="头像" src="../avatar/<%=avatar!=null?createBy+doc["avatar"].AsString:ConfigHelper.DefaultIconName %>" /></a></div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <%} if (questions == null || retCount == 0)
      {
        Response.Clear();
        Response.Write("nodata");
        Response.End();
    }%>