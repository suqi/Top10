<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_register, App_Web_nasjltov" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>注册-<%=ConfigHelper.SiteName %></title>
<style>
label {display: inline-block;float: left;font-size: 14px;line-height: 30px;margin-right: 15px;text-align: right;vertical-align: baseline;width: 100px;font-family: Tahoma;vertical-align: middle;}
.item {margin: 15px 0;}
.item span{margin-right:30px;display:inline-block;margin-top:5px;}
.add_uni{margin-left:10px;}
.school{width:210px;margin-top:5px;}
#s2{display:none;}
</style>
<script src="../scripts/My97DatePicker/WdatePicker.js"></script>
<script>
function delBs() {
    $('#bs_uni').hide();
    $('#bs_year').val('');
    $('#bs_school').val('');
}
function delYjs() {
    delBs();
    $('#yjs_uni').hide();
    $('#yjs_year').val('');
    $('#yjs_school').val('');
}
function checkEmail(input) {
    if (input.value == '') {
        $('#lbemail').html('邮箱不能为空');
        return;
    }
    if (input.value.indexOf('@') < 1 || input.value.indexOf('.') < 1) {
        $('#lbemail').html('邮箱格式错误');
        input.select();
        input.focus();
        return;
    }
    $.post('../service/unauth.aspx', { 'action': 'checkEmail', 'email': input.value }, function (r) {
        var legal = r == '200';
        $('#lbemail').html(legal ? '' : '邮箱已经被注册，请更换');
        if (!legal) {
            input.select();
            input.focus();
        }
    });
}
function checkForm() {
    var canSubmit = true;
    if ($('#email').val() == '') {
        $('#lbemail').html('邮箱不能为空');
        canSubmit = false;
    }
    var pwd = $('#password').val();
    if (pwd == '' || pwd.length < 6) {
        $('#lbpassword').html('密码长度不能小于六位');
        canSubmit = false;
    }
    if ($('#realname').val() == '') {
        $('#lbrealname').html('姓名不能为空');
        canSubmit = false;
    }
    if ($('#invitecode').val() == '') {
        $('#lbcode').html('邀请码不能为空');
        canSubmit = false;
    }
    if ($('#birthday').val() == '') {
        $('#lbsr').html('生日不能为空');
        canSubmit = false;
    }
    var city = $('#userCity').val()
    if ( city== ''||city==null) {
        $('#lbjx').html('请选择你的家乡');
        canSubmit = false;
    }
    if ($('#uni_year').val() == '') {
        $('#lbdxrs').html('大学入学年份不能为空');
        canSubmit = false;
    }
    if ($('#uni_year').val() == '') {
        $('#lbdxrs').html('大学入学年份不能为空');
        canSubmit = false;
    }
    if ($('#university').val() == '') {
        $('#lbdxmc').html('请选择你的大学');
        canSubmit = false;
    }
    if($('#self_tags').val()==''){
        $('#tag-tip').html('至少输入一个标签').addClass('error');
        canSubmit = false;
    }
    return canSubmit;
}
$(function () {
    $('#btn_sub').click(function () {
        var canSubmit = true;
        if ($('#email').val() == '') {
            $('#lbemail').html('邮箱不能为空');
            canSubmit = false;
        }
        var pwd = $('#password').val();
        if (pwd == '' || pwd.length < 6) {
            $('#lbpassword').html('密码长度不能小于六位');
            canSubmit = false;
        }
        if ($('#realname').val() == '') {
            $('#lbrealname').html('姓名不能为空');
            canSubmit = false;
        }
        var inviteCode = $('#code').val();
        if (inviteCode == '') {
            $('#lbcode').html('邀请码不能为空');
            canSubmit = false;
        } else { 
            if('<%=ConfigHelper.InviteCode %>'.indexOf(inviteCode)<0){
                $('#lbcode').html('邀请码不正确');
                canSubmit = false;
            }
        }
        if (canSubmit) {
            $('#s1').hide();
            $('#s2').show();
        }
    });
    $('#form1').ajaxForm(function (r) {
        if (r && r.status == 200) {
            $.cookie('uid', r.uid, { path: '/' });
            $.cookie('token', r.token, { path: '/' });
            window.location.href = "recommend.aspx";
        } else if (r && r.status != 200) {
            alert(r.detail);
        }
    });
});
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<%var unis = Util.SchoolUtil.GetUniversities(); %>
<h1>欢迎加入<%=ConfigHelper.SiteName %></h1>
<form id="form1" method="post" action="register.aspx">
<div class="article">
<div id="s1">
    <h2>第一步：填写账号信息</h2>
    <div class="item">
        <label>邮箱</label>
        <input type="email" value="" tabindex="1" maxlength="40" class="basic-input" name="email" id="email" onblur="checkEmail(this);" autofocus />
        <span id="lbemail" class="error"></span>
    </div>
    <div class="item">
        <label>密码</label>
        <input type="password" maxlength="20" tabindex="2" class="basic-input" name="password" id="password" />
        <span id="lbpassword" class="error"></span>
    </div>
    <div class="item">
        <label>姓名</label>
        <input type="text" value="" tabindex="3" maxlength="4" class="basic-input" name="realname" id="realname" />
        <span id="lbrealname" class="error"></span>
    </div>
    <div class="item">
        <label>性别</label>
        <span><input type="radio" value="男" tabindex="3" name="gender" checked="checked" />男</span>
        <span><input type="radio" value="女" tabindex="3" name="gender" />女</span>
    </div>
    <div class="item" style="display:none;">
        <label>邀请码</label>
        <input type="text" value="2011whu" id="code" name="code"class="basic-input" /><span id="lbcode" class="error"> </span>
    </div>
    <div class="item">
        <label>&nbsp;</label>
        <input type="button" value="下一步" class="btn-submit" id="btn_sub" />
    </div>
</div>
<div id="s2">
    <h2>第二步：完善个人资料，找到你身边的朋友</h2>
    <div class="item">
        <label>生日</label>
        <input type="text" value="" class="basic-input Wdate" name="birthday" id="birthday" readonly="readonly" onfocus="WdatePicker({minDate:'1900-01-01',maxDate:'<%=DateTime.Now.AddYears(-15).ToString("yyyy-MM-dd") %>'});" />
        <span id="lbsr" class="error"></span>
    </div>
    <div class="item">
        <label>家乡</label>
        <select onchange="showcity(this.value, document.getElementById('userCity'));" name="province" id="userProvince">
            <option value="">--请选择省份--</option><option value="北京">北京</option><option value="上海">上海</option>
            <option value="广东">广东</option><option value="江苏">江苏</option>
            <option value="浙江">浙江</option><option value="重庆">重庆</option><option value="安徽">安徽</option>
            <option value="福建">福建</option><option value="甘肃">甘肃</option><option value="广西">广西</option><option value="贵州">贵州</option>
            <option value="海南">海南</option><option value="河北">河北</option>
            <option value="黑龙江">黑龙江</option><option value="河南">河南</option><option value="湖北">湖北</option><option value="湖南">湖南</option>
            <option value="江西">江西</option><option value="吉林">吉林</option><option value="辽宁">辽宁</option><option value="内蒙古">内蒙古</option>
            <option value="宁夏">宁夏</option><option value="青海">青海</option><option value="山东">山东</option><option value="山西">山西</option>
            <option value="陕西">陕西</option><option value="四川">四川</option><option value="天津">天津</option><option value="新疆">新疆</option>
            <option value="西藏">西藏</option><option value="云南">云南</option><option value="香港">香港特别行政区</option>
            <option value="澳门">澳门特别行政区</option><option value="台湾">台湾</option><option value="海外">海外</option>
        </select>
        <select name="city" id="userCity" style="width:80px;"></select><span id="lbjx" class="error"></span>
    </div>
    <div class="item">
        <label>大学入学年份</label>
        <input type="text" value="" class="basic-input year" name="uni_year" id="uni_year" title="入学年份" maxlength="4"/><span id="lbdxrs" class="error"></span>
    </div>
    <div class="item">
        <label>大学</label>
        <select name="university" class="school" id="university">
        <%foreach(string school in unis){ %>
            <option value="<%=school %>"><%=school %></option>
        <%} %>
        </select>
    </div>
    <div class="item">
        <label>标签</label>
        <input autocomplete="off" type="text" value="" tabindex="3"  class="basic-input" name="self_tags" id="self_tags" title="多个标签按空格隔开" /><b class="ignore" style="margin-left:10px;" id="tag-tip">多个标签按空格隔开</b>
    </div>
    <div class="item" style="margin-top:5px;">
        <label>&nbsp;</label>
        <b>什么是标签？</b><a style="margin-left:10px;" href="../qa/tags.aspx" target="_blank">查看热门标签</a>
        <div>标签是你感兴趣的东西，给自己加上标签之后，方便其他爱好相同的朋友找到你。</div>
    </div>
    <div class="item">
        <label>&nbsp;</label>
        <input type="submit" id="btn_submit" value="完成注册" class="btn-submit" onclick="return checkForm();" />
    </div>
</div>
</div>
</form>
<div class="aside">
    <p class="pl">已经拥有帐号? <a href="login.aspx?identity=<%=Request.QueryString["identity"] %>">直接登录</a></p>
</div>
</asp:Content>

