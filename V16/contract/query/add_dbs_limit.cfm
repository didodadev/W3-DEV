<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Company'ye ait dbs limit tanimlari siliniyor, yeniden yazilacak --->
		<cfquery name="del_dbs_limit" datasource="#dsn#">
			DELETE FROM
				COMPANY_CREDIT_DBS
			WHERE
				COMPANY_ID = #attributes.company_id#
				AND OUR_COMPANY_ID = #attributes.our_cmp_id_#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num_dbs#" index="i">
			<cfif evaluate("attributes.row_kontrol_dbs#i#") neq 0>
				<cfquery name="add_dbs_limit" datasource="#DSN#">
					INSERT INTO
						COMPANY_CREDIT_DBS
					(
						COMPANY_ID,
						OUR_COMPANY_ID,
						PRIORITY,
						BANK_ID,
						BRANCH_ID,
						LIMIT,
						AVAILABLE_LIMIT,
						CREDIT_USED_AMOUNT,
						CURRENCY_ID,
						IS_ACTIVE,	
						IS_OLD,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						#attributes.company_id#,
						#attributes.our_cmp_id_#,
						<cfif isdefined("attributes.priority#i#") and len(evaluate("attributes.priority#i#"))>#evaluate("attributes.priority#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.bank_id#i#") and len(evaluate("attributes.bank_id#i#"))>#evaluate("attributes.bank_id#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.bank_branch_id#i#") and len(evaluate("attributes.bank_branch_id#i#"))>#evaluate("attributes.bank_branch_id#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.limit#i#") and len(evaluate("attributes.limit#i#"))>#filternum(evaluate("attributes.limit#i#"))#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.available_limit#i#") and len(evaluate("attributes.available_limit#i#"))>#filternum(evaluate("attributes.available_limit#i#"))#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.credit_used_amount#i#") and len(evaluate("attributes.credit_used_amount#i#"))>#filternum(evaluate("attributes.credit_used_amount#i#"))#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.money_id#i#") and len(evaluate("attributes.money_id#i#"))>'#evaluate("attributes.money_id#i#")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_active#i#") and  len(evaluate("attributes.is_active#i#"))>1<cfelse>0</cfif>,
						1,
						#session.ep.userid#,
						'#remote_addr#',
						#now()#
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#attributes.company_id#">

