<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_questions, App_Web_wdpwwatm" %>
<%@ Register Src="~/ascxs/questions.ascx" TagName="question" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/mytags.ascx" TagName="tags" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/poptags.ascx" TagName="pop" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/popquestions.ascx" TagName="popq" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title><%=ConfigHelper.SiteName %>-大学生的问答社区-falelife.com <%=Request.QueryString["tag"] %></title>
<style>
#switcher h1 a{text-decoration:none;}
#questions{float: left;margin-bottom: 25px;}
.el{clear:both;display:block;}
.el .left{float:left;width:58px;text-align:center;background-color:#e4e4e4;padding:10px;margin-top:2px;}
.el .right{float:left;margin-left:10px;width:642px;}
.reply,.int{padding-top:5px;}
.reply b{font-size:240%;color:#AE0000;}
.reply .ignore,.int .ignore{_margin-top:6px;}
.int{margin-top:5px;}
.int b{font-size:240%;color:#F90;}
#questions .title a{font: 14px Arial,Helvetica,sans-serif;line-height: 150%;font-weight:bold;color:#1259C7;}
.content{margin-bottom:2px;margin-top:2px;padding-left:20px;}
.tags{line-height: 18px;width:72%;vertical-align:top;}
.info{color: #999;width:28%;}
.user-info{text-align:right;}
.user-info a{margin-right:6px;font-weight:bold;padding:2px 4px;text-decoration:none;}
.avatar{text-align:right;}
.avatar img{width:32px;height:32px;}
.summarycount {text-align: left;color: #808185;font-size: 240%;font-weight: bold;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
        int pageNo = 1;
        int.TryParse(Request.QueryString["p"], out pageNo);
        pageNo = pageNo > 0 ? pageNo : 1;
        int pagecount=1;
        int totalCount=0;
        string qtag = string.IsNullOrEmpty(Request.QueryString["tag"]) ? "" : ("&tag=" + Request.QueryString["tag"]);
        var questions = BLL.Question.GetQuestions(Request.QueryString["sort"],Server.UrlDecode(Request.QueryString["tag"]),pageNo, 15, out pagecount,out totalCount);
        QList.Questions = questions;
        MyTags.UserItem = CurrentUser;    
    %>
<div class="mleft"><%var baseUrl = ResolveUrl("~"); %>
    <a href="<%=baseUrl %>qa/questions.aspx" id="nav-questions" class="youarehere" title="查看所有提问">问题</a>
    <a href="<%=baseUrl %>qa/tags.aspx" id="nav-tags">标签</a>
    <a href="<%=baseUrl %>qa/unsolved.aspx">未解决</a>
    <a href="<%=baseUrl %>qa/solved.aspx">已解决</a>
    <a href="<%=baseUrl %>qa/ask.aspx"  id="nav-askquestion">提问</a>
</div>
<div class="mright" title="按标签在所有问题中搜索">
    <form action="questions.aspx" method="get" name="ssform">
        <input type="text" maxlength="30" name="tag" class="s-text" value="<%=Request.QueryString["tag"] %>" placeholder="按标签在所有问题中搜索" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索问题</a>
    </form>
</div>
<div style="clear:both;height:5px;"></div>
<div class="q-head">
    <div id="switcher"><h1><%=string.IsNullOrEmpty(Request.QueryString["tag"])?"全部问题":("标签：<a class='anchor' title='查看此标签的简介以及用户排行' target='_blank' href='tag.aspx?key="+Server.UrlEncode(Request.QueryString["tag"])+"'>"+Request.QueryString["tag"]+"</a>") %></h1></div>
    <div id="tabs">
        <a href="<%=baseUrl %>qa/questions.aspx?sort=newest&p=<%=pageNo %><%=qtag %>" <%=(string.IsNullOrEmpty(Request.QueryString["sort"])||string.Compare(Request.QueryString["sort"],"newest",true)==0)?"class='current'":"" %> title="按提问时间先后排序">最新提问</a>
        <a href="<%=baseUrl %>qa/questions.aspx?sort=latestreply&p=<%=pageNo %><%=qtag %>" <%=string.Compare(Request.QueryString["sort"],"latestreply",true)==0?"class='current'":"" %> title="按最后回答时间排序">最新回答</a>
    	<a href="<%=baseUrl %>qa/questions.aspx?sort=votes&p=<%=pageNo %><%=qtag %>" <%=string.Compare(Request.QueryString["sort"],"votes",true)==0?"class='current'":"" %> title="看那些投票最多的问题">最多投票</a>
    	<a href="<%=baseUrl %>qa/questions.aspx?sort=stars&p=<%=pageNo %><%=qtag %>" <%=string.Compare(Request.QueryString["sort"],"stars",true)==0?"class='current'":"" %> title="看看大家都关注什么问题">最多收藏</a>
        <a href="<%=baseUrl %>qa/questions.aspx?sort=unanswered&p=<%=pageNo %><%=qtag %>" <%=string.Compare(Request.QueryString["sort"],"unanswered",true)==0?"class='current'":"" %> title="救救那些迷茫中的孩子吧！" >零回复</a>
    </div>
</div>
<div style="clear:both;"></div>
<uc:question ID="QList" runat="server" />
<div class="sidebar">
    <h2>问题总数</h2>
    <h2 class="summarycount"><%=totalCount %></h2>
    <uc:pop ID="PopTags" runat="server" />
    <uc:tags ID="MyTags" runat="server" />
    <uc:popq ID="PopQ" runat="server" />
</div>
<a id="top-link" href="#top" style="display: none;"></a>
<script>
    var index=<%=pageNo %>;
    $(function () {
        $('#q-more').click(function () {
            var more=this;
            $('#q-loading').show();
            $.get('load.aspx?sort=<%=Request.QueryString["sort"] %><%=qtag %>&p='+(index+1),function(r){
                if(r=='nodata'||r.length<18){
                    $(more).hide();
                    $('#q-none').show();
                    $('#q-loading').hide();
                    return;
                }
                else if(r&&r.length>10){
                    index++;
                    $('#el-list').append(r);
                    $('#q-loading').hide();
                }
            });
        });
    });  
</script>
</asp:Content>

