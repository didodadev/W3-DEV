<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfinclude template="../query/get_asset_state.cfm">
<cfinclude template="../query/get_money.cfm">
<cfset motorized_vehicle_value =0>
<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
    <cfset assetp_id = attributes.asset_id>
    <cfif not (isDefined("attributes.care_id") and len(attributes.care_id))>
        <cfquery name="get_cate_states" datasource="#dsn#">
    	SELECT CARE_ID FROM CARE_STATES WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
        </cfquery>
        <cfif get_cate_states.recordcount>
            <cfset attributes.care_id = get_cate_states.CARE_ID>
        </cfif>
    </cfif>
</cfif>
<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
    <cfquery name="GET_ASSET_GUARANTY" datasource="#dsn#">
        SELECT
            *
        FROM 
            ASSET_CARE_REPORT
        WHERE
            ASSET_ID = #attributes.asset_id#
    </cfquery>
</cfif>
<cfif isdefined("attributes.failure_id")>
    <cfquery name="GET_ASSET_FAILURE" datasource="#dsn#">
        SELECT 
            ASSET_FAILURE_NOTICE.STATION_ID,
            ASSET_FAILURE_NOTICE.ASSET_CARE_ID,
            ASSET_P.ASSETP_ID
		FROM
            ASSET_FAILURE_NOTICE,
            ASSET_P,
            ASSET_CARE_CAT
		WHERE
            FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
            ASSET_P.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID AND
            ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
    </cfquery>
    <cfparam name="attributes.asset_id" default="#get_asset_failure.assetp_id#">
	<cfset attributes.care_state_id = get_asset_failure.asset_care_id>
	<cfif len(attributes.asset_id)>
        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
            SELECT 
                ASSET_P.ASSETP,
				ASSET_P.INVENTORY_NUMBER,
                ASSET_P_CAT.MOTORIZED_VEHICLE,
                ASSET_P_CAT.IT_ASSET
		<cfif isdefined("attributes.care_id") and len(attributes.care_id)>
			,'İlişkili Bakım Planı: ' + ASSET_P.INVENTORY_NUMBER + ' ' + ASSET_P.ASSETP as BakimPlani,
			case when CARE_STATES.PERIOD_ID = 1 Then 'Haftada Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 2 Then '15 Günde Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 3 Then 'Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 4 Then '2 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 5 Then '3 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 6 Then '4 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 7 Then '6 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 8 Then 'Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 9 Then '5 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 10 Then '2 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 11 Then '3 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 12 Then '4 Yılda Bir Bakımı'
			else '' end as Periyot
		</cfif>		
			FROM 
                ASSET_P,
                ASSET_P_CAT
		<cfif isdefined("attributes.care_id") and len(attributes.care_id)>
		left join CARE_STATES on (CARE_STATES.CARE_ID = #attributes.care_id#)
		</cfif>
			WHERE 
                ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.assetp_id#"> AND 
                ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
        </cfquery>
        <cfif get_asset_name.motorized_vehicle>
            <cfset motorized_vehicle_value= 1>
        </cfif>
    </cfif>
<cfelse>
    <cfif isdefined("attributes.care_id") and len(attributes.care_id)>
    	<cfquery name="get_station" datasource="#dsn#">
			SELECT STATION_ID,CARE_STATE_ID,ASSET_ID FROM CARE_STATES WHERE CARE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_id#">
        </cfquery>
		<cfset attributes.asset_id = get_station.asset_id>
		<cfset attributes.care_state_id = get_station.care_state_id>
	<cfelse>
		<cfset attributes.asset_id = ''>
		<cfset attributes.care_state_id = ''>
	</cfif>
	<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
            SELECT 
                ASSET_P.ASSETP,
				ASSET_P.INVENTORY_NUMBER,
                ASSET_P_CAT.MOTORIZED_VEHICLE,
                ASSET_P_CAT.IT_ASSET
		<cfif isdefined("attributes.care_id") and len(attributes.care_id)>
			,'İlişkili Bakım Planı: ' + ASSET_P.INVENTORY_NUMBER + ' ' + ASSET_P.ASSETP as BakimPlani,
			case when CARE_STATES.PERIOD_ID = 1 Then 'Haftada Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 2 Then '15 Günde Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 3 Then 'Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 4 Then '2 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 5 Then '3 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 6 Then '4 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 7 Then '6 Ayda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 8 Then 'Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 9 Then '5 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 10 Then '2 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 11 Then '3 Yılda Bir Bakımı'
				 when CARE_STATES.PERIOD_ID = 12 Then '4 Yılda Bir Bakımı'
			else '' end as Periyot
		</cfif>	
			FROM 
                ASSET_P,
                ASSET_P_CAT
		<cfif isdefined("attributes.care_id") and len(attributes.care_id)>
		left join CARE_STATES on (CARE_STATES.CARE_ID = #attributes.care_id#)
		</cfif>
			WHERE 
                ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#"> AND 
                ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
        </cfquery>
		<cfif get_asset_name.motorized_vehicle>
			<cfset motorized_vehicle_value= 1>
		</cfif>
    </cfif>
</cfif>
<cfif IsDefined("assetp_id") and len(assetp_id)>
    <cfquery name="GET_ASSETP" datasource="#DSN#">
        SELECT ASSETP FROM ASSET_P  WHERE ASSETP_ID = #assetp_id#
    </cfquery>
</cfif>
<cfif isDefined("attributes.care_report_id") and len(attributes.care_report_id)>
    <cfquery name="GET_ASSET_CARE" datasource="#DSN#">
        SELECT
            ASSET_CARE_REPORT.DETAIL,
            ASSET_CARE_REPORT.DETAIL2,
            ASSET_CARE_REPORT.COMPANY_ID,
            ASSET_CARE_REPORT.COMPANY_PARTNER_ID,
            ASSET_CARE_REPORT.STATION_ID,
            ASSET_CARE_REPORT.OUR_COMPANY_ID,
            ASSET_CARE_REPORT.PROJECT_ID,
            ASSET_CARE_REPORT.C_EMPLOYEE1_ID,
            ASSET_CARE_REPORT.C_EMPLOYEE2_ID,
            ASSET_CARE_REPORT.DOCUMENT_TYPE_ID,
            ASSET_CARE_REPORT.BILL_ID,
            ASSET_CARE_REPORT.CARE_DATE,
            ASSET_CARE_REPORT.EXPENSE_AMOUNT,
            ASSET_CARE_REPORT.expense_amount_net,
            ASSET_CARE_REPORT.CARE_FINISH_DATE,
            ASSET_CARE_REPORT.ASSET_ID,
            ASSET_CARE_REPORT.CARE_TYPE,
            ASSET_CARE_REPORT.CARE_ID,
            ASSET_P.ASSETP,
            ASSET_P.ASSETP_ID,
            ASSET_P_CAT.MOTORIZED_VEHICLE
        FROM
            ASSET_CARE_REPORT,
            ASSET_P,
            ASSET_P_CAT
        WHERE
            ASSET_CARE_REPORT.CARE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_report_id#"> AND
            ASSET_CARE_REPORT.ASSET_ID = ASSET_P.ASSETP_ID AND
            ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
    </cfquery>
    <cfset attributes.asset_id = get_asset_care.asset_id>
    <cfset attributes.asset_name = get_asset_care.assetp>
</cfif>
<cfif isdefined("url.asset_id") and len(url.asset_id)>
    <cfset attributes.asset_id = url.asset_id>
</cfif>
<cfif isDefined("attributes.asset_id") and Len(attributes.asset_id)>
    <cfquery name="get_care_cat" datasource="#dsn#">
		SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = #attributes.asset_id# AND A.ASSETP_CATID = ACC.ASSETP_CAT
	</cfquery>
</cfif>
<cfif isdefined("get_asset_failure.station_id") and len(get_asset_failure.station_id)>
    <cfset station_id = get_asset_failure.station_id>
    <cfelseif isdefined("get_station.station_id") and len(get_station.STATION_ID)>
    <cfset station_id = get_station.station_id>
<cfelseif isdefined("attributes.station_id") and len(attributes.station_id)>
    <cfset station_id = "#attributes.station_id#">
<cfelse>
    <cfset station_id = "">
</cfif>
<cfif isdefined("attributes.station_company_id") and len(attributes.station_company_id)>
    <cfset station_company_id = "#attributes.station_company_id#">
</cfif>
<cfif isdefined("attributes.station_name") and len(attributes.station_name)>
    <cfset station_name = "#attributes.station_name#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
    <cfset project_id = "#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
    <cfset project_head = "#attributes.project_head#">
</cfif>
<cfif isdefined("attributes.care_type_id") and len(attributes.care_type_id)>
    <cfset care_type_id = "#attributes.care_type_id#">
</cfif>
<cfquery name="GET_MAX_REPORT" datasource="#DSN#">
	SELECT MAX(CARE_REPORT_ID) AS MAX_CARE_REPORT_ID FROM ASSET_CARE_REPORT
</cfquery>
<cfif len(get_max_report.max_care_report_id)>
    <cfset max_asset_care_id = get_max_report.max_care_report_id+1>
<cfelse>
    <cfset max_asset_care_id = 1>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="asset_care" id="asset_care" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_asset_care" onsubmit="return(unformat_fields());">
        <cf_box>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfoutput>
                        <input type="hidden" name="failure_id" id="failure_id" value="<cfif isdefined("attributes.failure_id") and len(attributes.failure_id)>#attributes.failure_id#</cfif>">
                        <input type="hidden" name="asset_id" id="asset_id" value="<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#</cfif>">
                        <input type="hidden" name="motorized_vehicle" id="motorized_vehicle" value="<cfif isdefined("get_asset_name")>#get_asset_name.motorized_vehicle#</cfif>">
                        <input type="hidden" name="care_id" id="care_id" value="<cfif isdefined("attributes.care_id") and len(attributes.care_id)>#attributes.care_id#<cfelseif isDefined("get_asset_care.care_id") and len(get_asset_care.care_id)>#get_asset_care.care_id#</cfif>">
                        <!--- Bakım takviminden kayıt edildiğinde hangi tarihe kayıt edildiğini tutmak için eklendi. --->
                        <input type="hidden" name="calender_date" id="calender_date" value="<cfif isdefined("attributes.cln_date") and len(attributes.cln_date)>#right(attributes.cln_date,2)#/#mid(attributes.cln_date,5,2)#/#left(attributes.cln_date,4)#<cfelseif isdefined('attributes.care_date') and len(attributes.care_date)>#attributes.care_date#</cfif>">
                        
                    </cfoutput>
                    <cfif isdefined("attributes.care_id") and len(attributes.care_id)>
                        <cfoutput>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"></label>
                                <div class="col col-8 col-xs-12"><b>#GET_ASSET_NAME.BakimPlani# #GET_ASSET_NAME.Periyot#</b></div>
                            </div>
                        </cfoutput>
                    </cfif>
                    <div class="form-group" id="item-is_yasal_islem">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48154.Bakım İşlem Tipi'></label>
                        <div class="col col-4 col-xs-12">
                            <label><input name="is_yasal_islem" id="is_yasal_islem" type="radio" value="0" checked onClick="son_deger_degis(0);"><cf_get_lang dictionary_id='48207.Normal Bakım'></label>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <label><input name="is_yasal_islem" id="is_yasal_islem" type="radio" value="1" onClick="son_deger_degis(1);"><cf_get_lang dictionary_id='43161.Yasal Bakım'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47993.Bakım No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="care_number" id="care_number" value="<cfoutput>#max_asset_care_id#</cfoutput>" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-asset_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29452.Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29452.Varlık'></cfsavecontent>
                                <cfif isdefined("get_asset_care.assetp") and len(get_asset_care.assetp)>
                                    <cfinput type="text" name="asset_name" id="asset_name" value="#get_asset_care.assetp#" required="yes" message="#message#">
                                <cfelseif isdefined("get_assetp.assetp") and len(get_assetp.assetp)>
                                    <cfinput type="text" name="asset_name" id="asset_name" value="#get_assetp.assetp#" required="yes" message="#message#">
                                <cfelse>
                                    <cfinput type="text" name="asset_name" id="asset_name" value="" required="yes" message="#message#">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer"onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&call_function=degistir_care_type&field_id=asset_care.asset_id&field_name=asset_care.asset_name&event_id=0&field_motorized_vehicle=asset_care.motorized_vehicle&motorized_vehicle='+document.asset_care.motorized_vehicle.value+'');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-service_company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48111.Bakımı Yapan Sirket'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="service_company_id" id="service_company_id" value="<cfif isDefined("get_asset_care.company_id") and len(get_asset_care.company_id)><cfoutput>#get_asset_care.company_id#</cfoutput></cfif>">
                                <input type="text" name="service_company" id="service_company" value="<cfif isDefined("get_asset_care.company_id") and len(get_asset_care.company_id)><cfoutput>#get_par_info(get_asset_care.company_id,1,0,0)#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=asset_care.service_company&field_comp_id=asset_care.service_company_id&field_name=asset_care.authorized&field_partner=asset_care.authorized_id&is_buyer_seller=1&select_list=7');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-station_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58834.İstasyon'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                    <input type="hidden" name="station_id" id="station_id" <cfif isDefined("get_asset_care.STATION_ID") and len(get_asset_care.STATION_ID)>VALUE="<cfoutput>#get_asset_care.STATION_ID#</cfoutput>"<cfelseif isdefined("attributes.STATION_ID") and len(attributes.STATION_ID)>VALUE="<cfoutput>#attributes.STATION_ID#</cfoutput>"</cfif>>
                                <cfif isDefined("get_asset_care.STATION_ID") and len(get_asset_care.STATION_ID)>
                                    <cfset new_dsn3 = "#dsn#_#get_asset_care.OUR_COMPANY_ID#">
                                    <cfquery name="GET_STATION" datasource="#new_dsn3#">
                                        SELECT  STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #get_asset_care.STATION_ID#
                                    </cfquery>
                                    <input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#get_asset_care.our_company_id#</cfoutput>">
                                    <input type="text" name="station_name" id="station_name" value="<cfoutput>#GET_STATION.STATION_NAME#</cfoutput>">
                                <cfelse>
                                    <input type="hidden" name="station_company_id" id="station_company_id" value="<cfif isDefined("get_asset_care.our_company_id") and len(get_asset_care.our_company_id)><cfoutput>#get_asset_care.our_company_id#</cfoutput><cfelseif isdefined("attributes.station_company_id") and len(attributes.station_company_id)><cfoutput>#attributes.station_company_id#</cfoutput></cfif>">
                                    <input type="text" name="station_name" id="station_name" <cfif isDefined("get_asset_care.station_name") and len(get_asset_care.station_name)>VALUE="<cfoutput>#get_asset_care.station_name#</cfoutput>"<cfelseif isdefined("attributes.station_name") and len(attributes.station_name)>VALUE="<cfoutput>#attributes.station_name#</cfoutput>"</cfif>>
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_comp_id=upd_care.station_company_id&field_name=asset_care.station_name&field_id=asset_care.station_id</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47910.Bakımı Yapan Çalışan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isDefined("get_asset_care.c_employee1_id") and len(get_asset_care.c_employee1_id)><cfoutput>#get_asset_care.c_employee1_id#</cfoutput></cfif>">
                                <input type="text" name="employee" id="employee" value="<cfif isDefined("get_asset_care.c_employee1_id") and len(get_asset_care.c_employee1_id)><cfoutput>#get_emp_info(get_asset_care.c_employee1_id,0,0)#</cfoutput></cfif>"	readonly>
                                <span class="input-group-addon  icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=asset_care.employee_id&field_name=asset_care.employee&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="document_type_id" id="document_type_id">
                                <option value=""></option>
                                <cfoutput query="get_document_type">
                                        <option value="#document_type_id#" <cfif isDefined("get_asset_care.document_type_id") and len(get_asset_care.document_type_id) and get_asset_care.document_type_id eq document_type_id>selected</cfif>>#document_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48629.Bakım Baslangic Tarihi'> *</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfif isDefined("get_asset_care.care_date") and len(get_asset_care.care_date)>
                                    <cfinput type="text" name="care_start_date" value="#dateformat(get_asset_care.care_date,dateformat_style)#" message="#message#" required="yes" validate="#validate_style#" maxlength="10">
                                    <cf_wrk_date_image date_field="care_start_date">
                                    <cfset start_hour = hour(get_asset_care.care_date)>
                                <cfelse>
                                    <cfinput type="text" name="care_start_date" value="" message="#message#" required="yes" validate="#validate_style#" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="care_start_date"></span>
                                </cfif>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-6">
                            <cf_wrkTimeFormat name="start_clock" value="">
                        </div>
                        <div class="col col-2 col-xs-6">
                            <cfoutput>
                                <select name="start_minute" id="start_minute">
                                    <option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="0" to="55" step="5" index="k">
                                            <option value="#k#">#numberformat(k,00)#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_finish_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48630.Bakım Bitis Tarihi'>*</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerinizi Kontrol Ediniz'> !</cfsavecontent>
                                <cfif isDefined("get_asset_care.care_finish_date") and len(get_asset_care.care_finish_date)>
                                    <cfinput type="text" name="care_finish_date" value="#dateformat(get_asset_care.care_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message1#">
                                    <cf_wrk_date_image date_field="care_finish_date">
                                    <cfset finish_hour = hour(get_asset_care.care_finish_date)>
                                    <cfset finish_minute = minute(get_asset_care.care_finish_date)>
                                <cfelse>
                                    <cfinput type="text" name="care_finish_date" value="" validate="#validate_style#" maxlength="10" message="#message1#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="care_finish_date"></span>
                                    <cfset finish_hour = ''>
                                    <cfset finish_minute = ''>
                                </cfif>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-6">
                            <cf_wrkTimeFormat name="finish_clock" value="">
                        </div>
                        <div class="col col-2 col-xs-6">
                            <cfoutput>
                                <select name="finish_minute" id="finish_minute">
                                    <option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="0" to="55" step="5" index="k">
                                            <option value="#numberformat(k,00)#">#numberformat(k,00)#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_guaranty">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48270.Sigorta Odemesi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="col col-3 col-xs-12">
                                    <label><input name="is_guaranty" id="is_guaranty" type="radio" value="0" <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and isdefined("GET_ASSET_GUARANTY") and GET_ASSET_GUARANTY.IS_GUARANTY eq 0>checked</cfif>><cf_get_lang dictionary_id='58546.Yok'></label>
                                </div>
                                <div class="col col-3 col-xs-12">
                                    <label><input name="is_guaranty" id="is_guaranty" type="radio" value="1" <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and isdefined("GET_ASSET_GUARANTY") and GET_ASSET_GUARANTY.IS_GUARANTY eq 1>checked</cfif>><cf_get_lang dictionary_id='58564.Var'></label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="care_detail" id="care_detail"><cfif isDefined("get_asset_care.detail") and len(get_asset_care.detail)><cfoutput>#get_asset_care.detail#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-surec">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47913.Bakım Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="care_type_id" id="care_type_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif isDefined("attributes.asset_id") and Len(attributes.asset_id)>
                                    <cfoutput query="get_care_cat">
                                        <option value="#asset_care_id#" <cfif (isDefined("get_asset_care.care_type") and get_care_cat.asset_care_id eq get_asset_care.care_type) or (isDefined("attributes.CARE_TYPE_ID") and get_care_cat.asset_care_id eq attributes.CARE_TYPE_ID)>selected</cfif>>#asset_care#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-authorized">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47909.Bakımı Yapan Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="authorized_id" id="authorized_id" value="<cfif isDefined("get_asset_care.company_partner_id") and len(get_asset_care.company_partner_id)><cfoutput>#get_asset_care.company_partner_id#</cfoutput></cfif>">
                            <input type="text" name="authorized" id="authorized" value="<cfif isDefined("get_asset_care.company_partner_id") and len(get_asset_care.company_partner_id)><cfoutput>#get_par_info(get_asset_care.company_partner_id,0,-1,0)#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("get_asset_care.project_id") and len(get_asset_care.project_id)><cfoutput>#get_asset_care.project_id#</cfoutput><cfelseif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isDefined("get_asset_care.project_head") and len(get_asset_care.project_head)>#GET_PROJECT_NAME(get_asset_care.project_head)#<cfelseif isdefined("attributes.project_head") and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','asset_care','3','200')" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=asset_care.project_id&project_head=asset_care.project_head</cfoutput>');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47910.Bakım Yapan Çalışan'>2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id2" id="employee_id2" value="<cfif isDefined("get_asset_care.c_employee2_id") and len(get_asset_care.c_employee2_id)><cfoutput>#get_asset_care.c_employee2_id#</cfoutput></cfif>">
                                <input type="text" name="employee2" id="employee2" value="<cfif isDefined("get_asset_care.c_employee2_id") and len(get_asset_care.c_employee2_id)><cfoutput>#get_emp_info(get_asset_care.c_employee2_id,0,0)#</cfoutput></cfif>" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=asset_care.employee_id2&field_name=asset_care.employee2&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div id="belge_no_kapsam">
                        <div class="form-group" id="item-bill_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="bill_id" id="bill_id" value="<cfif isDefined("get_asset_care.bill_id") and len(get_asset_care.bill_id)><cfoutput>#get_asset_care.bill_id#</cfoutput><cfelseif isdefined("attributes.document_no") and len(attributes.document_no)><cfoutput>#attributes.document_no#</cfoutput></cfif>" maxlength="20">
                            </div>
                        </div>
                    </div>
                    <div id="police_no_kapsam" style="display:none;">
                        <div class="form-group" id="item-policy_num">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48113.Poliçe No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="policy_num" id="policy_num" value="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_care_km">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48112.Bakım KM'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="care_km" id="care_km" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event),0);" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-money_currency">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48114.KDV li Toplam Tutar'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58258.maliyet'></cfsavecontent>
                        <div class="col col-5 col-xs-8">
                            <cfif isdefined("get_asset_care.expense_amount") and len(get_asset_care.expense_amount)>
                                <cfinput type="text" name="expense" value="#tlformat(get_asset_care.expense_amount)#" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="expense" value="" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                        <div class="col col-3 col-xs-4">
                            <select name="money_currency" id="money_currency">
                                <cfoutput query="get_money">
                                        <option value="#money#"<cfif money eq session.ep.money> selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-money_currency_net">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48105.KDV siz Toplam Tutar'></label>
                        <div class="col col-5 col-xs-8">
                            <cfif isdefined("get_asset_care.expense_amount_net") and len(get_asset_care.expense_amount_net)>
                                <cfinput type="text" name="expense_net" value="#TLFormat(get_asset_care.expense_amount_net)#" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="expense_net" value="" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                        <div class="col col-3 col-xs-4">
                            <select name="money_currency_net" id="money_currency_net">
                                <cfoutput query="get_money">
                                        <option value="#money#">#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_detail2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>2</label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="care_detail2" id="care_detail2"><cfif isDefined("get_asset_care.detail2") and len(get_asset_care.detail2)><cfoutput>#get_asset_care.detail2#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format='1'>
            </cf_box_footer>
        </cf_box>
        <cfif xml_show_care_rows eq 1>
            <div class="ui-row">
                <div class="col col-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='48401.Bakım Kalemleri'></cfsavecontent>
                    <cfif isDefined("attributes.care_report_id") and len(attributes.care_report_id)>
                        <cf_box id="rel_phy_asset_" title="#message#" box_page="#request.self#?fuseaction=assetcare.emptypopup_add_care_row&care_report_id=#attributes.care_report_id#" closable="0"></cf_box>
                    <cfelse>
                        <cf_box id="rel_phy_asset_" title="#message#" box_page="#request.self#?fuseaction=assetcare.emptypopup_add_care_row" closable="0"></cf_box>
                    </cfif>
                </div>
            </div>
        </cfif>
    </cfform>
</div>
<script>
degistir_care_type();
function son_deger_degis(deger)
{
    if(deger==0)
    {
        goster(belge_no_kapsam);
        gizle(police_no_kapsam);
    }
    else
    {
        goster(police_no_kapsam);
        gizle(belge_no_kapsam);
    }
    degistir_care_type();
}
function degistir_care_type()
{
    if(document.asset_care.is_yasal_islem[1] != undefined && document.asset_care.is_yasal_islem[1].checked == true)
    {var yasal_mi = 1;}
    else if(document.asset_care.is_yasal_islem != undefined && document.asset_care.is_yasal_islem.value == 1)
    {

        var yasal_mi = 1;
    }
    else{
        var yasal_mi = 0;
    }



    for(j=document.getElementById("care_type_id").length; j>=0; j--)
    {
        document.getElementById("care_type_id").options[j] = null;
    }
    var get_care_type_id = wrk_query("SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = " + document.getElementById("asset_id").value + " AND ACC.IS_YASAL = " + yasal_mi + " AND A.ASSETP_CATID = ACC.ASSETP_CAT","dsn");
if(get_care_type_id.recordcount != 0)
{
    document.getElementById("care_type_id").options[0]=new Option('Seçiniz','');
for(var jj=0;jj < get_care_type_id.recordcount; jj++)
{
    document.getElementById("care_type_id").options[jj+1]=new Option(get_care_type_id.ASSET_CARE[jj],get_care_type_id.ASSET_CARE_ID[jj]);
<cfif isDefined("get_asset_care.care_type") and len(get_asset_care.care_type)>
    var gelenDeger = '<cfoutput>#get_asset_care.care_type#</cfoutput>';
        $(document).ready(function () {
            $('#care_type_id option').each(function () {
                if ($(this).val() == gelenDeger) {
                    $(this).attr('selected', 'selected')
                }
            });
        });
</cfif>
}
}
else
{document.getElementById("care_type_id").options[0]=new Option('Seçiniz','');}

}

row_count = 0;

function pencere_ac_asset()
{
}

/*function unformat_fields()
{
    if(asset_care.record_num != undefined)
    {
        for(r=1;r<=asset_care.record_num.value;r++)
        eval("document.asset_care.quantity"+r).value = filterNum(eval("document.asset_care.quantity"+r).value);
    }

    if(document.asset_care.expense != undefined ) document.asset_care.expense.value = filterNum(document.asset_care.expense.value);
    if(document.asset_care.care_km != undefined ) document.asset_care.care_km.value = filterNum(document.asset_care.care_km.value);
}*/

function kontrol()
{
    if(document.asset_care.is_yasal_islem[1] != undefined && document.asset_care.is_yasal_islem[1].checked == true)
    {
        if(document.asset_care.policy_num.value == "")
        {
            alert("<cf_get_lang dictionary_id='52263.Poliçe No Giriniz'>");
            return false;
        }
    }

if(document.asset_care.asset_id.value == "")
{
if(document.asset_care.motorized_vehicle.value != 1)
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29452.Varlık'>");
    return false;
}
else
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58480.Araç'> !");
    return false;
}
}

if(document.asset_care.care_type_id.value == "")
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47913.Bakım Tipi'> !");
    return false;
}
    //belge tipi zorunlulugu xml den gelir BK
    xxx = document.asset_care.document_type_id.selectedIndex;
if(document.asset_care.document_type_id[xxx].value == "")
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58533.Belge Tipi'> !");
    return false;
}
if(document.getElementById('care_start_date').value=='')
{
alert("<cf_get_lang dictionary_id='57782.Tarih Değerinizi Kontrol Ediniz'> !");
    return false;
}
if(document.getElementById('motorized_vehicle').value == 1)
{
if(document.getElementById('care_km').value=="")
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48112.Bakım Km'> !");
    return false;
}
}
    //tarih degerlerinin kontrolu
if ((document.asset_care.care_start_date.value != "") && (document.asset_care.care_finish_date.value != ""))
{
    if(!time_check(document.asset_care.care_start_date,document.asset_care.start_clock,document.asset_care.start_minute,document.asset_care.care_finish_date,document.asset_care.finish_clock,document.asset_care.finish_minute,"<cf_get_lang dictionary_id='54672.Bakım Başlangıç Tarihi ve Saati, Bitiş Tarihi ve Saatinden önce olmalıdır'>"))
    return false;
}
if(asset_care.record_num != undefined && document.asset_care.record_num.value > 0)
{
for(r=1;r<=asset_care.record_num.value;r++)
{
    deger_unit = eval("document.asset_care.unit"+r);
if(eval("document.asset_care.row_kontrol"+r).value == 1)
{
if(eval("document.asset_care.care_cat_id"+r).value == "")
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48401.Bakım Kalemi'>!");
    return false;
}

if(eval("document.asset_care.quantity"+r).value == "")
{
alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57635.Miktar'>!");
    return false;
}

    x = deger_unit.selectedIndex;
if (deger_unit[x].value == "")
{
alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57636.birim'> !");
    return false;
}
}
}
}

    if(process_cat_control())
    {
        if(document.getElementById('care_km') != undefined ) document.getElementById('care_km').value = filterNum(document.getElementById('care_km').value);
    }
    else
        return false;


}
</script>
