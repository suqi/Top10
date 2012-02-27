<%@ control language="C#" autoeventwireup="true" inherits="ascxs_popquestions, App_Web_2hyfrruf" %>
<h2>热门问题</h2>
<div class="q-list">
<%foreach(var q in BLL.Question.GetHotQuestions(Request.QueryString["tag"],null)){ %>
<div style="margin-bottom:8px;" title="<%=q["realname"].AsString %>" ><a class="anchor" href="../qa/question.aspx?id=<%=q["_id"].AsObjectId.ToString() %>"><%=q["title"].AsString %></a></div>
<%} %>
</div>