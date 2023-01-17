<cfset get_inspection_type_list = createObject("component","V16.settings.cfc.setupInspectionTypes").getInspectionTypes()>

<div style="position:relative;height:250;z-index:88;overflow:auto;">
<table cellpadding="0" cellspacing="0" border="0">
  	<tr>
    	<td class="txtbold" height="20" colspan="2"><cf_get_lang no='128.Muayene Tipi'></td>
	</tr>
<cfif get_inspection_type_list.recordcount>
  <cfoutput query="get_inspection_type_list">
  	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_inspection_type&inspection_type_id=#inspection_type_id#" class="tableyazi">#inspection_type#</a></td>
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
