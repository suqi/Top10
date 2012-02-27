<%@ page language="C#" autoeventwireup="true" inherits="event_loadwatch, App_Web_f2vpwpqs" %><!DOCTYPE html>
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
    var interest = plan["interest"].AsBsonArray;
 %>
 <div class="int-list" style="border-top:1px dashed #D4D4D4;padding-top:7px;">
  <div class="int-zone" style="margin-bottom:10px;">
  <%if(CurrentUser!=null){ %>

    <%if(interest.Contains(CurrentUser["_id"].AsObjectId)==false){ %>
        <button type="button" class="btn-submit" id="btn-int">+&nbsp;&nbsp;关注</button>
         <script>
             $('#btn-int').click(function () {
                 $.post('loadwatch.aspx?action=watch', { id: '<%=Request["id"] %>' }, function (r) {
                     if (r && r.status == 200) {
                         $('#<%=Request["id"] %> a.watch').click();
                     } else if (r && r.status != 200) {
                         alert(r.detail)
                     }
                 });
             });
        </script>
    <%}else{ %>
        <button type="button" class="btn-submit" id="btn-cancel-int">取消关注</button>
        <script>
            $('#btn-cancel-int').click(function () {
                $.post('loadwatch.aspx?action=unwatch', { id: '<%=Request["id"] %>' }, function (r) {
                    if (r && r.status == 200) {
                        $('#<%=Request["id"] %> a.watch').click();
                    } else if (r && r.status != 200) {
                        alert(r.detail)
                    }
                });
            });
        </script>
    <%} %>
 <%} %><a class="anchor" style="margin-left:20px;" href="javascript:;" onclick="$('#<%=Request["id"] %>').find('.load-i').hide();">收起</a>
  </div>
 <%if(interest.Count>0){ %>
 <%foreach(var item in interest){ %>
    <%
        var intUid = item.AsObjectId;
        var user = Cache[intUid.ToString()] as MongoDB.Bson.BsonDocument;
        var rpAvt = user["avatar"].AsString;
        %>
       <a title="<%=user["university"].AsString %>-<%=user["realname"].AsString %>" class="int-avt" href="../fellow/profile.aspx?id=<%=intUid.ToString() %>"><img src="../avatar/<%=rpAvt==ConfigHelper.DefaultIconName?ConfigHelper.DefaultIconName:intUid.ToString()+ rpAvt%>" alt="头像" /></a>
 <%} %>
 <%}else{ %>
    <p class="ignore">还没有用户对此活动计划感兴趣</p>
 <%} %>
 </div>