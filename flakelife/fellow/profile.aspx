<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="fellow_profile, App_Web_z1hjc4it" %>
<%@ Register Src="~/ascxs/friends.ascx" TagName="friends" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title><%=user["realname"].AsString %>的公开资料-<%=ConfigHelper.SiteName %></title>
<style>
h1{border-bottom: 1px solid #666;height: 34px;clear: both;margin-bottom: 15px;}
h2{margin-top:10px;}
b.score{font-weight:bolder;font-size:14px;}
.vcard{}
.avatar{float:left;width:130px;}
.avatar img{width:120px;height:120px;}
.info{float:left;margin-left:10px;}
.ileft{width:80px;text-align:right;}
.irt{text-align:left;padding-left:20px;width:120px;}
.ops a{margin-top:6px; display:block;padding:3px 8px;font-weight:bold;color:#3FA156;background-color:#e8f4e8;text-decoration:none;border-radius:4px;outline:none;border: 1px solid #A6D098;}
.ops a:hover{}
.title{padding-left:20px;}
.title a{font-size:14px;color:#1259C7;font-weight:bold;}
.title a:visited{color:#1259C7;}
.block{margin: 0 6px 0 0;padding: 5px;width: 38px;height: 38px;text-align:center;}
.count{height: 25px;font-size: 190%;font-weight: bold;}
.star{background-color:#B4CC66;color:#DE564B;}
.answer{color:#566917;border:0;}
a.username{font-size:12px;margin-right:10px;}
.line{margin:5px 0;}
.user-head a{display:inline-block;margin-right:6px;text-align:center;}
.user-head a:hover{text-decoration:none;}
.user-head img{height:48px;width:48px;}
div.boy{color:#1259C7;font-weight:bold;}
div.girl{color:#F0F;font-weight:bold;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%
    //当前浏览用户的关注和粉丝
    Friends.UserItem = user;
    string avatar=user["avatar"].AsString;
    var userid=user["_id"].AsObjectId;
    string gender=user["gender"].AsString;
    //粉丝和关注
    MongoDB.Bson.BsonValue fans=null;
    user.TryGetValue("fans", out fans);
    var query=new MongoDB.Driver.QueryDocument();
    query.Add("userid",userid);
    query.Add("anony", MongoDB.Bson.BsonString.Create("0"));
    //用户提问(筛除匿名提问)
    var questions = DAL.DAL.Query(BLL.CollectionInfo.QuestionCollectionName, query).SetSortOrder(MongoDB.Driver.Builders.SortBy.Descending("createon"));
    int printedQuestion = 0;
    //标签
    var userTags=user["self_tags"].AsBsonArray.ToList();
    //收藏
    MongoDB.Bson.BsonValue starQuestion = null;
    MongoDB.Driver.MongoCursor<MongoDB.Bson.BsonDocument> starQuestions = null;
    user.TryGetValue("interest", out starQuestion);
    if (starQuestion != null)
    {
        var starQuery = new MongoDB.Driver.QueryDocument();
        starQuery.Add("_id", new MongoDB.Bson.BsonDocument("$in", starQuestion.AsBsonArray));
        starQuestions = DAL.DAL.Query(BLL.CollectionInfo.QuestionCollectionName, starQuery).SetSortOrder(MongoDB.Driver.Builders.SortBy.Descending("createon"));
    }
     %>
<%--（个人收藏、个人好友、我的非匿名问题、我的回答、我的标签）--%>
<h1><%=user["realname"].AsString %></h1>
<div class="vcard">
    <div class="avatar"><img src="../avatar/big/<%=avatar==ConfigHelper.DefaultIconName?avatar:userid.ToString()+avatar %>" alt="用户头像" /></div>
    <table class="info">
        <tr><td colspan="2"><b>基本信息</b></td></tr>
        <tr><td class="ileft">性别</td><td class="irt"><%=gender%></td></tr>
        <tr><td class="ileft">生日</td><td class="irt"><%=user["birthday"].AsString %></td></tr>
        <tr><td class="ileft">家乡</td><td class="irt" title="找到你的老乡"><%=user["province"].AsString %>-<%=user["city"].AsString %></td></tr>
        <tr><td class="ileft">积分</td><td class="irt"><b class="score"><%=user["score"].AsDouble %></b></td></tr>
    </table>
    <table class="info">
        <tr><td colspan="2"><b>学校信息</b></td></tr>
            <tr><td class="ileft"><%=user["uni_year"].AsString%></td><td class="irt"><a href="../qa/questions.aspx?tag=<%=Server.UrlEncode(user["university"].AsString)%>" target="_blank"><%=user["university"].AsString%></a></td></tr>
    </table>
    <div class="info ops">
        <%if(CurrentUser==null){ %>
        <a class="anchor" href="javascript:;" id="watch-him">添加关注</a><a class="anchor" href="javascript:;" id="cancel-watch" style="display:none;">取消关注</a>
        <a class="anchor" href="javascript:;" id="send">发短消息</a>
        <%} %>
        <%else{ %>
            <%if(CurrentUser["_id"].AsObjectId!=userid){ %>
                <%if (fans != null && fans.AsBsonArray.Contains(CurrentUser["_id"].AsObjectId)){ %>
                <a class="anchor" href="javascript:;" id="cancel-watch">取消关注</a><a class="anchor" href="javascript:;" id="watch-him" style="display:none;">添加关注</a>
                <%}else{ %>
                <a class="anchor" href="javascript:;" id="watch-him">添加关注</a><a class="anchor" href="javascript:;" id="cancel-watch" style="display:none;">取消关注</a>
                <%} %>
                <a class="anchor" href="../accounts/send.aspx?id=<%=user["_id"].AsObjectId.ToString()%>" id="send">发短消息</a>
            <%} %>
        <%}%>
    </div>
</div>
<div style="clear:both;"></div>
<h2 title="他（她）喜欢这些东西">标签</h2>
<div class="line"></div>
<div class="tags">
    <%foreach(var tag in userTags){ %>
        <a href="../qa/questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
    <%} %>
</div>
<h2 title="看看你们之间的兴趣相似度">共同标签</h2>
<div class="line"></div>
<%if(CurrentUser==null){ %>
    <div class="ignore">你还没有<a href="../accounts/login.aspx" class="anchor">登录</a>，无法查看你们之间的共同标签</div>
<%}else{ %>
    <%if(CurrentUser!=user){ %>
        <%var myTags = CurrentUser["self_tags"].AsBsonArray; %>
        <%if(myTags.Count<1){ %>
            <div>你还没有标签，来<a href="../qa/questions.aspx" class="anchor">这里</a>添加</div>
        <%}else{ %>
            <%var inter = myTags.ToList().Intersect<MongoDB.Bson.BsonValue>(userTags); %>
            <%if(inter.Count()<1){ %>
                <div>你们的品位差距太大，找不到共同标签</div>
            <%}else{ %>
                <div class="tags">
                <%foreach(var tag in inter){ %>
                <a href="../qa/questions.aspx?tag=<%= Server.UrlEncode(tag.AsString)%>" target="_blank"><%= tag.AsString%></a>
                <%} %>
                </div>
            <%} %>
        <%} %>
    <%}else{ %>
        <div class="ignore">对你的标签还满意吗？</div>
    <%} %>
<%} %>
<uc:friends ID="Friends" runat="server" />
<h2 title="没有显示用户的全部提问">最近提问</h2>
<div class="line"></div>
<div class="user-questions">
    <table>
    <%foreach (var question in questions){
           printedQuestion++;
          if (printedQuestion < 10){%>
    <tr>
        <td class="block star"><div class="count"><%=question["starno"].AsInt32.ToString() %></div><div class="ignore">收藏</div></td>
        <td class="block answer"><div class="count"><%=question["replyno"].AsInt32.ToString() %></div><div class="ignore">回答</div></td>
        <td class="title">
            <a target="_blank" href="../qa/question.aspx?id=<%=question["_id"].AsObjectId.ToString() %>"><%=question["title"].AsString %></a>
            <div class="ignore"><%=question["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %></div>
        </td>
    </tr>
    <%} }%>
    </table>
</div>
<h2 title="没有显示用户收藏的全部问题">最近收藏</h2>
<div class="line"></div>
<div class="user-questions">
<table>
<%printedQuestion = 0; 
    if(starQuestions!=null){
        foreach (var question in starQuestions)
        {
            printedQuestion++;
            if (printedQuestion > 10)
                break;
            else
            {%>
<tr>
    <td class="block star"><div class="count"><%=question["starno"].AsInt32.ToString()%></div><div class="ignore">收藏</div></td>
    <td class="block answer"><div class="count"><%=question["replyno"].AsInt32.ToString()%></div><div class="ignore">回答</div></td>
    <td class="title">
        <a target="_blank" href="../qa/question.aspx?id=<%=question["_id"].AsObjectId.ToString() %>"><%=question["title"].AsString%></a>
        <div class="ignore"><a class="username" href="profile.aspx?id=<%=question["userid"].AsObjectId.ToString() %>"><%=question["realname"].AsString%></a><%=question["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></div>
    </td>
</tr>
<%}}}else{%>
<tr><td class="ignore">该用户还没有收藏提问</td></tr>
<%} %>
</table>
</div>
<script>
    $(function () {
        <%if(CurrentUser!=null){ %>
        $('#watch-him').click(function () {
            var a=this;
            $.post('service.aspx', {'action':'watch','userid':'<%=userid.ToString() %>'}, function (r) {
                if(r&&r.status==200){
                    $(a).hide();
                    $('#cancel-watch').show();
                }else if(r&&r.status!=200){
                    alert(r.detail);
                }
             });
        });
        $('#cancel-watch').click(function () {
            var a=this;
            $.post('service.aspx', {'action':'cancel-watch','userid':'<%=userid.ToString() %>'}, function (r) {
                if(r&&r.status==200){
                    $(a).hide();
                    $('#watch-him').show();
                }else if(r&&r.status!=200){
                    alert(r.detail);
                }
             });
        });
        <%}else{ %>
        $('#send,#watch-him').click(function(){
            alert('你还没有登录');
            return false;
        });
        <%} %>
    });
</script>
</asp:Content>
