<cfinclude template="../query/get_purchase_prod_discount_detail.cfm">
<cfinclude template="../query/get_paymethods.cfm">
<thead>
	<tr>
		<th width="150"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='29533.Tedarikçi'></th>
		<th width="130"><cf_get_lang dictionary_id='33134.Geçerlilik'></th>
		<th colspan="5"><cf_get_lang dictionary_id='57641.İSK'></th>
		<th width="95"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
		<th width="75"><cf_get_lang dictionary_id='33133.Teslim'>/ <cf_get_lang dictionary_id='57490.Gün'></th>
		<th width="100"><cf_get_lang dictionary_id='57483.Kayıt'></th>
	</tr>
</thead>
<tbody>
	<cfif get_purchase_prod_discount_detail.recordcount>
		<cfset company_id_list =''>
		<cfset get_emp_list = ''>
		<cfoutput query="get_purchase_prod_discount_detail">
			<cfif len(company_id) and not listfind(company_id_list,company_id)>
				<cfset company_id_list=listappend(company_id_list,company_id)>
			</cfif>
			<cfif len(record_emp) and not listfind(get_emp_list,record_emp)>
				<cfset get_emp_list=listappend(get_emp_list,record_emp)>
			</cfif>
			<cfif len(update_emp) and not listfind(get_emp_list,update_emp)>
				<cfset get_emp_list=listappend(get_emp_list,update_emp)>
			</cfif>
		</cfoutput>
		<cfif len(company_id_list)>
			<cfquery name="get_company_name" datasource="#DSN#">
				SELECT FULLNAME, MEMBER_CODE, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#)
			</cfquery>
			<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_name.company_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(get_emp_list)>
			<cfquery name="get_employee" datasource="#dsn#">
				SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_emp_list#)
			</cfquery>
			<cfset get_emp_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_purchase_prod_discount_detail">
			<tr>
				<td><cfif len(company_id)>#get_company_name.member_code[listfind(company_id_list,company_id,',')]# #get_company_name.fullname[listfind(company_id_list,company_id,',')]#</cfif></td>
				<td><cfif len(start_date)>
						#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif>
					<cfelseif DateFormat(STARTDATE,dateformat_style) neq '01/01/1900'>
						#DateFormat(STARTDATE,dateformat_style)# - #DateFormat(FINISHDATE,dateformat_style)#
					</cfif>
				</td>
				<td width="20" class="moneybox"><cfif len(DISCOUNT1) and DISCOUNT1 gt 0>#TLFormat(DISCOUNT1)#</cfif></td>
				<td width="20" class="moneybox"><cfif len(DISCOUNT2) and DISCOUNT2 gt 0>#TLFormat(DISCOUNT2)#</cfif></td>
				<td width="20" class="moneybox"><cfif len(DISCOUNT3) and DISCOUNT3 gt 0>#TLFormat(DISCOUNT3)#</cfif></td>
				<td width="20" class="moneybox"><cfif len(DISCOUNT4) and DISCOUNT4 gt 0>#TLFormat(DISCOUNT4)#</cfif></td>
				<td width="20" class="moneybox"><cfif len(DISCOUNT5) and DISCOUNT5 gt 0>#TLFormat(DISCOUNT5)#</cfif></td>
				<td><cfset paymethod_idpaymethod_id = paymethod_id>
					<cfloop query="PAYMETHODS">
						<cfif paymethod_idpaymethod_id is PAYMETHODS.paymethod_id>#PAYMETHODS.paymethod#</cfif>
					</cfloop>
				</td>
				<td align="center">#delivery_dateno#</td>
				<td><cfif len(update_emp)>
						<strong><cf_get_lang dictionary_id='57891.Güncelleyen'>: </strong>#get_employee.employee_name[listfind(get_emp_list,update_emp,',')]# #get_employee.employee_surname[listfind(get_emp_list,update_emp,',')]#
						<cfif len(update_date)><br/>#dateformat(update_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),'HH:mm:ss')#)</cfif>
					<cfelseif len(record_emp)>
						<strong><cf_get_lang dictionary_id='57483.Kayıt'>: </strong>#get_employee.employee_name[listfind(get_emp_list,record_emp,',')]# #get_employee.employee_surname[listfind(get_emp_list,record_emp,',')]#
						<cfif len(record_date)><br/>#dateformat(record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),'HH:mm:ss')#)</cfif>
					</cfif> 
				</td>
			</tr>
		</cfoutput>
	</cfif> 
</tbody>
