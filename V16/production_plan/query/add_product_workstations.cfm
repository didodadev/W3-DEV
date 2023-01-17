

<cfquery name="delete_workstations" datasource="#DSN3#">
    DELETE FROM WORKSTATION_PERIOD WHERE  CONCAT(',',STATION_ID,',') LIKE CONCAT('%,','#attributes.station_id_#',',%')   AND PERIOD_ID = #attributes.period_id#
</cfquery>
<!---<cfloop list="#attributes.station_id#" index="index">--->
	<cfquery name="upd_workstation" datasource="#dsn3#" result="cc">
		UPDATE WORKSTATIONS 
		SET REFLECTION_TYPE = #attributes.reflection_type#
		<cfif isdefined("attributes.prod_unit2") and len(attributes.prod_unit2)>,
			UNIT2 = '#attributes.prod_unit2#'
		</cfif> 
		WHERE STATION_ID IN (#attributes.station_id#)
	</cfquery>
<!---</cfloop>--->

<!--- Masraf Merkezi Yansıma Hesabı --->
<cfloop from="1" to="#attributes.record_num1#" index="i">
	<cfif evaluate("attributes.row_kontrol#i#") neq 0>
		<cfquery name="ADD_PRODUCT_WORKSTATION" datasource="#DSN3#">
			INSERT INTO 
				WORKSTATION_PERIOD
			(
				STATION_ID,
				PERIOD_ID,
				EXPENSE_ID,
				EXPENSE_SHIFT,
				COST_TYPE
			)
			VALUES
			(
				'#attributes.station_id#',
				#attributes.period_id#,
				'#wrk_eval("attributes.expense_id#i#")#',
				#evaluate("attributes.expense_shift#i#")#,
				#evaluate("attributes.expense_cost_type#i#")#
			)
		</cfquery>
	</cfif>
</cfloop>
<!--- Muhasebe Yansıma Hesabı --->
<cfloop from="1" to="#attributes.record_num2#" index="x">
	<cfif evaluate("attributes.row_kontrol2_#x#") neq 0>
        <cfquery name="ADD_PRODUCT_WORKSTATION_ACC" datasource="#DSN3#">
			INSERT INTO 
				WORKSTATION_PERIOD
			(
				STATION_ID,
				PERIOD_ID,
				ACCOUNT_ID,
				ACCOUNT_SHIFT,
				COST_TYPE
			)
			VALUES
			(
				'#attributes.station_id#',
				#attributes.period_id#,
				'#wrk_eval("attributes.account_id#x#")#',
				<cfif len(evaluate("attributes.account_shift#x#"))>#evaluate("attributes.account_shift#x#")#<cfelse>NULL</cfif>,
				#evaluate("attributes.account_cost_type#x#")#
			)
        </cfquery>
    </cfif>
</cfloop>
<script type="text/javascript">
	window.close();
</script>
