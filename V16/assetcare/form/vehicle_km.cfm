<cfinclude template="../query/get_assetp.cfm">
<cfif get_assetp.motorized_vehicle>
    <cfquery name="get_max_id" datasource="#dsn#">
        SELECT MAX(KM_CONTROL_ID) AS MAX_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID  = #get_assetp.assetp_id#
    </cfquery>
    <cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
        <cfquery name="get_km_control" datasource="#dsn#">
            SELECT 
                KM_START,
                KM_FINISH,
                RECORD_DATE	
            FROM 
                ASSET_P_KM_CONTROL 
            WHERE 
                KM_CONTROL_ID = #get_max_id.max_id#
        </cfquery>
    </cfif> 
    <cf_ajax_list>
        <table width="98%"  border="0" cellspacing="1" cellpadding="2">
            <tr>
                <td>
                    <table>
                        <tr>
                            <td class="txtbold" width="75"><cf_get_lang no='618.Başlama KM'></td>
                            <td><cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
									<cfif (get_km_control.recordcount) and len(get_km_control.km_start)>
                                        <cfoutput>#get_km_control.km_start#</cfoutput>
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='237.Bitiş KM'></td>
                            <td><cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
                                    <cfif (get_km_control.recordcount) and len(get_km_control.km_finish)>
                                        <cfoutput>#get_km_control.km_finish#</cfoutput>
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='330.Tarih'></td>
                            <td><cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
									<cfif (get_km_control.recordcount) and len(get_km_control.record_date)>
                                        <cfoutput>#dateformat(get_km_control.record_date,dateformat_style)#</cfoutput>
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='215.Kayıt Tarihi'></td>
                            <td><cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
                            		<cfoutput>#dateformat(get_km_control.record_date,dateformat_style)#</cfoutput>
                            	</cfif>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </cf_ajax_list>
</cfif>
