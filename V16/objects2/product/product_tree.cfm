<cfquery name="GET_PROD_TREE" datasource="#DSN3#">
	SELECT 
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		PRODUCT_TREE.AMOUNT,
		PRODUCT_TREE.PRODUCT_TREE_ID,
		<!--- PRODUCT_TREE.SPECT_MAIN_NAME, --->
		PRODUCT_UNIT.MAIN_UNIT,
		STOCKS.PRODUCT_DETAIL,
		STOCKS.PRODUCT_DETAIL2,
		STOCKS.USER_FRIENDLY_URL
	FROM
		STOCKS,
		PRODUCT_TREE,
		PRODUCT_UNIT
	WHERE
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
		PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
		PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfif isdefined("attributes.tree_alphabetic_type") and attributes.tree_alphabetic_type eq 1>
            ORDER BY
                PRODUCT_NAME ASC
        </cfif>
</cfquery>
<cfset product_id_list = ''>
<cfif get_prod_tree.recordcount>
	<cfoutput query="get_prod_tree">
		<cfif isdefined("attributes.tree_image") and attributes.tree_image eq 1>
			<cfif not listfindnocase(product_id_list,get_prod_tree.product_id)>
				<cfset product_id_list = listappend(product_id_list,get_prod_tree.product_id,',')>
			</cfif>
		</cfif>
	</cfoutput> 
</cfif>
<cfif isdefined("attributes.tree_image") and attributes.tree_image eq 1>
	<cfif listlen(product_id_list)>
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
			SELECT 
				PATH,
				PRODUCT_ID,
				PATH_SERVER_ID,
				DETAIL
			FROM 
				PRODUCT_IMAGES 
			WHERE 
				IMAGE_SIZE = 0 AND
				PRODUCT_ID IN (#product_id_list#) 
			ORDER BY
				PRODUCT_ID,
				UPDATE_DATE DESC
		</cfquery>
		<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
		<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
	</cfif>
</cfif>
<cfif get_prod_tree.recordcount>
	<table style="width:100%;">
	<cfoutput query="get_prod_tree">
		<tr>
			<cfif (isdefined("attributes.tree_image") and attributes.tree_image eq 1) and  listfindnocase(product_id_list,product_id)>
				<cfif isdefined("attributes.product_tree_image_width") and len(attributes.product_tree_image_width)>
					<cfset image_width_tree = attributes.product_tree_image_width>
				<cfelse>
					<cfset image_width_tree = ''>
				</cfif>
				<cfif isdefined("attributes.product_tree_image_height") and len(attributes.product_tree_image_height)>
					<cfset image_height_tree = attributes.product_tree_image_height>
				<cfelse>
					<cfset image_height_tree = ''>
				</cfif>
				<td width="75">
					<cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" title="#get_product_images.detail[listfind(product_id_list,product_id,',')]#" alt="#get_product_images.detail[listfind(product_id_list,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id,',')]#" output_type="0" image_width="#image_width_tree#" image_height="#image_height_tree#" image_link=1>
				</td>
			<cfelse>
				<td style="width:75px;"></td>
			</cfif>
			<cfif isdefined("attributes.tree_stock_code") and attributes.tree_stock_code eq 1>
				<td>#get_prod_tree.stock_code# </td>
			</cfif>
			<cfif isdefined("attributes.tree_product_link") and attributes.tree_product_link eq 1>
				<td>
					<cfif len(get_prod_tree.user_friendly_url)>
						<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#" class="tableyazi">#get_prod_tree.product_name#</a>
					<cfelse>
						<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#get_prod_tree.product_name#</a>
					</cfif>
				<cfif isdefined("attributes.tree_product_detail") and attributes.tree_product_detail eq 1>
					<br/>#product_detail#
				<cfelseif isdefined("attributes.tree_product_detail") and attributes.tree_product_detail eq 2>
					<br/>#product_detail2#
				</cfif>
				</td>
			<cfelse>
				<td>#get_prod_tree.product_name#<br/>
				<cfif isdefined("attributes.tree_product_detail") and attributes.tree_product_detail eq 1>
					<br/>#product_detail#
				<cfelseif isdefined("attributes.tree_product_detail") and attributes.tree_product_detail eq 2>
					<br/>#product_detail2#
				</cfif>
				</td>
			</cfif>
			<cfif isdefined("attributes.tree_amount") and attributes.tree_amount eq 1>
				<td>#get_prod_tree.amount#  #get_prod_tree.main_unit#</td>
			</cfif>
			<tr height="1">
				<td colspan="8"><hr style="height:1px;" color="E9E9E9"></td>
			</tr>
		</tr>
	</cfoutput>
	</table>
</cfif>
