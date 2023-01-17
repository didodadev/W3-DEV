<cfinclude template="../query/get_email_assets.cfm">
<table cellspacing="1" cellpadding="2" border="0" class="label" width="100%">
<tr class="color-row"> 
<td valign="top" width="200" align="center"> 
  <table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
	<tr class="color-border"> 
	  <td> 
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
		  <tr class="color-list" height="22"> 
			<td class="txtboldblue" width="170"><cf_get_lang_main no='156.Belgeler'></td>
			<td align="center" class="txtboldblue" width="30"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_form_add_email_asset&email_cont_id=#email_cont_id#</cfoutput>','small');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='156.Belgeler'>" border="0"></a></td>
		  </tr>
		<cfoutput query="get_email_assets">
		  <tr class="color-row">
		  <cfsavecontent variable="message"><cf_get_lang_main no ='1176.Emin misiniz'></cfsavecontent> 
			<td width="170"><a href="javascript://" onClick="windowopen('#file_web_path#campaign/#FILE_NAME#','small');" class="tableyazi">#ASSET_NAME#</a>&nbsp;(#FILE_SIZE# <cf_get_lang no='26.kb'>)</td>
			<td width="30"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_email_asset&asset_id=#asset_id#','small');"><img src="/images/pencilyellow15.gif" width="12" height="12" border="0" alt="<cf_get_lang no='135.Döküman Güncelle'>" title="<cf_get_lang no='135.Döküman Güncelle'>"></a> 
			  <a href="##" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=campaign.popup_del_email_asset&asset_id=#asset_id#','small');"><img src="/images/delete12.gif" width="12" height="12" border="0" alt="<cf_get_lang no='136.Döküman Sil'>" title="<cf_get_lang no='136.Döküman Sil'>"></a></td>
		  </tr>
		 </cfoutput>
		</table>
	  </td>
	</tr>
  </table>
