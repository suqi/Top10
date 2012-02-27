<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_recommend, App_Web_nasjltov" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server"><title>欢迎加入<%=ConfigHelper.SiteName %></title>
<style>
h2 {background-color: #EEFFED;color: #666666;padding: 3px 0;}
.ignore{margin-top:10px;margin-bottom:10px;}
.user-head a{display:inline-block;margin-right:6px;text-align:center;}
.user-head a:hover{text-decoration:none;}
.user-head img{height:64px;width:64px;}
.realname{font-weight:bold;margin-right:20px;}
.anchor{font-weight:bold;font-size:14px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<h1>欢迎你，<%=CurrentUser["realname"].AsString %></h1>
<h2>推荐用户</h2><%    int display = 0; string baseUrl = ResolveUrl("~");%>
<div class="user-head">
<%foreach(var user in BLL.Account.FindRecommendUser(CurrentUser)){ %>
<% display++;
   var userid = user["_id"].AsObjectId.ToString();
      %>
<a href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid%>" title="<%=user["university"].AsString %>" ">
    <img src="<%=baseUrl %>avatar/<%=user["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:userid+user["avatar"].AsString %>" alt="头像" />
    <div class="<%=user["gender"].AsString=="男"?"boy":"girl" %>"><%=user["realname"].AsString%></div>
</a>
<%} %>
<%if(display==0){ %>
<div class="ignore">暂时没有合适的用户推荐给你</div>
<% }%>
</div>
<h2>这些问题还没有答案</h2>
<div class="q-list">
<%foreach(var q in BLL.Question.GetHotQuestions("",false)){ %>
<div><a class="anchor" href="../qa/question.aspx?id=<%=q["_id"].AsObjectId.ToString() %>"><%=q["title"].AsString %></a>
<div><a class="realname" href="../fellow/profile.aspx?id=<%=q["userid"].AsObjectId.ToString() %>"><%=q["realname"].AsString %></a><span class="ignore"><%=q["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></span></div>
</div>
<%} %>
</div>
</asp:Content>
