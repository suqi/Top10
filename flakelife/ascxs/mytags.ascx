<%@ control language="C#" autoeventwireup="true" inherits="ascxs_mytags, App_Web_2hyfrruf" %>
<%
    string baseUrl = ResolveUrl("~");
 %>
    <%if (UserItem != null) { %>
    <%
        MongoDB.Bson.BsonValue tags = null;
        UserItem.TryGetValue("self_tags", out tags);   
           %>
        <%if(tags!=null){ %>
        <h2>我的标签</h2>
        <div id="my-tags" class="tags">
            <%foreach(var tag in tags.AsBsonArray){ %>
                <a href="<%=baseUrl %>qa/questions.aspx?tag=<%=Server.UrlEncode(tag.AsString) %>"><%=tag.AsString %></a><span class="delete-tag" title="删除标签 - <%=tag.AsString %>">&#10007;</span>
            <%} %>
        </div>
        <h2>添加标签</h2>
        <div title="添加我喜爱的标签">
            <input type="text" value="" class="basic-input" style="width:160px;height:14px;" id="add-tag-name" maxlength="20" placeholder="添加我喜爱的标签" /><br />
            <button type="button" class="btn-submit" style="padding:3px 10px;margin-top:5px;" id="add-tag">添加</button>
        </div>
    <%} %>
    <script>
        function deleteTag(span) {
            if ($('#my-tags>a').length < 2) {
                alert('至少要保留一个标签');
                return;
            }
            $.post('<%=baseUrl %>ascxs/service.aspx', { 'action': 'deletetag', 'tag': span.previousSibling.innerHTML }, function (r) {
                if (r && r.status == 200) {
                    $(span.previousSibling).remove();
                    $(span).remove();
                } else if (r && r.status == 200) {
                    alert('删除标签失败，请稍后重试');
                }
            });
        }
        $(function () {
            $('#my-tags>span').click(function () {deleteTag(this);});
            $('#add-tag').click(function () {
                var tagName = $('#add-tag-name').val();
                if (tagName == '') return;
                var anchors = document.getElementById('my-tags').getElementsByTagName('a');
                for (var i = 0, len = anchors.length; i < len; i++) {
                    if (anchors[i].innerHTML == tagName) {
                        $('#add-tag-name').val('');
                        alert('你已经添加了该标签');
                        return;
                    }
                }
                $.post('<%=baseUrl %>ascxs/service.aspx', { 'action': 'add-tag', 'tag': tagName }, function (r) {
                    if (r && r.status == 200) {
                        $('#my-tags').append('<a onmouseover="showTagSpan(this)" href="questions.aspx?tag=' + tagName + '">' + tagName + '</a><span onclick="deleteTag(this)" class="delete-tag" title="删除标签-' + tagName + '">&#10007;</span>');
                        $('#add-tag-name').val('');
                    }
                });
            });
        });
    </script>
    <%} %>
