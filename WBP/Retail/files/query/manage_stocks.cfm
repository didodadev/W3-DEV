<cftransaction>
	<CF_DATE tarih="attributes.process_date">
	<cfif not isdefined("attributes.table_code") or not len(attributes.table_code)>
        <cflock timeout="20">
            <cfquery name="get_table_no" datasource="#dsn2#">
                SELECT STOCK_NUMBER FROM #dsn_dev_alias#.SEARCH_TABLE_NO
            </cfquery>
            <cfset new_number = get_table_no.STOCK_NUMBER + 1>
            <cfquery name="upd_table_no" datasource="#dsn2#">
                UPDATE #dsn_dev_alias#.SEARCH_TABLE_NO SET STOCK_NUMBER = #new_number#
            </cfquery>
        </cflock>
        <cfset attributes.table_code = new_number>
        <cfloop from="1" to="#8-len(new_number)#" index="ccc">
            <cfset attributes.table_code = "0" & attributes.table_code>
        </cfloop>
        
        <cfquery name="add_" datasource="#dsn2#" result="max_id">
            INSERT INTO 
                #dsn_dev_alias#.STOCK_MANAGE_TABLES
                (
                TABLE_CODE,
                TABLE_INFO,
                PROCESS_DATE,
                DEPARTMENT_ID,
                LOCATION_ID,
                RECORD_DATE,
                RECORD_EMP
                )
            VALUES
                (
                '#attributes.table_code#',
                '#attributes.table_info#',
                #attributes.process_date#,
                #attributes.department_id#,
                1,
                #now()#,
                #session.ep.userid#
                )
        </cfquery>
        <cfset attributes.table_id = max_id.IDENTITYCOL>
    <cfelse>
        <cfquery name="del_" datasource="#dsn2#">
            DELETE FROM STOCKS_ROW WHERE WRK_ROW_ID = '#attributes.table_code#'
        </cfquery>
        
        <cfquery name="get_table_id" datasource="#dsn2#">
            SELECT TABLE_ID FROM #dsn_dev_alias#.STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfset attributes.table_id = get_table_id.TABLE_ID>
        
        <cfquery name="upd_" datasource="#dsn2#">
            UPDATE
                #dsn_dev_alias#.STOCK_MANAGE_TABLES
            SET
                DEPARTMENT_ID = #attributes.department_id#,
                LOCATION_ID = 1,
                TABLE_INFO = '#attributes.table_info#',
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                TABLE_ID = #attributes.table_id#
        </cfquery>
    </cfif>
    
    
    <cfloop from="1" to="#attributes.row_count#" index="ccc">
    	<cfset stock_id_ = evaluate("attributes.sid_#ccc#")>
        <cfset stock_type_ = evaluate("attributes.stock_type_#ccc#")>
        <cfset stock_count_ = evaluate("attributes.stock_count_#ccc#")>
        <cfif len(stock_id_) and len(stock_count_)>
        	<cfset stock_count_ = filternum(stock_count_)>
            <cfquery name="get_product_info" datasource="#dsn2#">
            	SELECT TOP 1
                    S.BARCOD,
                    S.STOCK_ID,
                    S.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    S.TAX,
                    S.IS_INVENTORY,
                    PU.MAIN_UNIT,
                    PU.MAIN_UNIT_ID,
                    PU.ADD_UNIT,
                    PU.UNIT_ID,
                    ISNULL(PU.MULTIPLIER,1) MULTIPLIER
                FROM
                    #dsn3_alias#.STOCKS S,
                    #dsn3_alias#.PRODUCT_UNIT PU
                WHERE
                    S.STOCK_ID = #stock_id_# AND 
                    S.PRODUCT_STATUS = 1 AND 
                    S.STOCK_STATUS = 1 AND 
                    S.PRODUCT_ID = PU.PRODUCT_ID AND
                    ISNULL(PU.MULTIPLIER,1) = 1
            </cfquery>
            <cfquery name="add_" datasource="#dsn2#">
            	INSERT INTO
                	STOCKS_ROW
                    (
                    STOCK_ID,
                    PRODUCT_ID,
                    UPD_ID,
                    PROCESS_TYPE,
                    STOCK_IN,
                    STOCK_OUT,
                    STORE,
                    STORE_LOCATION,
                    PROCESS_DATE,
                    DELIVER_DATE,
                    WRK_ROW_ID
                    )
                    VALUES
                    (
                    #stock_id_#,
                    #get_product_info.PRODUCT_ID#,
                    -1,
                    -1001,
                    <cfif stock_type_ eq 1>#stock_count_#<cfelse>0</cfif>,
                    <cfif stock_type_ eq -1>#stock_count_#<cfelse>0</cfif>,
                    #attributes.department_id#,
                    1,
                    #attributes.process_date#,
                    #attributes.process_date#,
                    '#attributes.table_code#'
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cftransaction>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.manage_stocks&table_code=#attributes.table_code#</cfoutput>";
</script>