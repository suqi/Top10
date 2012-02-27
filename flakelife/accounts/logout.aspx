<%@ page language="C#" autoeventwireup="true" inherits="accounts_logout, App_Web_nasjltov" %>
<!DOCTYPE html>
<html>
<head>
<script src="../scripts/jquery-1.5.1.min.js"></script>
<script src="../scripts/common.js"></script>
</head>
<body>
<script>
    $(function () {
        $.cookie('uid', null, { path: '/', domain: '<%=ConfigHelper.CookieDomain %>' });
        $.cookie('token', null, { path: '/', domain: '<%=ConfigHelper.CookieDomain %>' });
//        $.cookie('uid', null, { path: '/'});
//        $.cookie('token', null, { path: '/'});
        window.location.href = 'login.aspx';
    });
</script>
</body>
</html>
