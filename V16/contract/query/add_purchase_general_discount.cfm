<cf_date tarih = 'attributes.START_DATE'>
<cf_date tarih = 'attributes.FINISH_DATE'>
<cfif type eq 1><!--- Satın Alma ise --->
	<cfset TABLE_NAME ='CONTRACT_PURCHASE_GENERAL_DISCOUNT'>
	<cfset TABLE_BRANCH ='CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES'>
<cfelseif type eq 2>
	<cfset TABLE_NAME ='CONTRACT_SALES_GENERAL_DISCOUNT'>
	<cfset TABLE_BRANCH ='CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES'>	
</cfif>
<cflock name="#createuuid()#" timeout="50">
	<cftransaction>
		<cfquery name="ADD_PURCHASE_GENERAL_DISCOUNT" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO
				#TABLE_NAME#
			(
				COMPANY_ID,
				DISCOUNT_HEAD,
				START_DATE,
				FINISH_DATE,
				DISCOUNT,
				RECORD_EMP, 
				RECORD_IP, 
				RECORD_DATE
			)
			VALUES
			(
				'#COMPANY_ID#',
				<cfif len(attributes.DISCOUNT_HEAD)>'#attributes.DISCOUNT_HEAD#'<cfelse>NULL</cfif>,
				<cfif len(attributes.START_DATE)>#attributes.START_DATE#<cfelse>NULL</cfif>,
				<cfif len(attributes.FINISH_DATE)>#attributes.FINISH_DATE#<cfelse>NULL</cfif>,
				<cfif len(attributes.DISCOUNT)>#attributes.DISCOUNT#<cfelse>NULL</cfif>,
				#session.ep.userid#, 
				'#REMOTE_ADDR#', 
				#now()#
			)
		</cfquery>
		<cfloop list="#attributes.BRANCHES#" index="branch_id_ind">
			<cfquery name="ADD_CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES" datasource="#dsn3#">
				INSERT INTO
					#TABLE_BRANCH#
				(
					GENERAL_DISCOUNT_ID,
					BRANCH_ID
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#branch_id_ind#
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' , 'unique_comp_discount_id');
	</cfif>
</script>
