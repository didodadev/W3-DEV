<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('attributes.IS_DEFAULT') and attributes.IS_DEFAULT EQ 1>
			<cfquery name="UPDPRINTER" datasource="#dsn#">
				UPDATE SETUP_PRINTER SET IS_DEFAULT = 0
			</cfquery>		 
		</cfif>
		<cfquery name="UPDPRINTER" datasource="#dsn#">
			UPDATE 
				SETUP_PRINTER
			SET 
				PRINTER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PRINTER_NAME#">,
				IS_DEFAULT = <cfif isdefined('attributes.IS_DEFAULT')>#attributes.IS_DEFAULT#<cfelse>0</cfif>
			WHERE 
				PRINTER_ID = #attributes.PRINTER_ID#
		</cfquery>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY
		</cfquery>
		<cfoutput query="get_company">
			<cfset new_dsn3 = '#dsn#_#comp_id#'>
			<cfquery name="delete_paper" datasource="#dsn#">
				DELETE FROM #new_dsn3#.PAPERS_NO WHERE PRINTER_ID = #attributes.PRINTER_ID#
			</cfquery>		
		</cfoutput>
		<cfloop from="1" to="#attributes.record_num#" index="i">
		 <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
		 	<cfset new_dsn3 = '#dsn#_#evaluate("attributes.our_company#i#")#'>
			<cfif (isdefined("attributes.e_invoice_no#i#") and len(evaluate("attributes.e_invoice_no#i#")) and len(evaluate("attributes.e_invoice_number#i#"))) or (len(evaluate("attributes.revenue_receipt_no#i#")) and len(evaluate("attributes.revenue_receipt_number#i#"))) or (len(evaluate("attributes.invoice_no#i#")) and len(evaluate("attributes.invoice_number#i#"))) or (len(evaluate("attributes.ship_no#i#")) and len(evaluate("attributes.ship_number#i#")))>
				<cfquery name="ADD_PAPER" datasource="#dsn#">
				INSERT INTO 
					#new_dsn3#.PAPERS_NO 
					(
					   REVENUE_RECEIPT_NO,
					   REVENUE_RECEIPT_NUMBER,
					   INVOICE_NO,
					   INVOICE_NUMBER,
					   E_INVOICE_NO,
					   E_INVOICE_NUMBER,
					   SHIP_NO,
					   SHIP_NUMBER,
					   PRINTER_ID
					)
					VALUES     
					(
					   <cfif len(evaluate("attributes.revenue_receipt_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.revenue_receipt_no#i#")#'><cfelse>NULL</cfif>,
					   <cfif len(evaluate("attributes.revenue_receipt_number#i#"))>#evaluate("attributes.revenue_receipt_number#i#")#<cfelse>NULL</cfif>,
					   <cfif len(evaluate("attributes.invoice_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.invoice_no#i#")#'><cfelse>NULL</cfif>,
					   <cfif len(evaluate("attributes.invoice_number#i#"))>#evaluate("attributes.invoice_number#i#")#<cfelse>NULL</cfif>,
					   <cfif session.ep.our_company_info.is_efatura and len(evaluate("attributes.e_invoice_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.e_invoice_no#i#")#'><cfelse>NULL</cfif>,
					   <cfif session.ep.our_company_info.is_efatura and len(evaluate("attributes.e_invoice_number#i#"))>#evaluate("attributes.e_invoice_number#i#")#<cfelse>NULL</cfif>,
					   <cfif len(evaluate("attributes.ship_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.ship_no#i#")#'><cfelse>NULL</cfif>,
					   <cfif len(evaluate("attributes.ship_number#i#"))>#evaluate("attributes.ship_number#i#")#<cfelse>NULL</cfif>,
					   #attributes.PRINTER_ID#
					)
				</cfquery>
			</cfif>
		 </cfif>
		</cfloop>
	</cftransaction>
	<cfif isdefined("attributes.TO_EMP_IDS")>
		<cfquery name="get_all_emps" datasource="#dsn#">
			SELECT PRINTER_EMP_ID FROM SETUP_PRINTER_USERS WHERE PRINTER_EMP_ID IN (#attributes.TO_EMP_IDS#) AND PRINTER_ID <> #attributes.PRINTER_ID#
		</cfquery>
		<cfif get_all_emps.recordcount>
			<cfset emp_list = ''>
			<cfoutput query="get_all_emps">
				<cfif len(printer_emp_id) and not listfind(emp_list,printer_emp_id)>
					<cfset emp_list=listappend(emp_list,printer_emp_id)>
				</cfif>	
			</cfoutput>
			<cfif listlen(emp_list)>
				<cfset emp_list=listsort(emp_list,"numeric","ASC",',')>
				<cfquery name="get_employee" datasource="#dsn#">
					SELECT
						EMPLOYEE_NAME +' ' + EMPLOYEE_SURNAME AS FULLNAME
					FROM 
						EMPLOYEES 
					WHERE
						EMPLOYEE_ID IN (#emp_list#)
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
			</cfif>
			<cfset main_emp_list = valuelist(get_employee.FULLNAME,',')>
			<cfif len(main_emp_list)>
				<script type="text/javascript">
					alert("<cf_get_lang no ='2516.Seçtiğiniz Çalışanlara Ait Yazıcı Grup Tanımlamaları Bulunmaktadır'>.<cf_get_lang no ='2554.Çalışan Listesi'>  :'<cfoutput>#main_emp_list#</cfoutput>'  !");
					window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn#">
			DELETE FROM SETUP_PRINTER_USERS WHERE PRINTER_ID = #attributes.PRINTER_ID#
		</cfquery>
		<cfloop list="#attributes.TO_EMP_IDS#" delimiters="," index="ind_i">
			<cfquery name="add_printer_users" datasource="#dsn#">
				INSERT INTO SETUP_PRINTER_USERS
					(PRINTER_ID,PRINTER_EMP_ID)
				VALUES
					(#attributes.PRINTER_ID#,#ind_i#)
			</cfquery>
		</cfloop>
	<cfelse>
		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn#">
			DELETE FROM SETUP_PRINTER_USERS WHERE PRINTER_ID = #attributes.PRINTER_ID#
		</cfquery>
	</cfif>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_printer&ID=#attributes.PRINTER_ID#" addtoken="no">
