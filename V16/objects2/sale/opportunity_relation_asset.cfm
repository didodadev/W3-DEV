<cfquery name="get_asset_opp" datasource="#dsn#">
	SELECT
		*
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP,
		ASSET_RELATED 
	WHERE
		ASSET.ACTION_SECTION = 'OPP_ID' AND
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#"> AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND
		ASSET_RELATED.ASSET_ID = ASSET.ASSET_ID AND
		ASSET_RELATED.COMPANY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_category#">
	ORDER BY 
		ASSET.ACTION_ID
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<cfoutput query="get_asset_opp">
		<tr>
            <td width="15">
				<cfif ListLast(asset_file_name,'.') is 'flv'>
                    <img src="../objects2/image/tv_bt.gif"  border="0" align="absmiddle"/>
                <cfelseif ListLast(asset_file_name,'.') is 'swf'>
                    <img src="../objects2/image/swf_bt.gif" border="0" align="absmiddle" />
                <cfelseif ListLast(asset_file_name,'.') is 'pdf'>
                    <img src="../objects2/image/pdf_bt.gif" border="0" align="absmiddle" />
                <cfelseif ListLast(asset_file_name,'.') is 'doc'>
                    <img src="../objects2/image/doc_bt.gif" border="0" align="absmiddle" />
                <cfelseif ListLast(asset_file_name,'.') is 'ppt'>
                    <img src="../objects2/image/ppt_bt.gif" border="0" align="absmiddle" />
                <cfelseif ListLast(asset_file_name,'.') is 'jpg' or ListLast(asset_file_name,'.') is 'gif' or ListLast(asset_file_name,'.') is 'jpeg'>
                    <img src="../objects2/image/img_bt.jpg" border="0" align="absmiddle" />
                <cfelse>
                    <img src="../objects2/image/undefined_bt.jpg" border="0" align="absmiddle" />
                </cfif>
            </td>
			<td><a href="javascript://" onClick="windowopen('#file_web_path#/salespur/#asset_file_name#','medium');" class="tableyazi">#ASSET_NAME#</a></td>
		</tr>
        <tr>
        	<td></td>
            <td><a href="javascript://" onClick="windowopen('#file_web_path#/salespur/#asset_file_name#','medium');">#asset_detail#</a></td>                 		
		</tr>
	</cfoutput>
</table>


