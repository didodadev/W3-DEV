<cfif isdefined("attributes.last_visited_max_count") and len(attributes.last_visited_max_count)>
	<cfset max_ = attributes.last_visited_max_count>
<cfelse>
	<cfset max_ = 5>
</cfif>

<cfif isdefined("attributes.last_visited_col_count") and len(attributes.last_visited_col_count)>
	<cfset col_ = attributes.last_visited_col_count>
<cfelse>
	<cfset col_ = 1>
</cfif>
<cfif isdefined("cookie.last_visited_5_products") and listlen(cookie.last_visited_5_products)>
	<cfquery name="GET_LAST_VISITED_5_PRODUCTS" datasource="#DSN3#" maxrows="#max_#">
		SELECT
			P.PRODUCT_NAME, 
			P.PRODUCT_ID,
			P.PRODUCT_DETAIL,
			S.STOCK_ID,
			S.PROPERTY 
		FROM
			PRODUCT P,
			STOCKS S, 
			PRODUCT_CAT PC,
			#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
		WHERE
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			S.PRODUCT_ID = P.PRODUCT_ID AND
			P.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PC.IS_PUBLIC = 1 AND
			<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
			P.PRODUCT_STATUS = 1 AND
			S.STOCK_ID IN (#cookie.last_visited_5_products#)
	</cfquery>
    
	<cfif session_base.language neq 'tr'>
        <cfif not isDefined('get_all_for_langs')>
            <cfquery name="GET_ALL_FOR_LANGS" datasource="#DSN#">
                SELECT 
                    UNIQUE_COLUMN_ID, 
                    TABLE_NAME,
                    COLUMN_NAME,
                    LANGUAGE,
                    ITEM 
                FROM 
                    SETUP_LANGUAGE_INFO 
                WHERE 
                    (
                        (TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_NAME') OR
                        (TABLE_NAME = 'SETUP_COUNTRY' AND COLUMN_NAME = 'COUNTRY_NAME') OR
                        (TABLE_NAME = 'SETUP_UNIT' AND COLUMN_NAME = 'UNIT')                
                    ) AND
                    ITEM <> '' AND
                    LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
            </cfquery>
        </cfif>
        
        <cfquery name="GET_PRODUCT_NAMES" dbtype="query">
            SELECT * FROM GET_ALL_FOR_LANGS WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_NAME'
        </cfquery>
    </cfif> 
    
	<cfif get_last_visited_5_products.recordcount>
		<cfset product_id_list = ''>
		<cfoutput query="get_last_visited_5_products">
			<cfif not listfindnocase(product_id_list,get_last_visited_5_products.product_id)>
				<cfset product_id_list = listappend(product_id_list,get_last_visited_5_products.product_id,',')>
			</cfif>
		</cfoutput>
		<cfif listlen(product_id_list)>
			<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
				SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
			</cfquery>
			<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.PRODUCT_ID,','),'numeric','ASC',',')>
			<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
		</cfif>
		
		<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%;">
			<cfoutput query="get_last_visited_5_products">  
				<cfif currentrow eq 1 or (currentrow mod col_ eq 1 and currentrow gt col_)><tr></cfif> 
				<td valign="bottom" <cfif col_ gt 1>align="center"</cfif>>
					<cfif listfindnocase(product_id_list,product_id)>
						<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#">
							<cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" title="#get_product_images.detail[listfind(product_id_list,product_id,',')]#" alt="#get_product_images.detail[listfind(product_id_list,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id,',')]#"  output_type="0" image_width="70" image_link=0>
						</a>
					</cfif>
                    
                    <cfif session_base.language neq 'tr'>
                    	<cfquery name="GET_PRODUCT_NAME" dbtype="query">
                        	SELECT * FROM GET_PRODUCT_NAMES WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        </cfquery>
                        <cfif get_product_name.recordcount>
							<cfif col_ gt 1>
                                <br />
                                <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#get_product_name.item# #property#</a><br />
                                    #left(product_detail,100)#
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#get_product_name.item# #property#</a><br />
                                    #left(product_detail,100)#
                                </cfif>
                            </cfif>
                        <cfelse>
							<cfif col_ gt 1>
                                <br />
                                <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                    #left(product_detail,100)#
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                    #left(product_detail,100)#
                                </cfif>
                            </cfif>                        
                        </cfif>
					<cfelse>
						<cfif col_ gt 1>
                            <br />
                            <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                #left(product_detail,100)#
                            <cfelse>
                                <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                #left(product_detail,100)#
                            </cfif>
                        </cfif>
                    </cfif>
				</td>
                <cfif session_base.language neq 'tr'>
					<cfif get_product_name.recordcount>
                        <cfif col_ eq 1>
                            <td valign="top">
                                <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#get_product_name.item# #property#</a><br />
                                    #left(product_detail,100)#
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#get_product_name.item# #property#</a><br />
                                    #left(product_detail,100)#
                                </cfif>
                            </td>
                        </cfif>
                    <cfelse>
                        <cfif col_ eq 1>
                            <td valign="top">
                                <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                    #left(product_detail,100)#
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                    #left(product_detail,100)#
                                </cfif>
                            </td>
                        </cfif>                
                    </cfif>
				<cfelse>
					 <cfif col_ eq 1>
                        <td valign="top">
                            <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                #left(product_detail,100)#
                            <cfelse>
                                <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link">#product_name# #property#</a><br />
                                #left(product_detail,100)#
                            </cfif>
                        </td>
                    </cfif>                               
                </cfif>
				<cfif currentrow mod col_ eq 0></tr></cfif> 	
				<cfif currentrow mod col_ eq 0>
					<tr><td colspan="2"><hr style="color:ccc; height:0.1px;" /></td></tr>
				</cfif>
			</cfoutput>				
		</table>
	</cfif>	
</cfif>
