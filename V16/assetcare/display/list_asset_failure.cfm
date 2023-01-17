<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
<cf_get_lang_set module_name="assetcare">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_name" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.official_emp_id" default="">
<cfparam name="attributes.official_emp" default="">
<cfparam name="attributes.form_submitted" default="">
<cfif isdate(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT ASSET_CARE_ID, ASSET_CARE FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.list_asset_failure%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif len(attributes.form_submitted)>
	<cfinclude template="../query/list_failure_info.cfm">
	<cfparam name="attributes.totalrecords" default='#get_asset_failure_list.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure" method="post">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group" id="item-start_date">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
					<div class="input-group">
						<input type="text" name="start_date" id="start_date" maxlength="10" placeholder="<cfoutput>#place#</cfoutput>" value="<cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput>" />
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<cfsavecontent variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					<div class="input-group">
						<input type="text" name="finish_date" id="finish_date" maxlength="10" placeholder="<cfoutput>#place2#</cfoutput>" value="<cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>" />
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='control_()'>
					<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-asset_name">
						<label class="col col-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
						<div class="col col-12">
							<cfif attributes.asset_name eq ''><cfset attributes.asset_id =''></cfif>
							<cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#" fieldName='asset_name' form_name='search_asset' button_type='plus_thin'>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<cfif listfind(attributes.fuseaction,'assetcare','.')>
						<div class="form-group" id="item-official_emp">
							<label class="col col-12"><cf_get_lang dictionary_id='47882.Bildiren'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="text" name="official_emp" id="official_emp" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" value="<cfoutput>#attributes.official_emp#</cfoutput>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" title="Bildiren" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=search_asset.official_emp_id&field_name=search_asset.official_emp&select_list=1','list','popup_list_positions');"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-station_name">
						<label class="col col-12"><cf_get_lang dictionary_id ='58834.İstasyon'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#attributes.station_id#</cfoutput>">
								<input type="text" name="station_name" id="station_name" value="<cfoutput>#attributes.station_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_care.station_name&field_id=add_care.station_id</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-service_code">
						<label class="col col-12"><cf_get_lang dictionary_id ='58934.Arıza Kodu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="service_defect_code" id="service_defect_code" value="<cfif isdefined("attributes.service_defect_code")><cfoutput>#attributes.service_defect_code#</cfoutput></cfif>">
								<input type="hidden" name="service_code_id" id="service_code_id" value="<cfif isdefined("attributes.service_code_id")><cfoutput>#attributes.service_code_id#</cfoutput></cfif>">
								<input type="text" name="service_code" id="service_code" value="<cfif isdefined("attributes.service_code")><cfoutput>#attributes.service_code#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=service.popup_service_defect_codes&service_code_id=search_asset.service_code_id&service_code=search_asset.service_code&service_defect_code=search_asset.service_defect_code&keyword='+encodeURIComponent(document.search_asset.service_code.value),'medium');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-surec">
						<label class="col col-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-12">
							<select name="process_stage" id="process_stage">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="GET_PROCESS_STAGE">
									<option value="#process_row_id#"<cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif> >#STAGE#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(787,'Arıza Bildirimi',48658)#" uidrop="1" hide_table_column="1">
		<cfset colspan_ = 13>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='47879.Arıza Tarihi'></th>
					<th><cf_get_lang dictionary_id='47882.Bildiren'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_asset_failure&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>
					<cfif get_asset_failure_list.recordcount>
					<cfset failure_stage_list = "">
					<cfset failure_emp_list="">
					<cfset station_id_list = ""> 
					<cfoutput query="get_asset_failure_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(station_id) and not listfind(station_id_list,station_id)>
							<cfset station_id_list=listappend(station_id_list,station_id)>
						</cfif>
						<cfif len(failure_stage) and not listfind(failure_stage_list,failure_stage)>
							<cfset failure_stage_list=listappend(failure_stage_list,failure_stage)>
						</cfif>
						<cfif len(failure_emp_id) and not listfind(failure_emp_list,failure_emp_id)>
							<cfset failure_emp_list=listappend(failure_emp_list,failure_emp_id,',')>
						</cfif>
					</cfoutput>
					<cfif len(failure_stage_list)>
						<cfset failure_stage_list=listsort(failure_stage_list,"numeric","ASC",",")>
						<cfquery name="get_stage" datasource="#dsn#">
							SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#failure_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
					</cfif>
					<cfif len(station_id_list)> 
						<cfquery name="get_station_name" datasource="#dsn3#">
							SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
						</cfquery>
						<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station_name.station_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(failure_emp_list)>
						<cfquery name="get_emp_name" datasource="#dsn#">
							SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#failure_emp_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset failure_emp_list = listsort(listdeleteduplicates(valuelist(get_emp_name.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_asset_failure_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#assetp# </td>	
							<td><cfif isdefined("STATION_ID") and len(STATION_ID) and isdefined("get_station_name.STATION_NAME")>#get_station_name.STATION_NAME[listfind(station_id_list,STATION_ID,',')]#</cfif></td>
							<td>#notice_head#</td>
							<td><cfif len(failure_date)>
								#dateformat(failure_date,dateformat_style)#
								</cfif></td>
							<td><cfif len(failure_emp_id)>#get_emp_name.name[listfind(failure_emp_list,failure_emp_id)]#</cfif></td>
							<td><cfif len(FAILURE_STAGE)>#get_stage.stage[listfind(failure_stage_list,FAILURE_STAGE,',')]#</cfif></td>
							<!-- sil -->
							<td style="width:5px"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd&failure_id=#failure_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
						</tr> 
					</cfif>
					<cfelse>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
						</tr> 
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
		</cfif>
		<cfif isdefined("attributes.official_emp") and len(attributes.official_emp) and len(attributes.official_emp_id)>
			<cfset url_str = "#url_str#&official_emp_id=#attributes.official_emp_id#&official_emp=#attributes.official_emp#">
		</cfif>
		<cfif len(attributes.station_id) and len(attributes.station_name)>
			<cfset url_str = "#url_str#&station_id=#attributes.station_id#&station_name=#attributes.station_name#">
		</cfif>
		<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isDefined("attributes.service_code") and len(attributes.service_code)>
			<cfset url_str="#url_str#&service_defect_code=#attributes.service_defect_code#&service_code_id=#attributes.service_code_id#&service_code=#attributes.service_code#">
		</cfif>
		<cfif len(attributes.asset_id) and len(attributes.asset_name)>
			<cfset url_str="#url_str#&asset_id=#attributes.asset_id#&asset_name=#attributes.asset_name#">
		</cfif>
		<cfif len(attributes.process_stage) and len(attributes.process_stage)>
			<cfset url_str="#url_str#&process_stage=#attributes.process_stage#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##url_str#">
	</cf_box>
</div>
<script type="text/javascript">
$('#keyword').focus();
function control_()
{	
	if(datediff($('#start_date').val(),$('#finish_date').val(),0)<0)
	{
		alert("<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük olmaz'>");
		return  false;
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
