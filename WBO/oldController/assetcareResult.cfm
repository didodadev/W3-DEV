<cf_get_lang_set module = "assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.assetpcatid" default="">
    <cfif xml_datediff_finish_and_now eq 1>
        <cfparam name="attributes.date_format" default="4">
    <cfelse>
        <cfparam name="attributes.date_format" default="2">
    </cfif>
    <cfparam name="attributes.branch_id" default="">
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
        <cfinclude template="../assetcare/query/get_assetcare_report.cfm">
    <cfelse>
        <cfset get_assetcare_report.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_assetcare_report.recordcount#'>
	<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
    <cfinclude template="../assetcare/query/get_document_type.cfm">
    <cfinclude template="../assetcare/query/get_unit.cfm">
    <cfinclude template="../assetcare/query/get_asset_state.cfm">
    <cfinclude template="../assetcare/query/get_money.cfm">
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
    <cfif isdefined("attributes.asset_id") and len(asset_id)>
    <cfquery name="GET_ASSET_GUARANTY" datasource="#dsn#">
        SELECT
            IS_GUARANTY,*
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
                    ASSET_P_CAT.MOTORIZED_VEHICLE,
                    ASSET_P_CAT.IT_ASSET
                FROM 
                    ASSET_P,
                    ASSET_P_CAT
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
                SELECT STATION_ID,CARE_STATE_ID,ASSET_ID,CARE_TYPE_ID FROM CARE_STATES WHERE CARE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_id#">
            </cfquery>
            <cfset attributes.asset_id = get_station.asset_id>
            <cfset attributes.care_state_id = get_station.care_state_id>
        <cfelse>
            <!---<cfset attributes.asset_id = ''>--->
            <cfset attributes.care_state_id = ''>
        </cfif>
        <cfif isdefined("attributes.asset_id") and len(attributes.asset_id)><!---Neden ilişkili fiziki varlık üzerinden işlem yapılmaya çalışılmış ? Bilgisi olan ? Kodu kapatıyorum. PY 0615 --->
            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                SELECT 
                   -- B.ASSETP,
                    A.ASSETP,
                    A.RELATION_PHYSICAL_ASSET_ID,
                    ASSET_P_CAT.MOTORIZED_VEHICLE,
                    ASSET_P_CAT.IT_ASSET
                FROM 
                    ASSET_P A,
                  --  ASSET_P B,
                    ASSET_P_CAT
                WHERE 
                    A.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#"> AND 
                   -- A.RELATION_PHYSICAL_ASSET_ID = B.ASSETP_ID AND
                    A.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
            </cfquery>
            <cfif len(get_asset_name.motorized_vehicle)>
                <cfset motorized_vehicle_value = 1>            
            </cfif>
           <!--- <cfset attributes.asset_id = GET_ASSET_NAME.RELATION_PHYSICAL_ASSET_ID>--->
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
    <cfelse>
        <cfset station_id = "">
    </cfif>
    <cfquery name="GET_MAX_REPORT" datasource="#DSN#">
        SELECT MAX(CARE_REPORT_ID) AS MAX_CARE_REPORT_ID FROM ASSET_CARE_REPORT
    </cfquery> 
    <cfif len(get_max_report.max_care_report_id)>
        <cfset max_asset_care_id = get_max_report.max_care_report_id+1>
    <cfelse>
        <cfset max_asset_care_id = 1>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
    <cfinclude template="../assetcare/query/get_document_type.cfm">
    <cfinclude template="../assetcare/query/get_unit.cfm">
    <cfif isdefined("attributes.care_report_id") and len(care_report_id)>
    <cfquery name="GET_ASSET_GUARANTY" datasource="#dsn#">
        SELECT
            IS_GUARANTY,*
        FROM 
            ASSET_CARE_REPORT
        WHERE
            CARE_REPORT_ID = #attributes.care_report_id#
        </cfquery>
    </cfif>
    <cfquery name="GET_ASSET_CARE" datasource="#DSN#">
        SELECT
            ASSET_CARE_REPORT.*,
            <!--- ASSET_CARE_CAT.ASSET_CARE, --->
            ASSET_P.ASSETP,
            ASSET_P.ASSETP_ID,
            ASSET_P_CAT.MOTORIZED_VEHICLE
        FROM
            ASSET_CARE_REPORT,
            <!--- ASSET_CARE_CAT, --->
            ASSET_P,
            ASSET_P_CAT
        WHERE
            ASSET_CARE_REPORT.CARE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_report_id#"> AND
            <!--- ASSET_CARE_REPORT.CARE_TYPE = ASSET_CARE_CAT.ASSET_CARE_ID AND --->
            ASSET_CARE_REPORT.ASSET_ID = ASSET_P.ASSETP_ID AND
            ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
    </cfquery>
    <cfquery name="GET_CARE_REPORT_ROW" datasource="#DSN#">
        SELECT
            ASSET_CARE_REPORT_ROW.*,
            SETUP_CARE_CAT.HIERARCHY,
            SETUP_CARE_CAT.CARE_CAT
        FROM
            ASSET_CARE_REPORT_ROW,
            SETUP_CARE_CAT
        WHERE
            CARE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_report_id#"> AND
            SETUP_CARE_CAT.CARE_CAT_ID = ASSET_CARE_REPORT_ROW.CARE_CAT_ID
        ORDER BY
            ASSET_CARE_REPORT_ROW.CARE_REPORT_ROW_ID
    </cfquery>
    <cfset row = get_care_report_row.recordcount>
    <cfif len(get_asset_care.motorized_vehicle)>
        <cfset motorized_vehicle_value = 1>
    <cfelse>
        <cfset motorized_vehicle_value = 0>
    </cfif>
    <cfquery name="get_care_cat" datasource="#dsn#">
        SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = #get_asset_care.assetp_id# AND A.ASSETP_CATID = ACC.ASSETP_CAT
    </cfquery>
    <cfset start_hour = hour(get_asset_care.care_date)>
    <cfif len(get_asset_care.care_finish_date)>
		<cfset finish_hour = hour(get_asset_care.care_finish_date)>
        <cfset finish_minute = minute(get_asset_care.care_finish_date)>
    <cfelse>
        <cfset finish_hour = ''>
        <cfset finish_minute = ''>
    </cfif>
    <cfif len(get_asset_care.care_date)>
		<cfset start_hour = hour(get_asset_care.care_date)>
        <cfset start_minute = minute(get_asset_care.care_date)>
    <cfelse>
        <cfset start_hour = ''>
        <cfset start_minute = ''>
    </cfif>
    <cfinclude template="../assetcare/query/get_money.cfm">
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		$(document).ready(function(){
			$('#keyword').focus();
			});
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		function kontrol()
		{
			if(document.assetCare.is_yasal_islem[1] != undefined && document.assetCare.is_yasal_islem[1].checked == true)
			{
				if(document.assetCare.policy_num.value == "")
				{
					alert('<cf_get_lang dictionary_id="52263.Poliçe No Giriniz">!');
					return false;
				}
			}
		
			if(document.assetCare.asset_id.value == "")
			{
				if(document.assetCare.motorized_vehicle.value != 1)
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>");
					return false;
				}
				else
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1068.Araç'> !");
					return false;
				}
			}
			if(document.assetCare.care_type_id.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'> !");
				return false;
			}
			if(document.getElementById('care_start_date').value=='')
			{
				alert("<cf_get_lang_main no='370.Tarih Değerinizi Kontrol Ediniz'> !");
				return false;
			}
			if(document.getElementById('motorized_vehicle').value == 1)
			{
				if(document.getElementById('care_km').value=="")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='241.Bakım Km'> !");
					return false;
				}
			}
			//tarih degerlerinin kontrolu
			if ((document.assetCare.care_start_date.value != "") && (document.assetCare.care_finish_date.value != ""))
			{
				fix_date(document.assetCare.care_start_date,document.assetCare.care_start_date.name);
				fix_date(document.assetCare.care_finish_date,document.assetCare.care_finish_date.name);
			
			
				tarih1_ = document.assetCare.care_start_date.value.substr(6,4) + document.assetCare.care_start_date.value.substr(3,2) + document.assetCare.care_start_date.value.substr(0,2);
				tarih2_ = document.assetCare.care_finish_date.value.substr(6,4) + document.assetCare.care_finish_date.value.substr(3,2) + document.assetCare.care_finish_date.value.substr(0,2);
			
				if(document.assetCare.start_clock.value.length < 2) saat1_ = '00'; else saat1_ = document.assetCare.start_clock.value;
				if(document.assetCare.start_minute.value.length < 2) dakika1_ = '00'; else dakika1_ = document.assetCare.start_minute.value;
				if(document.assetCare.finish_clock.value.length < 2) saat2_ = '00'; else saat2_ = document.assetCare.finish_clock.value;
				if(document.assetCare.finish_minute.value.length < 2) dakika2_ = '00'; else dakika2_ = document.assetCare.finish_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;	
				
				if (tarih1_ >= tarih2_) 
				{
					alert("<cf_get_lang_main no='370.Tarih Değerlerini Kontrol Ediniz '> !");
					return false;
				}
			}		
			if(assetCare.record_num != undefined && document.assetCare.record_num.value > 0)
			{
				for(r=1;r<=assetCare.record_num.value;r++)
				{
					deger_unit = eval("document.assetCare.unit"+r);
					if(eval("document.assetCare.row_kontrol"+r).value == 1)
					{
						if(eval("document.assetCare.care_cat_id"+r).value == "")
						{
							alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='530.Bakım Kalemi'>!");
							return false;
						}
						
						if(eval("document.assetCare.quantity"+r).value == "")
						{
							alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='223.Miktar'>!");
							return false;
						}
						
						x = deger_unit.selectedIndex;
						if (deger_unit[x].value == "")
						{ 
							alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='224.birim'> !");
							return false;
						}
					}
				}
			}
			unformat_fields();
			if(process_cat_control())
			{
				if(document.getElementById('expense') != undefined ) document.getElementById('expense').value = filterNum(document.getElementById('expense').value);
				if(document.getElementById('care_km') != undefined ) document.getElementById('care_km').value = filterNum(document.getElementById('care_km').value); 

			}
			else
				return false;
			
			return true;
	
		}
		function degistir_care_type()
		{
			if(document.assetCare.is_yasal_islem[1] != undefined && document.assetCare.is_yasal_islem[1].checked == true)
				var yasal_mi = 1;
			else if(document.assetCare.is_yasal_islem != undefined && document.assetCare.is_yasal_islem.value == 1)
				var yasal_mi = 1;
			else
				var yasal_mi = 0;
			<cfif not isdefined("attributes.from_care")>
				for(j=document.getElementById("care_type_id").length; j>=0; j--)
					document.getElementById("care_type_id").options[j] = null;
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
					document.getElementById("care_type_id").options[0]=new Option('Seçiniz','');
			</cfif>
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		$(document).ready(function(){
			degistir_care_type(); //FBS20121207 kaldirdim, bakim planindan geldiginde kaldirmasina gerek yok zaten duzgun secilmis oluyor
			row_count = 0;
		});
		
		function pencere_ac_asset()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=assetCare.asset_id&field_name=assetCare.asset_name&event_id=0&field_motorized_vehicle=assetCare.motorized_vehicle&motorized_vehicle='+document.assetCare.motorized_vehicle.value+'&call_function=degistir_care_type','list','popup_list_assetps');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		$(document).ready(function(){
			row_count=<cfoutput>#row#</cfoutput>;
		});
		
		function unformat_fields()
		{
			if(assetCare.record_num != undefined)
			{
				for(r=1;r<=assetCare.record_num.value;r++)
					eval("document.assetCare.quantity"+r).value = filterNum(eval("document.assetCare.quantity"+r).value);
			}
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_asset_care';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_asset_care.cfm';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.list_asset_care';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/display/add_asset_care.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_asset_care.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_asset_care&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.list_asset_care';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/display/upd_asset_care.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_asset_care.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_care&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'care_report_id=##attributes.care_report_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.care_report_id##';
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')       
	{

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&asset_id=#get_asset_care.assetp_id#&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&asset_id=#get_asset_care.assetp_id#&care_report_id=#attributes.care_report_id#&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.care_report_id#&print_type=253','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(isdefined("attributes.event") and listfind('upd,del',attributes.event))       
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_asset_care&care_report_id=#care_report_id#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'assetcare/query/del_asset_care.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'assetcare/query/del_asset_care.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_asset_care';

	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetcareController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ASSET_P';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-care_km','item-asset_name','item-care_type_id','item-care_start_date','item-process_stage','item-policy_num','item-care_km']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

	
</cfscript>
