<script type="text/javascript">
	document.getElementById('security_capcha_code').style.display = '';
</script>
<table>
    <tr>
        <td></td>
        <td><cf_wrk_captcha name="captcha" action="display" refresh="1" refresh_func="AjaxPageLoad('#request.self#?fuseaction=objects2.security_capcha_page','security_capcha_code');"></td>
    </tr>
</table>
