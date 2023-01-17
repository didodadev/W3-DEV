<cfquery name="SCHOOL_PARTS" datasource="#DSN#">
	SELECT
       *
	FROM
		SETUP_SCHOOL_PART
	ORDER BY
		PART_NAME
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='961.Universite Bolumleri'></td>
	</tr>
<cfif school_parts.recordcount>
  <cfoutput query="school_parts">
  	<tr>
  		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_school_part&id=#part_id#" class="tableyazi">#part_name#</a></td>
  	</tr>
  </cfoutput>
<cfelse>
 	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    	<td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	</tr>
</cfif>
</table>
