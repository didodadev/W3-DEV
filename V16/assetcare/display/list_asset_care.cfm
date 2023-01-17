<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.assetpcatid" default="">
<cfif xml_datediff_finish_and_now eq 1>
	<cfparam name="attributes.date_format" default="4">
<cfelse>
	<cfparam name="attributes.date_format" default="2">
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.submit" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default=""> 
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_name" default="">
<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_assetcare_report.cfm">
<cfelse>
	<cfset get_assetcare_report.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetcare_report.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_asset_care">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-form_ul_keyword">		
					<cfsavecontent variable="place"><cf_get_lang dictionary_id ='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#place#">
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'>!</cfsavecontent>
						<cfinput message="#message#" placeholder="#place#" type="text" name="start_date" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<cfsavecontent variable="plac1"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'>!</cfsavecontent>
						<cfinput message="#message#" placeholder="#plac1#" type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>			
					</div>					
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(search_asset.start_date,search_asset.finish_date,'#message_date#')">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class ="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-assetpcatid">
						<label class="col col-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>					
						<div class="col col-12">
							<select name="assetpcatid" id="assetpcatid">
								<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
								<cfoutput query="get_assetp_cat">
									<option value="#assetp_catid#" <cfif attributes.assetpcatid eq assetp_catid> selected</cfif>>#assetp_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class ="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-asset_name">	
						<label class="col col-12">
							<cf_get_lang dictionary_id ='58833.Fiziki Varlık'>
						</label>				
						<div class="col col-12">
							<cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#" fieldName='asset_name' form_name='search_asset' button_type='plus_thin' width='145'>
						</div>
					</div>
				</div>
				<div class ="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-istasyon">					
						<label class="col col-12"><cf_get_lang dictionary_id ='58834.İstasyon'></label>
						<div class="col col-12">
							<div class="input-group">																
								<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#attributes.station_id#</cfoutput>">
								<input type="text" name="station_name" id="station_name" value="<cfoutput>#attributes.station_name#</cfoutput>">
								<div id="show_station" "position:absolute; margin-left:-200; margin-top:20;z-index:11;"></div>
								<span class="input-group-addon icon-ellipsis"onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_care.station_name&field_id=add_care.station_id</cfoutput>');"></span> 
							</div>
						</div>
					</div>
				</div>
				<div class ="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-branch_id">					
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<div class="input-group">							
								<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
								<input type="text" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class ="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-date_format">
					<label class="col col-12"><cf_get_lang dictionary_id='48632.Bakım Zamanı'></label>					
						<div class="col col-12">
							<select name="date_format" id="date_format">
								<option value="1" <cfif attributes.date_format eq 1> selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
								<option value="2" <cfif attributes.date_format eq 2> selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>						
								<cfif xml_datediff_finish_and_now eq 1>
									<option value="3" <cfif attributes.date_format eq 3> selected</cfif>><cf_get_lang dictionary_id='48632.Bakım Zamanı'><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
									<option value="4" <cfif attributes.date_format eq 4> selected</cfif>><cf_get_lang dictionary_id='48632.Bakım Zamanı'><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
								</cfif>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(6,'Varlık Bakım Sonuçları',37005)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="35"><cf_get_lang dictionary_id='47993.Bakım No'></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					<th><cf_get_lang dictionary_id='51086.Bakım Tipi'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='48629.Bakım Baslangic Tarihi'></th>
					<th><cf_get_lang dictionary_id='48630.Bakım Bitis Tarihi'></th>
					<th><cf_get_lang dictionary_id='48632.Bakım Zamanı'></th>
					<th><cf_get_lang dictionary_id='47907.Bakım Yapan'></th>
					<th><cf_get_lang dictionary_id="47703.Bakım Yapan Çalışan"> 1</th>
					<th><cf_get_lang dictionary_id="47703.Bakım Yapan Çalışan"> 2</th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<!-- sil -->	  
					<th width="20" class="header_icn_none text-center" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_asset_care&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_assetcare_report.recordcount>
					<cfset company_id_list="">
					<cfset company_partner_id_list="">
					<cfset assetp_cat_list = "">
					<cfset station_id_list ="">
					<cfset care_type_list = "">
					<cfoutput query="get_assetcare_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(station_id) and not listfind(station_id_list,station_id)>
							<cfset station_id_list=listappend(station_id_list,station_id)>
						</cfif>
						<cfif len(company_id) and not listfind(company_id_list,company_id)>
							<cfset company_id_list=listappend(company_id_list,company_id)>
						</cfif>
						<cfif len(company_partner_id) and not listfind(company_partner_id_list,company_partner_id)>
							<cfset company_partner_id_list=listappend(company_partner_id_list,company_partner_id)>
						</cfif>
						<cfif len(assetp_catid) and not listfind(assetp_cat_list,assetp_catid)>
							<cfset assetp_cat_list=listappend(assetp_cat_list,assetp_catid)>
						</cfif>
						<cfif len(care_type) and not listfind(care_type_list,care_type)>
							<cfset care_type_list=listappend(care_type_list,care_type)>
						</cfif>
					</cfoutput>
					<cfif len(station_id_list)>
						<cfquery name="get_station_name" datasource="#dsn3#">
							SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
						</cfquery>
						<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station_name.station_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="GET_COMPANY" datasource="#DSN#">
							SELECT COMPANY_ID,NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(company_partner_id_list)>
						<cfset company_partner_id_list=listsort(company_partner_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER_NAME" datasource="#DSN#">
							SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#company_partner_id_list#) ORDER BY PARTNER_ID
						</cfquery>
					</cfif>
					<cfif len(assetp_cat_list)>
						<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
							SELECT ASSETP_CATID, IT_ASSET,MOTORIZED_VEHICLE FROM ASSET_P_CAT WHERE ASSETP_CATID IN (#assetp_cat_list#) ORDER BY ASSETP_CATID
						</cfquery>
						<cfset assetp_cat_list = listsort(listdeleteduplicates(valuelist(get_assetp_cat.assetp_catid,',')),'numeric','ASC',',')>
					</cfif>
					<cfif ListLen(care_type_list)>
						<cfquery name="get_asset_care_cat" datasource="#dsn#">
							SELECT ASSET_CARE_ID,ASSET_CARE FROM ASSET_CARE_CAT WHERE ASSET_CARE_ID IN (#care_type_list#) ORDER BY ASSET_CARE_ID
						</cfquery>
						<cfset care_type_list = listsort(listdeleteduplicates(valuelist(get_asset_care_cat.asset_care_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_assetcare_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#care_report_number#</td>
						<td><cfif get_assetp_cat.it_asset[listfind(assetp_cat_list,assetp_catid,',')] eq 1>
								<cfset link_str = "assetcare.list_asset_it&event=upd"><!--- it varliksa --->
							<cfelseif get_assetp_cat.motorized_vehicle[listfind(assetp_cat_list,assetp_catid,',')] eq 1>
								<cfset link_str = "assetcare.list_vehicles&event=upd"><!--- aracsa --->
							<cfelseif (get_assetp_cat.motorized_vehicle[listfind(assetp_cat_list,assetp_catid,',')] neq 1) and (get_assetp_cat.it_asset[listfind(assetp_cat_list,assetp_catid,',')] neq 1)>
								<cfset link_str = "assetcare.list_assetp&event=upd"><!--- fiziki varliksa --->
							</cfif>
							<cfif isdefined("link_str")>
								<a href="#request.self#?fuseaction=#link_str#&assetp_id=#asset_id#" class="tableyazi">#assetp#</a>
							<cfelse>
								#assetp#
						</cfif>
						</td>
						<td>#assetp_cat#</td>
						<td>#zone_name# / #branch_name# / #department_head#</td>
						<td><cfif isdefined("STATION_ID") and len(STATION_ID)>#get_station_name.STATION_NAME[listfind(station_id_list,STATION_ID,',')]#</cfif></td>
						<td><cfif Len(care_type)>#get_asset_care_cat.asset_care[ListFind(care_type_list,care_type,',')]#</cfif></td>
						<td>#detail#</td>
						<td>#dateformat(care_date,dateformat_style)# #timeformat(care_date,timeformat_style)#</td>
						<td>#dateformat(care_finish_date,dateformat_style)# #timeformat(care_finish_date,timeformat_style)#</td>
						<td><cfif xml_datediff_finish_and_now eq 1 and Len(care_finish_date)>#round(DateDiff('h',now(),care_finish_date)/24)#<cfelse>#get_date_part(care_date,care_finish_date)#</cfif></td>
						<td><cfif len(company_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_company.company_id[listfind(company_id_list,get_assetcare_report.company_id,',')]#','medium');">#get_company.fullname[listfind(company_id_list,get_assetcare_report.company_id,',')]#</a></cfif>
							<cfif len(company_partner_id)>- <a href="javascript://" class="tableyazi"onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id= #get_partner_name.partner_id[listfind(company_partner_id_list,get_assetcare_report.company_partner_id,',')]#','medium');">#get_partner_name.company_partner_name[listfind(company_partner_id_list,get_assetcare_report.company_partner_id,',')]# #get_partner_name.company_partner_surname[listfind(company_partner_id_list,get_assetcare_report.company_partner_id,',')]#</a></cfif>
						</td>
						<td><cfif len(c_employee1_id)>#get_emp_info(c_employee1_id,0,0)#</cfif></td>
						<td><cfif len(c_employee2_id)>#get_emp_info(c_employee2_id,0,0)#</cfif></td>
						<td>#bill_id#</td>
						<td class="text-right">#tlformat(expense_amount)# #amount_currency#</td>
						<!-- sil -->
						<td><a href="#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#care_report_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = ''>
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.assetpcatid)>
			<cfset url_str = "#url_str#&assetpcatid=#attributes.assetpcatid#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.branch)>
			<cfset url_str = "#url_str#&branch=#attributes.branch#">
		</cfif>
		<cfif len(attributes.date_format)>
			<cfset url_str = "#url_str#&date_format=#attributes.date_format#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.asset_id")>
			<cfset url_str ="#url_str#&asset_id=#attributes.asset_id#">
		</cfif>
		<cfif isDefined("attributes.ord_by")>
			<cfset url_str ="#url_str#&ord_by=#attributes.ord_by#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="assetcare.list_asset_care&#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	$( document ).ready(function() {
		var submit= <cfoutput>#attributes.submit#</cfoutput>;
		if(submit ==1){
		$('.ui-form-list-btn .ui-btn-success')[0].click()
	}
});
</script>

