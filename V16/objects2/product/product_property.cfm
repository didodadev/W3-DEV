<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
	<cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelse>
	<cfset session_base = evaluate('session.qq')>
</cfif> 
<cfif isdefined("attributes.pid")>
	<cfset attributes.product_id = #attributes.pid#>
</cfif>
<cfquery name="GET_PROPERTY" datasource="#DSN#">
	WITH T1 AS(SELECT 
		PRODUCT_DT_PROPERTIES.DETAIL,
		PRODUCT_DT_PROPERTIES.VARIATION_ID,
        PRODUCT_DT_PROPERTIES.PRODUCT_DT_PROPERTY_ID,
		PRODUCT_PROPERTY.PROPERTY_ID,
		PRODUCT_PROPERTY.PROPERTY,
        PRODUCT_DT_PROPERTIES.LINE_VALUE
	FROM 
        #dsn1_alias#.PRODUCT_DT_PROPERTIES,
		#dsn1_alias#.PRODUCT_PROPERTY,
		#dsn1_alias#.PRODUCT
	WHERE 
		PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.IS_INTERNET = 1
    )

    SELECT
        COALESCE(SLIPD.ITEM,T.DETAIL) AS DETAIL,
		T.VARIATION_ID,
		T.PROPERTY_ID,
		T.PROPERTY
    FROM
    T1 T
    LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD 
    ON SLIPD.UNIQUE_COLUMN_ID = T.PRODUCT_DT_PROPERTY_ID 
    AND SLIPD.COLUMN_NAME ='DETAIL'
    AND SLIPD.TABLE_NAME = 'PRODUCT_DT_PROPERTIES'
    AND SLIPD.LANGUAGE = '#session_base.language#' 
	ORDER BY	
		T.LINE_VALUE,
		T.PRODUCT_DT_PROPERTY_ID
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY' AND
        TABLE_NAME = 'PRODUCT_PROPERTY'
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY_DETAIL' AND
        TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
</cfquery>
<cfset varyasyon_list= listsort(valuelist(get_property.variation_id,','),"numeric","asc",",")>
<!--- <cfif listlen(varyasyon_list)>
	<cfquery name="GET_VARIATIONS" datasource="#DSN1#">
		SELECT PROPERTY_DETAIL,PROPERTY_DETAIL_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID IN (#varyasyon_list#)
	</cfquery>
</cfif> --->
<cfset property_width = 12 / attributes.property_width_col> 
<cfset count_ = 0>
    <cfif get_property.recordcount>
        <div class="description-property">
            <h6><cf_get_lang dictionary_id='60320.Özellikler'></h6>
                <div class="description-property-item">
                <cfoutput query="get_property">
                    <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                        SELECT
                            *
                        FROM
                            GET_LANGUAGE_INFOS
                        WHERE
                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                    </cfquery>
                    <cfif isDefined("attributes.variation_id") and len(variation_id)>
                        <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                            SELECT
                                *
                            FROM
                                GET_LANGUAGE_INFOS2
                            WHERE
                                UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.variation_id#">
                        </cfquery>
                    <cfelse>
                        <cfset get_language_info2.recordcount = 0>
                    </cfif>
                    <cfif len(property)>
                        <div class="col-md-#property_width#">
                           <div class="description-property-item-flex">
                                <cfif get_language_info.recordcount>
                                    #get_language_info.item#
                                <cfelse>
                                    <cfif isDefined("attributes.property_icon") and attributes.property_icon eq 1>
                                        <span class="fa fa-cube" style="color:##FF9800;"></span>
                                    <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 2>
                                        <img src="themes/protein_business/assets/img/right_arrow_3.svg">                                        
                                    <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 3>
                                        <div class="right-arrow"></div>
                                    <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 4>
                                        <span class="ctl-cogwheels"></span>
                                    </cfif>
                                     #detail#
                                </cfif>
                            </div>
                        </div>  
                    </cfif>
                </cfoutput>
            </div>
        </div>    
    </cfif>	
