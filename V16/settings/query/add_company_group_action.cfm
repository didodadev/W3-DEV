<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_action" datasource="#dsn#">
			DELETE FROM COMPANY_GROUP_ACTIONS
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
				<cfquery name="add_action" datasource="#dsn#">
					INSERT INTO 
						COMPANY_GROUP_ACTIONS 
						(
							FROM_OUR_COMP_ID,
							FROM_ACT_TYPE,
							FROM_COMPANY_ID,
							FROM_PROCESS_STAGE,
							FROM_PROCESS_TYPE,
							TO_OUR_COMP_ID,
							TO_ACT_TYPE,
							TO_COMPANY_ID,
							TO_PROCESS_STAGE,
							TO_PROCESS_TYPE,
							TO_PAYMETHOD_ID,
							TO_DEPT_ID,
							TO_LOC_ID,
							TO_PRICE_CAT,
							TO_SALE_EMP,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES     
						(
							<cfif len(evaluate("attributes.from_our_company#i#"))>#evaluate("attributes.from_our_company#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.from_act_type#i#"))>#evaluate("attributes.from_act_type#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.from_company_id#i#")) and len(evaluate("attributes.from_comp_name#i#"))>#evaluate("attributes.from_company_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.from_process_stage#i#"))>#evaluate("attributes.from_process_stage#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.from_process_type#i#"))>#evaluate("attributes.from_process_type#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.to_our_company#i#"))>#evaluate("attributes.to_our_company#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.to_act_type#i#"))>#evaluate("attributes.to_act_type#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.to_company_id#i#")) and len(evaluate("attributes.to_comp_name#i#"))>#evaluate("attributes.to_company_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.to_process_stage#i#"))>#evaluate("attributes.to_process_stage#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.to_process_type#i#"))>#evaluate("attributes.to_process_type#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.paymethod#i#")) and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.deliver_dept#i#")) and len(evaluate("attributes.deliver_dept_id#i#"))>#listgetat(evaluate("attributes.deliver_dept_id#i#"),1,'-')#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.deliver_dept#i#")) and len(evaluate("attributes.deliver_dept_id#i#"))>#listgetat(evaluate("attributes.deliver_dept_id#i#"),2,'-')#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.price_catid#i#"))>#evaluate("attributes.price_catid#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.employee_id_#i#"))>#evaluate("attributes.employee_id_#i#")#<cfelse>NULL</cfif>,
							#now()#,
							#session.ep.userid#, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#cgi.referer#" addtoken="no">
