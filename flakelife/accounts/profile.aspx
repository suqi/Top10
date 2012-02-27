<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="accounts_profile, App_Web_nasjltov" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>我的帐号-<%=ConfigHelper.SiteName %></title>
<link href="../styles/jquery.autocomplete.css" rel="stylesheet" />
<style>
.smleft{float:left;width:100px;}
.smleft a{display:block;text-align:center;font-size:14px;padding:0 10px;}
.smleft a:hover{text-decoration:none;}
.smleft a.current{color:#fff;background-color:#3FA156;}
.smright{float:left;width:700px;margin-left:20px;}
.tdleft{text-align:right;padding-right:20px;width:100px;}
.tdright{text-align:left;width:580px;}
#tbSchool,#tbPwd,#tbAvatar{display:none;}
.school{width:210px;}
.lside{width:130px;text-align:center;}
.rside{width:480px;text-align:left;padding-left:20px;}
</style>
<script src="../scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../scripts/jquery.autocomplete.js"></script>
<script>
    function checkBasic() {
        if ($('#realname').val() == '') {
            $('#lbrealname').html('姓名不能为空');
            return false;
        }
    }
    function checkPwd() {
        var old = $('#old_pwd').val();
        var n = $('#new_pwd').val();
        var cfm = $('#cfm_pwd').val();
        if (old.length < 6 || n.length < 6 || cfm.length < 6) {
            $('#lbpwdTip').html('密码长度至少为六位数');
            return false;
        }
        if (n != cfm) {
            $('#lbpwdTip').html('两次输入密码不一致');
            return false;
        }
    }
    function setSelect(select, value) {
        var opts = select.options;
        for (var x = 0, len = opts.length; x < len; x++) {
            if (opts[x].value == value) {
                opts[x].selected = true;
                break;
            }
        }
    }
    $(function () {
        $('.smleft a[tableid]').click(function () {
            $(this).siblings('.current').removeClass('current');
            $(this).addClass('current');
            $('table').hide();
            $('#' + $(this).attr('tableid')).show();
        });
        //设置家乡
        var province = '<%=CurrentUser["province"].AsString %>';
        var city = '<%=CurrentUser["city"].AsString %>';
        var opts = document.getElementById('userProvince').options;
        for (var i = 1, len = opts.length; i < len; i++) {
            if (opts[i].text == province) {
                opts[i].selected = true;
                showcity(province, document.getElementById('userCity'));
                break;
            }
        }
        var opts2 = document.getElementById('userCity').options;
        for (var j = 1, len2 = opts2.length; j < len2; j++) {
            if (opts2[j].text == city) {
                opts2[j].selected = true;
                break;
            }
        }
        //设置学校
        setSelect(document.getElementById('university'), '<%=CurrentUser["university"].AsString %>');
        $('form.normal').ajaxForm(function (r) {
            if (!r || r.status != 200) {
                alert(r.detail);
                return;
            }
            alert('操作成功');
        });
        $('#formAvatar').ajaxForm(function (r) {
            r = eval('(' + r + ')');
            if (!r || r.status != 200) {
                alert(r.detail);
                return;
            }
            //避免浏览器缓存
            $('#avt').attr('src', '../avatar/' + r.detail + '?t=' + new Date().getMilliseconds());
            alert('操作成功');
        });

    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <%var unis = Util.SchoolUtil.GetUniversities(); %>
<div class="q-head">
    <div id="switcher"><h1>我的帐号</h1></div>
    <div id="tabs">
        <a href="profile.aspx" class="current">个人资料</a>
        <a href="my.aspx">我的提问</a>
        <a href="myanswers.aspx">我的回答</a>
    	<a href="mystars.aspx">我的收藏</a>
    </div>
</div>
<div style="clear:both;"></div>
<div class="smleft">
    <a class="current" href="javascript:;" tableid="tbBasic">个人资料</a>
    <a href="javascript:;" tableid="tbAvatar">头像设置</a>
    <a href="javascript:;"  tableid="tbPwd">修改密码</a>
    <a href="javascript:;" tableid="tbSchool">学校设置</a>
</div>
<div class="smright">
<form id="formBasic" method="post" action="profile.aspx?action=basic" class="normal">
    <table id="tbBasic">
        <tr>
            <td class="tdleft">姓名</td>
            <td class="tdright">
                <input type="text" value="<%=CurrentUser["realname"].AsString %>" name="realname" class="basic-input" id="realname" />
                <span id="lbrealname" class="error"></span>
            </td>
        </tr>
        <tr>
            <td class="tdleft">性别</td>
            <td class="tdright">
                <label><input type="radio" value="男" tabindex="3" name="gender" <%=CurrentUser["gender"].AsString=="男"?"checked": ""%> />男</label>
                <label><input type="radio" value="女" tabindex="3" name="gender" <%=CurrentUser["gender"].AsString=="女"?"checked": ""%>/>女</label>
            </td>
        </tr>
        <tr>
            <td class="tdleft">生日</td>
            <td class="tdright">
                <input type="text" value="<%=CurrentUser["birthday"].AsString %>" class="basic-input Wdate" name="birthday" id="birthday" readonly="readonly" onfocus="WdatePicker({minDate:'1900-01-01',maxDate:'<%=DateTime.Now.AddYears(-15).ToString("yyyy-MM-dd") %>'});" />
            </td>
        </tr>
        <tr>
            <td class="tdleft">家乡</td>
            <td>
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
                <select name="city" id="userCity" style="width:80px;"></select>
            </td>
        </tr>
        <tr><td></td><td class="tdright"><button type="submit" class="btn-submit" onclick="return checkBasic();">确认</button></td></tr>
    </table>
</form>
<form id="formSchool" method="post" action="profile.aspx?action=school"  class="normal">
    <table id="tbSchool">
        <tr>
            <td class="tdleft">入学年份</td>
            <td class="tdright">
                <input type="text" value="<%=CurrentUser["uni_year"].AsString %>" name="uni_year" class="basic-input" id="uni_year" maxlength="4" />
            </td>
        </tr>
        <tr>
            <td class="tdleft">大学</td>
            <td class="tdright">
                <select name="university" class="school" id="university">
                <%foreach(string school in unis){ %>
                    <option value="<%=school %>"><%=school %></option>
                <%} %>
                </select>
            </td>
        </tr>
        <tr><td></td><td class="tdright"><button type="submit" class="btn-submit">确认</button></td></tr>
    </table>
</form>
<form id="formPwd" method="post" action="profile.aspx?action=password"  class="normal">
    <table id="tbPwd">
        <tr>
            <td class="tdleft">当前密码</td>
            <td class="tdright">
                <input type="password" value="" name="old" id="old_pwd" class="basic-input" maxlength="20" autocomplete="off" />
                <span id="lbpwdTip" class="error"></span>
            </td>
        </tr>
        <tr>
            <td class="tdleft">新的密码</td>
            <td class="tdright"><input type="password" value="" name="new" id="new_pwd" class="basic-input" maxlength="20"  autocomplete="off" /></td>
        </tr>
        <tr>
            <td class="tdleft">确认密码</td>
            <td class="tdright"><input type="password" name="cfm" id="cfm_pwd" class="basic-input" maxlength="20"  autocomplete="off" /></td>
        </tr>
        <tr><td></td><td class="tdright"><button type="submit" class="btn-submit" onclick="return checkPwd()">确认</button></td></tr>
    </table>
</form>
<form id="formAvatar" method="post" action="profile.aspx?action=avatar" enctype="multipart/form-data">
    <table id="tbAvatar">
        <tr>
            <td class="lside" rowspan="3" >
            <%if (CurrentUser["avatar"].AsString!=ConfigHelper.DefaultIconName){%>
                <img id="avt" style="width:120px;height:120px;" alt="当前头像" src="<%=ResolveUrl("~/avatar/big/"+CurrentUser["_id"].AsObjectId.ToString()+CurrentUser["avatar"].AsString) %>" />
            <%}else{ %>  
                <img id="avt" style="width:120px;height:120px;" alt="当前头像" src="<%=ResolveUrl(ConfigHelper.AvatarDefaultBig) %>" />
            <%} %>
            </td>
            <td class="rside">
                <h2>强烈建议大家使用真实的头像</h2>
            </td>
        </tr>
        <tr>
            <td class="rside">
                <input type="file" name="avatar" />
            </td>
        </tr>
        <tr><td class="rside"><button type="submit" class="btn-submit">确认</button></td></tr>
    </table>
</form>
</div>
</asp:Content>

