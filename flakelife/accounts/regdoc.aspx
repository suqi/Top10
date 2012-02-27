<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_regdoc, App_Web_nasjltov" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%if(Request.QueryString["identity"]=="professor"){%>
<h1>教授，您好！欢迎加入到<%=ConfigHelper.SiteName %></h1>  
<p>请下载下面的Word文档，填写相关信息后发送至<b style="margin-left:10px;">accounts@flakelife.com</b></p>
<p>我们会在最短的时间内联系您。</p>
<a href="javascript:;">Word</a>
<%}else if (Request.QueryString["identity"] == "advertise"){ %>
<h1>商家，您好！欢迎加入到<%=ConfigHelper.SiteName %></h1>  
<p>请下载下面的Word文档，填写相关信息后发送至<b style="margin-left:10px;">accounts@flakelife.com</b></p>
<p>我们会在最短的时间内联系您。</p>
<a href="javascript:;">Word</a>
<%} %>
</asp:Content>

