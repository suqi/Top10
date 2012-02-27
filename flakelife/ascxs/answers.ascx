<%@ control language="C#" autoeventwireup="true" inherits="ascxs_answers, App_Web_2hyfrruf" %>
<%
    //所有回答
    var query = new MongoDB.Driver.QueryDocument();
    query.Add("qid", QuestionItem["_id"].AsObjectId);
    var answerCursor = DAL.DAL.Query(BLL.CollectionInfo.AnswerCollectionName, query)
        .SetSortOrder(MongoDB.Driver.Builders.SortBy.Ascending("createon","voteup"));
    int defaultShowNum = 30;
    int count = 0;
    string baseUrl = ResolveUrl("~");
 %>
<h2>共有<b id="total-count"><%=QuestionItem["replyno"].AsInt32%></b>个回答，<b id="lighted-count">0</b>个亮了</h2>
<ul id="answer-list">
<%foreach(var entity in answerCursor){ %>
    <% 
        string answerid = entity["_id"].AsObjectId.ToString();
        string userid = entity["userid"].AsObjectId.ToString();
        bool best = entity["best"].AsInt32 == 1;
        //点亮数目
        int aVoteup = entity["voteup"].AsBsonArray.Count;
        count++;
        //默认只显示前30条记录
        if (count > defaultShowNum)
            break;
        %>
    <li id="<%=answerid%>" style="background-color:<%=Util.ColorUtil.GenerateHexColor(aVoteup) %>" class="answer<%=best?" best":"" %><%=aVoteup>0?" lighted-answer":"" %>">
        <div class="a-avatar">
            <a href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid%>"><img src="<%=baseUrl %>avatar/<%=entity["avatar"].AsString %>" alt="头像" /></a>
        </div>
        <div class="a-content">
            <div class="a-head">
                <a class="a-realname" href="<%=baseUrl %>fellow/profile.aspx?id=<%=userid %>"><%=entity["realname"].AsString %></a>
                <a class="a-uni" href="<%=baseUrl %>qa/questions.aspx?tag=<%=entity["university"].AsString %>"><%=entity["university"].AsString %></a>
                <b class="ignore"><%=Util.DateTimeUtil.FormatDate(entity["createon"].AsDateTime)%></b>
                <span style="position:relative" class="light">
                    <a href="javascript:;" class="ilike_icon">亮了</a>(<span class="ignore"><%=aVoteup %></span>)
                </span>
            </div>
            <div class="a-ops"><a class="rpl" href="javascript:;" title="回应TA">@</a>  
            <%if (CurrentUser != null){ %>
            <%var cUid=CurrentUser["_id"].AsObjectId ; %>
            <%if(cUid.ToString()==userid){ %>
                <a href="<%=baseUrl %>qa/editanswer.aspx?id=<%=answerid %>" class="edit">修改</a>
            <%} %>
            <%if (cUid== QuestionItem["userid"].AsObjectId){ %>
                <%if (best == false){ %>
                <a href="javascript:;" class="set-best">设为最佳</a>
                <%} else{ %>
                <a href="javascript:;" class="unset-best">取消最佳</a>
                <%} %>
            <%} %>
            <%} %>
            </div>
            <div style="clear:both;"></div>
            <div class="a-content-strip"><%=entity["content"].AsString.Replace("<script","").Replace("script>","") %></div>
        </div>
       <div style="clear:both;"></div>
    </li>
<%} %></ul>
<%--删除回答，暂时不实现此功能，因为删除回答需要将问题的replyno更新
//$('a.del').click(function () { 
//    var li=$(this).parents('li:eq(0)');
//    if(li.find('.light span').html()!='0'){
//        alert('不能删除已经被人点亮的回答');
//        return;
//    }
//    if(confirm('确认删除此回答吗？')){
//        $.post('<%=baseUrl %>ascxs/service.aspx', { 'action': 'deleteanswer', 'answerid':li.attr('id') }, function (r) {
//            if (r && r.status == 200) {
//                $('#'+li.attr('id')).remove();
//            } else if (r && r.detail) {
//                alert(r.detail);
//            }
//        });
//    }
//});--%>
<%if(count==30){ %>
<div id="q-more">加载更多问题</div><div id="q-loading"></div><div id="q-none" style="cursor:text;">没有更多的问题了</div>
<%} %>
<script>
<%if (CurrentUser != null){ %>
$('#answer-list a.ilike_icon').click(function () {
    var span = this.parentNode;
    $.post('<%=baseUrl %>qa/question.aspx', { 'action': 'lightanswer', 'answerid': $(span).parents('.answer').attr('id') }, function (r) {
        if (r && r.status == 200) {
            var $countSpan = $(span).find('span.ignore')
            $countSpan.html(parseInt($countSpan.html()) + 1);
        } else if (r && r.detail) {
            alert(r.detail);
        }
    });
});
$("a.edit").colorbox({ width: "600px", height: "400px", iframe: true });
<%}else{ %>
    $('#answer-list a.ilike_icon,a.rpl').click(function () {alert('您还没有登录')});
<%} %>
</script>