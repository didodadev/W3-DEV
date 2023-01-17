<!--- Sosyal Medya Kategorileri Listeleme --->
<cfquery name="smc" datasource="#dsn#">
	SELECT SMCAT_ID,SMCAT FROM SETUP_SOCIAL_MEDIA_CAT
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <cfif smc.recordcount>
	<cfoutput query="smc">
  	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
      	<td>&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_social_media_cat&ID=#SMCAT_ID#" >#SMCAT#</a></td>
  	</tr>
  	</cfoutput>
  <cfelse>
  <tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    	<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
  </tr>
  </cfif>
</table>
