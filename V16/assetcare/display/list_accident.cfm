<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_accident.cfm">
<cfset fault_ratio_list = ''>
<cfif get_accident.recordcount>

<cfoutput query="get_accident">
	<cfif len(fault_ratio_id) and not listFind(fault_ratio_list,fault_ratio_id,',')>
		<cfset fault_ratio_list = listAppend(fault_ratio_list,fault_ratio_id)>
	</cfif>
</cfoutput>

</cfif>

<cfif len(fault_ratio_list)>
  <cfquery name="GET_FAULT_RATIO" datasource="#dsn#">
	SELECT
		FAULT_RATIO_ID,
		FAULT_RATIO_NAME
	FROM
		SETUP_FAULT_RATIO
	WHERE
		FAULT_RATIO_ID IN (#fault_ratio_list#)
  </cfquery>
</cfif>
<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='29453.Plaka'></th>
			<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
			<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
			<th><cf_get_lang dictionary_id='48266.Kaza Tarihi'></th>
			<th><cf_get_lang dictionary_id='48268.Kaza Tipi'></th>
			<th><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th><cf_get_lang dictionary_id='48269.Kusur Oranı'></th>
			<th><cf_get_lang dictionary_id='48270.Sigorta Ödemesi'></th>
			<th width="20"><cf_get_lang dictionary_id='48290.Ceza Ekle'></th>
			<th width="20"><cf_get_lang dictionary_id='48291.Bakım Ekle'></th>
			<!--- <th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="parent.frame_accident.location='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_accident&iframe=1';"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th> --->
			<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_accident&iframe=1')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_accident.recordCount>
			<cfoutput query="get_accident">
				<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="80" nowrap="nowrap">#assetp#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#branch_name# - #department_head#</td>
					<td>#dateformat(accident_date,dateformat_style)#</td>
					<td>#accident_type_name#</td>
					<td>#document_num#</td>
					<td><cfif len(fault_ratio_id)>
							<cfquery name="get_fault_ratio_record" dbtype="query">
								SELECT * FROM get_fault_ratio WHERE FAULT_RATIO_ID = #fault_ratio_id#
							</cfquery>
								#get_fault_ratio_record.fault_ratio_name#
						</cfif>
					</td>
					<td><cfif insurance_payment eq 1><cf_get_lang dictionary_id='58564.Var'><cfelse><cf_get_lang dictionary_id='58546.Yok'></cfif></td>
					<td style="text-align:center;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_add_accident_punishment&accident_id=#accident_id#','medium','popup_add_accident_punishment');"><i class="fa fa-bomb" alt="<cf_get_lang dictionary_id='48021.Ceza Kayıt'>" title="<cf_get_lang dictionary_id='48021.Ceza Kayıt'>"></i></a></td>
					<td style="text-align:center;"><a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=add&assetp_id=#assetp_id#&accident_id=#accident_id#" target="_blank"><i class="fa fa-wrench" alt="<cf_get_lang dictionary_id='29682.Bakım Planı'>" title="<cf_get_lang dictionary_id='29682.Bakım Planı'>"></i></a></td>
					<!--- <td style="text-align:center;"><a href="javascript://" onClick="parent.frame_accident.location.href='#request.self#?fuseaction=assetcare.popup_upd_accident&accident_id=#accident_id#&iframe=1';"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td> --->
					<td style="text-align:center;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_accident&accident_id=#accident_id#&iframe=1')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="13" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
