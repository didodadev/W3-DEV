<cfif len(attributes.offer_asset_maxrows)>
	<cfset offer_asset_maxrows = #attributes.offer_asset_maxrows#>
<cfelse>
	<cfset offer_asset_maxrows = ''>
</cfif>	

<cfquery name="get_asset_offer" datasource="#DSN#" maxrows="#offer_asset_maxrows#">
	SELECT
		*
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP
	WHERE
		ASSET.ACTION_SECTION = 'OFFER_ID' AND
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
		ASSET.IS_INTERNET = 1
	ORDER BY 
		ASSET.ACTION_ID
</cfquery>
<cfif get_asset_offer.recordcount>
	<table width="98%">
		<cfoutput query="get_asset_offer">
			<cfif attributes.offer_asset_name eq 1>
				<tr>
					<td><li><a href="javascript://" onClick="windowopen('#file_web_path#/salespur/#asset_file_name#','medium');" class="tableyazi">#ASSET_NAME# 
							<cfif attributes.offer_asset_type eq 1>
								<font color="red">(#name#)</font>
							</cfif>
							</a>
						</li>
					</td>                 		
				</tr>
			</cfif>
			<cfif attributes.offer_asset_detail eq 1>
				<tr>
					<td><a href="javascript://" onClick="windowopen('#file_web_path#/salespur/#asset_file_name#','medium');">#asset_detail#</a></td>                 		
				</tr>
			</cfif>
		</cfoutput>
	</table>
</cfif>

