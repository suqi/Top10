<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_tags, App_Web_wdpwwatm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>热门标签-<%=ConfigHelper.SiteName %></title>
<style>
.tag-cell{float:left;}
.tag-cell {
    border-bottom: 1px dotted #E0E0E0;
    padding-bottom: 12px;
    padding-right: 6px;
    padding-top: 6px;
    vertical-align: top;
    width: 220px;
}
.item-multiplier {
    color: #444444;
    font-size: 120%;
    font-weight: bold;
    margin-right: 4px;
}
.excerpt {
    font-size: 12px;
    height: 30px;
    line-height: 14px;
    margin-bottom: 4px;padding-top: 4px;
    overflow: hidden;
}
.excerpt a{color:#c60;}
.tag-ops a{margin-right:10px;}
a.post-tag{background-color: #E9F4E9;color: #3FA156;border-bottom: 1px solid #37607D;border-right: 1px solid #37607D;padding: 3px 4px 3px 4px;margin: 2px 6px 2px 0;text-decoration: none;font-size: 90%;line-height: 2.4;white-space: nowrap;}
a.post-tag:hover{background-color: #3FA156;color:#E9F4E9;text-decoration: none;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="questions.aspx" id="nav-questions" title="查看所有提问">问题</a>
    <a href="tags.aspx" id="nav-tags"  class="youarehere">标签</a>
    <a href="unsolved.aspx">未解决</a>
    <a href="solved.aspx">已解决</a>
    <a href="ask.aspx"  id="nav-askquestion">提问</a>
</div>
<div class="mright" title="查询标签信息">
    <form action="tags.aspx" method="get" name="ssform">
        <input type="text" maxlength="30" name="tag" class="s-text" value=""  placeholder="查询标签信息" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索标签</a>
    </form>
</div>
<div style="clear:both;height:5px;"></div>
<div class="q-head">
    <div id="switcher"><h1>热门标签<%=string.IsNullOrWhiteSpace(Request.QueryString["tag"])?"":"："+Request.QueryString["tag"] %></h1></div>
    <div id="tabs">
        <a href="tags.aspx?tab=use" class="current" title="使用次数最多的标签">使用最多</a>
<%--        <a href="tags.aspx?tab=view" title="浏览次数最多的标签">浏览最多</a>
    	<a href="tags.aspx?tab=star" title="收藏人数最多的标签">收藏最多</a>--%>
    </div>
</div>
<div style="clear:both;"></div>
<div id="tleft">
 <%if(string.IsNullOrWhiteSpace(Request.QueryString["tag"])){ %>
    <%foreach(var item in BLL.Tag.GetTagsByUsedTime()){ %>
    <%
        MongoDB.Bson.BsonValue detail = null;
        item.TryGetValue("info", out detail);
        var tag=item["tag"].AsString;
           %>
    <div class="tag-cell">
        <div>
            <a title="查看与<%=tag %>有关的问题" target="_blank" class="post-tag" href="questions.aspx?tag=<%=Server.UrlEncode(tag) %>"><%=tag %></a><span class="item-multiplier">×&nbsp;<%=item["no"].AsInt32 %></span>
        </div>
        <div class="excerpt ignore"><%=detail != null ? detail.AsString : "此标签还没有用户参与编辑"%></div>
        <div class="tag-ops">
            <a  class="anchor" href="tag.aspx?key=<%=Server.UrlEncode(tag) %>#edit">编辑词条</a><a href="tag.aspx?key=<%=Server.UrlEncode(tag) %>#user" class="anchor">用户排行</a>
        </div>
    </div>
    <%} %>
<%}else{ %>
    <%
        var item = BLL.Tag.GetTag(Request.QueryString["tag"]);
        MongoDB.Bson.BsonValue detail = null;
        item.TryGetValue("info", out detail);
        var tag=item["tag"].AsString;
           %>
    <div class="tag-cell">
        <div>
            <a class="post-tag" href="tag.aspx?key=<%=Server.UrlEncode(tag) %>"><%=tag %></a><span class="item-multiplier">×&nbsp;<%=item["no"].AsInt32 %></span>
        </div>
        <div class="excerpt ignore"><%=detail != null ? detail.AsString : "<a href='tag.aspx?key=" + Server.UrlEncode(tag)+ "'>参与编辑</a>"%></div>
        <div>
            <a href="user.aspx?tag=<%=tag %>" class="anchor">热门用户</a>
        </div>
    </div>
<%} %>
</div>
</asp:Content>

