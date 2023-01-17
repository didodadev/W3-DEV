<cfif LEN(get_prod.SONUC_STOCK_ID) and  LEN(STATION_ID)>
	<cfset attributes.STOCK_IDS=get_prod.SONUC_STOCK_ID>
	<cfset attributes.report_ws_id=STATION_ID>
	<cfinclude template="../query/get_station_cost.cfm">
	<cfif GET_TOTAL.RECORDCOUNT>
		<cfset TPLM_WS=0>
		<cfset ENERGY=0>
		<cfloop   from="1" to="#GET_total.recordcount#"  index="k">
			<cfif LEN(GET_total.RESULT[k])>
				<cfset TPLM_WS=TPLM_WS+GET_total.RESULT[k]>										
			</cfif>

			<cfset ENERGY=ENERGY+#GET_total.ENERGY_T[k]#>										
		</cfloop>
		<cfset ENERGY=ENERGY/GET_TOTAL.RECORDCOUNT>	
		<cfset TPLM_WS=TPLM_WS/GET_TOTAL.RECORDCOUNT>									
		<cfset deger2=1>
		<cfif LEN(TPLM_WS)  >
			<cfset TOTAL_COST2=(TPLM_WS)>
			<cfoutput>#TLFormat(TOTAL_COST2)#&nbsp;#SESSION.EP.MONEY#</cfoutput>
		</cfif>
	</cfif>	
</cfif>			
