<cfquery name="ZONES" datasource="#dsn#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='158.Bölgeler'></td>
  </tr>
  <cfif zones.recordcount>
	<cfoutput query="zones">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <cfif isdefined("attributes.hr")>
	<td><a href="#request.self#?fuseaction=hr.form_upd_company_zone&ID=#zone_ID#&hr=1" class="tableyazi">#zone_name#</a></td>
	<cfelse>
	<td><a href="#request.self#?fuseaction=settings.form_upd_zone&ID=#zone_ID#" class="tableyazi">#zone_name#</a></td>
	</cfif>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>



