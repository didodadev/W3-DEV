<cfsetting showdebugoutput="no">
<cfquery name="GET_VIDEO_POSITION" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="GET_ASSET_FLV" datasource="#DSN#" maxrows="5">
	SELECT DISTINCT
		ASSET.ASSET_FILE_NAME,
		ASSET.RECORD_DATE,
		ASSET.ASSET_NAME,
		ASSET.ASSET_FILE_SERVER_ID,
		ASSET.ASSETCAT_ID,
		ASSET.ASSET_ID,
		ASSET.ASSET_DESCRIPTION,
		ASSET_CAT.ASSETCAT_PATH,
		ASSET.EMBEDCODE_URL,
		ASSET.ASSET_FILE_SIZE    
	FROM 
		ASSET,
		ASSET_CAT
	WHERE 
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		ASSET.ASSET_ID IN (SELECT DISTINCT ASSET_ID FROM ASSET_RELATED WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1 OR POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_video_position.position_cat_id#">) 	
		AND( (ASSET.EMBEDCODE_URL LIKE '%loom.com%' OR ASSET.EMBEDCODE_URL LIKE '%youtube.com%' OR ASSET.EMBEDCODE_URL LIKE '%youtu.be%' OR ASSET.EMBEDCODE_URL LIKE '%vimeo.com%') OR ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.MP4%'>) and
	
		ASSET.MODULE_ID != 6
	ORDER BY 
		ASSET.RECORD_DATE DESC
</cfquery>

<cf_flat_list>
	<tbody>	
		<cfif get_asset_flv.recordcount>
		<cfset file_add_ = "asset/">
		<cfoutput query="get_asset_flv">
			<cfif assetcat_id gte 0>
				<cfset file_add_ = "asset/">
			<cfelse>
				<cfset file_add_ = "">
			</cfif>
			<cfif asset_file_size neq 0 and len(embedcode_url)>
				<tr>
					<td width="100">
						<a href="#embedcode_url#" target="_blank"  class="tableyazi">
							<cf_get_server_file output_file="thumbnails/middle/#asset_file_name#" output_server="#asset_file_server_id#" output_type="0" image_link="0" image_width="90" image_height="50">
						</a>
					</td>
					<td width="250">
						<p class="bold" style="width:200px">#LEFT(asset_name,90)#</p>
						<p style="width:200px">#LEFT(asset_description,140)#</p>
					</td>
				</tr>
			</cfif>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
<div class="margin-top-5">
	<a href="index.cfm?fuseaction=asset.tv" target="_blank" class="tableyazi"><i class="fa fa-tv bold" style ="color: #FF9800;"></i> &nbsp<b><cf_get_lang dictionary_id='62197.Tüm Videolar'></b></a>
</div>


