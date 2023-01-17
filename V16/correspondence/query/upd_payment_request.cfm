<cfif isdefined("attributes.del_id")>
	<cfquery name="del_rec" datasource="#DSN#">
		DELETE 
		FROM
			CORRESPONDENCE_PAYMENT
		WHERE
			ID=#attirbutes.del_id#
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif emp_id neq 1>
	<cfset TO_EMPS = "">
	<cfset TO_PARS = "">
	<cfset TO_CONS = "">
	<cfset TO_GRPS = "">
	<cfloop LIST="#FORM.EMP_ID#" INDEX="I">
		<cfif I CONTAINS "EMP">
			<cfset TO_EMPS = LISTAPPEND(TO_EMPS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "PAR">
		<cfset TO_PARS = LISTAPPEND(TO_PARS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "CON">
			<cfset TO_CONS = LISTAPPEND(TO_CONS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "GRP">
			<cfset TO_GRPS = LISTAPPEND(TO_GRPS,LISTGETAT(I,2,"-"))>
		</cfif>
	</cfloop> 
</cfif>
<cfif emp_id_cc neq 1>
	<cfset CC_EMPS = "">
	<cfset CC_PARS = "">
	<cfset CC_CONS = "">
	<cfset CC_GRPS = "">
	<cfloop LIST="#FORM.EMP_ID_CC#" INDEX="I">
		<cfif I CONTAINS "EMP">
			<cfset CC_EMPS = LISTAPPEND(CC_EMPS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "PAR">
		<cfset CC_PARS = LISTAPPEND(CC_PARS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "CON">
			<cfset CC_CONS = LISTAPPEND(CC_CONS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "GRP">
			<cfset CC_GRPS = LISTAPPEND(CC_GRPS,LISTGETAT(I,2,"-"))>
		</cfif>
	</cfloop>
</cfif>
<cf_date tarih='attributes.due_date'>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_PAYMENT_REQUEST" datasource="#dsn#">
			UPDATE
				CORRESPONDENCE_PAYMENT
			SET
			<cfif FORM.EMP_ID NEQ 1>
				<cfif len(TO_EMPS)>
					TO_EMP=',#TO_EMPS#,',
				<cfelse>
					TO_EMP=NULL,
				</cfif>	
				<cfif len(TO_PARS)>
					TO_PARS=',#TO_PARS#,',
				<cfelse>
					TO_PARS=NULL,
				</cfif>
				<cfif len(TO_CONS)>
					TO_CONS=',#TO_CONS#,',
				<cfelse>
					TO_CONS=NULL,
				</cfif>
			</cfif>
			<cfif FORM.EMP_ID_CC NEQ 1>
				<cfif len(CC_EMPS)>
					CC_EMP=',#CC_EMPS#,',
				<cfelse>
					CC_EMP=NULL,
				</cfif>
				<cfif len(CC_PARS)>
					CC_PARS=',#CC_PARS#,',
				<cfelse>
					CC_PARS=NULL,
				</cfif>
				<cfif len(CC_CONS)>
					CC_CONS=',#CC_CONS#,',
				<cfelse>
					CC_CONS=NULL,
				</cfif>
			</cfif>
				RECORD_EMP=#SESSION.EP.USERID#,
				RECORD_DATE=#now()#,
			<cfif isdefined("PRIORITY")>
				PRIORITY=#PRIORITY#, 
			</cfif>
				SUBJECT = '#SUBJECT#',
				DUEDATE = #attributes.due_date#,                                                
				PAYMETHOD_ID = #pay_method#, 
				<cfif len(COMPANY_ID)>
					TO_COMPANY_ID = #COMPANY_ID#,  
					TO_EMPLOYEE_ID = NULL,
				<cfelse>
					TO_EMPLOYEE_ID = #EMPLOYEE_ID#,
					TO_COMPANY_ID = NULL,
				</cfif>
				AMOUNT=#AMOUNT#,
				MONEY='#MONEY_ID#'
				<cfif isdefined('attributes.DETAIL')>
					,DETAIL='#DETAIL#'                             
				</cfif>                                                                                                                                                                    
				<cfif len(ORDER_ID)>
					,ORDER_ID=#ORDER_ID#
					,INVOICE_ID=-1
				<cfelse>
					,INVOICE_ID=#BILL_ID#
					,ORDER_ID=-1
				</cfif>
				,PERIOD_ID=#SESSION.EP.PERIOD_ID#
			WHERE 
				ID=#attributes.ID#
		</cfquery>
	</cftransaction>
</cflock>

<cflocation addtoken="no" url="#request.self#?fuseaction=correspondence.welcome" >
