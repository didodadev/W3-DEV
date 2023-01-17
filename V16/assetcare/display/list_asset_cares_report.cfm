<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_ids" default="">
<cfparam name="attributes.assetpcatid" default="">
<cfparam name="attributes.date_format" default="1">
<cfquery name="GET_ASSETCARE_REPORT" datasource="#dsn#">
	SELECT
		ACR.*,
		A.ASSETP,
		APC.ASSETP_CAT,
		A.ASSETP_CATID,
		A.DEPARTMENT_ID
	FROM
		ASSET_CARE_REPORT ACR,
		ASSET_P A,
		ASSET_P_CAT APC
	WHERE 
		ACR.ASSET_ID = #attributes.asset_id# AND
		APC.ASSETP_CATID = A.ASSETP_CATID AND
		A.ASSETP_ID = ACR.ASSET_ID AND
		ACR.ASSET_TYPE = 'P' 
		<cfif len(attributes.keyword)>
			AND 
			(
				A.ASSETP LIKE '%#attributes.keyword#%'
				OR
				ACR.BILL_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif len(attributes.date_format) and attributes.date_format eq 1>ORDER BY ACR.RECORD_DATE DESC</cfif>
		<cfif len(attributes.date_format) and attributes.date_format eq 2>ORDER BY ACR.RECORD_DATE</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_assetcare_report.recordcount#>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('assetcare','Tamir Bakım Sonuçları','47877')#">
	<cfform name="form" action="#request.self#?fuseaction=assetcare.popup_list_asset_cares_report&asset_id=#attributes.asset_id#" method="post">
		<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<select name="date_format" id="date_format">
						<option value="1" <cfif len(attributes.date_format) and attributes.date_format eq 1>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
						<option value="2" <cfif len(attributes.date_format) and attributes.date_format eq 2>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
					</select> 
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="25%"><cf_get_lang_main no='74.Kategori'></th>
				<th width="25%"><cf_get_lang_main no='2234.Lokasyon'></th>
				<th width="25%"><cf_get_lang no='41.Bakım Tarihi'></th>
				<th width="25%"><cf_get_lang_main no='1121.Belge Tipi'> / No</th>
				<th width="25%"><a href="<cfoutput>#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#url.asset_id#</cfoutput>" target="_blank"><i class="fa fa-plus"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_assetcare_report.recordcount>
				<cfoutput query="get_assetcare_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#assetp_cat#</td>
						<td><cfif len(department_id)>
						<cfset attributes.department_id = department_id>
						<cfinclude template="../query/get_assetp_department.cfm">
						#get_assetp_dep.zone_name# / #get_assetp_dep.branch_name# / #get_assetp_dep.department_head#<cfelse> - </cfif></td>
						<td>#dateformat(care_date,dateformat_style)#</td>
						<td><cfif len(document_type_id) and len(bill_id)><!--- #document_type# ---> - #bill_id#</cfif></td>
						<td align="center"><a href="#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#care_report_id#"><i class="fa fa-pencil"></i></a></td>
						<!--- Ustteki linkin ilk hali BK <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_care&care_report_id=#care_report_id#&id=#expense_item_row_id#','medium')"> --->
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif get_assetcare_report.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
		</div>
	</cfif>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.department_ids") and len(attributes.department_ids)>
	<cfset url_str = "#url_str#&department_ids=#attributes.department_ids#">
	</cfif>
	<cfif isdefined("attributes.assetpcatid") and len(attributes.assetpcatid)>
	<cfset url_str = "#url_str#&assetpcatid=#attributes.assetpcatid#">
	</cfif>
	<cfif (attributes.totalrecords gt attributes.maxrows)>
      <cf_paging
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="assetcare.popup_list_asset_cares_report#url_str#&asset_id=#attributes.asset_id#"></td>
	</cfif>
</cf_box>
