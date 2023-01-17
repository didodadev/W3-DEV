<cfinclude template="../query/get_company_rival_info.cfm">
<cfif get_company_rival_info.recordcount>
  <cfoutput query="get_company_rival_info">
	  <cfquery name="GET_OPTIONS" datasource="#dsn#">
			SELECT 
				SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON
			FROM 
				COMPANY_RIVAL_OPTION_APPLY,
				SETUP_RIVAL_PREFERENCE_REASONS
			WHERE  
				COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID = #attributes.cpid# AND 
				COMPANY_RIVAL_OPTION_APPLY.RIVAL_ID = #r_id# AND
				SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON_ID = COMPANY_RIVAL_OPTION_APPLY.OPTION_ID
	  </cfquery>
	  <cfquery name="GET_ACTS" datasource="#dsn#">
		SELECT 
			B.ACTIVITY_TYPE
		FROM 
			COMPANY_RIVAL_ACTIVITY A, 
			SETUP_ACTIVITY_TYPES B
		WHERE 
			A.ACTIVITY_ID = B.ACTIVITY_TYPE_ID AND
			A.RIVAL_ID = #r_id# AND 
			A.COMPANY_ID = #attributes.cpid#
		ORDER BY 
			ACTIVITY_TYPE DESC
	</cfquery>
	<cfquery name="GET_COMPANY_RIVAL_DETAIL" datasource="#DSN#">
		SELECT SERVICE_NUMBER, RELATION_LEVEL, SPECIAL_INFO FROM  COMPANY_RIVAL_DETAIL WHERE COMPANY_ID = #attributes.cpid# AND RIVAL_ID = #r_id#
	</cfquery>
    <table cellSpacing="0" cellpadding="0" width="100%" border="0" align="center">
	<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
	  <tr>
        <td>
          <table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
                  <tr>
                    <td class="headbold" height="35"><cf_get_lang no='176.Rakip Bilgileri'></td>
                  </tr>
                </table>
		  <table cellspacing="1" cellpadding="2" width="100%" border="0">
            <tr class="color-list">
              <td class="formbold">&nbsp;#rival_name#</td>
              <td width="15"  style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_rival_info&cpid=#attributes.cpid#&r_id=#r_id#&rival_name=#rival_name#','medium')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
            </tr>
            <tr class="color-row">
              <td>
                <table>
                  <tr>
                    <td class="txtboldblue"><cf_get_lang no='277.Tercih Nedeni'></td>
                    <td>: <cfloop query="get_options">#get_options.PREFERENCE_REASON#, </cfloop></td>
                  </tr>
                  <tr>
                    <td class="txtboldblue"><cf_get_lang no='276.Yapılan Etkinlikler'></td>
                    <td>: <cfloop query="get_acts">#get_acts.activity_type#, </cfloop></td>
                  </tr>
                  <tr>
                    <td class="txtboldblue"><cf_get_lang no='275.Servis Sayısı'></td>
                    <td>: <cfif get_company_rival_detail.service_number eq 1>1
                  			<cfelseif get_company_rival_detail.service_number eq 2>2
                  			<cfelseif get_company_rival_detail.service_number eq 3>3
                  			<cfelseif get_company_rival_detail.service_number eq 4>4
                  			<cfelseif get_company_rival_detail.service_number eq 5>5
                  			<cfelseif get_company_rival_detail.service_number eq 6>6
                 			<cfelseif get_company_rival_detail.service_number eq 7>7
                  			<cfelseif get_company_rival_detail.service_number eq 8>8
                  			<cfelseif get_company_rival_detail.service_number eq 9>9
                  			<cfelseif get_company_rival_detail.service_number eq 10>10
                  			<cfelseif get_company_rival_detail.service_number eq 11>11
                  			<cfelseif get_company_rival_detail.service_number eq 12>12
                  			<cfelseif get_company_rival_detail.service_number eq 13>13
                  			<cfelseif get_company_rival_detail.service_number eq 14>14
                  			<cfelseif get_company_rival_detail.service_number eq 15>15</cfif></td>
                  </tr>
                  <tr>
                    <td class="txtboldblue"><cf_get_lang no='291.İlişki Düzeyi'></td>
                    <td>: 
						<cfif len(get_company_rival_detail.relation_level)>
						<cfquery name="GET_REL" datasource="#dsn#">
							SELECT PARTNER_RELATION FROM SETUP_PARTNER_RELATION WHERE PARTNER_RELATION_ID = #get_company_rival_detail.relation_level#
						</cfquery>#get_rel.partner_relation#</cfif></td>
                  </tr>
                  <tr>
                    <td class="txtboldblue"><cf_get_lang no='290.Özel Bilgiler'></td>
                    <td>: #get_company_rival_detail.special_info#</td>
                  </tr>
                </table>
								<br/>
			  <td>&nbsp;</td>
				</tr>
          </table>
        </td>
      </tr>
    </table>
  </cfoutput>
<cfelse>
    <table cellSpacing="0" cellpadding="0" width="100%" border="0" align="center" height="100%">
      <tr>
        <td valign="top">
          <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
            <tr class="color-row">
              <td valign="top">
                <table height="100%">
                  <tr valign="top">
                    <td><cf_get_lang no='320.Lütfen Özel Bilgiler Sayfasından Çalıştığı Rakip Depoları Seçiniz'> .....</td>
                  </tr>
                </table>
				</tr>
          </table>
        </td>
      </tr>
    </table>
</cfif>
