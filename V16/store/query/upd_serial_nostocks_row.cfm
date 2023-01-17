<cfif isdefined("attributes.serial_no_start_number#i#") and listlen(evaluate("attributes.serial_no_start_number#i#")) >
	<cfset dizimiz = evaluate("attributes.serial_no_start_number#i#")>
	<cfloop list="#dizimiz#" index="kkk_dizi">
		<cfquery name="get_ser" datasource="#DSN2#">
			SELECT 
            	*  
            FROM 
            	SERVICE_STOCKS_ROW 
            WHERE 
            	PRODUCT_SERIAL_NUMBER = '#kkk_dizi#' AND STOCK_ID = #evaluate("attributes.stock_id#i#")#
		</cfquery>
		<cfif get_ser.recordcount>
			<cfquery name="del_ser" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ser.SERVICE_STOCK_ROW_ID# AND PROCESS_TYPE = 140
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
