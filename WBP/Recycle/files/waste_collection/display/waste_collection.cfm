<cfinclude template="../../header.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
    <cfset waste_collection = createObject("component","WBP/Recycle/files/waste_collection/cfc/waste_collection") />
			
	<cfset getWasteCollection = waste_collection.getWasteCollection(
		keyword: attributes.keyword,
		process_stage = attributes.process_stage
    ) />

<cfelse>
	<cfset getWasteCollection.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default=#getWasteCollection.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_target" method="post" action="#request.self#?fuseaction=recycle.waste_collection">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
                </div>
                <div class="form-group">
					<cf_workcube_process is_upd='0' select_value="127" process_cat_width='250' is_detail='0'>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='62086.Atık Toplama Seferleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<cfoutput>
						<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th><cf_get_lang dictionary_id='62118.Çekici Plaka'></th>
						<th><cf_get_lang dictionary_id='62130.Dorse Plaka'></th>
                        <th><cf_get_lang dictionary_id='60933.Şoför'></th>
                        <th><cf_get_lang dictionary_id='62117.Yardımcı Şoför'></th>
						<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.waste_collection&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfif getWasteCollection.recordcount>
                    <cfoutput query="getWasteCollection" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
							<td>#ASSETP_NAME#</td>
							<td>#ASSETP_DORSE_NAME#</td>
							<td>#DRIVER_EMPLOYEE_NAME# #DRIVER_EMPLOYEE_SURNAME#</td>
							<td>#YRD_EMPLOYEE_NAME# #YRD_EMPLOYEE_SURNAME#</td>
							<td class="align-center;"><a href="#request.self#?fuseaction=recycle.waste_collection&event=upd&waste_collection_id=#WASTE_COLLECTION_EXPEDITIONS_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.process_stage)>
				<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
			</cfif>
			<cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="recycle.waste_collection#url_str#">
        </cfif>
	</cf_box>
</div>