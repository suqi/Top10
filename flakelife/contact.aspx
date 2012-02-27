<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="contact, App_Web_leryrlr4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>联系我们-<%=ConfigHelper.SiteName %></title>
<style>
h2{background-color:#eeffed;color:#666;font-weight:normal;padding:3px 7px;}
p{padding:5px 5px 5px 25px;}
p a{margin:0 6px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<h1>联系我们</h1>
<div class="article">
<h2>意见反馈</h2>
<p>我们时刻欢迎您对社区提出改进的建议和意见，请Email：<a>bug#flakelife.com</a>(#换成@)</p>
<h2>广告合作</h2>
<p>如果您有意进行校园方面的推广活动或者投放广告，请Email：<a>ad#flakelife.com</a>(#换成@)</p>
<h2>投资意向</h2>
<p>如果您是天使投资人，并且看好我们的未来，请Email：<a>invest#flakelife.com</a>(#换成@)</p>
</div>
</asp:Content>

