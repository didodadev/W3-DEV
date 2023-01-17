<cfif isdefined('attributes.content_asset_maxrows') and len(attributes.content_asset_maxrows)>
	<cfset content_asset_maxrows = #attributes.content_asset_maxrows#>
<cfelse>
	<cfset content_asset_maxrows = ''>
</cfif>
<cfquery name="get_asset" datasource="#DSN#" maxrows="#content_asset_maxrows#">
	SELECT
		ASSET.*,
		CP.NAME,
		ASSET_CAT.ASSETCAT_PATH
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP,
		ASSET_CAT
	WHERE
		
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND
		ASSET.ACTION_SECTION = 'CONTENT_ID' AND
		<cfif isdefined("url.cid")>
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#(structKeyExists(url, "cid") ? url.cid : attributes.param_2)#"> AND 
		<cfelse>
		ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#(structKeyExists(attributes, "cid") ? attributes.cid : attributes.param_2)#"> AND 
		</cfif> 
		ASSET.IS_INTERNET = 1
	ORDER BY
		ASSET.ACTION_ID
</cfquery>
<cfif get_asset.recordcount>
	<cfoutput query="get_asset">
		<div class="list_chapter-type2">	
			<cfif EMBEDCODE_URL contains 'www.youtube.com' or EMBEDCODE_URL contains 'youtu.be'>
				<cfif EMBEDCODE_URL contains 'youtu.be'>
					<cfset str = listlast(EMBEDCODE_URL, '/')>
				<cfelse>
					<cfset str = listfirst(listrest(EMBEDCODE_URL, '='),'&')>
				</cfif>
				<div class="list_chapter_item-type2" style="background-color:rgba(10,187,135,.1);">
					<div class="list_chapter_item-type2_text">
						<iframe width="100%" height="100%" style="min-height:250px;" src="https://www.youtube.com/embed/#str#"  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen ></iframe>
					</div>
				</div>
            <cfelseif EMBEDCODE_URL contains 'loom'>
                <cfset loomLink = listToArray (EMBEDCODE_URL, "/",false,true)>
				<div class="list_chapter_item-type2" style="background-color:rgba(10,187,135,.1);">
					<div class="list_chapter_item-type2_text">
						<iframe src="https://www.loom.com/embed/#ArrayLast(loomLink)#" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 50; left: 0; width: 100%; height: 100%;"></iframe>
					</div>
				</div>
			<cfelse>
				<div class="description description-type2">
					<ul class="description_list-type2" style="border-bottom:1px solid rgba(0,0,0,.125);text-align:center;padding:0px;">
						<li style="list-style-type:none;">
							<cfif ListLast(asset_file_name,'.') is 'flv'>
								<a href="/documents/#assetcat_path#/#asset_file_name#" target="_blank"> 
									<i class="fa fa-file-video fa-4x mb-3"></i>
									<p>#asset_name# </p>
								</a>
							<cfelse>
								<a href="/documents/#assetcat_path#/#asset_file_name#" target="_blank" title="#asset_name#">
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
									<cfelseif ListLast(asset_file_name,'.') is 'png'or ListLast(asset_file_name,'.') is 'jpg'>
										<div class="list_chapter_item-type2_text">
											<img src="/documents/#assetcat_path#/#asset_file_name#" style="max-width:100%;">
										</div>
									<cfelse>
										<i class="fa fa-file fa-4x mb-3"></i>
										<p>#asset_name# </p>
									</cfif>
								</a>
							</cfif>
						</li>
					</ul>
				</div>		
			</cfif>	
		</div>
	</cfoutput>
<cfelse>
	<cfset widget_live = "die">
</cfif>
<script>
	$('.list_chapter-type2').parent('.card-body').addClass('list_chapter-type2-card_body');
</script>
