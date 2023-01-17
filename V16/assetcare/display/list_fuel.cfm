<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_fuel.cfm">
 <table class="detail_basket_list" width="100%">
    <thead>
        <tr>
            <th width="65"><cf_get_lang_main no='1656.Plaka'></th>
            <th><cf_get_lang_main no='132.Sorumlu'></th>
            <th><cf_get_lang_main no='41.Şube'> / <cf_get_lang_main no='2234.Lokasyon'></th>
            <th width="150"><cf_get_lang_main no='2320.Yakıt Şirketi'></th>
            <th><cf_get_lang_main no='2316.Yakıt Tipi'></th>
            <th><cf_get_lang_main no='1121.Belge Tipi'></th>
            <th><cf_get_lang_main no='468.Belge No'></th>
            <th width="65"><cf_get_lang_main no='330.Tarih'></th>
            <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'>/LT</th>
            <th width="130" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
            <th width="15"><a href="javascript://" onClick="parent.frame_fuel.location='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_fuel&iframe=1';"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_fuel.recordCount>
        <cfset company_id_list=''>
        <cfset fuel_type_list=''>
        <cfset document_type_list=''>
        <cfset employee_list=''>
        <cfoutput query="get_fuel">
            <cfif len(FUEL_COMPANY_ID) and not listfind(company_id_list,FUEL_COMPANY_ID)>
                <cfset company_id_list=listappend(company_id_list,FUEL_COMPANY_ID)>
            </cfif>
            <cfif len(FUEL_TYPE_ID) and not listfind(fuel_type_list,FUEL_TYPE_ID)>
                <cfset fuel_type_list=listappend(fuel_type_list,FUEL_TYPE_ID)>
            </cfif>
            <cfif len(DOCUMENT_TYPE_ID) and not listfind(document_type_list,DOCUMENT_TYPE_ID)>
                <cfset document_type_list=listappend(document_type_list,DOCUMENT_TYPE_ID)>
            </cfif>
        </cfoutput>
        <cfif len(company_id_list)>
            <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
            </cfquery>
        </cfif>
        <cfif len(fuel_type_list)>
            <cfset fuel_type_list=listsort(fuel_type_list,"numeric","ASC",",")>
            <cfquery name="GET_FUEL_TYPE" datasource="#DSN#">
                SELECT FUEL_ID,FUEL_NAME FROM SETUP_FUEL_TYPE WHERE FUEL_ID IN (#fuel_type_list#) ORDER BY FUEL_ID
            </cfquery>
        </cfif>
        <cfif len(document_type_list)>
            <cfset document_type_list=listsort(document_type_list,"numeric","ASC",",")>
            <cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#">
                SELECT DOCUMENT_TYPE_ID,DOCUMENT_TYPE_NAME FROM SETUP_DOCUMENT_TYPE WHERE DOCUMENT_TYPE_ID IN (#document_type_list#) ORDER BY DOCUMENT_TYPE_ID
            </cfquery>
        </cfif>
        
       <!--- <cfif len(employee_list)>
            <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
            <cfquery name="GET_EMPLOYEES" datasource="#DSN#">
                SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME  FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
        </cfif>--->
  
        <cfoutput query="get_fuel">
			<tr>
				<td>#assetp#</td>
				<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
				<td>#zone_name# / #branch_name# / #department_head#</td>
				<td><cfif len(FUEL_COMPANY_ID)>#get_company.fullname[listfind(company_id_list,get_fuel.FUEL_COMPANY_ID,',')]#</cfif></td>
				<td><cfif len(FUEL_TYPE_ID)>#GET_FUEL_TYPE.FUEL_NAME[listfind(fuel_type_list,get_fuel.FUEL_TYPE_ID,',')]#</cfif></td>
				<td><cfif len(DOCUMENT_TYPE_ID)>#GET_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME[listfind(document_type_list,get_fuel.DOCUMENT_TYPE_ID,',')]#</cfif></td>
				<td>#document_num#</td>
				<td>#dateformat(fuel_date,dateformat_style)#</td>
				<td style="text-align:right;">#tlformat(fuel_amount)#</td>
				<td style="text-align:right;">#tlformat(total_amount)# #total_currency#</td>
				<td><a href="javascript://" onClick="parent.frame_fuel.location.href='#request.self#?fuseaction=assetcare.popup_upd_fuel&fuel_id=#fuel_id#&iframe=1';"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absbottom"></a></td>
			</tr>
        </cfoutput>
        <cfelse>
            <tr>
              <td colspan="11"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
    </tbody>
</table>
