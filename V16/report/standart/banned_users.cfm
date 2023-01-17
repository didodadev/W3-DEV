<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.delete_username") and len(attributes.delete_username)>
    	<cfquery name="DELETE_USERNAME" datasource="#dsn#">
        	DELETE FROM FAILED_LOGINS WHERE USER_NAME = '#attributes.delete_username#'
        </cfquery>
    </cfif>
</cfif>
<cfquery name="GET_FAILED_LOGINS" datasource="#dsn#">
    SELECT
        USER_NAME,
        USER_IP,
        LOGIN_DATE
    FROM
        FAILED_LOGINS
    ORDER BY
        USER_NAME
</cfquery>
<table class="big_list">
	<thead>
        <tr>
            <th width="33%"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
			<th width="33%"><cf_get_lang dictionary_id='29921.Kullanıcı IP'></th>
			<th width="33%"><cf_get_lang dictionary_id='55493.Son Giriş Tarihi'></th>
        </tr>
    </thead>
    <tbody>
        <cfform name="show_list" action="#request.self#?fuseaction=report.detail_report&event=det&report_id=#url.report_id#" method="post">
            <cfinput type="hidden" name="is_form_submitted" value="0">
            <cfinput type="hidden" name="delete_username" value="">
            <cfoutput query="GET_FAILED_LOGINS" group="USER_NAME">
                <tr>
                    <td colspan="2"><a href="javascript://" onclick="goster_tr('#USER_NAME#')" class="tableyazi">#USER_NAME#</a></td>
                    <td><a href="javascript://" onclick="delete_bans('#USER_NAME#')" class="tableyazi"><cf_get_lang dictionary_id='60652.Ban Aç'></a></td>
                </tr>
                <tr id="#USER_NAME#" style="display:none;">
                    <td colspan="3">
                        <table width="100%" cellspacing="2" cellpadding="0" border="0" class="no-hover">
                            <cfoutput>
                                <tr>
                                    <td width="33%">#USER_NAME#</td>
                                    <td width="33%">#USER_IP#</td>
                                    <td width="33%">#LOGIN_DATE#</td>
                                </tr>
                            </cfoutput> 
                        </table>
                    </td> 
                </tr>
            </cfoutput>
        </cfform>
    </tbody>
</table>
<script type="text/javascript">
function goster_tr(tr_id)
{
	if(document.getElementById(tr_id).style.display == 'none')
		document.getElementById(tr_id).style.display = 'block';
	else
		document.getElementById(tr_id).style.display = 'none';
}
function delete_bans(user_name)
{
	document.getElementById('delete_username').value = user_name;
	document.show_list.submit();
}
</script>
