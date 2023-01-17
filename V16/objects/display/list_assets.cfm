<cf_xml_page_edit fuseact="objects.list_assets">
<cfinclude template="../query/get_assetp_cats_reserve.cfm">
<cfinclude template="../query/get_assetps_reserve.cfm">
<cfparam name="attributes.process_stage_type" default="">
<cfset adres = "">
<cfif isDefined('attributes.event_id') and len(attributes.event_id)>
	<cfset adres = "#adres#&event_id=#attributes.event_id#">
</cfif>
<cfif isDefined('attributes.class_id') and len(attributes.class_id)>
	<cfset adres = "#adres#&class_id=#attributes.class_id#">
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset adres = "#adres#&project_id=#attributes.project_id#">
</cfif>
<cfif isDefined('attributes.field_id') and len(attributes.field_id)>
	<cfset adres = "#adres#&field_id=#attributes.field_id#">
</cfif>
<cfif isDefined('attributes.organization_id') and len(attributes.organization_id)>
	<cfset adres = "#adres#&organization_id=#attributes.organization_id#">
</cfif>
<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
	<cfset adres = "#adres#&field_name=#attributes.field_name#">
</cfif>
<cfquery name="GET_STAGE" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.form_add_assetp%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetps_reserve.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Fiziki Varlıklar','30004')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_assets#adres#" method="post">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#">
					</div>
				</div>
				<div class="form-group" id="item-employee_name">
					<div class="input-group x-12">
							<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.employee_id#</cfoutput>" maxlength="50">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58875.Çalışanlar'></cfsavecontent> 
							<input type="text" name="employee_name" id="employee_name"  placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.employee_name#</cfoutput>" maxlength="50" style="width:100px;" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.emp_id&field_name=search_asset.employee_name&select_list=1&branch_related')"></span>
						</div>
					</div>	 
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-process_stage_type">
						<div class="input-group">
							<select name="process_stage_type" id="process_stage_type">
								<option value=""><cf_get_lang dictionary_id="57482.Asama"></option>
								<cfoutput query="get_stage">
									<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected="selected"</cfif>>#STAGE#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-asset_cat">
						<div class="input-group">
							<select name="asset_cat" id="asset_cat">
								<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
								<cfoutput query="get_assetp_cats_reserve">
									<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-department_id">
						<select name="department_id" id="department_id">
							<option value=""><cf_get_lang dictionary_id='57572.Departman'>
							<cfoutput query="dep">
								<option value="#department_id#" <cfif isdefined("attributes.DEPARTMENT_ID")><cfif attributes.DEPARTMENT_ID eq department_id>selected</cfif></cfif>>#branch_name# / #department_head#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="22"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="35"><i class="fa fa-flag" title="<cf_get_lang dictionary_id='44754.Rezervasyon Durumu'>"></i></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th width="130"><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th width="130"><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th width="35" class="text-center"><span href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.popup_form_assetp_reserve_clocks&assetp_id=#get_assetps_reserve.assetp_id#<cfif isDefined("attributes.event_id")>&event_id=#attributes.event_id#<cfelseif isdefined('attributes.eventid')>&eventid=#attributes.eventid#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif><cfif isDefined("attributes.organization_id")>&organization_id=#attributes.organization_id#</cfif></cfoutput>');"><i <i class="fa fa-history" title="<cf_get_lang dictionary_id='33480.Rezerve edilen saatler'>"></i></span></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_assetps_reserve.recordcount>
					<cfset position_code_list = "">
					<cfset assetp_id_list = "">
					<cfoutput query="get_assetps_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(position_code) and not listfind(position_code_list,position_code)>
							<cfset position_code_list=listappend(position_code_list,position_code)>
						</cfif>
						<cfif len(assetp_id) and not listfind(assetp_id_list,assetp_id)>
							<cfset assetp_id_list=listappend(assetp_id_list,assetp_id)>
						</cfif>
					</cfoutput>
					<cfif len(position_code_list)>
						<cfset position_code_list = listsort(position_code_list,"numeric","ASC",",")>
						<cfquery name="get_position_name" datasource="#dsn#">
							SELECT POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_code_list#) ORDER BY POSITION_CODE
						</cfquery>
						<cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_position_name.POSITION_CODE,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(assetp_id_list)>
						<cfset assetp_id_list = listsort(assetp_id_list,"numeric","ASC",",")>
						<cfquery name="GET_ASSETP_NAME" datasource="#DSN#">
							SELECT 
								ASSET_P.ASSETP_ID ASSETP_ID,
								ASSET_P_RESERVE.ASSETP_ID,
								ASSET_P_RESERVE.ASSETP_RESID,
								ASSET_P_RESERVE.EVENT_ID,
								ASSET_P_RESERVE.STARTDATE,
								ASSET_P_RESERVE.FINISHDATE,
								ASSET_P_RESERVE.UPDATE_EMP
							FROM 
								ASSET_P,
								ASSET_P_RESERVE
							WHERE
								ASSET_P.ASSETP_ID IN (#assetp_id_list#) AND
								ASSET_P.ASSETP_ID = ASSET_P_RESERVE.ASSETP_ID AND
								ASSET_P_RESERVE.STARTDATE <= #now()# AND
								ASSET_P_RESERVE.FINISHDATE >= #now()#
						</cfquery>
						<cfset assetp_id_list = listsort(listdeleteduplicates(valuelist(get_assetp_name.assetp_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_assetps_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td align="center">#currentrow#</td>
							<td width="35" align="center" valign="middle">
								<cfif len(get_assetp_name.assetp_id[listfind(assetp_id_list,assetp_id,',')])>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.event_id")>&event_id=#attributes.event_id#<cfelseif isdefined('attributes.eventid')>&eventid=#attributes.eventid#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif><cfif isDefined("attributes.organization_id")>&organization_id=#attributes.organization_id#</cfif>');"><i class="fa fa-flag-checkered" style="color:red" title="<cf_get_lang dictionary_id='32931.Kaynak Şu anda Müsait Değil'> !"></i></a>
								<cfelse>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.event_id")>&event_id=#attributes.event_id#<cfelseif isdefined('attributes.eventid')>&eventid=#attributes.eventid#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif><cfif isDefined("attributes.organization_id")>&organization_id=#attributes.organization_id#</cfif>');"><i class="fa fa-flag-checkered" style="color:green!important" title="<cf_get_lang dictionary_id='32932.Kaynak Rezerve Edin'> !"></i></a>
								</cfif>
							</td>
							<td><cfif isdefined("attributes.event_id") and attributes.event_id eq 0>
									<a href="javascript://" onclick="asset_care('#assetp_id#','#assetp#');">#assetp#</a>
								<cfelse>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_assetp_info&assetp_id=#assetp_id#')">#assetp#</a>
								</cfif>
								<cfif is_collective_usage eq 1><font color="FFF0000"><cf_get_lang dictionary_id='33612.Ortak Kullanım'></font></cfif>
							</td>
							<td>#zone_name# / #branch_name# / #department_head#</td>
							<td><cfif isdefined("get_position_name")>#get_position_name.employee_name[listfind(position_code_list,position_code,',')]# #get_position_name.employee_surname[listfind(position_code_list,position_code,',')]#</cfif></td>
							<td class="text-center"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#get_assetps_reserve.assetp_id#');"><i class="fa fa-history" title="<cf_get_lang dictionary_id='32455.Rezervasyon Tarihçe'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>! 
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfif isDefined('attributes.asset_cat') and len(attributes.asset_cat)>
	<cfset adres = "#adres#&asset_cat=#attributes.asset_cat#">
</cfif>
<cfif isDefined('attributes.process_stage_type') and len(attributes.process_stage_type)>
	<cfset adres = "#adres#&process_stage_type=#attributes.process_stage_type#">
</cfif>
<cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
	<cfset adres = "#adres#&employee_name=#attributes.employee_name#">
</cfif>
<cfif isDefined('attributes.emp_id') and len(attributes.emp_id)>
	<cfset adres = "#adres#&emp_id=#attributes.emp_id#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="objects.popup_assets&#adres#">
</cfif>
<script type="text/javascript">
	function asset_care(id,assetp)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = assetp;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
