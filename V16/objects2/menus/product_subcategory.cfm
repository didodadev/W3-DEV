<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and not isdefined("attributes.hierarchy")>
	<cfquery name="GET_" datasource="#DSN1_alias#">
		SELECT 
			HIERARCHY
		FROM
			PRODUCT_CAT
		WHERE
			PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
	</cfquery>
	<cfset attributes.hierarchy = get_.hierarchy>
</cfif>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1_alias#">
    SELECT 
        PC.PRODUCT_CATID,
        PC.PRODUCT_CAT,
        PC.HIERARCHY,
        PC.LIST_ORDER_NO,
        UFU.USER_FRIENDLY_URL        
    FROM
        PRODUCT_CAT PC
        LEFT JOIN #dsn_alias#.USER_FRIENDLY_URLS UFU 
		ON UFU.ACTION_TYPE = 'PRODUCT_CATID' 
		AND UFU.ACTION_ID = PC.PRODUCT_CATID 
		AND UFU.PROTEIN_EVENT = 'det' 
		AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE# 
		AND UFU.PROTEIN_PAGE = #GET_PAGE.PROTEIN_PAGE#
    WHERE				
        <cfif listlen(attributes.hierarchy,'.') gt 1>
            <cfloop from="1" to="#listlen(attributes.hierarchy,'.')#" index="ccc">
                <cfif ccc eq 1>
                    HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.hierarchy,ccc,".")#"> OR
                <cfelse>
                    <cfset hie_ = "">
                    <cfloop from="1" to="#ccc#" index="mmm">
                        <cfif mmm eq 1>
                            <cfset hie_ = listgetat(attributes.hierarchy,mmm,".")>
                        <cfelse>
                            <cfset hie_ = hie_ & '.' & listgetat(attributes.hierarchy,mmm,".")>
                        </cfif>
                    </cfloop>
                    HIERARCHY = '#hie_#' OR
                </cfif>
            </cfloop>
        <cfelse>
            HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"> OR
        </cfif>
        HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#.%">				
</cfquery>	

<cfif isdefined("attributes.is_prod_number") and attributes.is_prod_number eq 1>
	<cfquery name="GET_PRODUCT_COUNT" datasource="#DSN3#">
	SELECT
		COUNT(P.PRODUCT_ID) AS PRODUCT_COUNT,
		PC.PRODUCT_CATID		
	FROM 
		PRODUCT P,
		PRICE_STANDART PR,
		PRODUCT_CAT PC,
		PRODUCT_BRANDS PB,
		#DSN1_alias#.PRODUCT_BRANDS_OUR_COMPANY PBO
	WHERE 
		<cfif isdefined("product_cat_list") and listlen(product_cat_list)>
			PC.PRODUCT_CATID IN (#product_cat_list#) AND
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
			P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
		</cfif>
		P.BRAND_ID = PB.BRAND_ID AND
		PB.BRAND_ID = PBO.BRAND_ID AND
		PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PB.IS_ACTIVE = 1 AND
		PB.IS_INTERNET = 1 AND
		P.IS_INTERNET = 1 AND		
		PR.PRODUCT_ID = P.PRODUCT_ID AND
		PR.PRICE > 0 AND
		PR.PRICESTANDART_STATUS = 1	AND
		PR.PURCHASESALES = 1 AND
		P.PRODUCT_STATUS = 1 AND			
		(
		P.PRODUCT_CATID = PC.PRODUCT_CATID OR 
		P.PRODUCT_CODE LIKE PC.HIERARCHY + '.%'
		)
	GROUP BY
		PC.PRODUCT_CATID
	</cfquery>
	<cfset product_cat_id_list = valuelist(get_product_count.product_catid)>
	<cfset product_cat_count_list = valuelist(get_product_count.product_count)>
</cfif>

<table border="0" cellpadding="0" cellspacing="2" align="center" style="width:100%;">
	<cfset this_row_ = 0>
    <cfset p_c_list = "">
    <cfloop query="get_product_cat">
        <cfset hier = get_product_cat.hierarchy>
        <cfif not listfindnocase(p_c_list,hier)>
            <cfset p_c_list = listappend(p_c_list,hier)>
            <cfif listlen(hier,'.') eq 1>
            	<cfset this_row_ = this_row_ + 1>
				<cfset pcat_id = get_product_cat.product_catid>
                <cfset pcat = get_product_cat.product_cat>
                <cfif isdefined("attributes.is_prod_number") and attributes.is_prod_number eq 1>
                    <cfif listfindnocase(product_cat_id_list,pcat_id)>
                        <cfset product_count_ = listgetat(product_cat_count_list,listfindnocase(product_cat_id_list,pcat_id))>
                    <cfelse>
                        <cfset product_count_ = 0>
                    </cfif>
                </cfif>
                <cfif listlen(hier,'.') eq 1>
                    <cfquery name="GET_ALTS" dbtype="query">
                        SELECT 
                            * 
                        FROM 
                            GET_PRODUCT_CAT 
                        WHERE 
                            HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#hier#.%"> 
                        ORDER BY 
                            <cfif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 1>
                                PRODUCT_CAT	
                            <cfelseif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 0>
                                HIERARCHY
                            <cfelseif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 2>
                                LIST_ORDER_NO
                            <cfelse>
                                HIERARCHY
                            </cfif>
                    </cfquery>
                </cfif>
                <cfoutput>                     
                    <cfif (listlen(hier,'.') eq 1 or (isdefined("product_cat_list") and listlen(product_cat_list) and isdefined("attributes.hierarchy") and listlen(hier,'.') eq listlen(attributes.hierarchy,'.'))) and get_alts.recordcount>
                        <span id="kategori_#pcat_id#" <cfif isdefined("attributes.hierarchy") and listfirst('#attributes.hierarchy#','.') is listfirst('#hier#','.')>style="display:;"<cfelse>style="display:none;"</cfif>>
                            <table border="0" cellpadding="1" cellspacing="1" style="width:100%;">
                                <cfloop query="get_alts">
                                    <cfif isdefined("attributes.is_prod_number") and attributes.is_prod_number eq 1>
                                        <cfif listfindnocase(product_cat_id_list,get_alts.product_catid)>
                                            <cfset product_count_ = listgetat(product_cat_count_list,listfindnocase(product_cat_id_list,get_alts.product_catid))>
                                        <cfelse>
                                            <cfset product_count_ = 0>
                                        </cfif>
                                    </cfif>
                                    <tr style="height:22px;">
                                        <td align="left" class="inner_menu_link_td_#listlen(get_alts.hierarchy,'.')-1#">                                                
                                            <a href="#USER_FRIENDLY_URL#" class="inner_menu_link_alt_#listlen(get_alts.hierarchy,'.')-1#">                                               
                                            #get_alts.product_cat#<cfif isdefined("attributes.is_prod_number") and attributes.is_prod_number eq 1> (#product_count_#)</cfif>
                                            </a>
                                            <br/>
                                        </td>
                                    </tr>
                                </cfloop>
                            </table>
                        </span>
                    </cfif>                  
                </cfoutput>
            </cfif>
        </cfif>
    </cfloop>
</table>
