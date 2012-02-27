<%@ page language="C#" autoeventwireup="true" inherits="qa_editanswer, App_Web_wdpwwatm" validaterequest="false" %>
<%@ Import Namespace="MongoDB.Bson" %>
<%@ Import Namespace="MongoDB.Driver" %>
<!DOCTYPE html>
<html>
<head><title></title>
<script src="../scripts/jquery-1.5.1.min.js"></script>
<%
    var answerid = BsonObjectId.Create(Request.QueryString["id"]);
    string error="</head><div style='color:Red;font-weight:bold;font-size:13px;text-align:center;'>回答不存在或者已经被删除</div></body></html>";
    if (answerid == null)
    {
        Response.Write(error);
        Response.End();
    }
    var answer = DAL.DAL.FindOneById(BLL.CollectionInfo.AnswerCollectionName, answerid);
    if (answer == null)
    {
        Response.Write(error);
        Response.End();
    }
    //没有限制修改时间
     %>
<link type="text/css" href="../styles/site.css" rel="Stylesheet" />
<script src="../scripts/jquery.form-2.67.js"></script>
<script src="../scripts/editor/kindeditor-min.js"></script>
<script>
    KE.show({
        id: 'content',
        resizeMode: 0,
        allowPreviewEmoticons: false,
        allowUpload: false,
        items: ['bold', 'italic', 'underline', 'strikethrough', 'removeformat', '|', 'insertorderedlist', 'insertunorderedlist', '|',
				 'textcolor', 'bgcolor', 'fontname', 'fontsize', '|', 'link', 'unlink', 'emoticons', 'code', '|', 'image', 'selectall', 'source', 'about']
    });
    $(function () {
        $('#btn-submit').click(function () {
            KE.sync('content');
            if ($('#content').val().length < 10) {
                $('#error').html('回答内容不能少于10个字');
                return false;
            }
        });
        $("#form1").ajaxStart(function () {
            $('#btn-submit').val('正在保存...');
            $('#btn-submit').attr('disabled', true);
        });
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                $('#error').html('修改回答内容成功，等待跳转...').css('color', 'Green');
                setTimeout('window.parent.location.reload()', 300);
            } else {
                $('#btn-submit').html('保存修改').removeAttr('disabled');
            }
        });
    });
</script>
</head>
<body>
<div>
<h2>修改回答内容</h2>
<div class="line"></div>
<form id="form1" method="post" action="../ascxs/service.aspx?action=editanswer&answerid=<%=answerid %>">
    <textarea id="content" name="content" style="width:100%;height:200px;" class="basic-input"><%=answer["content"].AsString.Replace("<script", "").Replace("script>", "")%></textarea>
    <p><button id="btn-submit" type="submit" class="btn-submit" style="margin-top:15px;">保存修改</button><span id="error" class="error"></span></p>
</form>
</div>
</body>
</html>
