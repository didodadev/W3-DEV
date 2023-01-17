<cf_date tarih = 'attributes.START_DATE'>
<cf_date tarih = 'attributes.FINISH_DATE'>
<cfif isdefined('attributes.type') and len(attributes.type)>
	<cfif attributes.type eq 1><!--- 1=satınalma --->
		<cfset TABLE_NAME ='CONTRACT_PURCHASE_GENERAL_DISCOUNT'>
		<cfset BRACH_TABLE ='CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES'>
	<cfelseif attributes.type eq 2><!--- 2=satış --->
		<cfset TABLE_NAME ='CONTRACT_SALES_GENERAL_DISCOUNT'>
		<cfset BRACH_TABLE ='CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES'>
	</cfif>
</cfif>
<CFTRANSACTION>
	<cfquery name="UPD_PURCHASE_GENERAL_DISCOUNT" datasource="#dsn3#">
		UPDATE
			#TABLE_NAME#
		SET	
			DISCOUNT_HEAD=<cfif len(attributes.DISCOUNT_HEAD)>'#attributes.DISCOUNT_HEAD#'<cfelse>NULL</cfif>,
			START_DATE=<cfif len(attributes.START_DATE)>#attributes.START_DATE#<cfelse>NULL</cfif>,
			FINISH_DATE=<cfif len(attributes.FINISH_DATE)>#attributes.FINISH_DATE#<cfelse>NULL</cfif>,
			DISCOUNT=<cfif len(attributes.DISCOUNT)>#attributes.DISCOUNT#<cfelse>NULL</cfif>,
			UPDATE_EMP=#session.ep.userid#, 
			UPDATE_IP='#REMOTE_ADDR#', 
			UPDATE_DATE=#now()#
		WHERE
			GENERAL_DISCOUNT_ID = #attributes.GENERAL_DISCOUNT_ID#
	</cfquery>
	<cfquery name="DEL_CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES" datasource="#dsn3#">
		DELETE FROM #BRACH_TABLE# WHERE GENERAL_DISCOUNT_ID = #attributes.GENERAL_DISCOUNT_ID#
	</cfquery>
	<cfloop list="#attributes.BRANCHES#" index="branch_id_ind">
		<cfquery name="ADD_CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES" datasource="#dsn3#">
			INSERT INTO #BRACH_TABLE#
			(
				GENERAL_DISCOUNT_ID,
				BRANCH_ID
			)
			VALUES
			(
				#attributes.GENERAL_DISCOUNT_ID#,
				#branch_id_ind#
			)
		</cfquery>
	</cfloop>
</CFTRANSACTION>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' , 'unique_comp_discount_id');
	</cfif>
</script>

