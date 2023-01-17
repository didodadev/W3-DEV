<cfif isdefined("DSN1")>
	<cfset caller.dsn1 = dsn1>
<cfelseif not isdefined("DSN1")>
    <cfif isdefined(caller.DSN1)>
        <cfset caller.dsn1 = caller.dsn1>
    </cfif>
</cfif>
<cfif isdefined("attributes.pid")><!--- Urun Resimleri --->
    <cfquery name="GET_IMAGES" datasource="#caller.DSN1#">
        SELECT 
            PI.IMAGE_SIZE,
            PI.PRODUCT_IMAGEID,
            PI.PATH,
            PI.DETAIL,
            PI.PATH_SERVER_ID,
            PI.STOCK_ID,
            PI.IS_EXTERNAL_LINK,
            PI.VIDEO_PATH,
            PI.VIDEO_LINK,
            #caller.dsn#.Get_Dynamic_Language( P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME) AS PRODUCT_NAME
        FROM
            PRODUCT_IMAGES PI,
            PRODUCT P
        WHERE
            P.PRODUCT_ID = PI.PRODUCT_ID AND
            PI.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        ORDER BY
            PI.PRODUCT_IMAGEID DESC
    </cfquery>
    <cfquery name="GET_MEDIUM_" dbtype="query" maxrows="1">
        SELECT PATH,PATH_SERVER_ID,PRODUCT_NAME,IS_EXTERNAL_LINK,VIDEO_PATH,VIDEO_LINK FROM GET_IMAGES WHERE IMAGE_SIZE = 2 AND STOCK_ID IS NULL ORDER BY PRODUCT_IMAGEID DESC 
    </cfquery>
    <cfset image_id = attributes.pid>
    <cfset image_type = "product">
    <cfset image_detail = get_product.product_name>
<cfelseif isdefined("attributes.brand_id")><!--- Marka Resimleri --->
    <cfquery name="GET_IMAGES" datasource="#caller.DSN1#">
        SELECT 
            PBI.IMAGE_SIZE,
            PBI.BRAND_IMAGEID AS PRODUCT_IMAGEID,
            PBI.PATH,
            PBI.DETAIL,
            PBI.PATH_SERVER_ID,
            PBI.IS_EXTERNAL_LINK,
            PB.BRAND_NAME
        FROM
            PRODUCT_BRANDS_IMAGES PBI,
            PRODUCT_BRANDS PB
        WHERE
            PB.BRAND_ID = PBI.BRAND_ID AND
            PBI.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
        ORDER BY
            PRODUCT_IMAGEID DESC
    </cfquery>
    <cfquery name="GET_MEDIUM_" dbtype="query" maxrows="1">
        SELECT PATH,PATH_SERVER_ID,BRAND_NAME PRODUCT_NAME,IS_EXTERNAL_LINK FROM GET_IMAGES WHERE IMAGE_SIZE = 2 ORDER BY PRODUCT_IMAGEID DESC 
    </cfquery>
    <cfset image_id = attributes.brand_id>
    <cfset image_type = "brand">
    <cfset image_detail = get_brand.brand_name>
<cfelse>
	<cfset get_medium_.recordcount = 0>    
</cfif>
<!---urun imajlarinin stok iliskisi olmayan ve en son kaydedilen ekrana basilir  --->

<cfif get_medium_.recordcount>
<cf_box id="img_get">
        <tbody>
            <tr>
                <td>
					<cfif get_medium_.is_external_link eq 1><!--- Resim bir link ise --->
                        <cfif isdefined("attributes.pid")>
                            <cfif get_medium_.VIDEO_LINK eq 1>
                                <cf_get_server_file output_file="#get_medium_.VIDEO_PATH#" output_server="#get_medium_.path_server_id#" output_type="9" image_link="1" image_width="100%" image_height="100%" title="#get_medium_.product_name#" alt="#get_medium_.product_name#">                                
                            <cfelse> 
                                <cf_get_server_file output_file="#get_medium_.VIDEO_PATH#" output_server="#get_medium_.path_server_id#" output_type="8" image_link="1" image_width="100%" image_height="100%" title="#get_medium_.product_name#" alt="#get_medium_.product_name#">
                            </cfif>
                        <cfelse>
                            <cf_get_server_file output_file="#get_medium_.path#" output_server="#get_medium_.path_server_id#" output_type="8" image_link="1" image_width="100%" image_height="100%" title="#get_medium_.product_name#" alt="#get_medium_.product_name#">                            
                        </cfif>
                    <cfelse>
                        <cf_get_server_file output_file="product/#get_medium_.path#" output_server="#get_medium_.path_server_id#" output_type="0" image_link="1" image_width="100%" image_height="100%" title="#get_medium_.product_name#" alt="#get_medium_.product_name#">
                    </cfif>
                </td>
            </tr>		
        </tbody>
</cf_box>
</cfif>
