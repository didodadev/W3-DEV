<cfquery name="get_assetps" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P_CAT.IT_ASSET,
		ASSET_P_CAT.MOTORIZED_VEHICLE
	FROM
		ASSET_P
		LEFT JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
	WHERE
		ASSET_P.STATUS = 1 AND
		ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		ASSET_P.ASSETP
</cfquery>
<cfsetting showdebugoutput="no">
<cf_ajax_list>
    <tbody>
		<cfif get_assetps.recordcount>
            <cfoutput query="get_assetps">
                <tr>
                    <td colspan="2">
						<cfif get_module_user(40)>
							<cfif it_asset eq 1>
                    			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#','page');" class="tableyazi">#assetp#</a>
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#','page');" class="tableyazi">#assetp#</a>
							</cfif>
						<cfelse>
                    		#assetp#
                    	</cfif>
                    		- #assetp_cat#
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
