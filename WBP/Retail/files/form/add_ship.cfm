<cfoutput>#attributes.SELECTED_PRODUCT_LIST#</cfoutput>

<cfset myQuery = QueryNew("ROW_ID,DEPARTMENT_OUT,DEPARTMENT_IN,SHIP_DATE,STOCK_ID,PRODUCT_ID,AMOUNT,NAME_PRODUCT,TAX", "Integer,Integer,Integer,Date,Integer,Integer,Decimal,VarChar,Integer")>
<cfset query_count = 0>

<cfloop list="#attributes.SELECTED_PRODUCT_LIST#" index="product_id">
	<cfset stock_list = evaluate("attributes.PRODUCT_STOCK_LIST_#product_id#")>
    <cfloop list="#stock_list#" index="stock_id">
        <cfloop list="#attributes.DEPARTMENT_ID_LIST#" index="depo_id">
            <cfset amount1 = evaluate("attributes.sevk_islemi_#stock_id#_#depo_id#")>
            <cfoutput>
                	attributes.sevk_islemi_#stock_id#_#depo_id#: #amount1#<br />
				<cfloop list="#amount1#" index="i">
                
                	<cfif listgetat(i,2,'-') gt 0>
                		stock_id: #stock_id# -- çıkış depo:#depo_id# -- giriş depo: #listgetat(i,1,'-')# -- miktar: #listgetat(i,2,'-')# <br />
                        <cfquery name="GET_PROD" datasource="#DSN1#">
                        	SELECT
                            	P.*
                            FROM
                            	STOCKS S INNER JOIN
                                PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
                            WHERE
                            	S.STOCK_ID =  #stock_id#  
                        </cfquery>
						<cfset query_count = query_count + 1>
                        <cfset newRow = QueryAddRow(MyQuery,1)>
                        <cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_IN","#listgetat(i,1,'-')#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_OUT","#depo_id#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"SHIP_DATE","#now()#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#GET_PROD.product_id#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"AMOUNT","#listgetat(i,2,'-')#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"NAME_PRODUCT","#GET_PROD.PRODUCT_NAME#",query_count)>
                        <cfset temp = QuerySetCell(myQuery,"TAX","#GET_PROD.TAX#",query_count)>
                    </cfif>
                </cfloop>
			</cfoutput>
            
        </cfloop>
    </cfloop>
</cfloop>

<cfif myQuery.recordcount>
<cftransaction>
    <cfquery name="get_group" dbtype="query">
        SELECT
            DISTINCT
                DEPARTMENT_IN,
                DEPARTMENT_OUT
        FROM
            myQuery
    </cfquery>
    <cfdump var="#get_group#">
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
        <cfdump var="#GET_ROWS#">

		<cfquery name="ADD_SALE" datasource="#DSN2#" result="MAX_ID">
		INSERT INTO
			SHIP_INTERNAL
		(
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
<cfelse>
	İlgili Sevk İrsaliyesi Satırı Bulunamadı!
</cfif>