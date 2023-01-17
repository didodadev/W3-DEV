<cfquery name="GET_CARE_STATES" datasource="#dsn#">
	SELECT
    	CARE_REPORT_ID,
		ASSET_ID,
		CARE_DATE,
        CARE_TYPE,
		STATION_ID
	FROM
		ASSET_CARE_REPORT
	WHERE
    	<cfif attributes.care_id eq 0>
  			FAILURE_ID = #attributes.action_id#
        <cfelse>
        	CARE_ID = #attributes.action_id#
        </cfif>
	ORDER BY 
		RECORD_DATE
</cfquery>

<cf_ajax_list>
    <thead>
        <tr>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57420.Varlıklar'></th>
                <th><cf_get_lang dictionary_id='47913.Bakım Tipi'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                <th><cf_get_lang dictionary_id='58834.İstasyon'></th>
                <th></th>  
        </tr>
    </thead>
    <tbody>
        <cfif get_care_states.recordcount>
            <cfoutput query="get_care_states">
                <tr>
                    <td>#currentrow#</td>
                        <cfif len(asset_id)>
                            <cfquery name="get_asset" datasource="#dsn#">
                                SELECT ASSETP FROM ASSET_P where ASSETP_ID=#ASSET_ID#
                            </cfquery>
                        </cfif>
                    <td><cfif isdefined("get_asset.assetp")>#get_asset.assetp#</cfif></td>
                        <cfif len(care_type)>
                            <cfquery name="get_assetcare" datasource="#dsn#">
                                SELECT ASSET_CARE FROM ASSET_CARE_CAT WHERE ASSET_CARE_ID=#CARE_TYPE#
                            </cfquery>
                        </cfif>
                    <td><cfif isdefined("get_assetcare.asset_care")>#get_assetcare.asset_care#</cfif></td>
                    <td><cfif len(care_date)>#DateFormat(care_date,dateformat_style)#</cfif></td>
                    <cfif len(station_id)>
                        <cfquery name="get_station" datasource="#dsn3#">
                            SELECT  STATION_NAME FROM WORKSTATIONS WHERE STATION_ID=#station_id#
                        </cfquery>
                    </cfif>
                    <td><cfif isdefined("get_station.station_name")>#get_station.station_name#</cfif></td>
                    <td width="15"><a href="#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#care_report_id#<cfif attributes.care_id eq 0>&failure_id=#attributes.action_id#<cfelse>&care_id=#attributes.action_id#</cfif>"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
