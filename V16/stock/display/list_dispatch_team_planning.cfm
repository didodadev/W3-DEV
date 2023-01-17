<!--- Sevkiyat Ekip Listesi --->
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.assetp_name" default="">
<cfparam name="attributes.team_employee_id" default="">
<cfparam name="attributes.team_employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.planning_date" default="">
<cfif isdate(attributes.planning_date)><cf_date tarih="attributes.planning_date"></cfif>
<cfquery name="get_dispatch_stage" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.submitted")>
	<cfquery name="get_dispatch_team_planning" datasource="#dsn3#">
		SELECT
			*
		FROM
			DISPATCH_TEAM_PLANNING
		WHERE
			1 = 1
			<cfif Len(attributes.assetp_id) and Len(attributes.assetp_name)>AND ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"></cfif>
			<cfif Len(attributes.process_stage_type) and Len(attributes.process_stage_type)>AND PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#"></cfif>
			<cfif Len(attributes.team_employee_id) and Len(attributes.team_employee_name)>AND TEAM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_employee_id#"></cfif>
			<cfif Len(attributes.keyword)>AND TEAM_ZONES LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
			<cfif isdate(attributes.planning_date)>AND PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"></cfif>
		ORDER BY
        	PLANNING_DATE DESC,
			TEAM_CODE
	</cfquery>
<cfelse>
	<cfset get_dispatch_team_planning.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_dispatch_team_planning.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form_list_team_planning" action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning" method="post">
			<input type="hidden" name="submitted" id="submitted" value="1" />
			<cf_box_search> 
				<div class="form-group">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<input type="text" name="keyword" id="keyword" placeholder="<cfoutput>#getlang(48,'Filtre',57460)#</cfoutput>" maxlength="50" value="<cfif Len(attributes.keyword)><cfoutput>#attributes.keyword#</cfoutput></cfif>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfoutput>
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58480.Araç'></cfsavecontent>
							<input type="hidden" maxlength="50" name="assetp_id" id="assetp_id" value="<cfif Len(attributes.assetp_id) and Len(attributes.assetp_name)><cfoutput>#attributes.assetp_id#</cfoutput></cfif>">
							<input type="text" maxlength="50" placeHolder="#header_#" name="assetp_name" id="assetp_name" value="<cfif Len(attributes.assetp_id) and Len(attributes.assetp_name)><cfoutput>#attributes.assetp_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP','get_assetp_vehicle','','ASSETP_ID,ASSETP','assetp_id,assetp_name','','3','120');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=form_list_team_planning.assetp_id&field_name=form_list_team_planning.assetp_name&is_active=1','project','popup_list_ship_vehicles')" title="<cf_get_lang dictionary_id='44630.Ekle'>"></span>
						</cfoutput>
					</div>
				</div>				
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="header_"><cfoutput>#getlang(330,'Tarih',57742)#</cfoutput></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
						<cfinput type="text" maxlength="10" placeHolder="#header_#" name="planning_date" value="#dateformat(attributes.planning_date,dateformat_style)#" message="#message#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="planning_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_dispatch_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">               
				</div>
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Ekip Planlama',45752)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='45753.Ekip Kodu'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<th><cf_get_lang dictionary_id='29453.Plâka'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning&event=add</cfoutput>','list','popup_add_dispatch_team_planning');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
			<cfif get_dispatch_team_planning.recordcount>
				<cfset assetp_id_list = "">
				<cfoutput query="get_dispatch_team_planning" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfif len(assetp_id) and not listfind(assetp_id_list,assetp_id,',')>
						<cfset assetp_id_list = ListAppend(assetp_id_list,assetp_id,',')>
					</cfif>
				</cfoutput>
				<cfif Len(assetp_id_list)>
					<cfset ListSort(assetp_id_list,"numeric","asc",",")>
					<cfquery name="get_assetp_name" datasource="#dsn#">
						SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#assetp_id_list#) ORDER BY ASSETP_ID
					</cfquery>
					<cfset assetp_id_list = ListSort(ListDeleteDuplicates(ValueList(get_assetp_name.assetp_id,',')),'numeric','asc',',')>
				</cfif>
				<cfoutput query="get_dispatch_team_planning" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td>#currentrow#</td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning&event=upd&planning_id=#planning_id#','list','popup_upd_dispatch_team_planning');" class="tableyazi">#team_code#</a></td>
					<td>#DateFormat(planning_date,dateformat_style)#</td>
					<td>#team_zones#</td>
					<td><cfif Len(assetp_id)>#get_assetp_name.assetp[ListFind(assetp_id_list,assetp_id,',')]#</cfif></td>
					<!-- sil -->
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning&event=upd&planning_id=#planning_id#','list','popup_upd_dispatch_team_planning');" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					<!-- sil -->
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cfif isdefined("attributes.submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.planning_date") and len(attributes.planning_date)>
			<cfset url_str = url_str & "&planning_date=#dateformat(attributes.planning_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.assetp_id) and len(attributes.assetp_name)>
			<cfset url_str = url_str & "&assetp_id=#attributes.assetp_id#&assetp_name=#attributes.assetp_name#">
		</cfif>
		<cfif len(attributes.team_employee_id) and len(attributes.team_employee_name)>
			<cfset url_str = url_str & "&team_employee_id=#attributes.team_employee_id#&team_employee_name=#attributes.team_employee_name#">
		</cfif>
		<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = url_str & "&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.submitted") and len(attributes.submitted)>
			<cfset url_str = url_str & "&submitted=#attributes.submitted#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
