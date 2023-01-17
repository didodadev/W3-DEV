<cfquery name="GET_USER" datasource="#DSN#">
	SELECT 
		GROUP_ID,
		GROUP_NAME 
	FROM 
		USERS
	WHERE
	<cfif isdefined("session.ep.userid")>
		RECORD_MEMBER = #session.ep.userid#
	<cfelse>
		RECORD_MEMBER = #session.pp.userid#
	</cfif> 
	    OR TO_ALL = 1
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2"><cf_get_lang dictionary_id='42143.Gruplar'></td>
	</tr>
<cfif get_user.recordcount>
  <cfoutput query="get_user">
	<tr>
    	<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
	<cfif not isdefined("attributes.process")>
    	<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_users&group_id=#group_id#" clasS="tableyazi">#group_name#</a></td>
   	<cfelse>
		<td width="380"><a href="#request.self#?fuseaction=settings.popup_upd_users&group_id=#group_id#&process=sett" clasS="tableyazi">#group_name#</a></td>
	</cfif>
	</tr>
  </cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
	    <td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</font></td>
	</tr>
</cfif>
</table>
