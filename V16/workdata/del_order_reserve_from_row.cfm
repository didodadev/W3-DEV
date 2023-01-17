<!--- 
	amac            : CFTOKEN,STOCK_ID vererek ORDER_ROW_RESERVED den ilgili kayıtları silmek (pda de basket ten satır silindiğinde rezerve edilen ürünleri de siler)
	parametre adi   : cftoken
	ayirma isareti  : ,
	kullanim        : del_order_reserve_from_row('35345345,45') 
	WORKDATA kullanim: workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+get_stock_id.STOCK_ID+'')
	Yazan           : A.Selam Karatas
	Tarih           : 5.12.2007
	Guncelleme      : 5.12.2007
 --->
<cffunction name="del_order_reserve_from_row" access="public" returnType="any" output="no">
	<cfargument name="cftoken_stock_id" required="yes" type="string" default=""><!--- 1:CFTOKEN,2:STOCK_ID,3:RESERVE_STOCK_OUT,4:out / in --->
	<cfquery name="del_order_reserve_from_row" datasource="#DSN3#" maxrows="1">
		DELETE FROM 
			ORDER_ROW_RESERVED 
		WHERE 
			PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.cftoken_stock_id,1)#"> AND 
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,2)#"> AND 
            <cfif not len(listgetat(arguments.cftoken_stock_id,4)) or listgetat(arguments.cftoken_stock_id,4) is 'out'>
			RESERVE_STOCK_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,3)#"> 
            <cfelseif listgetat(arguments.cftoken_stock_id,4) is 'in'>
			RESERVE_STOCK_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,3)#"> 
            </cfif>
            AND ROW_RESERVED_ID = 
                (	SELECT MAX(ROW_RESERVED_ID) FROM ORDER_ROW_RESERVED WHERE 
                    PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.cftoken_stock_id,1)#"> AND 
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,2)#"> AND 
                    <cfif not len(listgetat(arguments.cftoken_stock_id,4)) or listgetat(arguments.cftoken_stock_id,4) is 'out'>
                    RESERVE_STOCK_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,3)#"> 
                    <cfelseif listgetat(arguments.cftoken_stock_id,4) is 'in'>
                    RESERVE_STOCK_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cftoken_stock_id,3)#"> 
                    </cfif>
                )
	</cfquery>
	<!--- <cfreturn del_order_reserve_from_row> --->
</cffunction>
