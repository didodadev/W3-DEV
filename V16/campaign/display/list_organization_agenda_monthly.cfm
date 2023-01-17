<cfset tarih_bugun=dateformat(now(),"yyyy-mm-dd")>
<style>
	.border-bottom-transparent{
		border-bottom:1px solid transparent!important;
	}
</style>
<cf_grid_list>
	<thead>
		<tr>
			<th width="15%"><cf_get_lang dictionary_id='57604.Pazartesi'></th>
			<th width="15%"><cf_get_lang dictionary_id='57605.Salı'></th>
			<th width="15%"><cf_get_lang dictionary_id='57606.Çarşamba'></th>
			<th width="15%"><cf_get_lang dictionary_id='57607.Perşembe'></th>
			<th width="15%"><cf_get_lang dictionary_id='57608.Cuma'></th>
			<th width="15%"><cf_get_lang dictionary_id='57609.Cumartesi'></th>
			<th><cf_get_lang dictionary_id='57610.Pazar'></th>
		</tr>
	</thead>
	<tbody>
	<cfset sayac =0>
	<tr>
        <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
            <td class="border-bottom-transparent">&nbsp;</td>
        </cfloop>
        <cfloop index="x" from="#bas#" to="7">
            <td class="txtbold border-bottom-transparent"><cfoutput>#gun#</cfoutput></td>
            <cfset gun = gun +1>
            <cfset sayac = sayac +1>
        </cfloop>
	</tr>
	<cfset gun = gun - sayac>
	<tr class="color-row">
        <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
            <td>&nbsp;</td>
        </cfloop>
	<cfset gun=0>
    <cfloop index="x" from="#bas#" to="7">
		<cfset gun = gun + 1>
		<cfoutput>
		<td valign="top" class="label">
			<cfset attributes.to_day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
			<cfset compare_tarih="#yil#-#numberformat(ay,'00')#-#numberformat(gun,'00')#">
			<cfset attributes.tarih_egitim = '#yil#-#ay#-#gun#'>
			<cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >
			<cfinclude  template="../query/get_todays_organizations.cfm">
                <cfloop query="get_tr">
                    <cfif NOT LEN(get_tr.FINISH_DATE[currentrow]) and NOT LEN(get_tr.START_DATE[currentrow])>
                        <cfset color_="000000">
                    <cfelse>
                        <cfset compare_tarih=dateformat(get_tr.FINISH_DATE[currentrow],"yyyy-mm-dd")>
                        <cfset start_tarih=dateformat(get_tr.START_DATE[currentrow],"yyyy-mm-dd")>
                        
                        <cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
                            <cfset color_="FF0000">
                        <cfelse>
                            <cfset color_="FF00FF">
                        </cfif>
                    </cfif>
                    <cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
                        <cfif is_project_current eq 1>
                            <cfif len(company_id) and len(company_id_list)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_partner_detail.nickname[listfind(company_id_list,partner_id,',')]#</a>-
                            <cfelseif len(consumer_id) and len(consumer_id_list)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
                            </cfif>
                        </cfif>
                        <a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#get_tr.organization_id#" ><font color="#color_#">#get_tr.organization_head# </font></a> 
                        <cfif compare_tarih eq start_tarih >
                            <img src="/images/starton.gif" border="0" alt="<cf_get_lang_main no='1055.Start'>"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle">
                        <cfelseif attributes.tarih_egitim eq compare_tarih >
                            <img src="/images/stop.gif" border="0" alt="<cf_get_lang_main no='90.Bitiş'>" title="<cf_get_lang_main no='90.Bitiş'>" align="absmiddle"> <img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"></cfif>
                            
                        <br/>
                    </cfif>						
                </cfloop>
					&nbsp;
				 </td>
		</cfoutput>
    </cfloop>
		<cfset gun = gun + 1>
        </tr>
    <cfloop index=y from=2 to=6>
		<cfset sayac=0>
        <tr>
        <cfloop index=x from=1 to=7>
			<cfif gun LTE son>
                <td class="txtbold  border-bottom-transparent"><cfoutput>#gun#</cfoutput></td>
            <cfelse>
                <td class="border-bottom-transparent">&nbsp;</td>
            </cfif>
			<cfset gun = gun +1>
            <cfset sayac = sayac +1>
        </cfloop>
        </tr>
			<cfset gun=gun-sayac>
			<tr> 
			<cfoutput>
				<cfloop index="x" from="1" to="7" >
					<cfif gun LTE son>
						<td height="20" class="label">
							<cfset attributes.tarih_egitim= '#yil#-#ay#-#gun#'>
							<cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >					  
							<cfinclude  template="../query/get_todays_organizations.cfm">
							<cfloop  query="get_tr">
								<cfif NOT LEN(get_tr.FINISH_DATE[currentrow]) and NOT LEN(get_tr.START_DATE[currentrow])>
									<cfset color_="000000" >
								<cfelse>
									
									<cfset compare_tarih=dateformat(get_tr.FINISH_DATE[currentrow],"yyyy-mm-dd")>

									<cfset start_tarih= date_add('h',session.ep.time_zone,get_tr.START_DATE[currentrow])>
									<cfset start_tarih=dateformat(start_tarih,"yyyy-mm-dd")>

									<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
										<cfset color_="FF0000" >
									<cfelseif (compare_tarih gt tarih_bugun) and  (start_tarih  gt tarih_bugun)>
										<cfset color_ = "000000" >
									<cfelse>
										<cfset color_ = "FF00FF" >
									</cfif>
								</cfif>
								<cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
									<cfif is_project_current eq 1>
										<cfif len(company_id) and len(company_id_list)>
											<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_partner_detail.nickname[listfind(company_id_list,partner_id,',')]#</a>-
										<cfelseif len(consumer_id) and len(consumer_id_list)>
											<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
										</cfif>	
									</cfif>
									<a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#get_tr.organization_id#"><font color="#color_#">#get_tr.organization_head#</font></a> 
									<cfif compare_tarih eq start_tarih >
										<img src="/images/starton.gif" border="0" alt="<cf_get_lang_main no='1055.Start'>"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"> <img src="/images/stop.gif" border="0" alt="<cf_get_lang_main no='90.Bitiş'>" title="<cf_get_lang_main no='90.Bitiş'>"  align="absmiddle">
									<cfelseif attributes.tarih_egitim eq compare_tarih >
										<img src="/images/stop.gif" border="0" alt="<cf_get_lang_main no='90.Bitiş'>" title="<cf_get_lang_main no='90.Bitiş'>"  align="absmiddle">
									<cfelse>
										<img src="/images/starton.gif" border="0"  alt="<cf_get_lang_main no='1055.Start'>" title="<cf_get_lang_main no='1055.Start'>" align="absmiddle">
									</cfif>
								<br/>
								</cfif>
							</cfloop>
						</td>
					<cfelse>
					<td>&nbsp;</td>
					</cfif>
				<cfset gun = gun +1>
				</cfloop>
			</cfoutput> 
			  </tr>
		  </cfloop>
		</tbody>
	</cf_grid_list>
