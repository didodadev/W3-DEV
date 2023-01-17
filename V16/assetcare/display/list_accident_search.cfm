<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_accident_search.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfif isdefined("attributes.is_submitted")>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_accident_search.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<!-- sil --> 
<!--- <table class="color-header" width="100%" style="text-align:right;">
	<tr> 
		<td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
	</tr>
</table> --->
<!-- sil -->
<cf_box title="." uidrop="1">

<cf_grid_list>
<!--- <table class="detail_basket_list"> --->

    <thead>
        <tr> 
          <th style="width:9%;"><cf_get_lang dictionary_id='57487.No'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='41443.Plaka'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='57544.Sorumlu'></th>
          <th style="width:11%;"><cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='43132.Kaza Tipi'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
          <th style="text-align:right, width:9%"><cf_get_lang dictionary_id='57880.Belge No'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='48270.Sigorta Ödemesi'></th>
          <th style="width:9%;"><cf_get_lang dictionary_id='48266.Kaza Tarihi'></th>
			<th style="width:4%;"><cf_get_lang dictionary_id='48290.Ceza Ekle'></th>
			<th style="width:4%;"><cf_get_lang dictionary_id='48291.Bakım Ekle'></th>
			<th style="width:4%;"><cf_get_lang dictionary_id='48549.Sigorta Bilgisi'></th>
			<th style="width:4%;"><cf_get_lang dictionary_id='57464.Güncelle'></th>
          <!--- <th></th>
          <th></th>
          <th></th> --->
        </tr>
    </thead>
    <tbody>
		<cfif isdefined("attributes.is_submitted")>
			<cfif get_accident_search.recordcount>
				<cfoutput query="get_accident_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr> 
						<td>#accident_id#</td>
						<td>#assetp#</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a></td>
						<td>#branch_name# / #department_head#</td>
						<td>#accident_type_name#</td>
						<td><cfif len(document_type_id)>
							<cfquery name="get_document_type_record" dbtype="query">
								SELECT * FROM GET_DOCUMENT_TYPE WHERE DOCUMENT_TYPE_ID = #get_accident_search.document_type_id#
							</cfquery>
							#get_document_type_record.document_type_name#					
							</cfif>
						  </td>
						<td style="text-align:right;">#document_num#</td>
						<td><cfif #insurance_payment# eq 0>
							<cf_get_lang dictionary_id='58546.Yok'> 
							<cfelseif #insurance_payment# eq 1>
							<cf_get_lang dictionary_id='58564.Var'></cfif></td>
						<td width="65">#dateformat(accident_date,dateformat_style)#</td>
						<td style="text-align:center;">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_add_accident_punishment&accident_id=#accident_id#','medium','popup_add_accident_punishment');"><i class="fa fa-bomb" alt="<cf_get_lang dictionary_id='48021.Ceza Kayıt'>" title="<cf_get_lang dictionary_id='48021.Ceza Kayıt'>"></i></a> 
						</td>	
							<td style="text-align:center;">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.list_assetp_period&event=add&assetp_id=#assetp_id#&accident_id=#accident_id#','medium','popup_add_care_period');"><i class="fa fa-wrench" alt="<cf_get_lang dictionary_id='29682.Bakım Planı'>" title="<cf_get_lang dictionary_id='29682.Bakım Planı'>"></i></a> 
						</td>

						<td>
							<cfif len(denounce_date) and is_payment eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_insurance_info&assetp_id=#assetp_id#&accident_id=#accident_id#','medium','popup_upd_insurance_info');"><i class="fa fa-info" alt="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>" title="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>"></i></a>
							<cfelseif len(denounce_date) and is_payment neq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_insurance_info&assetp_id=#assetp_id#&accident_id=#accident_id#','medium','popup_upd_insurance_info');"><i class="fa fa-info" alt="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>" title="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>"></i></a>
							<cfelseif not len(denounce_date) and is_payment neq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_add_insurance_info&assetp_id=#assetp_id#&accident_id=#accident_id#','medium','popup_add_insurance_info');"><i class="fa fa-info" alt="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>" title="<cf_get_lang dictionary_id='48549.Sigorta Bilgisi'>"></i></a>
							</cfif>
						</td>
						<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_accident_detail&accident_id=#accident_id#','medium','popup_upd_accident_detail');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></td>
					</tr>
				</cfoutput> 
			<cfelse>
				<tr class="color-row"> 
					<td colspan="14" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		<cfelse>
			<tr class="color-row"> 
				<td colspan="14" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
			</tr>
		</cfif>
    </tbody>
<!--- </table> --->
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.branch_id")>
	  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  <cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
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
	<cfif isdefined("attributes.is_offtime")>
	  <cfset url_str = "#url_str#&is_offtime=#attributes.is_offtime#">
	</cfif>
	<cfif isdefined("attributes.accident_type_id")>
	  <cfset url_str = "#url_str#&accident_type_id=#attributes.accident_type_id#">
	</cfif>
	<cfif isdefined("attributes.document_type_id")>
	  <cfset url_str = "#url_str#&document_type_id=#attributes.document_type_id#">
	</cfif>
	<cfif isdefined("attributes.document_num")>
	  <cfset url_str = "#url_str#&document_num=#attributes.document_num#">
	</cfif>
	<cfif isdefined("attributes.is_insurance_payment")>
	  <cfset url_str = "#url_str#&is_insurance_payment=#attributes.is_insurance_payment#">
	</cfif>
	<cfif isdefined("attributes.record_num")>
	  <cfset url_str = "#url_str#&record_num=#attributes.record_num#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>	
	<!-- sil -->
	<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="assetcare.popup_list_accident_search#url_str#"></td>
      <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='55072.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang dictionary_id='57581.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
  <!-- sil -->
  <br/>
</cfif>

</cf_grid_list>
</cf_box>
