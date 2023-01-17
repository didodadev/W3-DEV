<cfset tarih_bugun=dateformat(now(),"yyyy-mm-dd")>
<cfset bu_ay=Month(now())>
<cf_grid_list>
	<tr class="color-header" height="22"> 
    	<td width="60"><b><cf_get_lang dictionary_id="58672.Aylar"></b></td>
    	<td valign="middle">
    		<div style="float:left">
        		<b><cf_get_lang dictionary_id='49713.Etkinlikler'></b>
	        </div>
    	    <div style="float:right">
        	    <cfloop from="-2" to="2" index="i">
            		<cfset year_k=evaluate(session.ep.period_year + i)>
                	<cfoutput>
                    	<a href="#request.self#?fuseaction=campaign.list_organization_agenda#url_str#&yil_src=#year_k#&page_type=2">
	                    <cfif isdefined("attributes.yil_src") and attributes.yil_src eq year_k > <font color="FF0000">#year_k#</font><cfelse>#year_k#</cfif>
    	                </a> | 
        	        </cfoutput>
            	</cfloop>
	        </div>			
    	</td>
	</tr>
	<cfoutput>
		<cfloop from="1" to="12" index="attributes.month_id">  
			<tr height="35" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>
					<cfif attributes.month_id eq 1><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=1<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='180.Ocak'></a></cfif>
					<cfif attributes.month_id eq 2><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=2<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='181.Şubat'></a></cfif>
					<cfif attributes.month_id eq 3><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=3<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='182.Mart'></a></cfif>
					<cfif attributes.month_id eq 4><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=4<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='183.Nisan'></a></cfif>
					<cfif attributes.month_id eq 5><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=5<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='184.Mayıs'></a></cfif>
					<cfif attributes.month_id eq 6><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=6<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='185.Haziran'></a></cfif>
					<cfif attributes.month_id eq 7><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=7<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='186.Temmuz'></a></cfif>
					<cfif attributes.month_id eq 8><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=8<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='187.Ağustos'></a></cfif>
					<cfif attributes.month_id eq 9><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=9<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='188.Eylül'></a></cfif>
					<cfif attributes.month_id eq 10><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=10<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='189.Ekim'></a></cfif>
					<cfif attributes.month_id eq 11><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=11<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='190.Kasım'></a></cfif>				
					<cfif attributes.month_id eq 12><a class="tableyazi" href="#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1&ay=12<cfif isdefined('attributes.yil_src')>&yil=#attributes.yil_src#</cfif>"><cf_get_lang_main no='191.Aralık'></a></cfif>																																																													
				</td>
				<td colspan="2">
					<cfinclude template="../query/get_organization_agenda.cfm">
					<cfloop query="get_organization">
						<cfif not len(finish_date) and not len(start_date)>
							<cfset color_="000000">
						<cfelse>
							<cfset compare_tarih=dateformat(finish_date,"yyyy-mm-dd")>
							<cfset start_tarih=dateformat(start_date,"yyyy-mm-dd")>
							<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
								<cfset color_="FF0000">
							<cfelseif start_tarih gt tarih_bugun>
								<cfset color_="000000">
							<cfelseif compare_tarih lt tarih_bugun>
								<cfset color_="FF00FF">
							</cfif>
						</cfif>		
						<cfif is_project_current eq 1>
							<cfif len(company_id) and len(company_id_list)>
								<a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#get_organization.organization_id#" class="tableyazi"><font color="#color_#">#get_organization.organization_head#</font></a>-
							<cfelseif len(consumer_id) and len(consumer_id_list)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=campaign.list_organization_agenda&event=upd&org_id=#get_organization.organization_id#','medium');><font color="#color_#">#get_organization.organization_head#</font></a>&con_id=#consumer_id#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
							</cfif>
						</cfif>
						<a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#get_organization.organization_id#" class="tableyazi"><font color="#color_#">#get_organization.organization_head#</font></a>
						<cfif get_organization.currentrow neq get_organization.Recordcount>,</cfif>
					</cfloop>
				</td>
			</tr>
		</cfloop> 
	</cfoutput>
</cf_grid_list>
