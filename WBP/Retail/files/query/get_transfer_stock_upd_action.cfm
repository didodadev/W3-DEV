<cfquery name="get_transfers" datasource="#dsn_Dev#">
    DELETE
    FROM
        STOCK_TRANSFER_LIST
    WHERE
        STOCK_ID = #attributes.stock_id# AND
        DEPARTMENT_ID = #attributes.department_id#
</cfquery>

<cfloop list="#attributes.department_id_list#" index="dept">
	<cfset deger_ = evaluate("attributes.amount_#dept#")>
    <cfif len(deger_) and deger_ gt 0>
    	<cfquery name="add_" datasource="#dsn_dev#">
        	INSERT INTO
            	STOCK_TRANSFER_LIST
                (
                STOCK_ID,
                DEPARTMENT_ID,
                AMOUNT,
                TO_DEPARTMENT_ID,
                RECORD_EMP,
                RECORD_DATE
                )
                VALUES
                (
                #attributes.stock_id#,
                #attributes.department_id#,
                #deger_#,
                #dept#,
                #session.ep.userid#,
                #now()#
                )
        </cfquery>
    </cfif>
</cfloop>