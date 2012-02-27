<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_my, App_Web_nasjltov" %>
<%@ Register Src="~/ascxs/mytags.ascx" TagName="tags" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/poptags.ascx" TagName="pop" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>我的提问-<%=string.IsNullOrEmpty(Request.QueryString["tag"])?"":("关于"+Request.QueryString["tag"]+"的问题") %>-<%=ConfigHelper.SiteName %></title>
<style>
#qleft{float:left;width:660px;}
.title { padding-left: 10px;}
.anchor{font-size: 14px;font-weight: bold;}
#qleft .count {font-size: 190%;font-weight: bold;height: 25px;}
.star {background-color: #B4CC66; color: #DE564B;}
.block { height: 38px;margin: 0 6px 0 0;padding: 5px;text-align: center;width: 58px;}
.answer {border: 0 none;color: #566917;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%--<div class="mleft">
</div>
<div class="mright" title="按标签在我的所有提问中搜索">
    <form action="my.aspx" method="get" name="ssform">
        <input type="text" maxlength="30" name="tag" class="s-text" value="<%=Request.QueryString["tag"] %>" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索提问</a>
    </form>
</div>
<div style="clear:both;height:5px;"></div>--%>
<%
    int pageNo = 1;
    int.TryParse(Request.QueryString["p"], out pageNo);
    pageNo = pageNo > 0 ? pageNo : 1;
    int pagecount=1;
    int totalCount=0;
    MyTags.UserItem = CurrentUser;   
    string qtag = string.IsNullOrEmpty(Request.QueryString["tag"]) ? "" : ("&tag=" + Request.QueryString["tag"]);
    var questions = BLL.Question.GetMyQuestions(CurrentUser["_id"].AsObjectId, Request.QueryString["tag"], pageNo, 15, out pagecount, out totalCount);
     %>
<div class="q-head">
    <div id="switcher"><h1>我的帐号</h1></div>
    <div id="tabs">
        <a href="profile.aspx">个人资料</a>
        <a href="my.aspx?p=<%=pageNo %><%=qtag %>" class="current">我的提问</a>
        <a href="myanswers.aspx?p=<%=pageNo %>">我的回答</a>
    	<a href="mystars.aspx?p=<%=pageNo %><%=qtag %>">我的收藏</a>
    </div>
</div>
<div style="clear:both;"></div>
<div id="qleft">
    <table id="q-list"><tbody>
    <%foreach (var question in questions){%>
    <tr>
        <td class="block star"><div class="count"><%=question["starno"].AsInt32.ToString() %></div><div class="ignore">收藏</div></td>
        <td class="block answer"><div class="count"><%=question["replyno"].AsInt32.ToString() %></div><div class="ignore">回答</div></td>
        <td class="title">
            <a class="anchor" style="color:#1259C7"  href="../qa/question.aspx?id=<%=question["_id"].AsObjectId.ToString() %>"><%=question["title"].AsString %></a>
            <div class="tags">
                <%foreach(var tag in question["tags"].AsBsonArray){ %>
                    <a href="my.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
                <%} %>
            </div>
            <div class="ignore"><%=question["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></div>
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
    <h2>问题总数</h2>
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
            $.post('loadmy.aspx?p='+(index+1)+'<%=qtag %>',function(r){
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

