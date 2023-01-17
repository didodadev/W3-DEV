<cfquery name="GET_CARE_STATES" datasource="#dsn#">
	SELECT
    	CARE_ID,
		ASSET_ID,
		CARE_STATE_ID,
		STATION_ID,
		PERIOD_TIME
	FROM
		CARE_STATES
	WHERE
		FAILURE_ID=#attributes.action_id#
	ORDER BY 
		RECORD_DATE
</cfquery>
<cfquery name="GET_ASSET_FAILURE" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_CARE_CAT.ASSET_CARE_ID,
		ASSET_FAILURE_NOTICE.STATION_ID
	FROM
		ASSET_FAILURE_NOTICE,
		ASSET_P,
		ASSET_CARE_CAT
	WHERE
		FAILURE_ID = #attributes.action_id# AND
		ASSET_P.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID AND
		ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
</cfquery>

<cf_ajax_list>
	<cfif get_care_states.recordcount>
        <thead>
            <tr>
                <cfoutput>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57420.Varlıklar'></th>
                    <th><cf_get_lang dictionary_id='47913.Bakım Tipi'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='58834.İstasyon'></th>
                    <th></th>
                </cfoutput>    
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_care_states">
                <tr>
                    <td>#currentrow#</td>
                    <cfif len(asset_id)>
                        <cfquery name="get_asset" datasource="#dsn#">
                             SELECT ASSETP FROM ASSET_P where ASSETP_ID=#ASSET_ID#
                        </cfquery>
                    </cfif>
                    <td><cfif isdefined("get_asset")>#get_asset.assetp#</cfif></td>
                    <cfif len(care_state_id)>
                        <cfquery name="get_assetcare" datasource="#dsn#">
                            SELECT ASSET_CARE FROM ASSET_CARE_CAT WHERE ASSET_CARE_ID=#CARE_STATE_ID#
                        </cfquery>
                    </cfif>    
                    <td><cfif isdefined("get_assetcare")>#get_assetcare.asset_care#</cfif></td>
                    <td>#DateFormat(PERIOD_TIME,dateformat_style)#</td>
                    <cfif isdefined("station_id") and  len(station_id)>
                        <cfquery name="get_station" datasource="#dsn3#">
                            SELECT  STATION_NAME FROM WORKSTATIONS WHERE STATION_ID=#station_id#
                        </cfquery>
                    </cfif>
                    <td><cfif isdefined("get_station.station_name")>#get_station.station_name#</cfif></td>
                    <td width="15"><a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#&failure_id=#attributes.action_id#&assetp_id=#asset_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                </tr>
            </cfoutput>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>
