<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="fellow_follow, App_Web_z1hjc4it" %>
<%@ Import Namespace="MongoDB.Bson" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>我关注的用户</title>
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
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="follow.aspx" id="nav-follow"  title="我关注的朋友" class="youarehere">关注</a>
    <a href="fans.aspx" id="nav-fans" title="关注我的人">粉丝</a>
    <a href="destiny.aspx"  id="nav-guess" title="猜你可能喜欢这些人">推荐</a>
</div><div style="clear:both;height:5px;"></div>
<%
    var follow = CurrentUser["follow"].AsBsonArray;
 %>
<div class="q-head">
    <div id="switcher"><h1>我的关注(<span id="count"><%=follow.Count %></span>)</h1></div>
</div>
<div class="user-head">
<%foreach(var item in follow){ %>
<% 
      var userid = item.AsObjectId;
      var user = Cache[userid.ToString()] as BsonDocument;
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
                <a href="javascript:;" class="cancel">取消关注</a>
            </div>
        </div>  
      <%} %>
<%} %>
<%if(follow.Count==0){ %>
<div class="ignore">还有关注任何人</div>
<% }%>
</div>
<script>
    $(function () {
        $('a.cancel').click(function () {
            var userid = $(this).parents('div.user-item').attr('id');
            $.post('service.aspx', { 'action': 'cancel-watch', 'userid': userid }, function (r) {
                if (r && r.status == 200) {
                    $('#' + userid).remove();
                    var span = $('#count');
                    span.html(parseInt(span.html()) - 1);
                } else if (r && r.status != 200) {
                    alert(r.detail);
                }
            });
        });
    });
</script>
</asp:Content>

