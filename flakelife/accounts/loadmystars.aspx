<%@ page language="C#" autoeventwireup="true" inherits="qa_loadmystars, App_Web_nasjltov" %><!DOCTYPE html>
<%
    //AJAX加载更多我的问题
    int pageNo = 1;
    int.TryParse(Request.QueryString["p"], out pageNo);
    pageNo = pageNo > 0 ? pageNo : 1;
    int pagecount=1;
    int totalCount = 0;
    int retCount = 0;
    if (Request.Cookies["sid"] == null)
    {
        Response.Clear();
        Response.Write("请重新登录");
        Response.End();
    }
    var sid=Request.Cookies["sid"].Value;
    if (string.IsNullOrEmpty(sid) || Cache[sid] == null)
    {
        Response.Clear();
        Response.Write("请重新登录");
        Response.End();
    }
    var bson = Cache[Cache[sid].ToString()] as MongoDB.Bson.BsonDocument;
    if (bson == null)
    {
        Response.Clear();
        Response.Write("请重新登录");
        Response.End();
    }
    MongoDB.Bson.ObjectId userid = bson["_id"].AsObjectId;
    var questions = BLL.Question.GetMyStarQuestions(userid, Request.QueryString["tag"], pageNo, 15, out pagecount, out totalCount);
         %>
<%foreach (var question in questions){%>
<%retCount++; %>
    <tr>
        <td class="block star"><div class="count"><%=question["interest"].AsInt32.ToString() %></div><div class="ignore">收藏</div></td>
        <td class="block answer"><div class="count"><%=question["replyno"].AsInt32.ToString() %></div><div class="ignore">回答</div></td>
        <td class="title">
            <a class="anchor" style="color:#1259C7"  href="question.aspx?id=<%=question["_id"].AsObjectId.ToString() %>"><%=question["title"].AsString %></a>
            <div class="tags">
                <%foreach(var tag in question["tags"].AsBsonArray){ %>
                    <a href="mystars.aspx?tag=<%=tag.AsString %>"><%=tag.AsString %></a>
                <%} %>
            </div>
            <div class="ignore">
            <a class="username" href="../fellow/profile.aspx?id=<%=question["userid"].AsObjectId.ToString() %>"><%=question["realname"].AsString %></a>
            <%=question["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %>
            <a href="javascript:;" class="unstar" onclick="unstar(this,'<%=question["_id"].AsObjectId.ToString() %>')">取消收藏</a>
            </div>
        </td>
    </tr>
<%} 
if (questions == null || retCount == 0)
      {
        Response.Clear();
        Response.Write("nodata");
        Response.End();
    }%>