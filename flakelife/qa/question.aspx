<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_question, App_Web_wdpwwatm" validaterequest="false" %>
<%@ Register Src="~/ascxs/mytags.ascx" TagName="tags" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/usercard.ascx" TagName="usercard" TagPrefix="uc" %>
<%@ Register Src="~/ascxs/answers.ascx" TagName="answer" TagPrefix="uc" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title><%if(item!=null) {%><%=item["title"].AsString %>-<%} %>问答-<%=ConfigHelper.SiteName %></title>
<style>
h2{margin-top:5px;margin-bottom:5px;}
#question-header{border-bottom: 1px solid #555555;margin-bottom: 10px;}
#question table{width:100%;}
.q-content{vertical-align:top;}
.vote{vertical-align: top;width: 60px;text-align:center;}
.info b{font-size:14px;margin-right:10px;}
.ul img{width:64px;height:64px;}
.vote-up,.vote-down,.in-bookmark, .no-bookmark{background: url("../imgs/vote.png") no-repeat scroll -10px -10px transparent;display: block;outline:none;height: 13px;margin: 0 auto;text-indent: -9999px;width: 20px;}
.vote-down {background-position: -10px -30px;}
.vote-count {color: #AAAAAA;display: block;font-family: Arial,Liberation Sans,DejaVu Sans,sans-serif;font-size: 28px;font-weight: bold;margin: 10px 0;}
.createon{font-weight:normal;margin-left:20px;}
.q-bookmark {color: #999999;font-size: 13px;font-weight: bold;margin-top: 20px;}
.in-bookmark, .no-bookmark, a.no-bookmark:hover {background-position: -8px -48px;height: 22px;margin-bottom: 5px;width: 23px;}
.no-bookmark, a.no-bookmark:hover {background-position: -38px -48px;}
#the-best-answer{display:none;}
.solved,.unsolved{font-weight:bold;}
.unsolved{color:#F30;}
.solved{color:#3FA156;}
.answer{display:block;clear:both;}
/*回答列表*/
#answer-list{margin-bottom:15px;display:block;}
#answer-list li {display: list-item;}
.answer{border-top: 1px dashed #D4D4D4;margin-top:5px;padding-top:3px;}
.a-avatar{width:70px;text-align:center;vertical-align:top;float:left;}
.a-avatar img{width:48px;height:48px;}
.a-head{float:left;}
.a-head a{margin-right:10px;}
.a-head b{margin-right:5px;}
.a-ops{float:right;}
.a-content{vertical-align:top;text-align:left;float:left; width:550px;overflow:hidden;margin-left:5px;}
.a-content-strip{padding-left:20px;}
.a-content-strip p,.q-content p{margin-top:6px;margin-bottom:6px;}
.a-content-strip a{color:#1259C7;}
.a-realname{font-weight:bold;}
.a-ops a{margin-left:10px;}
.best{border:2px solid #40AA53;}
.q-ops{margin-top:15px;}
.q-ops a{margin-right:10px;}
.a-uni{color:#494949;}
#add-detail{margin-left:40px;padding:10px;margin-top:5px;display:none;border-radius:6px;background-color:#eee;width:490px;}
#add-detail textarea{height:66px;border:1px solid #999;padding:3px;outline: none;}
#add-detail textarea,#add-detail p{width:480px;}
#add-detail p{text-align:right;}
#add-detail p .ignore{margin:0 10px;}
#add-error{margin-right:20px;display:none;}
#more-list{padding-left:50px;width:500px;padding-top:10px;}
#more-list .el{border:1px solid #ddd;background-color:#e9e9e9;padding:5px 5px;margin-bottom:3px;border-radius:6px;}
</style>
<%if(CurrentUser!=null){ %>
<script src="../scripts/editor/kindeditor-min.js"></script>
<%} %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="questions.aspx" id="nav-questions" class="youarehere" title="查看所有提问">问题</a>
    <a href="tags.aspx" id="nav-tags">标签</a>
    <a href="unsolved.aspx">未解决</a>
    <a href="solved.aspx">已解决</a>
    <a href="ask.aspx"  id="nav-askquestion">提问</a>
</div>
<div class="mright" title="按标签在所有问题中搜索">
    <form action="questions.aspx" method="get" name="ssform">
        <input type="text" maxlength="30" name="tag" class="s-text" value="" placeholder="按标签在所有问题中搜索" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索问题</a>
    </form>
</div>
<div style="clear:both;height:20px;"></div>
<%if(item==null){ %>
    <div class="error" style="text-align:center;font-size:16px;font-weight:bold;">对不起，找不到你请求的资源。</div>
<%}else{ %>
    <%
        //更新浏览量
        var qUpd = new MongoDB.Driver.UpdateDocument();
        qUpd.Add("$inc", new MongoDB.Bson.BsonDocument("viewno", MongoDB.Bson.BsonInt32.Create(1)));
        DAL.DAL.UpdateById(BLL.CollectionInfo.QuestionCollectionName, item["_id"].AsObjectId, qUpd);
        string id=item["_id"].AsObjectId.ToString();
        var tags = item["tags"].AsBsonArray;
        string userid = item["userid"].AsObjectId.ToString();
        var creator = DAL.DAL.FindOneById(BLL.CollectionInfo.AccountCollectionName, MongoDB.Bson.BsonObjectId.Create(userid));
        string realname = creator["realname"].AsString;
        MyTags.UserItem = CurrentUser;
        UserCardInfo.UserItem = creator;
        AnswerList.CurrentUser = CurrentUser;
        AnswerList.QuestionItem = item;
      %>
    <div id="question-header"><h1><%=item["title"].AsString %><b class="createon ignore" title="提问时间"><%=Util.DateTimeUtil.FormatDate(item["createon"].AsDateTime)%></b></h1></div>
    <div class="article">
        <div id="question">
            <table>
                <tr>
                    <td class="vote">
                        <div class="vote-status">
                            <a title="问得好！投票支持，让更多人参与。" href="javascript:;" class="vote-up">好问题</a>
                            <span class="vote-count" title="<%=CurrentUser==null?"登录后点击上方和下方的箭头进行投票":"点击上方和下方的箭头进行投票，投票后不可以撤销" %>"><%=item["voteup"].AsBsonArray.Count-item["votedown"].AsBsonArray.Count %></span>
                            <a title="闹眼子，赶紧沉了吧！" href="javascript:;" class="vote-down">烂问题</a>
                        </div>
                        <div class="q-bookmark" style="position: relative;">
                            <%if(CurrentUser==null){ %>
                                <a id="star-q" href="javascript:;" class="no-bookmark" title="登录后收藏此问题">未收藏</a>
                            <%}else{ %>
                                <%if(CurrentUser["interest"].AsBsonArray.Contains(item["_id"])){ %>
                                <a title="点此取消收藏" href="javascript:;" class="in-bookmark" id="unstar-q">已收藏</a>
                                <%}else{ %>
                                <a id="star-q" href="javascript:;" class="no-bookmark" title="点此收藏此问题">未收藏</a>
                                <%} %>
                            <%} %>
                            <span title="收藏该问题的人数"><%=item["starno"].AsInt32.ToString() %></span>
                        </div>
                    </td>
                    <td class="q-content"><%=item["content"].AsString %>
                    <div style="clear:both;"></div>
                    <div class="q-ops"><a id="more-details" class="anchor" href="javascript:;" onclick="showAddDetail()">>>补充说明</a></div>
                        <div id="more-list">
                        <% var more = item["more"].AsBsonArray; %>
                        <%if(more!=null&&more.Count>0){ %>
                            <%foreach(var detail in more){ %>
                                <%var docu = detail.AsBsonDocument; %>
                                <div class="el"><a href="../fellow/profile.aspx?id=<%=item["userid"].AsObjectId.ToString() %>" style="margin-right:10px;"><%=item["realname"].AsString %></a><%=docu["on"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm") %><p class="ignore"><%=docu["say"].AsString %></p></div>
                            <%} %>
                        <%} %>
                        </div>
                        <%if(CurrentUser!=null&&CurrentUser["_id"].AsObjectId==item["userid"].AsObjectId){ %>
                        <div id="add-detail" style="display:none;">
                            <form action="question.aspx?action=more&id=<%=Request["id"] %>" method="post" id="form-add">
                                <textarea maxlength="256" name="say" id="say"></textarea>
                                <p><span class="error" id="add-error">补充说明不得少于十个字</span><button type="submit" class="btn-submit" onclick="if($('#say').val().length<10){$('#add-error').show();return false;}">提交</button><span class="ignore">或</span><a class="anchor" href="javascript:;" onclick="$('#add-detail').hide();">关闭</a></p>
                            </form>
                        </div>
                        <%} %>
                    </td>
                </tr>
            </table>
        </div>
        <div id="the-best-answer"><h2>最佳答案</h2></div>
        <uc:answer ID="AnswerList" runat="server" />
        <div class="line" style="clear:both;"></div>
        <%if(CurrentUser!=null){ %>
        <div><a name="hash-for-reply"></a>
            <textarea id="content" name="content" style="width:100%;height:200px;" class="basic-input"></textarea>
            <button id="btn-submit" type="button" class="btn-submit" style="margin-top:15px;">提交回答</button><span id="error" class="error"></span>
        </div>
        <%}else{ %>
        <p style="text-align:center;font-size:14px;" class="ignore">请<a href="../accounts/login.aspx?goto=qa/question.aspx?id=<%=Request.QueryString["id"] %>" class="anchor" style="font-weight:bold;">登录</a>后再回答问题</p>
        <%} %>
    </div>
    <div class="aside">
        <div id="tags">
            <h2>问题状态</h2>
            <div id="status" title="绿色边框的回答为最佳答案"><%=item["best"].AsInt32==1?"<b class='solved'>已解决</b>":"<b class='unsolved'>未解决</b>" %></div>
            <uc:usercard ID="UserCardInfo" runat="server" />
            <div style="clear:both;"></div>        
            <h2>该问题的标签</h2>
            <div class="tags">
                <%foreach(var tag in tags){ %><a href="questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>" target="_blank"><%=tag.AsString %></a><br /><%} %>
            </div>
            <%if(CurrentUser!=null){ %>
                <%
                    MongoDB.Bson.BsonValue mytags = null;
                    CurrentUser.TryGetValue("self_tags", out mytags);
                    var mytagArray = mytags.AsBsonArray.ToList();
                        %>
                <%if(userid!=CurrentUser["_id"].AsObjectId.ToString()){ %>
                <%
                    MongoDB.Bson.BsonValue creatorTags = null;
                    creator.TryGetValue("self_tags", out creatorTags);
                    var creatorTagArray = creatorTags.AsBsonArray.ToList(); 
                       %>
                <h2 title="共同标签越多，说明你们的兴趣爱好越相似">你和<%=creator["gender"].AsString=="男"?"他":"她" %>共同的标签</h2>
                <div title="共同标签越多，说明你们的兴趣爱好越相似" class="tags">
                    <%if(mytags==null||creatorTags==null){ %>
                        你和提问者没有共同标签
                    <%}else{ %>
                        <%var sameTags = mytagArray.Intersect(creatorTagArray);%>
                         <%foreach(var tag in sameTags){ %>
                         <a href="questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a>
                         <% }%>
                    <%} %>
                </div>
                <%} %>
                <uc:tags ID="MyTags" runat="server" />
            <%}else{ %>
            <h2 title="共同标签越多，说明你们的兴趣爱好越相似">共同标签</h2>
            <div><a href="../accounts/login.aspx">登录</a>后，你和提问者共同的标签会显示在这里</div>
            <%} %>
        </div>
    </div>
    <script>
        function star(a){
            $.post('question.aspx',{'action':'star','id':'<%=id %>'},function(r){
                if (r && r.status == 200) {
                    var countSpan=$(a).next('span'); 
                    countSpan.html(parseInt(countSpan.html())+1);
                    $(a).removeClass('no-bookmark').addClass('in-bookmark').attr('title','点此取消收藏').unbind('click').click(function(){
                        unstar(a);
                    });
                } else if (r && r.detail) {
                    alert(r.detail);
                }
            });
        }
        function unstar(a){
            $.post('question.aspx',{'action':'unstar','id':'<%=id %>'},function(r){
                if (r && r.status == 200) {
                    var countSpan=$(a).next('span'); 
                    countSpan.html(parseInt(countSpan.html())-1);
                    $(a).removeClass('in-bookmark').addClass('no-bookmark').attr('title','点此收藏此问题').unbind('click').click(function(){
                        star(a);
                    });
                } else if (r && r.detail) {
                    alert(r.detail);
                }
            });
        }
        function setBest(a){
            var div=$(a).parents('.answer');
            var aid=div.attr('id');
            $.post('question.aspx',{'action':'setbest','id':'<%=id %>','answerid':aid},function(r){
                if(r&&r.status==200){
                    $('#status>b').html('已解决').removeClass('unsolved').addClass('solved');
                    $(div).addClass('best');
                    $(a).html('取消最佳').unbind('click').click(function(){unsetBest(this);});
                    $('#the-best-answer').append(div.clone(true)).show();
                }else if(r&&r.detail){
                    alert(r.detail);
                }
            });
        }
        function unsetBest(a){
            var div=$(a).parents('.answer');
            var aid=div.attr('id');
            $.post('question.aspx',{'action':'unsetbest','id':'<%=id %>','answerid':aid},function(r){
                if(r&&r.status==200){
                    $('#status>b').html('未解决').removeClass('solved').addClass('unsolved');
                    $(div).removeClass('best');
                    $('#the-best-answer').find('#'+aid).remove();
                    $('#'+aid).removeClass('best').find('.set-best').html('设为最佳').unbind('click').click(function(){setBest(this);});
                }else if(r&&r.detail){
                    alert(r.detail);
                }
            });
        }
        function showAddDetail(){
            var addDetail=document.getElementById('add-detail');
            alert(addDetail.style.display)
            if(addDetail.style.display=='none'){
                alert(0)
                $(addDetail).show();
            }else{
                $(addDetail).hide();
                alert(1);
            }
            alert(2);
        }
        $(function () {
        <%if(CurrentUser!=null){ %>
            $('#form-add').ajaxForm(function(r){
                if(r&&r.status==200){
                    $('#more-list').append('<div class="el"><a href="javascript:;" style="margin-right:10px">提问者</a>刚刚<p class="ignore">'+$('#say').val()+'</p></div>');
                    document.getElementById('form-add').reset();
                    $('#add-detail').hide();
                }
            });
            <%if(userid==CurrentUser["_id"].AsObjectId.ToString()){ %>
                $('#answer-list a.set-best').click(function(){setBest(this);});
                $('#answer-list a.unset-best').click(function(){unsetBest(this);});
            <%} %>
            KE.show({
                id: 'content',
                resizeMode: 1,
                allowPreviewEmoticons: false,
                allowUpload: false,
                items: ['bold', 'italic', 'underline', 'strikethrough', 'removeformat', '|', 'insertorderedlist', 'insertunorderedlist', '|',
				     'textcolor', 'bgcolor', 'fontname', 'fontsize', '|', 'link', 'unlink', 'emoticons', 'code', '|', 'image', 'selectall', 'source', 'about']
            });
            //回应
            $('a.rpl').click(function(){
                var usr=$(this).parents('div.a-content').find('a.a-realname');
                KE.html('content','@<a target="_blank" href="'+usr.attr('href')+'">'+usr.html()+'</a>:');
                window.location.hash='hash-for-reply';
            });
            $('#question a.vote-up').click(function () {
                var a = this;
                var id = '<%=id %>';
                $.post('question.aspx', { 'action': 'voteup', 'id': id}, function (r) {
                    if (r && r.status == 200) {
                        var count = $('#question span.vote-count').html();
                        $('#question span.vote-count').html(parseInt(count) + 1);
                    } else if (r && r.detail) {
                        alert(r.detail)
                    }
                });
            });
            $('#question a.vote-down').click(function () {
                var a = this;
                var id = '<%=id %>';
                $.post('question.aspx', { 'action': 'votedown', 'id': id}, function (r) {
                    if (r && r.status == 200) {
                        var count = $('#question span.vote-count').html();
                        $('#question span.vote-count').html(parseInt(count) - 1);
                    } else if (r && r.detail) {
                        alert(r.detail);
                    }
                });
            });
            $('#star-q').click(function(){star(this);});
            $('#unstar-q').click(function(){unstar(this);});
            $('#btn-submit').click(function () {
                var btn = this;
                $(btn).html('正在提交').attr('disabled',true);
                var html = KE.html('content');
                KE.sync('content');
                var content = $('#content').val();
                if (content.length < 10) {
                    $('#error').html('内容不能少于10个字');
                    $(btn).removeAttr('disabled');
                    return false;
                }
                $.post('question.aspx', { "action": "reply", "id": "<%=id %>", "content": content }, function (r) {
                    $(btn).removeAttr('disabled');
                    if (r && r.status == 200) {
                        location.reload();
                    }
                    else if(r && r.status != 200){
                        $(btn).html('提交回答').removeAttr('disabled');
                        $('#error').html(r.detail);
                    }
                });
            });
        <%}else{ %>
            $('#question a.vote-up,#question a.vote-down,#star-q,#star-q,#more-details').click(function(){
                alert('您还没有登录');
            });
        <%} %>
        $('#lighted-count').html($('#answer-list>div.lighted-answer').length);
        var best=$('#answer-list>.best');
        if(best.length>0)
            $('#the-best-answer').append(best.clone(true)).show();
        });
    </script>
<%} %>
</asp:Content>

