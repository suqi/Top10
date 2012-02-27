<%@ page language="C#" autoeventwireup="true" inherits="event_loadreply, App_Web_f2vpwpqs" %><!DOCTYPE html>
<%
    var planId = MongoDB.Bson.BsonObjectId.Create(Request["id"]);
    if (planId == null)
    {
        Response.Write("编号错误");
        Response.End();
    }
    var plan = DAL.DAL.FindOneById(BLL.CollectionInfo.PlanCollectionName, planId);
    if (planId == null)
    {
        Response.Write("活动计划不存在");
        Response.End();
    }
    var reply = plan["reply"].AsBsonArray;
 %>
<div class="rp-list" style="border-top:1px dashed #D4D4D4;padding-top:7px;">
 <div class="rp-zone" style="margin-bottom:10px;">
<form method="post" action="loadreply.aspx?action=reply&id=<%=Request["id"] %>" id="form-rp">
 <%if(CurrentUser!=null){ %>
    <input type="text" name="reply-content" class="basic-input" style="width:360px;margin-right:10px;" maxlength="30" />
    <button type="submit" class="btn-submit" onclick="return $(this).prev('input').val()!=''">评论</button>
 <script>
     $('#form-rp').ajaxForm(function (r) {
         if (r && r.status == 200) {
             $('#<%=Request["id"] %> a.reply').click();
         }
     });
 </script>
 <%} %><a  class="anchor"  style="margin-left:20px;" href="javascript:;" onclick="$('#<%=Request["id"] %>').find('.load-r').hide();">收起</a>
</form>
  </div>
    <%for (int i = reply.Count - 1; i>=0; i--) { %>
        <%
            var rpItem = reply[i].AsBsonDocument;
            var rpUser = Cache[rpItem["userid"].AsObjectId.ToString()] as MongoDB.Bson.BsonDocument;
            var rpUid = rpUser["_id"].AsObjectId;
            var rpAvt = rpUser["avatar"].AsString;
            %>
        <div class="rp-el">
            <a  title="<%=rpUser["university"].AsString %>-<%=rpUser["realname"].AsString %>"  href="../fellow/profile.aspx?id=<%=rpUid.ToString() %>"><img src="../avatar/<%=rpAvt==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:rpUid.ToString()+ rpAvt%>" alt="头像" /></a>
            <div class="rp-ct">
                <a href="../fellow/profile.aspx?id=<%=rpUid.ToString() %>"><%=rpUser["realname"].AsString %></a><span class="ignore"><%=rpItem["createon"].AsDateTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm")%></span>
                <div><%=Util.HtmlUtil.StripHtmlTags(rpItem["content"].AsString)%></div>
            </div>
            <div style="clear:both;"></div>
        </div>
    <%} %>
</div>
