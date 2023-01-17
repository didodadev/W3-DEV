<cfif (isdefined("attributes.product_catid") and len(attributes.product_catid)) or (isdefined("attributes.hierarchy") and len(attributes.hierarchy))>
	<cfif isdefined("attributes.brand_cat_coloum") and len(attributes.brand_cat_coloum)>
		<cfparam name="attributes.brand_cat_coloum" default="#attributes.brand_cat_coloum#">
	<cfelse>
		<cfparam name="attributes.brand_cat_coloum" default="1">
	</cfif>
	<cfquery name="GET_BRANDS_CAT" datasource="#DSN1#">
		SELECT 
			PB.BRAND_NAME,
			PB.BRAND_ID,
			PBI.PATH,
			PBI.PATH_SERVER_ID,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		FROM 
			PRODUCT_BRANDS PB,
			PRODUCT_BRANDS_OUR_COMPANY PBO,
            PRODUCT_BRANDS_IMAGES PBI,
			PRODUCT_CAT_BRANDS PCB,
			PRODUCT_CAT PC
		WHERE
   			PBI.BRAND_ID = PB.BRAND_ID AND
			PCB.PRODUCT_CAT_ID = PC.PRODUCT_CATID AND
			PB.BRAND_ID = PBO.BRAND_ID AND
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
				PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
			<cfelse>
				PC.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"> AND
			</cfif>
			PCB.BRAND_ID = PB.BRAND_ID AND
			PB.IS_ACTIVE = 1 AND
			PB.IS_INTERNET = 1
		ORDER BY 
			PB.BRAND_NAME
	</cfquery>
	<cfset brand_list = valuelist(get_brands_cat.brand_id)>
	<cfset this_hier_ = '#get_brands_cat.hierarchy#'>

	<cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1 and listlen(brand_list)>
        <cfquery name="GET_PRODUCT_COUNT_BRAND" datasource="#DSN1#">
            SELECT
                COUNT(P.PRODUCT_ID) AS PRODUCT_COUNT,
                P.BRAND_ID		
            FROM 
                PRODUCT P,
                PRICE_STANDART PR,
                PRODUCT_CAT PC
            WHERE 
                P.IS_INTERNET = 1 AND		
                PR.PRODUCT_ID = P.PRODUCT_ID AND
                PR.PRICE > 0 AND
                PR.PRICESTANDART_STATUS = 1	AND
                PR.PURCHASESALES = 1 AND
                P.PRODUCT_STATUS = 1 AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
                (
                    <cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
                        PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
                    <cfelse>
                        PC.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
                    </cfif>
                    OR
                    P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_hier_#.%">
                ) 
                AND
                P.BRAND_ID IN (#brand_list#)
            GROUP BY
                P.BRAND_ID
        </cfquery>
        <cfset product_cat_brand_id_list = valuelist(get_product_count_brand.brand_id)>
        <cfset product_cat_brand_count_list = valuelist(get_product_count_brand.product_count)>
    </cfif>
    
    <cfif get_brands_cat.recordcount>
        <cfset this_row_brand_cat = 0>
        <cfif isdefined("attributes.is_brand_cat_image") and attributes.is_brand_cat_image eq 0>
            <table style="width:100%">
                <cfoutput query="get_brands_cat">
                    <cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1>
                        <cfif listfindnocase(product_cat_brand_id_list,brand_id)>
                            <cfset product_count_ = listgetat(product_cat_brand_count_list,listfindnocase(product_cat_brand_id_list,brand_id))>
                        <cfelse>
                            <cfset product_count_ = 0>
                        </cfif>
                    </cfif>
                    <cfset this_row_brand_cat = this_row_brand_cat + 1>
                    <cfif this_row_brand_cat mod attributes.brand_cat_coloum eq 1><tr></cfif>
                        <td>
                            &nbsp;<img src="../objects2/image/arrow_green.gif" align="baseline" border="0">&nbsp;
                            <a href="#request.self#?fuseaction=objects2.view_product_list&brand_id=#brand_id#&product_catid=#get_brands_cat.product_catid#" class="inner_menu_link">#brand_name#
                                <cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1> - (#product_count_#)</cfif>
                            </a>
                            <br/>
                        </td>
                    <cfif this_row_brand_cat mod attributes.brand_cat_coloum eq 0></tr></cfif>
                </cfoutput>
            </table>
        <cfelse>
            <cfif isdefined("attributes.is_brand_cat_image_width") and len(attributes.is_brand_cat_image_width)>
                <cfset is_brand_cat_image_width = #attributes.is_brand_cat_image_width#>
            <cfelse>
                <cfset is_brand_cat_image_width = ''>
            </cfif>
            <cfif isdefined("attributes.is_brand_cat_image_height") and len(attributes.is_brand_cat_image_height)>
                <cfset is_brand_cat_image_height = #attributes.is_brand_cat_image_height#>
            <cfelse>
                <cfset is_brand_cat_image_height = ''>
            </cfif>
            <table align="center" style="width:100%">
                <cfoutput query="get_brands_cat">
                    <cfset this_row_brand_cat = this_row_brand_cat + 1>
                    <cfif this_row_brand_cat mod attributes.brand_cat_coloum eq 1><tr></cfif>
                        <cfif len(get_brands_cat.path_server_id)>
                        <td>
                            <a href="#request.self#?fuseaction=objects2.view_product_list&brand_id=#brand_id#">
                                <cf_get_server_file output_file="product/#get_brands_cat.path#" output_server="#get_brands_cat.path_server_id#" image_width="#is_brand_cat_image_width#" image_height="#is_brand_cat_image_height#" output_type="0" title="#get_brands_cat.brand_name#" alt="#get_brands_cat.brand_name#" image_link="0">
                            </a>
                        </td>
                    </cfif>
                    <cfif this_row_brand_cat mod attributes.brand_cat_coloum eq 0></tr></cfif>
                </cfoutput>
            </table>
        </cfif>
	</cfif>
</cfif>
