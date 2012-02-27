<%@ page language="C#" autoeventwireup="true" inherits="qa_loadmyanswers, App_Web_nasjltov" %><!DOCTYPE html>
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
    var answers = BLL.Question.GetMyAnswers(userid,pageNo, 15, out pagecount, out totalCount);
         %>
<%foreach (var answer in answers){%>
<%retCount++; %>
<% string content=Util.HtmlUtil.StripHtmlTags(answer["content"].AsString); %>
<tr>
    <td class="block star"><div class="count"><%=answer["voteup"].AsBsonArray.Count%></div><div class="ignore">亮了</div></td>
    <td class="block answer"><div class="count"><%=answer["best"].AsInt32 == 1 ? "<div title='提问者采纳了你的回答'>&#10003;</div>" : "<div class='not-best' title='提问者没有采纳你的回答'>&#10007;</div>"%></div><div class="ignore">最佳</div></td>
    <td class="title">
        <a class="anchor" style="color:#1259C7"  href="question.aspx?id=<%=answer["qid"].AsObjectId.ToString() %>"><%=content.Length>30?content.Substring(0,30)+"...":content %></a>
        <div class="ignore"><%=answer["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></div>
    </td>
</tr>
<%}
    if (answers == null || retCount == 0)
      {
        Response.Clear();
        Response.Write("nodata");
        Response.End();
    }%>