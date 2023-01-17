
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
    SELECT <cfif isdefined('attributes.max_product_num') and len(attributes.max_product_num)>TOP #attributes.max_product_num#</cfif>
        P.PRODUCT_ID,                                       
        P.PRODUCT_CATID,
        COALESCE(SLIPN.ITEM,P.PRODUCT_NAME) AS PRODUCT_NAME,
        P.PRODUCT_DETAIL,
        P.PRODUCT_CODE_2,
        PC.PRODUCT_CAT,
        (SELECT TOP 1 PIMG.PATH FROM PRODUCT_IMAGES PIMG WHERE P.PRODUCT_ID = PIMG.PRODUCT_ID AND (PIMG.IMAGE_SIZE = 3)) PATH_ICON,
        UFU.USER_FRIENDLY_URL
    FROM
        PRODUCT AS P
        LEFT JOIN PRODUCT_CAT AS PC ON P.PRODUCT_CATID = PC.PRODUCT_CATID                    
        OUTER APPLY(
            SELECT TOP 1 UFU.USER_FRIENDLY_URL 
            FROM #dsn#.USER_FRIENDLY_URLS UFU 
            WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
            AND OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"LANGUAGE":"#session_base.language#"%'>
        AND UFU.ACTION_ID = P.PRODUCT_ID 		
        AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU
        LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
            ON SLIPN.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
            AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
            AND SLIPN.TABLE_NAME = 'PRODUCT'
            AND SLIPN.LANGUAGE = '#session_base.language#'
    WHERE
        P.IS_INTERNET = 1 AND       
        P.IS_SALES = 1 AND                    
        P.PRODUCT_STATUS = 1
        <cfif isDefined("attributes.product_menu_category_id") and len(attributes.product_menu_category_id)>
        AND PC.PRODUCT_CATID IN (<cfqueryparam value="#attributes.product_menu_category_id#" cfsqltype="cf_sql_integer" list="true">)
        </cfif>
</cfquery>

<div>
	<span class="cat-title">
		<cfif isDefined("attributes.product_list_menu_header") and len(attributes.product_list_menu_header)>
			<cf_get_lang dictionary_id='#attributes.product_list_menu_header#'>
		</cfif>
	</span>
	<ul>
        <cfoutput query="GET_PRODUCT_CAT">	
            <cfif isDefined("attributes.show_product_icon") and attributes.show_product_icon eq 1>
                <li class="d-flex align-items-center">
                    <cfif len(PATH_ICON)>
                        <img class="mr-1" src="documents/product/#PATH_ICON#" style="height:30px;width:30px">
                    </cfif>
                    <a href="#site_language_path#/#USER_FRIENDLY_URL#">#PRODUCT_NAME#</a> 
                </li>
            </cfif>	 	
            <li>   
                <cfif len(PRODUCT_CODE_2)>
                    <div class="row">
                    <p class="font-weight-bold px-2" style="width:80px">#PRODUCT_CODE_2#</p> 
                    <a class="col-8 p-0" href="#site_language_path#/#USER_FRIENDLY_URL#">#PRODUCT_NAME#</a> 
                    </div>   
                <cfelse>
                    <a href="#site_language_path#/#USER_FRIENDLY_URL#">#PRODUCT_NAME#</a> 

                </cfif>
            </li>
        </cfoutput>
	</ul>
</div>