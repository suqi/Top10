<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_tag, App_Web_wdpwwatm" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<%@ Import Namespace="MongoDB.Driver.Builders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>标签简介：<%=Request.QueryString["key"] %>-<%=ConfigHelper.SiteName %></title>
<style>
#user-list td{vertical-align:top;}
td.avatar{width:120px;text-align:center;}
.avatar img{width:100px;height:100px;}
.school a{margin-right:10px;}
.info{width:570px;white-space: nowrap;padding-left:10px;border:2px solid #FFF;}
.info div{margin-bottom:3px;}
.ops a{margin-top:6px; display:block;padding:3px 8px;font-weight:bold;color:#3FA156;background-color:#e8f4e8;text-decoration:none;border-radius:4px;outline:none;}
.pink{border:2px solid #FCF;}
#info{border-radius:10px;padding:5px 5px;}
.user-head a {display: inline-block;margin-right: 6px;text-align: center;}
.user-head img {height: 64px;width: 64px;}
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
    <form action="tag.aspx" method="get" name="ssform">
        <input type="text" maxlength="30" name="key" class="s-text" value=""  placeholder="查询标签信息" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索标签</a>
    </form>
</div>
<div style="clear:both;height:5px;"></div>
<div class="q-head">
    <div id="switcher"><h1>标签：<a class="anchor" title="查看此标签的相关问题" href="questions.aspx?tag=<%=Server.UrlEncode(Request.QueryString["key"]) %>"><%=Request.QueryString["key"] %></a></h1></div>
    <div id="tabs">
<%--     <a href="tag.aspx?key=<%=Request.QueryString["key"] %>"  class="current">标签简介</a>
        <a href="user.aspx?tag=<%=Request.QueryString["key"] %>" title="用户回答积分排行">用户排行</a>
    	<a href="tags.aspx?tab=star" title="收藏人数最多的标签">收藏最多</a>--%>
    </div>
</div>
<div style="clear:both;"></div>
<%
    var tag = DAL.DAL.FindOne(BLL.CollectionInfo.TagCollectionName, 
        new MongoDB.Driver.QueryDocument("tag", MongoDB.Bson.BsonString.Create(Request.QueryString["key"])));
    if (tag == null)
    {
        var id = BsonObjectId.GenerateNewId();
        var innerSet = new BsonDocument();
        innerSet.Add("_id", id);
        innerSet.Add("laston", BsonDateTime.Create(DateTime.Now));
        innerSet.Add("qid", BsonNull.Value);
        innerSet.Add("tag", BsonString.Create(Request.QueryString["key"]));
        innerSet.Add("no", BsonInt32.Create(0));
        DAL.DAL.Add(BLL.CollectionInfo.TagCollectionName, innerSet);
        tag = innerSet;
    }
    MongoDB.Bson.BsonValue info = null;
    tag.TryGetValue("info", out info);
    //是否可以编辑标签简介
    bool canEdit = CurrentUser==null||CurrentUser["score"].AsDouble<10?false:true;
    //编辑成员
    BsonValue tagAdmins = null;
    tag.TryGetValue("admin", out tagAdmins);
     %>
<h2>标签编辑</h2>
<div class="line"></div>
<div>
    <div class="userhead">
    <%if(tagAdmins!=null){ %>
        <%foreach(var usr in tagAdmins.AsBsonArray){ %>
            <%var user = Cache[usr.AsObjectId.ToString()] as BsonDocument;%>
            <%if(user!=null){ %>
            <a href="../fellow/profile.aspx?id=<%=usr.AsObjectId.ToString() %>" title="<%=user["university"].AsString %>">
                <img src="../avatar/<%=user["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:usr.AsObjectId.ToString()+user["avatar"].AsString %>" alt="头像" />
                <div class="<%=user["gender"].AsString=="男"?"boy":"girl" %>"><%=user["realname"].AsString%></div>
            </a>
            <%} %>
        <%} %>
    <%}else{ %>
        <%if(CurrentUser!=null){ %>
        <p class="ignore">向<a href="../fellow/profile.aspx?id=4e1cf97e2583580924739a9d" target="_blank">管理员</a>递交你的申请</p>
        <%}else{ %>
        <p class="ignore">此标签还没有编辑，<a href="../accounts/login.aspx">登录</a>之后赶紧申请吧！</p>
        <%} %>
    <%} %>
    </div>
</div>
<h2>标签简介<a name="edit"></a></h2>
<div class="line"></div>
<div>
    <form action="tag.aspx?key=<%=Request.QueryString["key"] %>" method="post" id="edit">
        <p class="ignore">最大输入长度为256个字符，还可以输入<b id="input-count" style="margin:0 8px;font-size:13px;">256</b>个字符</p>
        <textarea id="info" maxlength="256" style="width:100%;height:120px;" name="info"><%=info!=null?info.AsString:"" %></textarea>
        <p><button type="submit" class="btn-submit" id="editTag"<%=canEdit?"":" disabled"%>>更新标签简介</button>
		<span class="ignore" style="margin-left:10px;">  编辑此标签需要 10 积分，你现在积分为 <%=CurrentUser!=null?CurrentUser["score"].AsDouble:0%></span>
		</p>
    </form>
</div>
<h2>用户排行<a name="user"></a></h2>
<div class="line"></div>
<div id="user-list">
<%
    var accounts=DAL.DAL.Query(BLL.CollectionInfo.AccountCollectionName,
        new MongoDB.Driver.QueryDocument("self_tags",MongoDB.Bson.BsonString.Create(Request.QueryString["key"])));
    accounts.Skip = 0;
    accounts.Limit = 10;
    var result=accounts.SetSortOrder(SortBy.Descending("score"));
     %>
<%if(result.Count()>0){ %>
<table>
    <tbody>
    <%foreach (var creator in result){ %>
    <% string cid = creator["_id"].AsObjectId.ToString(); %>
    <tr>
        <td class="avatar"><a title="查看他（她）的公开资料" class="anchor" href="../fellow/profile.aspx?id=<%=cid%>"><img src="../avatar/<%=creator["avatar"].AsString==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:cid+creator["avatar"].AsString %>" alt="头像" /></a></td>
        <td class="info<%=creator["gender"].AsString=="男"?" boy":" girl" %>">
            <div class="ignore">姓名：<a href="../fellow/profile.aspx?id=<%=cid%>"><%=creator["realname"].AsString%></a></div>
            <div class="ignore school">学校：
                <a href="questions.aspx?tag=<%=creator["university"].AsString %>"><%=creator["university"].AsString%></a>
            </div>
            <div class="ignore">生日：<%=creator["birthday"].AsString %></div>
            <div class="ignore" >家乡：<%=creator["province"].AsString %>-<%=creator["city"].AsString %></div>
            <div class="tags ignore">标签：
                <%foreach(var htag in creator["self_tags"].AsBsonArray){ %>
                <a title="查看与此标签相关的问题" href="questions.aspx?tag=<%=Server.UrlEncode(htag.AsString) %>"><%=htag.AsString%></a>
                <%} %>
            </div>
        </td>
    </tr>
    <%} %>
    </tbody>
</table>
<%}else{ %>
<p class="ignore">还没有用户收藏该标签</p>
<%} %>
</div>
<script>
    function countInputWord(){
        var len=$('#info').val().length;
        $('#input-count').html(256-len);
    }
    $(function () {
        $('td.girl').mouseover(function () {
            $(this).addClass('pink').attr('title', '这是一个女生');
        });
        <%if(canEdit&&CurrentUser!=null){ %>
            $('#edit').ajaxForm(function(r){
                if(r&&r.status&&r.status==200){
                    alert('修改标签信息成功');
                }
            });
        <%}else if(CurrentUser==null){ %>
            $('#editTag').click(function(){
                alert('请先登录');
                return false;
            });
        <%}else{ %>
            $('#editTag').click(function(){
                alert('加油哦！你的积分不够，不能够修改此标签。');
                return false;
            });
        <%} %>
        setInterval(countInputWord,1200);
    });
</script>
</asp:Content>

