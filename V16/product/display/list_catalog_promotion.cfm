<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default=""> 
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_applied" default="">
<cfparam name="attributes.catalog_status" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../query/get_catalog_promotion.cfm">
<cfelse>
	<cfset get_catalog.recordcount=0>
</cfif>
<cfinclude template="../query/get_price_cats.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_catalog.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
	</cfif>
</cfif>
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date =''>
	<cfelse>
		<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=product.list_catalog_promotion" name="form" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:75px;" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<select name="price_catid" id="price_catid" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
						<cfoutput query="get_price_cats">
							<option value="#price_catid#" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq price_catid> selected</cfif>>#price_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="is_applied" id="is_applied" style="width:125px;">
						<option value="2" <cfif attributes.is_applied eq 2> selected</cfif>><cf_get_lang dictionary_id='58084.Fiyat'> <cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="0" <cfif attributes.is_applied eq 0> selected</cfif>><cf_get_lang dictionary_id='37436.Fiyat Oluşturulmadı'></option>
						<option value="1" <cfif attributes.is_applied eq 1> selected</cfif>><cf_get_lang dictionary_id='37357.Fiyat Oluşturuldu'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="catalog_status" id="catalog_status" style="width:50px;">
						<option value="1" <cfif attributes.catalog_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.catalog_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2" <cfif attributes.catalog_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
					<cfif not listfindnocase(denied_pages,'report.product_action_search')>
						<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=report.product_action_search"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='37256.Ürün Aksiyon Raporu'>" alt="<cf_get_lang dictionary_id='37256.Ürün Aksiyon Raporu'>"></i></a>
					</cfif>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-position_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="position_code" id="position_code" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
								<input name="position_name" type="text" id="position_name" style="width:100px;" onFocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','position_code','','3','135');" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.position_code&field_name=form.position_name&select_list=1&branch_related','list','popup_list_positions')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_date">
						<label class="col col-12"><cf_get_lang dictionary_id='37235.Geçerlilik'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
								</cfif>                                        
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-finish_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57483.Kayıt'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="finish_date" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10">			
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput type="text" name="finish_date" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
								</cfif>                                        
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58988.Aksiyonlar'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='42412.Aksiyon No'></th>
					<th><cf_get_lang dictionary_id='37210.Aksiyon'></th>
					<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></th>
					<th><cf_get_lang dictionary_id='57500.Onay'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='37356.Fiyat Oluşturdu'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_catalog_promotion&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_catalog.recordcount>
				<cfset employee_id_list=''>
				<cfset record_emp_list=''>
				<cfset catalog_id_list=''>
				<cfoutput query="get_catalog" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfif len(catalog_id) and not listfind(catalog_id_list,catalog_id)>
						<cfset catalog_id_list=listappend(catalog_id_list,catalog_id)>
					</cfif>			
				</cfoutput>
				<cfif len(employee_id_list)>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
					<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
						SELECT
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME
						FROM
							EMPLOYEES
						WHERE
							EMPLOYEE_ID IN (#employee_id_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
				</cfif>
				<cfif len(catalog_id_list)>
					<cfset catalog_id_list=listsort(catalog_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CATALOG_COUNT_MAIN" datasource="#DSN3#">
						SELECT 
							COUNT(CP.CATALOG_ID) SAYI, C.CATALOG_ID 
						FROM 	
							CATALOG_PROMOTION C, 
							CATALOG_PROMOTION_PRODUCTS CP 
						WHERE
							C.CATALOG_ID = CP.CATALOG_ID AND
							C.CATALOG_ID IN (#catalog_id_list#)
						GROUP BY 
							C.CATALOG_ID					
						ORDER BY
							C.CATALOG_ID
					</cfquery>
				</cfif> 
				<cfoutput query="get_catalog" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset temp_count = 0>
					<tr>
						<td>#catalog_id#</td>
						<td>#cat_prom_no#</td>
						<td><a href="#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#" class="tableyazi">#catalog_head#</a></td>
						<td>
							<cfif get_module_user(15)>
								<a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" class="tableyazi">#camp_head#</a>
							<cfelse>					
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_campaign&campaign_id=#camp_id#','medium');" class="tableyazi">#camp_head#</a>
							</cfif>
						</td>
						<td>
							<cfquery name="GET_CATALOG_COUNT" dbtype="query">
								SELECT SAYI FROM GET_CATALOG_COUNT_MAIN WHERE CATALOG_ID = #catalog_id#
							</cfquery>
							<cfif get_catalog_count.recordcount>#get_catalog_count.sayi#<cfelse>0</cfif>
						</td>
						<td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
						<td>
							<cfif (valid eq 1) or (valid eq 0)>
								<cfif len(valid_emp)>
									#VALID_EMP_NAME#
									(#dateformat(date_add('h',session.ep.time_zone,validate_date),dateformat_style)#)
								<cfelse>
									<cf_get_lang dictionary_id='37219.Bilinmiyor'>
								</cfif>
							<cfelse>
								<cf_get_lang dictionary_id='57615.Onay Bekliyor'>
							</cfif>
						</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_catalog.record_emp#','medium');" class="tableyazi">#EMP_NAME#</a></td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<td>
							<cfif is_applied eq 1>
								<cf_get_lang dictionary_id='57495.Evet'>
							<cfelse>
								<cf_get_lang dictionary_id='57496.Hayır'>
							</cfif>
						</td>
						<!-- sil -->
						<td width="15"><a href="#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="product.list_catalog_promotion&keyword=#attributes.keyword#&currency=#attributes.currency#&is_submitted=1&position_code=#attributes.position_code#&position_name=#attributes.position_name#&start_date=#attributes.start_date#&finish_date=#attributes.finish_date#&is_applied=#attributes.is_applied#&catalog_status=#attributes.catalog_status#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
