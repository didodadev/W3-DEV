<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_km.cfm">
<table class="detail_basket_list" width="100%">
	<thead>
		<tr>
		  <th width="85"><cf_get_lang no='362.Mesai Durumu'></th>
		  <th><cf_get_lang_main no='1656.Plaka'></th>
		  <th><cf_get_lang_main no='41.Şube'> / <cf_get_lang_main no='2234.Lokasyon'></th>
		  <th><cf_get_lang_main no='132.Sorumlu'></th>
		  <th width="100"><cf_get_lang_main no='243.Baş Tarihi'></th>
		  <th width="70"><cf_get_lang_main no='288.Bit Tarihi'></th>
		  <th style="text-align:right;"><cf_get_lang no='357.Önceki KM'></th>
		  <th style="text-align:right;"><cf_get_lang no='219.Son KM'></th>
		  <th style="text-align:right;"><cf_get_lang_main no='1171.Fark'></th>
		  <th><cf_get_lang_main no='217.Açıklama'></th>
		  <th width="15"><a href="javascript://" onClick="window.parent.frame_km.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_km&iframe=1';"><img src="/images/plus_square.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_km.recordcount>
		<cfset employee_list=''>
		<cfset main_employee_list=''>
		<cfoutput query="get_km">
			<cfif len(employee_id) and not listfind(employee_list,employee_id)>
				<cfset employee_list = Listappend(employee_list,employee_id)>
			</cfif>
		</cfoutput>
		<cfif len(employee_list)>
			<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
			<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
				SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset main_employee_list = listsort(listdeleteduplicates(valuelist(GET_EMPLOYEE.EMPLOYEE_ID,',')),'numeric','ASC',',')>
		</cfif>		
		<cfoutput query="get_km">
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td><cfif is_offtime eq 1><font color="red"><cf_get_lang no='358.Mesai Dışı'> </font></cfif><cfif is_allocate><font color="red">AT</font></cfif></td>
				<td>#assetp#</td>
				<td>#branch_name# / #department_head#</td>
				<td><cfif employee_id neq 0 ><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_km.employee_id#','medium');">#get_employee.employee_name[listfind(main_employee_list,get_km.employee_id,',')]# #get_employee.employee_surname[listfind(main_employee_list,get_km.employee_id,',')]#</cfif></td>
				<td>#dateformat(start_date,dateformat_style)#</td>
				<td>#dateformat(finish_date,dateformat_style)#</td>
				<td style="text-align:right;">#tlformat(km_start,0)#</td>
				<td style="text-align:right;">#tlformat(km_finish,0)#</td>
				<cfif len(km_start) eq 0>
					<cfset km_start_1=0>
				<cfelse>
					<cfset km_start_1=km_start>
				</cfif>
				<td style="text-align:right;">#tlformat(km_finish - km_start_1,0)#</td>
				<td>#left(detail,25)#</td>
				<td><cfif (is_allocate eq 0) and (km_control_id eq km_control_id_last)><a href="javascript://" onClick="window.parent.frame_km.location.href='#request.self#?fuseaction=assetcare.popup_upd_km&km_control_id=#km_control_id#&iframe=1';"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></cfif></td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
			  <td colspan="11" class="color-row"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</table>
