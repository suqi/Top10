<%@ page title="" language="C#" masterpagefile="~/Site.master" autoeventwireup="true" inherits="Accounts_Login, App_Web_nasjltov" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<title>登录-<%=ConfigHelper.SiteName %></title>
<style>
.aside div{margin-top:10px;} 
.aside a{margin-left:5px;}
.aside .hot{margin-left:10px;color:Red;}
label{display:inline-block;float: left;font-size: 14px;line-height: 30px;margin-right: 15px;text-align: right;vertical-align: baseline;width: 60px;font-family: Tahoma;vertical-align: middle;}
label.remember{color:#666;cursor: pointer;display: inline;float: none;font-size: 12px;margin: 0;text-align: left;width: auto;}
.item{margin:15px 0;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1>登录<%=ConfigHelper.SiteName %></h1>
    <div class="article">
        <form action="login.aspx" id="form1" method="post">
            <div class="item">
                <label for="email">邮箱</label>
                <input type="email" tabindex="1" maxlength="40" class="basic-input" name="email" id="email" autofocus />
                <span id="lbemail" class="error"></span>
            </div>
            <div class="item">
                <label for="password">密码</label>
                <input type="password" tabindex="2" maxlength="20" class="basic-input" name="password" id="password" />
                <span id="lbpwd" class="error"></span>
            </div>
            <div class="item">
                <label>&nbsp;</label>
                <input type="checkbox" tabindex="3" name="remember" id="remember" value="1" />
                <label class="remember" for="remember" title="请不要在公用电脑上勾选此项">自动登录</label>
            </div>
            <div class="item">
                <label>&nbsp;</label>
                <input type="submit" id="btn_login" class="btn-submit" value="登录" />
            </div>
        </form>
    </div>
    <div class="aside">
        还没有帐号？开始<a href="register.aspx">注册</a>
<%--        <div>●<a href="register.aspx">我（曾经）是学生</a><b class="hot">Hot!</b></div>
        <div>●<a href="regdoc.aspx?identity=professor">我是大学教授</a></div>
        <div>●<a href="regdoc.aspx?identity=advertise">我是商家，我要推广</a></div>--%>
    </div>
    <div class="error" id="error"></div>
<script>
    $(function () {
        $('#btn_login').click(function () {
            var canSubmit = true;
            if ($('#email').val() == '') {
                $('#lbemail').html('请输入邮箱');
                canSubmit = false;
            }
            if ($('#password').val() == '') {
                $('#lbpwd').html('请输入密码');
                canSubmit = false;
            }
            return canSubmit;
        }); 
        $('#form1').ajaxForm(function (r) {
            if (r && r.status == 200) {
                if (r.auto) {
                    $.cookie('uid', r.uid, { path: '/', domain: '<%=ConfigHelper.CookieDomain %>',expires: new Date( <%=(DateTime.Now.Year+1 )%>, 1, 1 )});
                    $.cookie('token', r.token, { path: '/', domain: '<%=ConfigHelper.CookieDomain %>' ,expires: new Date( <%=(DateTime.Now.Year+1 )%>, 1, 1 )});
                } else {
                    $.cookie('uid', r.uid, { path: '/' });
                    $.cookie('token', r.token, { path: '/' });
                }
                window.location.href ='<%=string.IsNullOrEmpty(Request.QueryString["goto"])?"../qa/questions.aspx":ResolveUrl("~/"+Request.QueryString["goto"]) %>';
            } else {
                $('#lbemail').html(r.detail);
            }
        });
    });
</script></asp:Content>