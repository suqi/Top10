<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="about, App_Web_leryrlr4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>关于<%=ConfigHelper.SiteName %></title>
<style>
h2{background-color:#eeffed;color:#666;font-weight:normal;padding:3px 7px;}
p{padding:5px 5px 5px 25px;}
p a{margin:0 10px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<h1>关于<%=ConfigHelper.SiteName %></h1>
<div class="article">
    <h2>来历</h2>
    <p><%=ConfigHelper.SiteName %>起源于这个美妙的句子：<br/>Meeting you is the flake of my life.<br />
    翻译为中文的意思是：<br />
    遇见你是我生命中的火花。<br />这句话代表着一个美丽的邂逅，一段变幻的人生传奇。
    <br />此时此刻我们想问你，<b style="margin:0 6px;color:#3FA156;">flakelife.com</b>会是你生命中的火花吗？
    </p>
    <h2>目的</h2>
    <p>
        <%=ConfigHelper.SiteName %>是一个面向大学生的专业的问答社区。
        <br />在大学时代，每个人都经历过迷茫与困惑：对专业无爱、考试挂科、生活艰难、情感问题...。
        <br />这些令我们痛苦和困惑的经历，极有可能只是在“重蹈覆辙”，这个时候我们往往选择默默地独自承担这一切。
        <br />为什么我们不寻求其他人的帮助呢？
        <br />为什么我们不敢和身边的朋友讨论这些话题呢？
        <br />为什么我们在关键时刻变得越来越沉默与封闭呢？
        <br />为什么我们总是喜欢用虚伪的坚强来掩饰内心的脆弱呢？
        <br />......
        <br />加入我们，开始分享吧，我相信你会在这里找到那个愿意帮助你的人！
        <br />如果你的经历能够或者你希望帮助一些人，请联系<b style="margin:0 6px;color:#3FA156;">help#flakelife.com</b>（#换成@）
    </p>
    <h2>使命</h2>
    <p>开放与分享，帮助和影响身边更多的人！</p>
</div>
<div class="aside"></div>
</asp:Content>

