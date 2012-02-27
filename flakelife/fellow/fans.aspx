<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="fellow_fans, App_Web_z1hjc4it" %>
<%@ Import Namespace="MongoDB.Bson" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>我的粉丝</title>
<style>
div.boy{color:#1259C7;font-weight:bold;}
div.girl{color:#F0F;font-weight:bold;}
.user-item{display:inline-block;margin-left:2px;width:180px;}
.user-item a:hover{text-decoration:none;}
.user-item .avatar{width:64px;height:64px;float:left;}
.user-item .avatar img{height:64px;width:64px;}
.user-item .info{float:left;margin-left:3px;}
.info .ignore{margin:3px 0;}
.anchor{font-weight:bold;}
b.ignore{font-weight:bold;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="follow.aspx" id="nav-follow"  title="我关注的朋友" >关注</a>
    <a href="fans.aspx" id="nav-fans" title="关注我的人" class="youarehere">粉丝</a>
    <a href="destiny.aspx"  id="nav-guess" title="猜你可能喜欢这些人">推荐</a>
</div><div style="clear:both;height:5px;"></div>
<%
    var fans = CurrentUser["fans"].AsBsonArray;
 %>
<div class="q-head">
    <div id="switcher"><h1>我的粉丝(<%=fans.Count%>)</h1></div>
</div>
<div class="user-head">

<%foreach (var item in fans){ %>
<% 
      var userid = item.AsObjectId;
      var user = Cache[userid.ToString()] as BsonDocument;
      var userFans = user["fans"].AsBsonArray;
       %>
      <%if(user!=null){ %>
        <div class="user-item" id="<%=userid.ToString() %>">
            <div class="avatar">
                <a href="profile.aspx?id=<%=userid.ToString() %>">
                    <img src="../avatar/<%=user["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:userid.ToString()+user["avatar"].AsString %>" alt="头像" />
                </a>
            </div>
            <div class="info">
                <a class="anchor" href="profile.aspx?id=<%=userid.ToString() %>"><%=user["realname"].AsString%></a>
                <div class="ignore"><%=user["university"].AsString %></div>
                <%if(userFans.Contains(CurrentUser["_id"].AsObjectId)==false){ %>
                <a href="javascript:;" class="watch">添加关注</a>
                <%}else{ %>
                <b class="ignore">已关注</b>
                <%} %>
            </div>
        </div>  
      <%} %>
<%} %>
<%if(fans.Count==0){ %>
<div class="ignore">还没有任何粉丝</div>
<% }%>
</div>
<script>
    $('a.watch').click(function () {
        var a = this;
        var userid = $(this).parents('div.user-item').attr('id');
        $.post('service.aspx', { 'action': 'watch', 'userid': userid }, function (r) {
            if (r && r.status == 200) {
                $(a).html('已关注').attr('disabled', true);
            } else if (r && r.status != 200) {
                alert(r.detail);
            }
        });
    });
</script>
</asp:Content>

