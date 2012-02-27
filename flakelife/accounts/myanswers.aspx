<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_myanswers, App_Web_nasjltov" %>
<%@ Register Src="~/ascxs/mytags.ascx" TagName="tags" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/poptags.ascx" TagName="pop" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>我的回答-<%=ConfigHelper.SiteName %></title>
<style>
#qleft{float:left;width:660px;}
#q-list td{vertical-align:top;}
.title { padding-left: 10px;}
.anchor{font-size: 14px;font-weight: bold;}
#qleft .count {font-size: 190%;font-weight: bold;height: 25px;}
.star {background-color: #B4CC66; color: #DE564B;}
.block { height: 38px;margin: 0 6px 0 0;padding: 5px;text-align: center;width: 58px;}
.answer {border: 0 none;color: #566917;}
.not-best{color:#FC0;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%--<div class="mleft">
    <a href="questions.aspx" id="nav-questions" title="查看所有提问">问题</a>
    <a href="tags.aspx" id="nav-tags">标签</a>
    <a href="unsolved.aspx">未解决</a>
    <a href="solved.aspx">已解决</a>
    <a href="ask.aspx"  id="nav-askquestion">提问</a>
</div>
<div style="clear:both;height:5px;"></div>--%>
<%
    int pageNo = 1;
    int.TryParse(Request.QueryString["p"], out pageNo);
    pageNo = pageNo > 0 ? pageNo : 1;
    int pagecount=1;
    int totalCount=0;
    MyTags.UserItem = CurrentUser;   
    var answers = BLL.Question.GetMyAnswers(CurrentUser["_id"].AsObjectId, pageNo, 15, out pagecount, out totalCount);
     %>
<div class="q-head">
    <div id="switcher"><h1>我的帐号</h1></div>
    <div id="tabs">
        <a href="profile.aspx">个人资料</a>
        <a href="my.aspx?p=<%=pageNo %>">我的提问</a>
        <a href="myanswers.aspx?p=<%=pageNo %>"  class="current">我的回答</a>
    	<a href="mystars.aspx?p=<%=pageNo %>">我的收藏</a>
    </div>
</div>
<div style="clear:both;"></div>
<div id="qleft">
    <table id="q-list"><tbody>
    <%foreach (var answer in answers){%>
    <% string content=Util.HtmlUtil.StripHtmlTags(answer["content"].AsString); %>
    <tr>
        <td class="block star"><div class="count"><%=answer["voteup"].AsBsonArray.Count%></div><div class="ignore">亮了</div></td>
        <td class="block answer"><div class="count"><%=answer["best"].AsInt32 == 1 ? "<div title='提问者采纳了你的回答'>&#10003;</div>" : "<div class='not-best' title='提问者没有采纳你的回答'>&#10007;</div>"%></div><div class="ignore">最佳</div></td>
        <td class="title">
            <a class="anchor" style="color:#1259C7"  href="../qa/question.aspx?id=<%=answer["qid"].AsObjectId.ToString() %>"><%=content.Length>30?content.Substring(0,30)+"...":content %></a>
            <div class="ignore"><%=answer["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></div>
        </td>
    </tr>
    <%} %>
    </tbody></table>
    <div style="clear:both;"></div>
    <div class="fix-ie6">
    <div id="q-more">加载更多问题</div><div id="q-loading"></div><div id="q-none" style="cursor:text;">没有更多的问题了</div>
    </div>
</div>
<div class="sidebar">
    <h2>回答总数</h2>
    <h2 class="summarycount"><%=totalCount %></h2>
    <uc:pop ID="PopTags" runat="server" />
    <uc:tags ID="MyTags" runat="server" />
</div>
<script>
    var index=<%=pageNo %>;
    $(function () {
        $('#q-more').click(function () {
            var more=this;
            $('#q-loading').show();
            $.post('loadmyanswers.aspx?p='+(index+1)+'',function(r){
                if(r=='nodata'||r.length<18){
                    $(more).hide();
                    $('#q-none').show();
                    $('#q-loading').hide();
                    return;
                }
                else if(r&&r.length>10){
                    index++;
                    $('#q-list>tbody').append(r);
                    $('#q-loading').hide();
                }
            });
        });
    });  
</script>
</asp:Content>
