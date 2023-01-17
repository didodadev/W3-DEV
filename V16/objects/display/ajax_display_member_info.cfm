<cfswitch expression="#attributes.act_type_id#">
 	<cfcase value="1">
		<cfset str_sql = "SELECT E.MEMBER_CODE,E.EMPLOYEE_NAME AS NAME,E.EMPLOYEE_SURNAME AS SURNAME,E.EMPLOYEE_EMAIL AS EMAIL,E.DIRECT_TELCODE AS PHONE_CODE,E.DIRECT_TEL AS PHONE,'' AS TAX_NO, ">
		<cfset str_sql = str_sql & " E.TASK AS TAX_OFFICE FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = #attributes.action_id#" >
		<cfset str_sql_account = "SELECT * FROM EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ">
	</cfcase>
 	<cfcase value="2">
		<cfset str_sql = "SELECT C.CONSUMER_NAME AS NAME,C.CONSUMER_SURNAME AS SURNAME,	C.CONSUMER_EMAIL AS EMAIL,	C.CONSUMER_HOMETELCODE AS PHONE_CODE,">
		<cfset str_sql = str_sql & " C.CONSUMER_HOMETEL AS PHONE,C.MOBIL_CODE,C.MOBILTEL AS MOBILE,C.MEMBER_CODE,C.CONSUMER_FAXCODE,C.CONSUMER_FAX,C.COMPANY AS COMPANY_NAME,">
		<cfset str_sql = str_sql & " C.COMPANY_SIZE_CAT_ID,C.SECTOR_CAT_ID,C.ISPOTANTIAL,C_CAT.CONSCAT,C.CONSUMER_ID AS ID" >
		<cfset str_sql = str_sql & " FROM CONSUMER AS C,CONSUMER_CAT AS C_CAT WHERE  C_CAT.CONSCAT_ID = C.CONSUMER_CAT_ID AND CONSUMER_ID = #attributes.action_id#">
		<cfset str_sql_account = "SELECT * FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = ">
	</cfcase>
 	<cfcase value="3">
		<cfset str_sql = "SELECT  -1  AS ID,'' AS NAME, '' AS SURNAME, '' AS EMAIL,'' AS PHONE_CODE, " >
		<cfset str_sql = str_sql & " '' AS PHONE,'' AS MOBIL_CODE,'' AS MOBILE,'' AS FAX,C.MEMBER_CODE,C.COMPANY_ID,C.NICKNAME AS COMPANY_NAME, " >
		<cfset str_sql = str_sql & " C.FULLNAME,	C.SECTOR_CAT_ID,C.COMPANY_SIZE_CAT_ID,-1 AS AUTHORITY_ID,	C.ISPOTANTIAL,	C.COMPANYCAT_ID,C_CAT.COMPANYCAT " >
		<cfset str_sql = str_sql & " FROM  COMPANY C, COMPANY_CAT C_CAT WHERE	 C_CAT.COMPANYCAT_ID = C.COMPANYCAT_ID AND C.COMPANY_ID = #attributes.action_id#" >
		<cfset str_sql_account = "SELECT * FROM COMPANY_REMAINDER WHERE COMPANY_ID = " >		
	</cfcase>
 	<cfcase value="4">
		<cfset str_sql = "SELECT  CP.PARTNER_ID AS ID,CP.COMPANY_PARTNER_NAME AS NAME, CP.COMPANY_PARTNER_SURNAME AS SURNAME, CP.COMPANY_PARTNER_EMAIL AS EMAIL,CP.COMPANY_PARTNER_TELCODE AS PHONE_CODE, " >
		<cfset str_sql = str_sql & " CP.COMPANY_PARTNER_TEL AS PHONE,CP.MOBIL_CODE,CP.MOBILTEL AS MOBILE,CP.COMPANY_PARTNER_FAX AS FAX,C.MEMBER_CODE,C.COMPANY_ID,C.NICKNAME AS COMPANY_NAME, " >
		<cfset str_sql = str_sql & " C.FULLNAME,	C.SECTOR_CAT_ID,C.COMPANY_SIZE_CAT_ID,-1 AS AUTHORITY_ID,	C.ISPOTANTIAL,	C.COMPANYCAT_ID,C_CAT.COMPANYCAT " >
		<cfset str_sql = str_sql & " FROM COMPANY_PARTNER AS CP, COMPANY C, COMPANY_CAT C_CAT WHERE	C.COMPANY_ID = CP.COMPANY_ID AND C_CAT.COMPANYCAT_ID = C.COMPANYCAT_ID AND CP.PARTNER_ID = #attributes.action_id#" >
		<cfset str_sql_account = "SELECT * FROM COMPANY_REMAINDER WHERE COMPANY_ID = " >
	</cfcase>
</cfswitch>
<cfquery name="GET_ACCOUNT_SIMPLE" datasource="#DSN#">
	#PreserveSingleQuotes(str_sql)#
</cfquery>
<cfif attributes.dsp_account eq 1>
	<cfif attributes.act_type_id eq 4>
		<cfset int_look_up_value = get_account_simple.company_id>
	<cfelse>
		<cfset int_look_up_value = attributes.action_id>
	</cfif>
	<cfset str_sql_account = "#str_sql_account# #int_look_up_value#" >
	<cfquery name="GET_REMAINDER" datasource="#DSN2#" >
		#PreserveSingleQuotes(str_sql_account)#
	</cfquery>
</cfif>

<table>
<cfif not session.ep.our_company_info.workcube_sector is 'it'>
	<tr> 
		<td width="100" class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
		<td>
		<cfif attributes.act_type_id eq 1>
			<cf_get_lang dictionary_id='57576.Çalışan'>
		<cfelseif attributes.act_type_id gte 3>			
			<cfoutput>#get_account_simple.companycat#</cfoutput> 
		<cfelseif attributes.act_type_id is 2>
			<cfoutput>#get_account_simple.conscat#</cfoutput> 
		</cfif> 
		</td>
	</tr>
</cfif>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
		<td> 
		<cfif attributes.act_type_id eq 1>
			<cfoutput query="get_account_simple"></cfoutput>
		<cfelseif attributes.act_type_id gte 3>
			<cfoutput>
			<cfif get_module_user(4)>
				<a href="javascript://"  onClick="window.open('#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_account_simple.company_id#');" class="tableyazi">#get_account_simple.company_name#</a>
			<cfelse>
				<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_account_simple.company_id#','medium');" class="tableyazi">#get_account_simple.company_name#</a>
			</cfif>
			</cfoutput>
		<cfelseif attributes.act_type_id eq 2>
			<cfoutput>#get_account_simple.company_name#</cfoutput>
		</cfif>	
		</td>
	</tr>
	<tr> 
		<td  class="txtbold"><cf_get_lang dictionary_id='57578.Yetkili'></td>
		<td>
		<cfif attributes.act_type_id eq 4>
			<cfoutput>
			<cfif get_module_user(4)>
				<a href="javascript://" onClick="window.open('#request.self#?fuseaction=member.list_contact&event=upd&pid=#attributes.action_id#');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
			<cfelse>
				<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#attributes.action_id#','medium');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
			</cfif>		
			</cfoutput>
		<cfelseif attributes.act_type_id eq 1>
			-
		<cfelseif attributes.act_type_id eq  2>
			<cfoutput>
			<cfif get_module_user(4)>
				<a href="javascript://" onClick="window.open('#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.action_id#');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
			<cfelse>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.action_id#','medium');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
			</cfif>
			</cfoutput>		
		</cfif>
		</td>
	</tr>
<cfif attributes.dsp_account eq 1>
	<!--- borç alacak bakiye isteniyor sa --->
	<tr> 
		<td class="txtbold"><cf_get_lang dictionary_id='57587.Borç'></td>
		<td align="right">  
		<cfif attributes.act_type_id gte 3>
			<cfif not get_remainder.recordcount>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>				
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfif not len(get_remainder.borc)><cfset borc = 0></cfif>					
				<cfif not len(get_remainder.alacak)><cfset alacak = 0></cfif>
				<cfset bakiye = get_remainder.bakiye>				
			</cfif>
			<cfoutput>#TLFormat(ABS(borc))# #session.ep.money#</cfoutput>
		</cfif>
		</td>
	</tr>
	<tr> 
		<td class="txtbold"><cf_get_lang dictionary_id='57588.Alacak'></td>
		<td align="right"> 
		<cfif attributes.act_type_id gt 1>	
			<cfif not get_remainder.recordcount>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>				
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfif not len(get_remainder.borc)><cfset borc = 0></cfif>					
				<cfif not len(get_remainder.alacak)><cfset alacak = 0></cfif>
				<cfset bakiye = get_remainder.bakiye>				
			</cfif>
			<cfoutput>
				<cfif attributes.act_type_id gt 3>
					#TLFormat(ABS(alacak))#&nbsp;#session.ep.money#
				<cfelse>
					#TLFormat(ABS(alacak))#&nbsp;#session.ep.money#
				</cfif>
			</cfoutput> 
		</cfif>
		</td>
	</tr>
	<tr> 
		<td class="txtbold"><cf_get_lang dictionary_id='57589.Bakiye'></td>
		<td align="right">
		<cfif attributes.act_type_id gt 1>
			<cfif get_remainder.recordcount eq 0>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>	
				<cfset bakiye_type = ''>			
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfset bakiye = get_remainder.bakiye>
				<cfif alacak gt borc>
					<cfset bakiye_type = '(A)'>
				<cfelse>
					<cfset bakiye_type = '(B)'>
				</cfif>				
			</cfif>
			<cfoutput>
			<cfif attributes.act_type_id gte 3>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_account_simple.company_id#','list');" class="tableyazi">#TLFormat(ABS(bakiye))#&nbsp;#session.ep.money#&nbsp;#bakiye_type#</a>
			<cfelseif attributes.act_type_id gte 2>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cons_extre&is_self=1&consumer_id=#attributes.action_id#','list');" class="tableyazi">#TLFormat(ABS(bakiye))#&nbsp;#session.ep.money#&nbsp;#bakiye_type#</a>
			</cfif>
			</cfoutput> 
		</cfif>
		</td>
	</tr>
</cfif>
</table>
