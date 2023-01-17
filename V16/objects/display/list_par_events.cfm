<cfinclude template="../query/get_par.cfm">
<cfinclude template="../query/get_par_events.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#par_events.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#get_par.member_code# #get_par.company_partner_name# #get_par.company_partner_surname#" uidrop="1" popup_box="#iif(isdefined('attributes.draggable'),1,0)#">
	
	<cf_box_elements>
		<table width="98%" height="35" cellpadding="0" cellspacing="0" border="0" align="center">
			<tr> 
			  <td  style="text-align:right;" ><cfoutput>#dateformat(start_date_par,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</cfoutput>&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='32912.h:hedef'>,<cf_get_lang dictionary_id='32913.g:gerçek'></td>
			  
			</tr>
	  </table>
	</cf_box_elements>
	<cf_grid_list>
		<thead>
			<tr>
			<th height="22" class="form-title" width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th class="form-title" width="120"><cf_get_lang dictionary_id='57446.kampanya'></th>
			<th class="form-title" width="120"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
			<th class="form-title" width="120"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="par_events" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="25">#currentrow#</td>
					<td>
						<cfif type is "Ajanda">
							<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#id#';self.close();" class="tableyazi">#type# - #name#</a>
						<cfelseif type is "SERVİS Görevi">
							<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=service.upd_service&service_id=#id#';self.close();" class="tableyazi">#type# - #name#</a>
						<cfelseif type is "SERVİS">
							<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=service.upd_service&service_id=#id#';self.close();" class="tableyazi">#type# - #name#</a>
						<cfelseif type is "Proje">
							<a href="#request.self#?fuseaction=project.works&event=det&ID=#id#" class="tableyazi">#type# - #name#</a>
						</cfif>
					</td>
					<td>h-#dateformat(target_start,dateformat_style)#<cfif len(real_start)>&nbsp;g-#dateformat(real_start,dateformat_style)#</cfif></td>
					<td>h-#dateformat(target_finish,dateformat_style)#<cfif len(real_finish)>&nbsp;g-#dateformat(real_finish,dateformat_style)#</cfif></td>
				</tr>
			</cfoutput>
			<cfif not par_events.recordcount>
				<tr class="color-row">
					<td colspan="4"> <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
			<cfif par_events.recordcount and (attributes.totalrecords gt attributes.maxrows)>
				<tr>
					<td colspan="4">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr> 
							<td height="2" align="left">
							<cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_emp_events&start_date_par=#start_date_par#&finishdate=#finishdate#&par_id=#par_id#">
							</td>
						<!-- sil --><td width="275" height="2"  style="text-align:right;"><P class="label"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></P></td><!-- sil -->
						</tr>
					</table>
					</td>
				</tr>
				</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>


