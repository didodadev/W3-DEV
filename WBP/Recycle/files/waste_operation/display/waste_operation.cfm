<cfinclude template="../../header.cfm">

<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
    <cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />
			
	<cfset getWasteOperation = waste_operation.getWasteOperation(
		keyword: attributes.keyword,
		consumer_id: attributes.consumer_id,
		company_id: attributes.company_id,
		member_name: attributes.member_name,
		process_stage : attributes.process_stage
    ) />

<cfelse>
	<cfset getWasteOperation.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default=#getWasteOperation.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_target" method="post" action="#request.self#?fuseaction=recycle.waste_operation">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
				</div>
				<div class="form-group">
					<cf_workcube_process is_upd='0' select_value="127" process_cat_width='250' is_select_text="1" is_detail='0'>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="hidden" name="consumer_id" id="consumer_id" value="#isdefined("attributes.consumer_id") and len(attributes.consumer_id) ? attributes.consumer_id : ''#">
						<cfinput type="hidden" name="company_id" id="company_id" value="#isdefined("attributes.company_id") and len(attributes.company_id) ? attributes.company_id : ''#">
						<cfinput type="hidden" name="member_type" id="member_type" value="#isdefined("attributes.member_type") and len(attributes.member_type) ? attributes.member_type : ''#">
						<cfinput name="member_name" type="text" placeholder="#getLang('','',57519)#" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="#isdefined("attributes.member_name") and len(attributes.member_name) ? attributes.member_name : ''#" autocomplete="off">
						<cfset str_linke_ait="&field_consumer=search_target.consumer_id&field_comp_id=search_target.company_id&field_member_name=search_target.member_name&field_type=search_target.member_type">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.search_target.member_name.value),'list');"></span>
					</div>
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
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='62770.Atık Belgeleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<cfoutput>
						<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th><cf_get_lang dictionary_id='57519.cari hesap'></th>
						<th><cf_get_lang dictionary_id='62093.Atık Kodu'></th>
						<th><cf_get_lang dictionary_id='62118.Çekici Plaka'></th>
						<th><cf_get_lang dictionary_id='62130.Dorse Plaka'></th>
						<th><cf_get_lang dictionary_id='60933.Şoför'></th>
						<th>Yardımcı Şoför</th>
						<th><cf_get_lang dictionary_id='62129.Araç Giriş Zamanı'></th>
						<th><cf_get_lang dictionary_id='62127.Araç Çıkış Zamanı'></th>
						<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.waste_operation&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfif getWasteOperation.recordcount>
                    <cfoutput query="getWasteOperation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
							<td>#(Len(FULLNAME) ? FULLNAME : CONSUMER_NAME & ' ' & CONSUMER_SURNAME)#</td>
							<td>#PRODUCT_CODE#</td>
							<td>#CAR_NUMBER#</td>
							<td>#DORSE_PLAKA#</td>
							<td>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</td>
							<td>#HELPER_COMPANY_PARTNER_NAME# #HELPER_COMPANY_PARTNER_SURNAME#</td>
							<td>#dateFormat(CAR_ENTRY_TIME, dateformat_style)# #timeFormat(CAR_ENTRY_TIME, timeformat_style)#</td>
							<td>#dateFormat(CAR_EXIT_TIME, dateformat_style)# #timeFormat(CAR_EXIT_TIME, timeformat_style)#</td>
							<td style="text-align:center;"><a href="#request.self#?fuseaction=recycle.waste_operation&event=upd&waste_operation_id=#REFINERY_WASTE_OIL_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
                    <tr>
                        <td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.consumer_id)>
				<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.company_id)>
				<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
			</cfif>
			<cfif len(attributes.member_type)>
				<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
			</cfif>
			<cfif len(attributes.member_name)>
				<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
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
				adres="recycle.waste_operation#url_str#">
        </cfif>
	</cf_box>
</div>