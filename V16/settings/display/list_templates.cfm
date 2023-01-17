<cfinclude template="../query/get_templates.cfm">

<table cellpadding="0" cellspacing="0" border="0" style="width:135px;">
  	<tr style="height:20px;"> 
    	<td class="txtbold" colspan="2">&nbsp;&nbsp;<cf_get_lang no='166.Belge Şablonları'></td>
  	</tr>
	<cfif templates.RecordCount>
		<cfoutput query="templates">
  			<tr>
    			<td align="right" style="text-align:right; width:20px; vertical-align:baseline"><img src="/images/tree_1.gif" width="13"></td>
      			<td style="width:115px;"><a href="#request.self#?fuseaction=settings.form_upd_del_template&id=#template_id#" class="tableyazi">#template_head#</a></td>
  			</tr>
  		</cfoutput>
	<cfelse>
 		<tr>
    		<td align="right" style="text-align:right; vertical-align:baseline; width:20px;"><img src="/images/tree_1.gif" width="13"></td>
    		<td style="width:115px;"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  		</tr>
 	</cfif>
</table>

