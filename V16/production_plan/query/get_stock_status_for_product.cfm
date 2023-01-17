<cfquery name="GET_STRATEGY" dbtype="query">
	SELECT 
		MAXIMUM_STOCK,
		REPEAT_STOCK_VALUE,
		MINIMUM_STOCK
	FROM 
		GET_STRATEGIES
	WHERE 
		PRODUCT_ID = #PRODUCT_ID#
</cfquery>

 <cfif get_strategy.recordcount>
	  <cfif product_stock lt 0>
	  <cfset var_=1>
		  <cfset stock_status = '<font color="ff0000">Stok Yok</font>'>
	  <cfelseif product_stock lt get_strategy.MINIMUM_STOCK>
	  <cfset var_=2>
		  <cfset stock_status = '<font color="ff0000">Acil Sipariş Ver</font>'>
	  <cfelseif product_stock lt get_strategy.REPEAT_STOCK_VALUE>
		  <cfset var_=3>
		  <cfset stock_status = '<font color="009933">Sipariş Ver</font>'>
	  <cfelseif product_stock lt get_strategy.MAXIMUM_STOCK>
		  <cfset var_=4>
		  <cfset stock_status = "Yeterli Stok">
	  <cfelse>
	  <cfset var_=5>
		  <cfset stock_status = '<font color="6666FF">Fazla Stok</font>'>
	  </cfif>
 <cfelse>
		<cfset var_=0>
		<cfset stock_status = "Tanımsız">
 </cfif>

