<cfset new_basket = DeserializeJSON(attributes.print_note)>

<cfset myQuery = QueryNew("ROW_ID,DEPARTMENT_OUT,DEPARTMENT_IN,SHIP_DATE,STOCK_ID,PRODUCT_ID,AMOUNT,NAME_PRODUCT,TAX", "Integer,Integer,Integer,Date,Integer,Integer,Decimal,VarChar,Integer")>
<cfset query_count = 0>

<cfloop from="1" to="#arraylen(new_basket)#" index="ccc">
	<cfset stock_id = new_basket[ccc].stock_id>
    <cfset product_id = listfirst(new_basket[ccc].product_code,'_')>
    <cfset product_name = new_basket[ccc].product_name>
    <cfset depo_id = listlast(new_basket[ccc].product_code,'_')>
    
    <cfquery name="GET_PROD" datasource="#DSN1#">
        SELECT
            P.TAX
        FROM
            STOCKS S INNER JOIN
            PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
        WHERE
            S.STOCK_ID =  #stock_id#  
    </cfquery>
    
	<cfloop from="1" to="#listlen(attributes.department_id_list)#" index="aaa">
    	<cfset in_depo_id = listgetat(attributes.department_id_list,aaa)>
		<cfset miktar = evaluate("new_basket[ccc].reel_dagilim_#in_depo_id#")>
        <cfset onay = evaluate("new_basket[ccc].onay_#in_depo_id#")>
    
		<cfif onay is 'YES' and miktar is not 'null' and miktar gt 0>
        	<cfset query_count = query_count + 1>
            <cfset newRow = QueryAddRow(MyQuery,1)>
            <cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_IN","#in_depo_id#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_OUT","#depo_id#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"SHIP_DATE","#now()#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#product_id#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"AMOUNT","#miktar#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"NAME_PRODUCT","#product_name#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"TAX","#GET_PROD.TAX#",query_count)>
        </cfif>
    </cfloop>
</cfloop>
<cf_popup_box title="DepolarArası Toplu Sevk Talebi">
	<cfif myQuery.recordcount eq 0>
    	Herhangi bir sevk talebi oluşturulmadı!
    	<cfexit method="exittemplate">
    </cfif>

<cfquery name="get_table_no" datasource="#dsn_dev#">
    SELECT TABLE_CODE FROM SEARCH_TABLE_NO
</cfquery>
<cfset new_number = get_table_no.TABLE_CODE + 1>
<cfquery name="upd_table_no" datasource="#dsn_dev#">
    UPDATE SEARCH_TABLE_NO SET TABLE_CODE = #new_number#
</cfquery>

<cfset wrk_id = new_number>
<cfloop from="1" to="#8-len(new_number)#" index="ccc">
    <cfset wrk_id = "0" & wrk_id>
</cfloop>
    
    <cftransaction>
        <cfquery name="get_group" dbtype="query">
            SELECT
                DISTINCT
                    DEPARTMENT_IN,
                    DEPARTMENT_OUT
            FROM
                myQuery
        </cfquery>
        <cfoutput query="get_group">
            <cfquery name="get_rows" dbtype="query">
                SELECT
                    *
                FROM
                    myQuery
                WHERE
                    DEPARTMENT_IN = #DEPARTMENT_IN# AND
                    DEPARTMENT_OUT = #DEPARTMENT_OUT#
            </cfquery>
    
            <cfquery name="ADD_SALE" datasource="#DSN2#" result="MAX_ID">
            INSERT INTO
                SHIP_INTERNAL
            (
                CODE,
                SHIP_DATE,
                DELIVER_DATE,
                PROCESS_STAGE,
                DISCOUNTTOTAL,
                NETTOTAL,
                GROSSTOTAL,
                TAXTOTAL,
                MONEY,
                RATE1,
                RATE2,
                DEPARTMENT_OUT,
                LOCATION_OUT,
                DEPARTMENT_IN,
                LOCATION_IN,
                DETAIL,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES
            (
                '#wrk_id#',
                #NOW()#,
                #NOW()#,
                53,
                0,
                0,
                0,
                0,
                'TL',
                1,
                1,
                #get_group.DEPARTMENT_OUT#,
                1,
                #get_group.DEPARTMENT_IN#,
                1,
                NULL,
                #now()#,
                #session.ep.userid#
            )
        </cfquery>        
            <cfset lsat_order_id_ = MAX_ID.IDENTITYCOL>
       
        <cfloop query="get_rows"> 
            <cfset stock_id_ = get_rows.STOCK_ID>
            <cfset product_id_ = get_rows.PRODUCT_ID>
            <cfset amount_ = get_rows.AMOUNT>
            <cfquery name="GET_UNIT" datasource="#DSN2#">
                SELECT
                    PRODUCT_UNIT_ID,
                    MAIN_UNIT
                FROM
                    #dsn1#.PRODUCT_UNIT
                WHERE
                    PRODUCT_ID = #get_rows.product_id#
                    AND IS_MAIN = 1
            </cfquery>
            <cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
                INSERT INTO
                    SHIP_INTERNAL_ROW
                (
                    NAME_PRODUCT,
                    PAYMETHOD_ID,
                    DISPATCH_SHIP_ID,
                    STOCK_ID,
                    PRODUCT_ID,
                    AMOUNT,
                    UNIT,
                    UNIT_ID,
                    TAX,
                    DELIVER_DEPT,
                    DELIVER_LOC,
                    PRICE,
                    PRICE_OTHER
                )
                VALUES
                (
                    '#get_rows.name_product#',
                    NULL,
                    #MAX_ID.IDENTITYCOL#,
                    #stock_id#,
                    #product_id#,
                    #amount#,
                    '#GET_UNIT.MAIN_UNIT#',
                    #GET_UNIT.PRODUCT_UNIT_ID#,
                    #get_rows.TAX#,
                    #get_group.DEPARTMENT_OUT#,
                    1,
                    0,
                    0
                )
            </cfquery>
        </cfloop>
        </cfoutput>
    </cftransaction>

<cfif attributes.is_from_list eq 1>
	<cfquery name="add_" datasource="#dsn_dev#">
        DELETE FROM
            STOCK_TRANSFER_LIST
        WHERE
            DEPARTMENT_ID = #attributes.department_id#
    </cfquery>
</cfif>

    <div align="center">
        <br />
        <br />
        <span class="headbold">İşlem Kodu : <cfoutput>#wrk_id#</cfoutput></span> <br />
        Bu Kodu Not Ediniz!
    </div>
</cf_popup_box>