<cfinclude template="../query/get_campaigns.cfm">
<table style="width:100%;">
	<cfif campaign.recordcount>
		<cfoutput query="campaign" maxrows="5">
            <tr>
                <td class="txtbold"><img src="objects2/image/arrow_org.gif" alt="<cf_get_lang_main no='34.Kampanya'> <cf_get_lang_main no='485.Adı'>" title="<cf_get_lang_main no='34.Kampanya'> <cf_get_lang_main no='485.Adı'>" align="absmiddle" /> 
                <a href="#request.self#?fuseaction=objects2.dsp_campaign&camp_id=#campaign.camp_id#">
                #campaign.camp_head#</a>
                 <cfif isdefined("session.pp.userid")>
                    #dateformat(date_add('h',session.pp.time_zone,camp_startdate),'dd/mm/yyyy')#
                <cfelse>
                    #dateformat(date_add('h',session.ww.time_zone,camp_startdate),'dd/mm/yyyy')#
                </cfif> - 
                <cfif isdefined("session.pp.userid")>
                    #dateformat(date_add('h',session.pp.time_zone,campaign.camp_finishdate),'dd/mm/yyyy')#
                <cfelse>
                    #dateformat(date_add('h',session.ww.time_zone,campaign.camp_finishdate),'dd/mm/yyyy')#
                </cfif>
                </td>
            </tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td><cf_get_lang_main no="72.Kayıt Yok">!</td>
		</tr>
	</cfif>
</table>
