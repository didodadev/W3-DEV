<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
<cfinclude template="../form/care_period_options.cfm">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.place" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_name" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.official_emp_id" default="">
<cfparam name="attributes.official_emp" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.period" default="">
<cfif isdate(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT ASSET_CARE_ID, ASSET_CARE FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
</cfquery>
<cfif len(attributes.form_submitted)>
	<cfinclude template="../query/list_care_info.cfm">
	<cfparam name="attributes.totalrecords" default='#get_work_asset_care.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Tamir-Bakım Planları',47225)#">
		<cfform name="search_assetp_period" action="#request.self#?fuseaction=assetcare.list_assetp_period" method="post">
			<cf_box_search> 
				<input type="hidden" name="dept_id_selected" id="dept_id_selected" value="" />
				<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
				<cfif isDefined("attributes.assetp_id")>
					<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>"/>
				</cfif>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-ord_by">
					<select name="ord_by" id="ord_by">
						<option value="1" <cfif isDefined('attributes.ord_by_period') and attributes.ord_by_period eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="2" <cfif isDefined('attributes.ord_by_period') and attributes.ord_by_period eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="3" <cfif isDefined('attributes.ord_by_period') and attributes.ord_by_period eq 3>selected</cfif>><cf_get_lang dictionary_id='29827.Azalan'> <cf_get_lang dictionary_id='47952.Periyot'></option>
						<option value="4" <cfif isDefined('attributes.ord_by_period') and attributes.ord_by_period eq 4>selected</cfif>><cf_get_lang dictionary_id='29826.Artan'> <cf_get_lang dictionary_id='47952.Periyot'></option>
					</select>
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<input type="text" name="start_date" id="start_date" maxlength="10" placeholder="<cfoutput><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfoutput>" value="<cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput>" />
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<input type="text" name="finish_date" id="finish_date" maxlength="10" message="#message3#" placeholder="<cfoutput><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfoutput>" value="<cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>" />
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3" onKeyUp ="isNumber(this)">
				</div>
				<div class="form-group" id="item-search">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
		 	</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>" />
								<input type="text" name="branch" id="branch"  value="<cfoutput>#attributes.branch#</cfoutput>"/>
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57453.Şube'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_assetp_period.branch_id&field_branch_name=search_assetp_period.branch');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-station_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58834.İstasyon'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#attributes.station_id#</cfoutput>">
								<input type="text" name="station_name" id="station_name"  value="<cfoutput>#attributes.station_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id ='58834.İstasyon'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_care.station_name&field_id=add_care.station_id</cfoutput>')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-department">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
								<input type="text" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57572.Departman'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_assetp_period.department_id&field_dep_branch_name=search_assetp_period.department');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-asset_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#" fieldName='asset_name' form_name='search_assetp_period' button_type='plus_thin'>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-official_emp">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="official_emp_id" id="official_emp_id" value="<cfoutput>#attributes.official_emp_id#</cfoutput>">
								<input type="text" name="official_emp" id="official_emp" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" value="<cfoutput>#attributes.official_emp#</cfoutput>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57569.Görevli'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=search_assetp_period.official_emp_id&field_name=search_assetp_period.official_emp&select_list=1')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-asset_cat">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="asset_cat" id="asset_cat">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_asset_cat">
									<option value="#asset_care_id#" <cfif attributes.asset_cat eq asset_care_id>selected</cfif>>#asset_care# </option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-period">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47952.Periyot'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="period" id="period" multiple>
								<cfloop array = "#period_list#" index="my_period_data">
									<cfoutput>
										<option value="#my_period_data[1]#"  <cfif len(attributes.period) and listfind(attributes.period,my_period_data[1],',')>selected</cfif>>#my_period_data[2]#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1885,'Bakım planı',29682)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>		
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57631.Adı'></th>
					<th><cf_get_lang dictionary_id='58602.demirbaş'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57572.Department'></th>
					<th><cf_get_lang dictionary_id='60371.Mekan'></th>
					<th><cf_get_lang dictionary_id='47913.Bakım Tipi'></th>
					<th><cf_get_lang dictionary_id='47952.Periyot'></th>
					<th><cf_get_lang dictionary_id='47946.Bakım Süresi'></th>
					<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					<th><cf_get_lang dictionary_id='41685.Bakım Tar'></th>
					<th><cf_get_lang dictionary_id='57569.Görevli'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp_period&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='57582.Ekle'>" title="<cf_get_lang dictionary_id ='57582.Ekle'>"/></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>
					<cfif get_work_asset_care.recordcount>
					<cfset assetp_cat_list = "">
					<cfset station_id_list = ""> 
					<cfoutput query="get_work_asset_care" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(assetp_catid) and not listfind(assetp_cat_list,assetp_catid)>
							<cfset assetp_cat_list=listappend(assetp_cat_list,assetp_catid)>
						</cfif>
						<cfif len(station_id) and not listfind(station_id_list,station_id) and our_company_id eq session.ep.company_id>
							<cfset station_id_list=listappend(station_id_list,station_id)>
						</cfif>
					</cfoutput>
					<cfif len(station_id_list)> 
						<cfquery name="get_station_name" datasource="#dsn3#">
							SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
						</cfquery>
						<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station_name.station_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(assetp_cat_list)>
						<cfquery name="get_assetp_cat" datasource="#dsn#">
							SELECT ASSETP_CATID, IT_ASSET,MOTORIZED_VEHICLE FROM ASSET_P_CAT WHERE ASSETP_CATID IN (#assetp_cat_list#) ORDER BY ASSETP_CATID
						</cfquery>
						<cfset assetp_cat_list = listsort(listdeleteduplicates(valuelist(get_assetp_cat.assetp_catid,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_work_asset_care" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="30">#currentrow#</td>
							<td><cfif get_assetp_cat.it_asset[listfind(assetp_cat_list,assetp_catid,',')] eq 1>
									<cfset link_str = "assetcare.list_asset_it&event=upd"><!--- it varliksa --->
								<cfelseif get_assetp_cat.motorized_vehicle[listfind(assetp_cat_list,assetp_catid,',')] eq 1>
									<cfset link_str = "assetcare.list_vehicles&event=upd"><!--- aracsa --->
								<cfelseif (get_assetp_cat.motorized_vehicle[listfind(assetp_cat_list,assetp_catid,',')] neq 1) and (get_assetp_cat.it_asset[listfind(assetp_cat_list,assetp_catid,',')] neq 1)>
									<cfset link_str = "assetcare.list_assetp&event=upd"><!--- fiziki varliksa --->
								</cfif>
								<cfif isdefined("link_str")>
									<a href="#request.self#?fuseaction=#link_str#&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a>
								<cfelse>
									#assetp#
								</cfif>
							</td>
							<td width="60">#INVENTORY_NUMBER#</td>
							<td><cfif care_type_id eq 1><cf_get_lang dictionary_id='58834.İstasyon'><cfelse><cf_get_lang dictionary_id='29452.Varlık'></cfif></td>
							<td>#branch_name#/#department_head#</td>
							<td>#place#</td>
							<td>#asset_care#</td>
							<td>
								<cfloop array = "#period_list#" index="my_period_data">
								<cfif len(period_id) and period_id EQ my_period_data[1]>
									#my_period_data[2]#
								</cfif>
								</cfloop>
							</td>
							<td><cfif len(care_day)>#care_day# <cf_get_lang dictionary_id='57490.gün'></cfif>
								<cfif len(care_hour)>#care_hour#<cf_get_lang dictionary_id='57491.saat'></cfif>
								<cfif len(care_minute)>#care_minute#<cf_get_lang dictionary_id='58827.dakika'></cfif>
							</td>
							<td><cfif isdefined("STATION_ID") and len(STATION_ID) and isdefined("get_station_name.STATION_NAME")>#get_station_name.STATION_NAME[listfind(station_id_list,STATION_ID,',')]#</cfif></td>  
							<td><cfif len(period_time)>#dateformat(period_time,dateformat_style)#</cfif></td>
							<td><cfif len(official_emp_id)>#get_emp_info(official_emp_id,0,0)#</cfif></td>
							<!-- sil --><td width="15"><a href="#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#care_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"/></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr> 
				</cfif>
				<cfelse>
					<tr>
						<td colspan="14"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
					</tr> 
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.department_id)>
			<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
		</cfif>
		<cfif len(attributes.department)>
			<cfset url_str = "#url_str#&department=#attributes.department#">
		</cfif>
		<cfif len(attributes.place)>
			<cfset url_str = "#url_str#&place=#attributes.place#">
		</cfif>
		<cfif len(attributes.asset_cat)>
			<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
		</cfif>
		<cfif len(attributes.period)>
			<cfset url_str = "#url_str#&period=#attributes.period#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.station_id)>
			<cfset url_str = "#url_str#&station_id=#attributes.station_id#">
		</cfif>
		<cfif len(attributes.station_name)>
			<cfset url_str = "#url_str#&station_name=#attributes.station_name#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isDefined("attributes.assetp_id")>
			<cfset url_str ="#url_str#&assetp_id=#attributes.assetp_id#">
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
			adres="assetcare.list_assetp_period#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus(); 
	//document.getElementById('keyword').focus();
</script>
