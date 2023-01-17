<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT
		ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_NAME,
        CP.NAME
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP
	WHERE
		ASSET.ACTION_SECTION = 'CAMPAIGN_ID' AND
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND
		ASSET.IS_INTERNET  = 1 
	ORDER BY 
		ASSET.ACTION_ID
</cfquery>
<cfif get_asset.recordcount>		
    <table border="0" style="width:100%;">
        <cfoutput query="get_asset">
            <tr>
                <td>
                <li><a href="javascript://" onClick="windowopen('#file_web_path#campaign/#asset_file_name#','medium');" class="tableyazi">#asset_name# <font color="red">(#name#)</font></a></li> <br/>
                </td>                 		
            </tr>
        </cfoutput>
    </table>
</cfif>
