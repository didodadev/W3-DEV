<cfsetting showdebugoutput="no">
<cfquery name="get_send_camp" datasource="#dsn#">
	SELECT
		C.CAMP_ID,
		C.CAMP_HEAD,
		C.CAMP_STATUS,
		SC.CONT_ID,
		SC.SEND_PAR,
		SC.SEND_CON,
		SC.CONT_TYPE,
		SC.SEND_DATE,
		SC.SENDER_EMP
	FROM
		#dsn3_alias#.CAMPAIGNS C,	
		SEND_CONTENTS SC
	WHERE
		C.CAMP_ID = SC.CAMP_ID AND
		<!--- Iliskili partner ve consumer icin baglantilari da getiriyor fbs204101220 --->
		<cfif isdefined('attributes.list_partner') and ListLen(attributes.list_partner,',')>
		(	
		 <cfloop from="1" to="#listlen(list_partner)#" index="i"> 
			 SC.SEND_PAR = #ListGetAt(list_partner,i,',')#
			 <cfif i neq listlen(list_partner)>OR</cfif>
		</cfloop>
		)
		<cfelse>
		(	
			SC.SEND_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
			SC.SEND_PAR IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
		)
		</cfif>
	ORDER BY 
		SC.SEND_DATE
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th id="deneme_emin" width="150"><cf_get_lang dictionary_id ='57446.Kampanya'></th>
			<th width="120"><cf_get_lang dictionary_id ='57653.İçerik'></th>
			<th><cf_get_lang dictionary_id ='31907.Gönderilen'></th>
			<th><cf_get_lang dictionary_id ='31753.Gönderim Tarihi'></th>
			<th><cf_get_lang dictionary_id ='31754.Gönderen'></th>
			<th><cf_get_lang dictionary_id ='31755.Gönderim Türü'></th>
			<th><cf_get_lang dictionary_id ='57756.Durum'></th>
		</tr>
	</thead>	
	<tbody>
	<cfif get_send_camp.recordcount>
		<cfset send_par_list = "">
		<cfset send_cons_list = "">
		<cfset send_content_list = "">
		<cfset sender_emp_list = "">
		<cfoutput query="get_send_camp">
			<cfif Len(send_par) and not listFind(send_par_list,send_par,',')>
				<cfset send_par_list = ListAppend(send_par_list,send_par,',')>
			</cfif>
			<cfif Len(send_con) and not listFind(send_cons_list,send_con,',')>
				<cfset send_cons_list = ListAppend(send_cons_list,send_con,',')>
			</cfif>
			<cfif Len(cont_id) and not listFind(send_content_list,cont_id,',')>
				<cfset send_content_list = ListAppend(send_content_list,cont_id,',')>
			</cfif>
			<cfif Len(sender_emp) and not listFind(sender_emp_list,sender_emp,',')>
				<cfset sender_emp_list = ListAppend(sender_emp_list,sender_emp,',')>
			</cfif>
		</cfoutput>
		<cfif ListLen(send_par_list)>
			<cfquery name="Get_Partner_Info" datasource="#dsn#">
				SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#send_par_list#) ORDER BY PARTNER_ID
			</cfquery>
			<cfset send_par_list = ListSort(ListDeleteDuplicates(ValueList(Get_Partner_Info.Partner_Id,',')),'numeric','asc',',')>
		</cfif>
		<cfif ListLen(send_cons_list)>
			<cfquery name="Get_Consumer_Info" datasource="#dsn#">
				SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#send_cons_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset send_cons_list = ListSort(ListDeleteDuplicates(ValueList(Get_Consumer_Info.Consumer_Id,',')),'numeric','asc',',')>
		</cfif>
		<cfif ListLen(send_content_list)>
			<cfquery name="Get_Content_Info" datasource="#dsn#">
				SELECT CONTENT_ID, CONT_HEAD FROM CONTENT WHERE CONTENT_ID IN (#send_content_list#) ORDER BY CONTENT_ID
			</cfquery>
			<cfset send_content_list = ListSort(ListDeleteDuplicates(ValueList(Get_Content_Info.Content_Id,',')),'numeric','asc',',')>
		</cfif>
		<cfif ListLen(sender_emp_list)>
			<cfquery name="Get_Employees_Info" datasource="#dsn#">
				SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#sender_emp_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset sender_emp_list = ListSort(ListDeleteDuplicates(ValueList(Get_Employees_Info.Employee_Id,',')),'numeric','asc',',')>
		</cfif>
		<cfoutput query="get_send_camp">
			<tr>
				<td nowrap="nowrap"><a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" target="_blank">#camp_head#</a></td>
				<td nowrap="nowrap"><cfif Len(cont_id)>#Get_Content_Info.Cont_Head[ListFind(send_content_list,cont_id,',')]#</cfif></td>
				<td nowrap="nowrap">
					<cfif Len(send_par)>
						(K) #Get_Partner_Info.Company_Partner_Name[ListFind(send_par_list,send_par,',')]# #Get_Partner_Info.Company_Partner_SurName[ListFind(send_par_list,send_par,',')]#
					<cfelse>
						(B) #Get_Consumer_Info.Consumer_Name[ListFind(send_cons_list,send_con,',')]# #Get_Consumer_Info.Consumer_SurName[ListFind(send_cons_list,send_con,',')]#
					</cfif>
				</td>
				<td>#dateformat(send_date,dateformat_style)#</td>
				<td><cfif Len(sender_emp)>#Get_Employees_Info.Employee_Name[ListFind(sender_emp_list,sender_emp,',')]# #Get_Employees_Info.Employee_SurName[ListFind(sender_emp_list,sender_emp,',')]#</cfif><!--- #employee_name#&nbsp;#employee_surname# ---></td>
				<td><cfif get_send_camp.cont_type eq 1><cf_get_lang dictionary_id='29463.Mail'><cfelseif get_send_camp.cont_type eq 2><cf_get_lang dictionary_id='32002.SMS'></cfif> </td>
				<td><cfif get_send_camp.camp_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
			</tr>
		</cfoutput>	
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
			</tr>
		</tbody></cfif>
</cf_ajax_list>
