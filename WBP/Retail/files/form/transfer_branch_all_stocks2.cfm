<cf_date tarih = "attributes.search_startdate">

<cfset attributes.search_startdate = dateadd('h',23,attributes.search_startdate)>
<cfset attributes.search_startdate = dateadd('n',59,attributes.search_startdate)>

<cfquery name="get_transfer_stocks" datasource="#dsn2#" result="get_transfer_stocks_r">
	SELECT 
    	SUM(SR.STOCK_IN-SR.STOCK_OUT) AS TOTAL,
        SR.PRODUCT_ID,
        SR.STOCK_ID
  	FROM 
    	STOCKS_ROW SR
    WHERE
    	SR.STORE = #attributes.department_id# AND
        SR.PROCESS_DATE < #dateadd('d',1,attributes.search_startdate)#
    GROUP BY
    	SR.PRODUCT_ID,
        SR.STOCK_ID
</cfquery>

<!--- 2 adet transfer kodu olusturuyor --->
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

<cflock timeout="20">
    <cfquery name="get_table_no" datasource="#dsn2#">
        SELECT STOCK_NUMBER FROM #dsn_dev_alias#.SEARCH_TABLE_NO
    </cfquery>
    <cfset new_number = get_table_no.STOCK_NUMBER + 1>
    <cfquery name="upd_table_no" datasource="#dsn2#">
        UPDATE #dsn_dev_alias#.SEARCH_TABLE_NO SET STOCK_NUMBER = #new_number#
    </cfquery>
</cflock>
<cfset attributes.table_code_inner = new_number>
<cfloop from="1" to="#8-len(new_number)#" index="ccc">
    <cfset attributes.table_code_inner = "0" & attributes.table_code_inner>
</cfloop>
<!--- 2 adet transfer kodu olusturuyor --->

<cfquery name="get_dep" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
        D.DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<cfquery name="get_dep_in" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
        D.DEPARTMENT_ID = #attributes.in_department_id#
</cfquery>

<cfquery name="add_" datasource="#dsn2#" result="max_id">
    INSERT INTO 
        #dsn_dev_alias#.STOCK_MANAGE_TABLES
        (
        TABLE_CODE,
        TABLE_INFO,
        PROCESS_DATE,
        DEPARTMENT_ID,
        LOCATION_ID,
        IS_BRANCH_TRANSFER,
        RECORD_DATE,
        RECORD_EMP
        )
    VALUES
        (
        '#attributes.table_code#',
        'Şube Stok Taşıma : #get_dep.DEPARTMENT_HEAD# ---> #get_dep_in.DEPARTMENT_HEAD#',
        #attributes.search_startdate#,
        #attributes.department_id#,
        1,
        1,
        #now()#,
        #session.ep.userid#
        )
</cfquery>
<cfset attributes.table_id = max_id.IDENTITYCOL>

<cfquery name="add_" datasource="#dsn2#" result="max_id">
    INSERT INTO 
        #dsn_dev_alias#.STOCK_MANAGE_TABLES
        (
        TABLE_CODE,
        TABLE_INFO,
        PROCESS_DATE,
        DEPARTMENT_ID,
        LOCATION_ID,
        IS_BRANCH_TRANSFER,
        UPPER_TABLE_CODE,
        RECORD_DATE,
        RECORD_EMP
        )
    VALUES
        (
        '#attributes.table_code_inner#',
        'Şube Stok Taşıma : #get_dep.DEPARTMENT_HEAD# ---> #get_dep_in.DEPARTMENT_HEAD#',
        #attributes.search_startdate#,
        #attributes.in_department_id#,
        1,
        1,
        '#attributes.table_code#',
        #now()#,
        #session.ep.userid#
        )
</cfquery>
<cfset attributes.table_id_inner = max_id.IDENTITYCOL>

<cfoutput query="get_transfer_stocks">
	<cfset stock_id_ = STOCK_ID>
    <cfset product_id_ = PRODUCT_ID>
	<cfset stock_count_ = TOTAL>
    <cfif len(stock_count_) and stock_count_ neq 0>
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
                #product_id_#,
                -1,
                -1006,
                0,
                #stock_count_#,
                #attributes.department_id#,
                1,
                #attributes.search_startdate#,
                #attributes.search_startdate#,
                '#attributes.table_code#'
                )
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
                #product_id_#,
                -1,
                -1007,
                #stock_count_#,
                0,
                #attributes.in_department_id#,
                1,
                #attributes.search_startdate#,
                #attributes.search_startdate#,
                '#attributes.table_code_inner#'
                )
        </cfquery>
    </cfif>
</cfoutput>
<script>
	alert('Aktarım Tamamlandı!');
	window.location.href = '<cfoutput>#request.self#?fuseaction=retail.list_manage_stocks</cfoutput>';
</script>
<cfabort>