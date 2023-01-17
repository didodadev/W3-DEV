<!-- sil -->
<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_fuel_search.cfm">
<cfif isdefined("attributes.is_submitted")>
    <cfquery dbtype="query" name="get_total_fuel">
        SELECT SUM(FUEL_AMOUNT) AS TOTAL_FUEL FROM get_fuel_search 
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_fuel_search.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<!-- sil -->
<thead>
    <tr>
        <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
        <th><cf_get_lang dictionary_id='29453.Plaka'></th>
        <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
        <th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
        <th><cf_get_lang dictionary_id='30117.Yakıt Şirketi'></th>
        <th><cf_get_lang dictionary_id='30113.Yakıt Tipi'></th>
        <th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
        <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'> /LT</th>
        <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_vehicles&event=add_fuel"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
    </tr>
</thead>
<tbody>
    <cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
        <cfif get_fuel_search.recordcount>
        <cfset company_id_list=''>
        <cfset fuel_type_list=''>
        <cfset document_type_list=''>
        <cfset employee_list=''>
            <cfoutput query="get_fuel_search">
                <cfif len(FUEL_COMPANY_ID) and not listfind(company_id_list,FUEL_COMPANY_ID)>
                    <cfset company_id_list=listappend(company_id_list,FUEL_COMPANY_ID)>
                </cfif>
                <cfif len(FUEL_TYPE_ID) and not listfind(fuel_type_list,FUEL_TYPE_ID)>
                    <cfset fuel_type_list=listappend(fuel_type_list,FUEL_TYPE_ID)>
                </cfif>
                <cfif len(DOCUMENT_TYPE_ID) and not listfind(document_type_list,DOCUMENT_TYPE_ID)>
                    <cfset document_type_list=listappend(document_type_list,DOCUMENT_TYPE_ID)>
                </cfif>
                <cfif len(EMPLOYEE_ID) and not listfind(employee_list,EMPLOYEE_ID)>
                    <cfset employee_list=listappend(employee_list,EMPLOYEE_ID)>
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
        <cfif len(employee_list)>
            <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
            <cfquery name="GET_EMPLOYEES" datasource="#DSN#">
                SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME  FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
        </cfif>
        <cfset aratoplam = 0>
        <cfset amount_aratoplam = 0>
            <cfoutput query="get_fuel_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif currentrow eq 1 or ASSETP[currentrow] eq ASSETP[currentrow-1]>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#assetp#</td>
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium','popup_emp_det')" class="tableyazi">#GET_EMPLOYEES.EMPLOYEE_NAME[listfind(employee_list,get_fuel_search.EMPLOYEE_ID,',')]# #GET_EMPLOYEES.EMPLOYEE_SURNAME[listfind(employee_list,get_fuel_search.EMPLOYEE_ID,',')]#</a></td>
                        <td>#branch_name# / #department_head#</td>
                        <td><cfif len(FUEL_COMPANY_ID)>#get_company.fullname[listfind(company_id_list,get_fuel_search.FUEL_COMPANY_ID,',')]#</cfif></td>
                        <td>#GET_FUEL_TYPE.FUEL_NAME[listfind(fuel_type_list,get_fuel_search.FUEL_TYPE_ID,',')]#</td>
                        <td>#GET_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME[listfind(document_type_list,get_fuel_search.DOCUMENT_TYPE_ID,',')]#</td>
                        <td>#document_num#</td>
                        <td>#dateformat(fuel_date,dateformat_style)#</td>
                        <td style="text-align:right;"><cfif len(fuel_amount)>#tlformat(fuel_amount)#<cfelse>#tlformat(0)#</cfif></td>
                        <td style="text-align:right;">#tlformat(total_amount)# #total_currency#</td>
                        <!-- sil -->
                        <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=upd_fuel&fuel_id=#fuel_id#'><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        <!-- sil -->
                    </tr>
                    <cfif len(fuel_amount)>
                        <cfset aratoplam = aratoplam + (fuel_amount)>
                    </cfif>
                    <cfif len(total_amount)>
                        <cfset amount_aratoplam = amount_aratoplam + (total_amount)>
                    </cfif>
                <cfelse>
                    <tr class="total">
                        <td colspan="12" style="text-align:right;">#assetp# - <cf_get_lang dictionary_id='57635.Miktar'> : #tlformat(aratoplam)#  lt./<cf_get_lang dictionary_id='57673.tutar'> : #tlformat(amount_aratoplam)#TL</td>
                    </tr>
                <cfset aratoplam = 0>
                <cfset amount_aratoplam = 0>
                <tr>
                    <td>#currentrow#</td>
                    <td>#assetp#</td>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium','popup_emp_det')" class="tableyazi">#GET_EMPLOYEES.EMPLOYEE_NAME[listfind(employee_list,get_fuel_search.EMPLOYEE_ID,',')]# #GET_EMPLOYEES.EMPLOYEE_SURNAME[listfind(employee_list,get_fuel_search.EMPLOYEE_ID,',')]#</a></td>
                    <td>#branch_name# / #department_head#</td>
                    <td><cfif len(FUEL_COMPANY_ID)>#get_company.fullname[listfind(company_id_list,get_fuel_search.FUEL_COMPANY_ID,',')]#</cfif></td>
                    <td>#GET_FUEL_TYPE.FUEL_NAME[listfind(fuel_type_list,get_fuel_search.FUEL_TYPE_ID,',')]#</td>
                    <td>#GET_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME[listfind(document_type_list,get_fuel_search.DOCUMENT_TYPE_ID,',')]#</td>
                    <td>#document_num#</td>
                    <td>#dateformat(fuel_date,dateformat_style)#</td>
                    <td style="text-align:right;">#tlformat(fuel_amount)#</td>
                    <td style="text-align:right;">#tlformat(total_amount)# #total_currency#</td>
                    <td><a href='#request.self#?fuseaction=assetcare.list_vehicles&event=upd_fuel&fuel_id=#fuel_id#'><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                </tr>
                <cfif len(fuel_amount)>
                    <cfset aratoplam = aratoplam + (fuel_amount)>
                </cfif>
                <cfif len(total_amount)>
                    <cfset amount_aratoplam = amount_aratoplam + (total_amount)>
                </cfif>
            </cfif>
            </cfoutput>
        <tr class="total">
            <td colspan="12" style="text-align:right;"><strong><cf_get_lang dictionary_id='57635.Miktar'> : <cfoutput>#tlformat(aratoplam)#</cfoutput>LT</strong></td>
        </tr>
        <tr class="total">
            <td colspan="12" style="text-align:right;">
                <strong><cf_get_lang dictionary_id='57673.Tutar'> : <cfoutput>#tlformat(amount_aratoplam)#</cfoutput>TL</strong> / 
                <strong><cf_get_lang dictionary_id='30120.Toplam Yakıt'> : <cfoutput>#tlformat(get_total_fuel.total_fuel)#</cfoutput>LT</strong>
            </td>
        </tr>
        <cfelse>
            <tr>
                <td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
    <cfelse>
        <tr>
            <td colspan="12"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
        </tr>
    </cfif>
</tbody>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.assetp_id")>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
	<cfif isdefined("attributes.assetp_name")>
	  <cfset url_str = "#url_str#&assetp_name=#attributes.assetp_name#">
	</cfif>
	<cfif isdefined("attributes.employee_id")>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif isdefined("attributes.employee_name")>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  <cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.branch_id")>
	  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.document_type_id")>
	  <cfset url_str = "#url_str#&document_type_id=#attributes.document_type_id#">
	</cfif>
	<cfif isdefined("attributes.fuel_type_id")>
	  <cfset url_str = "#url_str#&fuel_type_id=#attributes.fuel_type_id#">
	</cfif>
	<cfif isdefined("attributes.fuel_comp_name")>
	  <cfset url_str = "#url_str#&fuel_comp_name=#attributes.fuel_comp_name#">
	  <cfset url_str = "#url_str#&fuel_comp_id=#attributes.fuel_comp_id#">
	</cfif>
	<cfif isdefined("attributes.document_num")>
	  <cfset url_str = "#url_str#&document_num=#attributes.document_num#">
	</cfif>
	<cfif isdefined("attributes.record_num")>
	  <cfset url_str = "#url_str#&record_num=#attributes.record_num#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>
	<!-- sil -->
    <cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
        <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="assetcare.form_search_fuel#url_str#"></td>
    </cfif>
  <!-- sil -->
</cfif>	
