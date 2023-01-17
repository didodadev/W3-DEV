<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT
		ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_NAME,
        CP.NAME
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP,
        ASSET_SITE_DOMAIN ASD
	WHERE
        ASD.ASSET_ID = ASSET.ASSET_ID AND
        ASD.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
		ASSET.ACTION_SECTION = 'PROJECT_ID' AND
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
	ORDER BY 
		ASSET.ACTION_ID
</cfquery>
<cfif get_asset.recordcount>		
    <table style="width:100%">
        <cfoutput query="get_asset">
            <tr>
                <td>
                	<li style="margin-left:15px;"><a href="javascript://" onclick="windowopen('#file_web_path#/project/#asset_file_name#','medium');" class="tableyazi">#asset_name# <font color="red">(#name#)</font></a></li> <br>
                </td>                 		
            </tr>
        </cfoutput>
    </table>
</cfif>
