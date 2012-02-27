<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="qa_ask, App_Web_wdpwwatm" validaterequest="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <title>提问-<%=ConfigHelper.SiteName %></title>
<style>
h2,label{color: #060;font: 14px/150% Arial,Helvetica,sans-serif;margin: 0 0 12px;}
.item{margin-bottom:5px;}
.side-help{background-color: #E9F4E9;border-radius: 5px 5px 5px 5px;color: #735005;padding-top: 8px;padding-left:12px;display:none;}
#question-suggestions{color: #333;display:none;font-size: 115%;font-weight:bold;padding-bottom: 3px;}
.item label{font-weight:bold;}
h4{font-size: 130%;color:#AE0000;line-height: 1.4;padding-bottom: 7px;}
label.anonylabel{margin-right:20px;color:#000;font-weight:normal;}
.delete-tag{margin-left:5px;margin-right:10px;display:inline;}
</style>
<script src="../scripts/editor/kindeditor-min.js"></script>
<script>
    function checkForm() {
        var error = [];
        var title = $('#title').val();
        if (title.length < 10 || title.length > 50) {
            error.push('●标题的长度应该在10至50之间');
        }
        var html = KE.html('content');
        KE.sync('content');
        var content = $('#content').val();
        if (content.length<1) {
            error.push('●请描述你的问题');
        }
        var tags = $('#tags').val();
        if (tags == '') {
            error.push('●每个问题最少设置一个标签');
        } else {
            var arr = tags.split(' ');
            if (arr.length < 1 || arr.length > 5) {
                error.push('●标签的长度应该在1至5之间');
            }
        }
        if ($('div.item input:checked').length == 0) {
            error.push('●选择是否匿名提问');
        }
        if (error.length > 0) {
            $('#error-summary').html(error.join('<br/>'));
            return false;
        }
    }
    //过滤重复标签并全部转化为小写
    function filterArray(arr) {
        var a = [],o = {},i,v,len = arr.length;
        if (len < 2) {
            arr[0] = arr[0].toLocaleLowerCase()
            return arr;
        }
        for (i = 0; i < len; i++) {
            v = arr[i].toLocaleLowerCase();
            if (o[v] !== 1&&v!='') {
                a.push(v);
                o[v] = 1;
            }
        }
        return a;
    } 
    //移除标签，同步文本框和标签列表
    function removeTag(img,tag) {
        var val = $('#tags').val();
        $(img.previousSibling).remove();
        $(img).remove();
        $('#tags').val(val.replace(tag + ' ', '').replace(tag, ''));
    }
    //文本框失去焦点时设置标签列表和文本框
    function initTags(input) {
        var val = input.value;
        if (val != '') {
            if (window.localStorage)
                window.localStorage['tags'] = val;
            var arr = filterArray(val.split(' '));
            var html = [];
            for (var i = 0; i < arr.length; i++) {
                html.push('<a target="_blank" href="questions.aspx?tag=');
                html.push(arr[i].toLocaleLowerCase());
                html.push('">');
                html.push(arr[i].toLocaleLowerCase());
                html.push('</a><span title="删除此标签" class="delete-tag" src="" onclick="removeTag(this,\'' + arr[i] + '\')">&#10007;</span>');
            }
            $(input).val(arr.join(' '));
            $('#input-tags').html(html.join(''));
        }
    }
    KE.show({
        id: 'content',
        afterBlur: function (id) {
            if (window.localStorage)
                localStorage['content'] = KE.html('content');
        },
        afterCreate: function () {
            if (window.localStorage)
                KE.html('content', window.localStorage['content']);
        },
        resizeMode: 1,
        allowPreviewEmoticons: false,
        allowUpload: false,
        items: ['bold', 'italic', 'underline', 'strikethrough', 'removeformat', '|', 'insertorderedlist', 'insertunorderedlist', '|',
				 'textcolor', 'bgcolor', 'fontname', 'fontsize', '|', 'link', 'unlink', 'emoticons', 'code', '|', 'image', 'selectall', 'source', 'about']
    });
    $(function () {
        if (window.localStorage) {
            $('#title').val(window.localStorage['title']);
            if (window.localStorage['tags']) {
                var tag = document.getElementById('tags');
                $(tag).val(window.localStorage['tags']);
                initTags(tag);
            }
        }
        $('#title').focus(function () {
            $('.side-help').hide();
            $('#how-to-title').show();
        }).blur(function () {
            var val = $(this).val();
            if (val != '') {
                if (window.localStorage)
                    window.localStorage['title'] = val;
            }
        });
        $('#tags').focus(function () {
            $('.side-help').hide();
            $('#how-to-tags').show();
        }).blur(function (e) {
            initTags(this);
        });
        $("#form1").ajaxStart(function () {
            $('#btn-sub').val('正在提交...');
            $('#btn-sub').attr('disabled', true);
        });
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                if (window.localStorage) {
                    localStorage.removeItem("title");
                    localStorage.removeItem("tags");
                    localStorage.removeItem("content");
                }
                window.location.href = 'question.aspx?id=' + r.detail;
            }
            else {
                $('#btn-sub').html('提交问题').removeAttr('disabled');
                $('#error-summary').html(r.detail);
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="mleft">
    <a href="questions.aspx" id="nav-questions"  title="查看所有提问">问题</a>
    <a href="tags.aspx" id="nav-tags">标签</a>
    <a href="unsolved.aspx">未解决</a>
    <a href="solved.aspx">已解决</a>
    <a id="nav-askquestion" class="youarehere" style="cursor:text;">提问</a>
</div>
<div class="mright" title="按标签在所有问题中搜索">
    <form action="questions.aspx" method="get" name="ssform" target="_blank">
        <input type="text" maxlength="30" name="tag" class="s-text" value="" placeholder="按标签在所有问题中搜索" />
        <a href="javascript:;" onclick="this.parentNode.submit();">搜索问题</a>
    </form>
</div>
<div style="clear:both;height:20px;"></div>
<div class="article">
<form action="ask.aspx" method="post" id="form1">
    <div class="item"><label for="title">标题</label><span id="lbtitle" class="error"></span></div>
    <div class="item"><input id="title" name="title" type="text" value="" class="basic-input" style="width:100%;" maxlength="50" autocomplete="off" autofocus /></div>
    <div id="question-suggestions">
        <label style="font-weight:bold;">类似的问题</label>
        <div style="height:150px; overflow-y:scroll; overflow-x:clip;"></div>
    </div>
    <div class="item"><label for="content">描述问题</label><span id="lbcontent" class="error"></span></div>
    <div class="item">
        <textarea id="content" name="content" style="width:100%;height:200px;" class="basic-input"></textarea>
    </div>
    <div class="item"><label for="tags">标签</label><span id="lbtags" class="error"></span></div>
    <div class="item"><input id="tags" name="tags" type="text" value="" class="basic-input" style="width:100%;"  title="多个标签用空格隔开" placeholder="多个标签用空格隔开" autocomplete="off" /></div>
    <div class="item tags" id="input-tags"></div>
    <div class="item" title="匿名提问可以隐藏你的个人信息"><label>匿名提问</label></div>
    <div class="item" title="匿名提问可以隐藏你的个人信息"><label class="anonylabel"><input type="radio" value="0" name="anony" />否</label> <label class="anonylabel"><input type="radio" value="1" name="anony" />是</label></div>
    <div class="item error" id="error-summary"></div>
    <div class="item" style="margin-top:20px;"><button id="btn-sub" class="btn-submit" type="submit" onclick="return checkForm();">提交问题</button></div>
</form>
</div>
<div class="aside">
    <div id="how-to-title" class="side-help" style="display:block;">
        <h4>提问的艺术</h4>
        <p>●不要发表讨论过很多次的问题</p>
        <p>●问题要有明确的答案</p>
        <p>●与本站有关的问题，请到<a href="question.aspx?id=4e2244752583580f6ce8b162" class="anchor">这里</a>来</p>
    </div>
    <div id="how-to-tags"class="side-help">
        <h4>神奇的标签</h4>
        <p>●标签用于将问题分类，让问题的重点更清晰</p>
        <p>●我们会按你常用的标签为你推荐一些精彩的内容</p>
    </div>
</div>
</asp:Content>

