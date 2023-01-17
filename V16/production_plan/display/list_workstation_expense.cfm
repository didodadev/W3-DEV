<cfparam  name="attributes.reflection_type" default="">
<cfparam  name="attributes.station_id" default="">
<cfquery name="GET_COMPANY_PERIODS" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#  ORDER BY PERIOD_ID DESC
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID,
            STATION_NAME,
            '' UP_STATION
        FROM 
            #dsn3_alias#.WORKSTATIONS 
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY STATION_NAME ASC
    </cfquery>
<cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
<cfform name="list_workstation" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_product_workstations">
	<cf_big_list_search>
        <cf_big_list_search_area>
			<div class="row">
				<div class="col col-12 form-inline">
					<div class="form-group" id="item-station_id">
						<label><cf_get_lang dictionary_id ='29473.İstasyonlar'></label>
						<div class="x-26">
							<select name="station_id" id="station_id">
								<option value=""><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></option>
								<option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='36444.İstasyonu Boş Olanlar'></option>
								<cfoutput query="get_w">
									<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
								</cfoutput>
							</select>
						</div>	
					</div>
					<div class="form-group" id="item-period_id">
						<label><cf_get_lang dictionary_id="58472.Dönem"></label>
						<div class="x-16">
							<select name="period_id" id="period_id">
								<cfoutput query="get_company_periods">
									<option value="#period_id#"<cfif get_company_periods.period_id eq attributes.period_id>selected</cfif>>#period#</option>
								</cfoutput>
							</select>
						</div>
					</div>	
					<div class="form-group" id="item-reflection_type">
						<label><cf_get_lang dictionary_id="36649.Dağıtım Anahtarı"></label>
						<div class="x-12">
							<select name="reflection_type" id="prod_ref_type" onchange="kontrol_unit();">
								<option value="1" <cfif attributes.reflection_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29513.Süre"></option>
								<option value="2" <cfif attributes.reflection_type eq 2>selected</cfif>><cf_get_lang dictionary_id="36626.Ana Birim"></option>
								<option value="3" <cfif attributes.reflection_type eq 3>selected</cfif>><cf_get_lang dictionary_id="36635.Ek Birim"></option>
								<option value="4" <cfif attributes.reflection_type eq 4>selected</cfif>><cf_get_lang dictionary_id="36648.Standart Alış Fiyatı"></option>
							</select>
						</div>
					</div>
					<div class="form-group" style="margin-top:22px;">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57461.Kaydet'></cfsavecontent>
						<cf_wrk_search_button>
					</div>
				</div>
			</div>
       </cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
<thead>
	<tr>
		<th style="width:30px;"><cf_get_lang dictionary_id="58577.sıra"></th>
		<th><cf_get_lang dictionary_id="36326.İş İstasyonları"></th>
		<th><cf_get_lang dictionary_id="58472.Dönem"></th>
		<th><cf_get_lang dictionary_id="36649.Dağıtım Anahtarı"></th>
		<th style="width:30px;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_product_workstations','wide');"><img src="/images/plus_list.gif" border="0" align="absbottom"></a></th>
	</tr>
</thead>
<tbody>
	<tr>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
</tbody>
</cf_big_list>

