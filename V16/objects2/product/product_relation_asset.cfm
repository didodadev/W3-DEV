<cfparam  name="attributes.product_asset_maxrows" default="5">
<cfparam  name="attributes.PRODUCT_ASSET_NAME" default="">
<cfparam  name="attributes.PRODUCT_ASSET_DETAIL " default="">

<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>

<cfif len(attributes.product_asset_maxrows)>
	<cfset product_asset_maxrows = #attributes.product_asset_maxrows#>
<cfelse>
	<cfset product_asset_maxrows = 5>
</cfif>	


<cfquery name="GET_ASSET" datasource="#DSN#" maxrows="#product_asset_maxrows#">
	SELECT
    	ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_NAME,
        ASSET.ASSET_DETAIL,
		ASSET_CAT.ASSETCAT_PATH,
		ASSET.ASSET_ID

	FROM
		ASSET
		LEFT JOIN ASSET_CAT ON ASSET.ASSETCAT_ID  = ASSET_CAT.ASSETCAT_ID
	WHERE  
		ASSET.ACTION_SECTION = 'PRODUCT_ID'	AND
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 

</cfquery>
<cfif get_asset.recordcount>		
	
		<cfif attributes.product_asset_name eq 1 >
			<div class="description description-type2">
				<h6><cfoutput>#getLang('','',attributes.header_dic_id)#</cfoutput></h6> 
				<ul class="description_list-type2">
				<cfoutput query="get_asset">       

						<li>
							<cfif ListLast(asset_file_name,'.') is 'flv'>
								<!--- <a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#cgi.http_host#/documents/#assetcat_path#/#asset_file_name#&ext=flv&video_id=#asset_id#','video');" class="tableyazi"> --->
									<a href="/documents/#assetcat_path#/#asset_file_name#" target="_blank"> 
									<i class="fa fa-file-video fa-4x mb-3"></i>
									<p>#asset_name# </p>
								</a>
							<cfelse>
								<a href="/documents/#assetcat_path#/#asset_file_name#" target="_blank" title="#asset_name#">
									<!---<cfif attributes.product_asset_type eq 1>
										<font color="red">(#name#)</font>
									</cfif>--->
									<!--- Files at the img tags is deleted. Because of that  icons are used instead of those. --->
									<cfif ListLast(asset_file_name,'.') is 'swf'>
										<i class="fa fa-photo-film fa-4x mb-3"></i>
										<p>#asset_name# </p>

									<cfelseif ListLast(asset_file_name,'.') is 'pdf'>
										<i class="fa fa-file-pdf fa-4x mb-3" ></i>
										<p>#asset_name# </p>
									<cfelseif ListLast(asset_file_name,'.') is 'ppt'>
										<i class="fa fa-file-powerpoint fa-4x mb-3"></i>
										<p>#asset_name# </p>
									<cfelseif ListLast(asset_file_name,'.') is 'doc'or ListLast(asset_file_name,'.') is 'docx'>
										<i class="fa fa-file-word fa-4x mb-3"></i>
										<p>#asset_name# </p>
									<cfelseif ListLast(asset_file_name,'.') is 'csv'or ListLast(asset_file_name,'.') is 'xls'>
										<i class="fa fa-file-excel fa-4x mb-3"></i>
										<p>#asset_name# </p>
									<cfelse>
										<i class="fa fa-file fa-4x mb-3"></i>
										<p>#asset_name# </p>
									</cfif>
								</a>
							</cfif>
							<!--- <cfif attributes.product_asset_detail eq 1>
								<a href="/documents/#assetcat_path#/#asset_file_name#">#asset_detail#</a>           		
						</cfif> --->
						</li>
		</cfoutput>
				</ul>
			</div>  
		</cfif>
</cfif>

