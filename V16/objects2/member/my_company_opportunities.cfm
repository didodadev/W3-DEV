<cfsetting showdebugoutput="no">
<cfquery name="GET_OPPORTUNITY_LIST" datasource="#dsn3#">
	SELECT
		OPP_ID,
		OPP_NO,
		OPP_HEAD,
		OPP_DATE,
		OPP_STATUS,
		PROBABILITY,
		OPP_DETAIL,
		SALES_PARTNER_ID,
		SALES_EMP_ID
	FROM
		OPPORTUNITIES
	WHERE
		OPP_ID IS NOT NULL AND 
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	ORDER BY	
		OPP_DATE DESC
</cfquery>
<cfparam name="attributes.totalrecords" default="#GET_OPPORTUNITY_LIST.recordcount#">

<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr class="color-list" height="22">
				<td class="txtboldblue"><cf_get_lang dictionary_id='57487.No'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57480.Başlık'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id="34167.Satış Ortağı"></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id="44021.Görevli"></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57756.Durum'></td>
			</tr>
		</thead>
		<tbody>
			<cfset partner_id_list=''>
			<cfset sales_pcode_list=''>
			<cfset sales_partner_id_list=''>
			<cfoutput query="GET_OPPORTUNITY_LIST">
				<cfif len(sales_emp_id) and not listfind(sales_pcode_list,sales_emp_id)>
					<cfset sales_pcode_list=listappend(sales_pcode_list,sales_emp_id)>
				</cfif>
				<cfif len(sales_partner_id) and not listfind(partner_id_list,sales_partner_id)>
					<cfset partner_id_list=listappend(partner_id_list,sales_partner_id)>
				</cfif> 
				<cfif len(sales_partner_id) and not listFindnocase(sales_partner_id_list,sales_partner_id,',')>
					<cfset sales_partner_id_list = listAppend(sales_partner_id_list,sales_partner_id)>
				</cfif>
			</cfoutput>
			<cfif listlen(sales_pcode_list)>
			<cfset sales_pcode_list = listsort(sales_pcode_list,"numeric","ASC",",")>
			<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
				SELECT
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					EMPLOYEE_ID
				FROM
					EMPLOYEES
				WHERE
					EMPLOYEE_ID IN (#sales_pcode_list#)
				ORDER BY
					EMPLOYEE_ID
			</cfquery>
			<cfset main_sales_pcode_list = listsort(listdeleteduplicates(valuelist(get_position_detail.EMPLOYEE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(partner_id_list)>
			<cfset partner_id_list = listsort(partner_id_list,"numeric","ASC",",")>	
			<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
				SELECT
					CP.COMPANY_PARTNER_NAME,
					CP.COMPANY_PARTNER_SURNAME,
					CP.PARTNER_ID,						
					C.FULLNAME,
					C.NICKNAME
				FROM 
					COMPANY_PARTNER CP,
					COMPANY C
				WHERE 
					CP.PARTNER_ID IN (#partner_id_list#) AND
					CP.COMPANY_ID = C.COMPANY_ID
				ORDER BY
					CP.PARTNER_ID				
			</cfquery>
			<cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(sales_partner_id_list)>
			<cfset sales_partner_id_list = listsort(sales_partner_id_list,"numeric","ASC",",")>
				<cfquery name="get_sales_partner" datasource="#dsn#">
					SELECT
						CP.PARTNER_ID,
						C.COMPANY_ID,
						C.FULLNAME,
						C.NICKNAME,
						<cfif (database_type is 'MSSQL')>
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME
						<cfelseif (database_type is 'DB2')>
							CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME PARTNER_NAME
						</cfif>
					FROM
						COMPANY C,
						COMPANY_PARTNER CP
					WHERE
						C.COMPANY_ID = CP.COMPANY_ID AND
						CP.PARTNER_ID IN (#sales_partner_id_list#)
					ORDER BY
						CP.PARTNER_ID
				</cfquery>
			<cfset sales_partner_id_list = listsort(listdeleteduplicates(valuelist(get_sales_partner.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="GET_OPPORTUNITY_LIST" startrow="1" maxrows="#attributes.maxrows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="55">#OPP_NO#</td>
					<td width="40">#dateformat(OPP_DATE,'dd/mm/yyyy')#</td>
					<td><a href="#request.self#?fuseaction=objects2.dsp_opportunity&opp_id=#opp_id#" class="tableyazi">#OPP_HEAD#</a></td>
					<td><cfif len(sales_partner_id)>#get_sales_partner.nickname[listfind(sales_partner_id_list,sales_partner_id,',')]#</cfif></td>
					<td>
					<cfif len(sales_emp_id)>
						#get_position_detail.employee_name[listfind(main_sales_pcode_list,sales_emp_id,',')]# #get_position_detail.employee_surname[listfind(main_sales_pcode_list,sales_emp_id,',')]#
					<cfelseif len(sales_partner_id)>
						#get_partner_detail.company_partner_name[listfind(main_partner_id_list,sales_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,sales_partner_id,',')]#
					</cfif>
					</td>
					<cfif GET_OPPORTUNITY_LIST.OPP_STATUS eq 0>
						<td width="30"><cf_get_lang dictionary_id='57494.Pasif'></td>
					<cfelseif GET_OPPORTUNITY_LIST.OPP_STATUS eq 1>
						<td width="30"><cf_get_lang dictionary_id='57493.Aktif'></td>
					</cfif>
				</tr>
			</cfoutput>
			<cfif not GET_OPPORTUNITY_LIST.recordcount>
				<tr class="color-row">
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>