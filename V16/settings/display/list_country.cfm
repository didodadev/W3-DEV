<cfset get_country_list = createObject("component","V16.settings.cfc.setupCountry").getCountry()>

<div style="position:relative;height:250;z-index:88;overflow:auto;">
<table cellpadding="0" cellspacing="0" border="0">
  	<tr>
    	<td class="txtbold" height="20" colspan="2"><cf_get_lang_main no='807.Ülke'></td>
	</tr>
<cfif get_country_list.recordcount>
  <cfoutput query="get_country_list">
  	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_country&c_id=#country_id#" class="tableyazi">#country_name#</a></td>
	</tr>
  </cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
      	<td><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
    </tr>
  </cfif>
</table>
</div>
