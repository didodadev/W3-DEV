<cfinclude template="../query/get_care_reference_search.cfm">
<cfif isdefined("attributes.is_submitted")>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_care_reference_search.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfsavecontent variable="right">
	<table style="text-align:right;">
		<tr>
			<td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</td>
		</tr>
	</table>
</cfsavecontent>
<cf_popup_box right_images='#right#'>
	<cf_medium_list>		  	
		<thead>
			<tr>
				<th width="35"><cf_get_lang_main no='75.No'></th>
				<th><cf_get_lang no='42.Bakım Tipi'></th>
				<th><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></th>
				<th><cf_get_lang_main no='813.Model'></th>
				<th><cf_get_lang no='231.Başlangıç KM'></th>
				<th><cf_get_lang no='237.Bitiş KM'></th>
				<th><cf_get_lang no='377.Kontrol Km'></th>
				<th width="15"></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.is_submitted")>
				<cfif get_care_reference_search.recordcount>
					<cfoutput query="get_care_reference_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cfif #care_type_id# eq 1><cf_get_lang no='378.Periyodik'><cfelse><cf_get_lang no='379.Yağ'></cfif></td>
							<td>#brand_name# #brand_type_name#</td>
							<td>#make_year#</td>
							<td style="text-align:right;">#tlformat(start_km)#</td>
							<td style="text-align:right;">#tlformat(finish_km)#</td>
							<td style="text-align:right;">#tlformat(period_km)#</td>
							<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_care_ref_detail&care_reference_id=#care_reference_id#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
				<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang_main no='289.Filtre Ediniz '> !</td>
					</tr>
			</cfif>
		</tbody>
	</cf_medium_list>
</cf_popup_box>
<cf_popup_box_footer>
	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.care_type_id")>
		  <cfset url_str = "#url_str#&care_type_id=#attributes.care_type_id#">
		</cfif>
		<cfif isdefined("attributes.brand_type_id")>
		  <cfset url_str = "#url_str#&brand_type_id=#attributes.brand_type_id#">
		</cfif>
		<cfif isdefined("attributes.brand_name")>
		  <cfset url_str = "#url_str#&brand_name=#attributes.brand_name#">
		</cfif>
		<cfif isdefined("attributes.make_year")>
		  <cfset url_str = "#url_str#&make_year=#attributes.make_year#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
		  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<!-- sil -->
		<table width="99%" align="center" cellpadding="0" cellspacing="0" height="35">
			<tr>
				<td><cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="assetcare.popup_list_care_ref_search#url_str#"></td>
				<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang_main no='169.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
			</tr>
		</table>
		<!-- sil -->
	</cfif>
</cf_popup_box_footer>
