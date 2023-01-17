<cfinclude template="../query/get_service_plus.cfm">
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%;">
	<tr class="color-header">
		<td class="form-title">
	  		<a href="javascript://" onclick="gizle_goster_img('orderp_img12','orderp_img22','list_offers_take_menu2');"><img src="/images/listele_down.gif" title="<cf_get_lang no ='1476.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="orderp_img12" style="cursor:pointer;"></a>
	  		<a href="javascript://" onclick="gizle_goster_img('orderp_img12','orderp_img22','list_offers_take_menu2');"><img src="/images/listele.gif" title="<cf_get_lang no ='1477.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="orderp_img22" style="display:none;cursor:pointer;"></a>
			<cfif not listfindnocase(denied_pages,'objects2.popup_add_service_plus')> <!---and isdefined("attributes.type") and attributes.type eq 3 FA ne gerek var anlamadım.--->
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_service_plus&service_id=#attributes.service_id#&plus_type=service</cfoutput>','medium');"><img src="/images/plus_square.gif" border="0"></a>
			</cfif>
	 		<cf_get_lang no='608.Takipler'>
		</td>
	</tr>
  	<tr id="list_offers_take_menu2">
		<td colspan="2" class="color-row">		
			<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
				<cfoutput query="get_service_plus">
	  				<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
						<td>&nbsp;<b>#subject#</b> - #plus_content#</td>
						<td style="width:10px;">
		 				<cfif (len(get_service_plus.update_par) and get_service_plus.update_par eq session.pp.userid) and not len(get_service_plus.update_emp)>
		  					<cfif not listfindnocase(denied_pages,'objects2.popup_upd_service_plus')>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_upd_service_plus&service_id=#attributes.service_id#&service_plus_id=#service_plus_id#&plus_type=service','medium');"><img src="/images/update_list.gif" border="0"></a>
						  	</cfif>
		 				</cfif> 
						</td>
	  				</tr>
				</cfoutput>
			</table>
		</td>
 	 </tr>
</table>
<br/>
