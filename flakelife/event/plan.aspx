<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="event_plan, App_Web_f2vpwpqs" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<%@ Import Namespace="MongoDB.Driver.Builders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>活动计划-<%=ConfigHelper.SiteName %></title>
<style>
#share{font-weight:bold;margin:0 5px;}
#share_div td{padding:3px 10px;text-align:left;}
#share_div td.lf{font-weight:bold;color:#494949;font-size:13px;padding-left:25px;}
span.ignore{margin-left:15px;}
#preview{padding-left:25px;}
#preview b{display:inline-block;margin:0 7px;color:#3FA156;font-weight:bold;}
#share_div{display:none;border-radius:8px;background-color:#eee;padding:5px;}
#radios label{display:inline-block; margin-right:10px;}
#radios input{margin-right:5px;}
#custom{display:none;}
#plan-list td{vertical-align:top;}
#plan-list td img{width:64px;height:64px;}
#plan-list .plans{padding-left:10px;}
#plan-list .ct{padding-left:15px;color:#444;}
#plan-list .ct span{margin:10px;font-weight:bold;text-decoration:underline;}
#plan-list td.avt{width:64px;}
#plan-list td.plans{width:600px;}
#plan-list .author a{font-weight:bold;font-size:13px;}
#plan-list .ops a{margin-right:20px;}
div.rp-el{padding:3px;background-color:#eee;margin-bottom:3px;border-radius:6px;}
div.rp-el a{float:left;margin-left:3px;}
#plan-list div.rp-el img{width:32px;height:32px;border:1px solid #D4D4D4;}
.rp-ct{float:left;vertical-align:top;margin-left:5px;}
.rp-ct a{margin-left:0;}
a.int-avt img{height:50px;width:50px;margin-right:5px;border:1px solid #D4D4D4;}
</style>
</asp:Content>
<asp:Content ID="Cmonontent2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="q-head">
    <div id="switcher"><h1>计划</h1></div>
    <div id="tabs">
        <a href="plan.aspx"<%=string.IsNullOrEmpty(Request.QueryString["tab"])?" class='current'":""%>>全部计划</a>
        <%if (CurrentUser != null){ %>
        <a href="plan.aspx?tab=my"<%=Request.QueryString["tab"]=="my"?" class='current'":""%>>我的计划</a>
        <a href="plan.aspx?tab=fav"<%=Request.QueryString["tab"]=="fav"?" class='current'":""%>>我关注的</a>
        <%} %>
    </div>
</div>
<div style="clear:both;"></div>
<p id="plan-tip" class="ignore" style="margin-left:20px;">看看大家的活动计划。
<%if (CurrentUser != null){ %>
<a href="javascript:;" id="share" onclick="$('#share_div').show();$('#plan-tip').hide();">分享</a>我的活动计划，找到感兴趣的朋友。</p>
<div id="share_div">
    <form action="plan.aspx?action=plan" method="post" id="form1">
    <h2>分享计划</h2>
    <div id="preview">
        <div class="ignore">发布后的计划内容格式如下：</div>
        <p>我和<b id="b-with">大美女</b>计划在<b id="b-on">2011年8月1号</b>去<b id="b-at">VOX</b>那里<b id="b-do">看演出</b></p>
    </div>
    <table>
        <tr>
            <td class="lf">我的伙伴</td><td><input id="with" name="with"   type="text" value="" class="basic-input"/><span class="ignore">多个按空格隔开，@人名可以发送站内信</span> </td>
        </tr>
        <tr>
            <td class="lf">计划时间</td><td><select id="on" name="on"><option value="最近三天">最近三天</option><option value="本周内">本周内</option><option value="本月内">本月内</option><option value="一个月以后">一个月以后</option></select><span class="ignore"></span> </td>
        </tr>
        <tr>
            <td class="lf">计划地点</td><td><input id="at" name="at"   type="text" value="" class="basic-input"/> <span class="ignore"></span> </td>
        </tr>
        <tr>
            <td class="lf">去干什么</td><td>
            <div id="radios">
                <label><input type="radio" value="听音乐" name="do" />听音乐</label><label><input type="radio" value="听讲座" name="do" />听讲座</label>
                <label><input type="radio" value="看演出" name="do" />看演出</label><label><input type="radio" value="观展览" name="do" />观展览</label>
                <label><input type="radio" value="看电影" name="do" />看电影</label><label><input type="radio" value="聚会" name="do" />聚会</label>
                <label><input type="radio" value="旅行" name="do" />旅行</label><label><input type="radio" value="做运动" name="do" />做运动</label>
                <label><input type="radio" value="做公益" name="do" />做公益</label><a class="anchor" href="javascript:;" id="show-custom">自定义</a>
            </div>
            <div id="custom"><input id="do" name="do" type="text" value="" class="basic-input" maxlength="18" /> <a class="anchor" href="javascript:;" id="cancel-custom" style="margin-left:15px;">取消自定义</a></div>
             </td>
        </tr>
        <tr>
            <td colspan="2">
                <div id="tip" class="error"></div>
                <button type="submit" id="btn-sub" class="btn-submit">分享计划</button><span style="margin-left:30px;">
                或<a class="anchor" style="margin-left:10px;" href="javascript:;" onclick="$('#share_div').hide();$('#plan-tip').show();">关闭</a></span>
            </td>
        </tr>
    </table>
    </form>
</div>
<%}else{%>
<a href="../accounts/login.aspx?goto=event/plan.aspx" id="share">分享</a>我的活动计划，找到感兴趣的朋友。</p>
<%} %>
<div class="line"></div>
<div id="plan-list">
    <%
    var q = new QueryDocument();
    if (CurrentUser != null)
    {
        if (Request.QueryString["tab"] == "my")
            q.Add("userid", CurrentUser["_id"].AsObjectId);
        else if (Request.QueryString["tab"] == "fav")
        {
            q.Add("interest", CurrentUser["_id"].AsObjectId);
        }
    }
    var plans = DAL.DAL.Query(BLL.CollectionInfo.PlanCollectionName, q);
    plans.SetSortOrder(SortBy.Descending("createon"));
     %>
     <table>
     <%foreach (var item in plans)
       { %>
        <%
    var uid = item["userid"].AsObjectId;
    var user = Cache[uid.ToString()] as BsonDocument;
    var avt = user["avatar"].AsString;
    var with = item["with"].AsString;
    var interest = item["interest"].AsBsonArray;
    var reply = item["reply"].AsBsonArray;
               %>
        <tr id="<%=item["_id"].AsObjectId.ToString() %>">
            <td class="avt"><a title="<%=user["university"].AsString %>-<%=user["realname"].AsString %>"  href="../fellow/profile.aspx?id=<%=uid.ToString() %>"><img src="../avatar/<%=avt==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:uid.ToString()+ avt%>" alt="头像" /></a></td>
            <td class="plans">
                <div class="author"><a href="../fellow/profile.aspx?id=<%=uid.ToString() %>"><%=user["realname"].AsString%></a>
                    <span class="ignore"><%=item["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></span>
                </div>
                <div class="ct">
                    <%if (string.IsNullOrEmpty(with))
                      { %>
                    <span class="lonely">独自一人</span>
                    <%}
                      else
                      { %>
                    和<span class="with"><%=with.Replace(' ', '、')%></span>
                    <%} %>计划在<span class="on"><%=item["on"].AsString%></span>去<span class="at"><%=string.IsNullOrWhiteSpace(item["at"].AsString)?"随便什么地方":item["at"].AsString%></span>那里
                    <span class="do"><%=item["do"].AsString%></span>
                </div>
                <div class="ops">
                    <a href="javascript:;" class="watch">感兴趣(<b><%=interest.Count%></b>)</a>
                    <a href="javascript:;" class="reply">评论(<b><%=reply.Count%></b>)</a>
                </div>
                <div class="load-i"></div>
                <div class="load-r"></div>
            </td>
        </tr>
     <%} %>
     </table>
</div>
<script>
    $(function () {
        $('#btn-sub').click(function () {
            if ($('#do').val() == '' && $('#radios input:checked').length < 1) {
                alert('你计划去干什么呢？');
                return false;
            }
        });
        $('#show-custom').click(function () {
            $('#radios').hide().find('input:checked').removeAttr('checked');
            $('#custom').show().find('input').val('');
        });
        $('#cancel-custom').click(function () {
            $('#radios').show();
            $('#custom').hide().find('input').val('');
        });
        $('#plan-list a.watch').click(function () {
            var tr = $(this).parents('tr:eq(0)');
            tr.find('.load-i').show().load('loadwatch.aspx', { 'id': tr.attr('id') }, function (r) {
                if (r && r.length > 6) {
                    tr.find('.load-r').hide();
                }
            })
        });
        $('#plan-list a.reply').click(function () {
            var tr = $(this).parents('tr:eq(0)');
            tr.find('.load-r').show().load('loadreply.aspx', { 'id': tr.attr('id') }, function (r) {
                if (r && r.length > 6) {
                    tr.find('.load-i').hide();
                }
            })
        });
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                <%if(Request["tab"]!="fav"){ %>
                window.location.reload();
                <%}else{ %>
                alert('分享计划成功！');
                <%} %>
            } else if (r && r.status != 200) {
                alert(r.detail);
            }
        });
    });
</script>
</asp:Content>

