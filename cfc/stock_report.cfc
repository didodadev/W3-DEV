<cffunction name="getStock" access="remote" returntype="struct">
	<cfargument name="page" required="true" />
	<cfargument name="pageSize" required="true" />
	<cfargument name="gridsortcolumn" required="true" />
	<cfargument name="gridsortdirection" required="true" />
	
	<cfif arguments.gridsortcolumn eq "">
		<cfset arguments.gridsortcolumn = "STOCK_CODE" />
		<cfset arguments.gridsortdirection = "asc" />
	</cfif>

	<cfquery name="get_stock_analyse" datasource="workcube_cf_report">
		select		*
		from		GET_ALL_STOCK_REPORT
		order by	#arguments.gridsortcolumn# #arguments.gridsortdirection#
	</cfquery>

	<cfreturn queryconvertforgrid(get_stock_analyse, page, pagesize) />
</cffunction>

