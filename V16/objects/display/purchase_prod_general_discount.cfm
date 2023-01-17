<!--- // indirimler(ALIŞ VE SATIŞ) anlaşmada genel indirimler tanımlı ise ---><!---  --->
<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="10">
	SELECT
		1 TYPE,<!--- 1 SATINALMA --->
		CPGD.COMPANY_ID,
		CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID,
		CPGD.DISCOUNT,
		CPGD.START_DATE,
		CPGD.FINISH_DATE,
		CPGD.GENERAL_DISCOUNT_ID,
		CPGD.DISCOUNT_HEAD,
		CPGD.RECORD_EMP,
		CPGD.RECORD_DATE,
		CPGD.UPDATE_EMP,
		CPGD.UPDATE_DATE
	FROM
		CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
		CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES
	WHERE
		CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID = #attributes.branch_id# AND
		CPGD.COMPANY_ID=#attributes.company_id# AND
		CPGD.GENERAL_DISCOUNT_ID = CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.GENERAL_DISCOUNT_ID 
UNION ALL
	SELECT
		2 TYPE,<!--- SATIŞ --->
		CSGD.COMPANY_ID,
		CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID,
		CSGD.DISCOUNT,
		CSGD.START_DATE,
		CSGD.FINISH_DATE,
		CSGD.GENERAL_DISCOUNT_ID,
		CSGD.DISCOUNT_HEAD,
		CSGD.RECORD_EMP,
		CSGD.RECORD_DATE,
		CSGD.UPDATE_EMP,
		CSGD.UPDATE_DATE
	FROM
		CONTRACT_SALES_GENERAL_DISCOUNT AS CSGD,
		CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES
	WHERE
		CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID = #attributes.branch_id# AND
		CSGD.COMPANY_ID=#attributes.company_id# AND
		CSGD.GENERAL_DISCOUNT_ID = CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES.GENERAL_DISCOUNT_ID 

	ORDER BY
		CPGD.GENERAL_DISCOUNT_ID
</cfquery>
<cfquery name="get_company_name" datasource="#DSN#">
	SELECT FULLNAME,MEMBER_CODE,COMPANY_ID FROM COMPANY WHERE COMPANY_ID=#attributes.company_id#
</cfquery>
<thead>
	<tr>
		<th width="95"><cf_get_lang dictionary_id ='57630.Tip'></th>
		<th width="95"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
		<th width="130"><cf_get_lang dictionary_id='33134.Geçerlilik'></th>
		<th><cf_get_lang dictionary_id='57641.İSK'></th>
		<th width="120"><cf_get_lang dictionary_id='57483.Kayıt'></th>
	</tr>
</thead>
<tbody>
	<cfif get_c_general_discounts.recordcount>
		<cfset employee_list = ''>
		<cfoutput query="get_c_general_discounts">
			<cfif len(record_emp) and not listfind(employee_list,record_emp)>
				<cfset employee_list = listappend(employee_list,record_emp)>
			</cfif>
			<cfif len(update_emp) and not listfind(employee_list,update_emp)>
				<cfset employee_list = listappend(employee_list,update_emp)>
			</cfif>
		</cfoutput>
		<cfif len(employee_list)>
			<cfquery name="get_employee" datasource="#dsn#">
				SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#)
			</cfquery>
			<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_c_general_discounts">
			<tr class="color-row" height="20">
				<td><cfif TYPE eq 1><cf_get_lang dictionary_id='57449.Satın Alma'><cfelse><cf_get_lang dictionary_id ='57448.Satış'></cfif><!--- #CONTRACT_HEAD# ---></td>
				<td>#DISCOUNT_HEAD#</td>
				<td>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
				<td width="20" class="moneybox">#TLFormat(DISCOUNT)#</td>
				<td><cfif len(update_emp)>
						<strong><cf_get_lang dictionary_id='57891.Güncelleyen'>: </strong>#get_employee.employee_name[listfind(employee_list,update_emp,',')]# #get_employee.employee_surname[listfind(employee_list,update_emp,',')]#
						<cfif len(update_date)><br/>#dateformat(update_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),'HH:mm:ss')#)</cfif>
					<cfelseif len(record_emp)>
						<strong><cf_get_lang dictionary_id='57483.Kayit'>: </strong>#get_employee.employee_name[listfind(employee_list,record_emp,',')]# #get_employee.employee_surname[listfind(employee_list,record_emp,',')]#
						<cfif len(record_date)><br/>#dateformat(record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),'HH:mm:ss')#)</cfif>
					</cfif> 
				</td>
			</tr>
		</cfoutput> 
	</cfif>
</tbody>
