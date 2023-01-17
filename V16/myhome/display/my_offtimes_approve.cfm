<cf_xml_page_edit fuseact="myhome.my_offtimes">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfparam name="attributes.employee_id" default="#attributes.employee_id#">
<cfelse>
	<cfparam name="attributes.employee_id" default="#session.ep.userid#">
</cfif>
<cfparam name="attributes.process_filter" default="">
<cfparam name="attributes.process_status" default="2">


<cfif len(attributes.process_filter)>
    <cfset attributes.process_filter = listfirst(attributes.process_filter)>
</cfif>
<cfif len(attributes.process_status)>
    <cfset attributes.process_status = listfirst(attributes.process_status)>
</cfif>

<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<!--- İzin Süreleri XML'den ayarlanan 'Kaç yıldan itibaren geçmiş günün hesaba katılsın?' parametresi 20191030ERU --->
<cfset get_offtime_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.offtime_limit',
    property_name : 'x_old_sgk_days'
)
>
<!--- ehesap izin listeleme xml'i  "İzin Gün Bilgisi Resmi Tatiller ve Haftasonu Tatilleri Düşürülmeden Gelsin" seçeneği 13012020ERU --->
<cfset get_offtime_x_total_offdays_type = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.offtimes',
    property_name : 'x_total_offdays_type'
)
>

<cfif get_offtime_x_total_offdays_type.recordcount>
	<cfset x_total_offdays_type = get_offtime_x_total_offdays_type.PROPERTY_VALUE>
<cfelse>
	<cfset x_total_offdays_type = 1>
</cfif>

<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>


<cfquery name="get_hours" datasource="#dsn#">
    SELECT		
        OUR_COMPANY_HOURS.*
    FROM
        OUR_COMPANY_HOURS
    WHERE
        OUR_COMPANY_HOURS.DAILY_WORK_HOURS   > 0 AND
        OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
        OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
        OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset daily_work_hours = get_hours.DAILY_WORK_HOURS>
<cfif len(get_hours.recordcount) and len(get_hours.WEEKLY_OFFDAY)>
    <cfset this_week_rest_day_ = get_hours.WEEKLY_OFFDAY>
<cfelse>
    <cfset this_week_rest_day_ = 1>
</cfif>
<!--- çalışma saati başlangıç ve bitişleri al--->
<cfquery name="get_work_time" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.form_add_offtime_popup"> AND
		(PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_hour_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_min_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_hour_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_min_info"> OR
		PROPERTY_NAME = 'finish_am_hour_info' OR
		PROPERTY_NAME = 'finish_am_min_info' OR
		PROPERTY_NAME = 'start_pm_hour_info' OR
		PROPERTY_NAME = 'start_pm_min_info' OR
		PROPERTY_NAME = 'x_min_control'
		)	
</cfquery>
<cfif get_work_time.recordcount>
<cfloop query="get_work_time">	
	<cfif property_name eq 'start_hour_info'>
		<cfset start_hour = property_value>
	<cfelseif property_name eq 'start_min_info'>
		<cfset start_min = property_value>
	<cfelseif property_name eq 'finish_hour_info'>
		<cfset finish_hour = property_value>
	<cfelseif property_name eq 'finish_min_info'>
		<cfset finish_min = property_value>
	<cfelseif PROPERTY_NAME eq 'finish_am_hour_info'>
		<cfset finish_am_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'finish_am_min_info'>
		<cfset finish_am_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'start_pm_hour_info'>
		<cfset start_pm_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'start_pm_min_info'>
		<cfset start_pm_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'x_min_control'>
		<cfset x_min_control = PROPERTY_VALUE>
	</cfif>
</cfloop>
<cfelse>
	<cfset start_hour = '00'>
	<cfset start_min = '00'>
	<cfset finish_hour = '00'>
	<cfset finish_min = '00'>
	<cfset finish_am_hour = '00'>
	<cfset finish_am_min = '00'>
	<cfset start_pm_hour = '00'>
	<cfset start_pm_min = '00'>
	<cfset x_min_control = 0>
</cfif>	
<cfif not isdefined("x_min_control")>
	<cfset x_min_control = 0>
</cfif>

<cfset offday_list = ''>
<cfset offday_list_ = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''><!--- başlangıç --->
<cfset halfofftime_list3 = ''><!--- Bitiş --->
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>

<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
		for (mck=0; mck lt offday_gun; mck=mck+1)
		{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
			{
				halfofftime_list = listappend(halfofftime_list,'#daycode#');
			}
		}
	</cfscript>
</cfoutput>
<cfset employee_list=''>

<cfinclude template="../query/get_other_offtimes.cfm">
<cfif get_other_offtimes.recordcount>
    <cfoutput query="get_other_offtimes">
        <cfif len(employee_id) and not listfind(employee_list,employee_id)>
            <cfset employee_list=listappend(employee_list,employee_id)>
        </cfif>
    </cfoutput>
    <cfset employee_list=listsort(listdeleteduplicates(employee_list,','),'numeric','ASC',',')>
</cfif>
<cf_box>
    <cfform name = "search_form" method="post" action=""> 
        <div class="ui-form-list flex-list">
            <div class="form-group">
                <select name="process_status" id="process_status" onchange="show_hide_process()">
                    <option value="2" <cfif attributes.process_status eq 2>selected</cfif>><cf_get_lang dictionary_id='61148.İK Sürecini Bekleyenler'></option>
                    <option value="1" <cfif attributes.process_status eq 1>selected</cfif>><cf_get_lang dictionary_id='61149.IK Tarafından Onaylananlar'></option>
                    <option value="0" <cfif attributes.process_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61150.IK Tarafından Red Edilenler'></option>
                    <option value="3" <cfif attributes.process_status eq 3>selected</cfif>><cf_get_lang dictionary_id='63247.Benim Onayımı Bekleyenler'></option>
                </select>
            </div>
            <div class="form-group" style="display:none"  id="process_div">
                <cf_workcube_process is_upd='0' select_value='#attributes.process_filter#' is_select_text='1' process_cat_width='150' is_detail='0' select_name="process_filter">
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </div>
    </cfform>
</cf_box>
<cfparam name="attributes.totalrecords" default='#get_other_offtimes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_str = "";
	if (len(attributes.process_filter))
		url_str = "#url_str#&process_filter=#attributes.process_filter#";
	if (len(attributes.process_status))
		url_str = "#url_str#&process_status=#attributes.process_status#";
	if (isdefined("attributes.form_submit"))
		url_str = "#url_str#&form_submit=1";	
    if (isdefined("attributes.fuseaction"))
		url_str = "#url_str#&fuseaction=#attributes.fuseaction#";	  
</cfscript>

<cfform name="setProcessForm" id="setProcessForm" method="post">
    <cf_box title="#getLang('myhome',348)#" closable="0">
        <div>
            <cf_flat_list>
                <thead>			
                    <tr>
                        <th height="22"><cf_get_lang_main no='75.No'></th>
                        <th width="120"><cf_get_lang_main no='74.Kategori'></th>
                        <th><cf_get_lang_main no='158.Ad Soyad'></th>
                        <th width="220"><cf_get_lang dictionary_id='59811.İzin tarihi'></th>
                        <th width="100"><cf_get_lang_main no='78.Gün'></th>
                        <cfif x_min_control eq 1><th></th></cfif>
                        <cfif xml_offtime_ise_giris_tarihi eq 1>
                            <th>İşe Giriş Tarihi</th>
                        </cfif>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                        <!--- <th width="60"><cf_get_lang no="650.Kalan İzin"></th> --->
                        <th width="120"><cf_get_lang dictionary_id="57627.Kayıt tarihi"></th>
                        <th class="header_icn_none"></th>
                        <cfif attributes.fuseaction eq 'myhome.my_offtimes_approve'>
                            <th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
                        </cfif>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_other_offtimes.recordcount>
                        <cfoutput query="get_other_offtimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfset genel_izin_toplam = 0>
                            <cfset genel_dk_toplam = 0>
                            <cfset kisi_izin_toplam = 0>
                            <cfset kisi_izin_sayilmayan = 0>
                            <cfset izin_sayilmayan = 0>

                            <tr>
                                <td width="25"><a href="#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#" class="tableyazi">#offtime_id#</a></td>
                                <td><a href="#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#"  class="tableyazi">#NEW_CAT_NAME#</a></td>
                                <td>
                                    <cfif len(employee_id)>
                                        #get_emp_info(employee_id,0,0)#
                                    </cfif>
                                </td>
                                <td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# ) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)# )</td>
                                <td>
                                    <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                        SELECT SATURDAY_ON,DAY_CONTROL,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
                                        <cfif len(puantaj_group_ids)>
                                        (
                                            <cfloop from="1" to="#listlen(puantaj_group_ids)#" index="i">
                                                ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(puantaj_group_ids,i,",")#,%' <cfif listlen(puantaj_group_ids) neq i>OR</cfif> 
                                            </cfloop>
                                        )
                                        <cfelse>
                                            PUANTAJ_GROUP_IDS IS NULL
                                        </cfif>	
                                    </cfquery>
                                    <!--- Çalışanın vardiyalı çalışma saatleri --->
                                    <!--- Çalışanın vardiyalı çalışma saatleri --->
                                    <cfset finishdate_ = dateadd("d", 1, finishdate)>
                                    <cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_, control : 0)>
                            
                                        <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                            SELECT LIMIT_ID,SATURDAY_ON,DAY_CONTROL,DAY_CONTROL_AFTERNOON,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
                                            <cfif len(PUANTAJ_GROUP_IDS)>
                                            (
                                                <cfloop from="1" to="#listlen(puantaj_group_ids)#" index="i">
                                                    ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
                                                </cfloop>
                                            )
                                            <cfelse>
                                                PUANTAJ_GROUP_IDS IS NULL
                                            </cfif>
                                        </cfquery>
                                        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on)>
                                            <cfset saturday_on = get_offtime_cat.saturday_on>
                                        <cfelse>
                                            <cfset saturday_on = 1>
                                        </cfif>
                                        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
                                            <cfset day_control_ = get_offtime_cat.day_control>
                                        <cfelse>
                                            <cfset day_control_ = 0>
                                        </cfif>
                                        <cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
                                            <cfset day_control_afternoon = get_offtime_cat.day_control_afternoon>
                                        <cfelse>
                                            <cfset day_control_afternoon = 0>
                                        </cfif>
                                        <cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
                                            <cfset day_control = get_offtime_cat.day_control>
                                        <cfelse>
                                            <cfset day_control = 0>
                                        </cfif>
                                        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on)>
                                            <cfset sunday_on = get_offtime_cat.sunday_on>
                                        <cfelse>
                                            <cfset sunday_on = 0>
                                        </cfif>
                                        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on)>
                                            <cfset public_holiday_on = get_offtime_cat.public_holiday_on>
                                        <cfelse>
                                            <cfset public_holiday_on = 0>
                                        </cfif>
                                        <cfset get_offtimes = GET_OTHER_OFFTIMES>
                                        <!--- İzin Hesapları bu dosyada yapılıyor ---->
                                        <cfif x_min_control eq 1>
                                            <cfif get_shift.recordcount>
                                                <cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
                                            <cfelse>
                                                <cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
                                            </cfif>
                                            #TLFormat(total_day_calc,2)# 
                                        <cfelse>
                                            <cfif get_shift.recordcount gt 0>
                                                <cfquery name="get_emp_in_out" datasource="#dsn#">
                                                    SELECT   
                                                        IS_VARDIYA
                                                    FROM
                                                        EMPLOYEES_IN_OUT EI
                                                    WHERE
                                                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
                                                    ORDER BY 
                                                        IN_OUT_ID DESC, IS_VARDIYA DESC
                                                </cfquery>
                                                <cfif len(get_shift.WEEK_OFFDAY) and get_emp_in_out.IS_VARDIYA eq 2>
                                                    <cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
                                                <cfelse>
                                                    <cfset this_week_rest_day_ = 1>
                                                </cfif>
                                            <cfelse>
                                                <cfset this_week_rest_day_ = this_week_rest_day_>
                                            </cfif>
                                            <cfinclude template="/V16/hr/ehesap/display/offtime_calc_day.cfm">
                                            #izin_gun# 
                                        </cfif>   
                                    </td>  
                                    <cfif x_min_control eq 1>
                                        <td  align="center">
                                            <cfsavecontent variable = "day">
                                                <cf_get_lang dictionary_id ="57490.Gün">
                                            </cfsavecontent>
                                            <cfsavecontent variable = "hour">
                                                <cf_get_lang dictionary_id ="57491.Saat">
                                            </cfsavecontent>
                                            <cfsavecontent variable = "min">
                                                <cf_get_lang dictionary_id ="58827.Dk">
                                            </cfsavecontent>
                                            <cfif days neq 0>#days##left(day,1)# </cfif>
                                            <cfif hours neq 0>#hours##left(hour,1)# </cfif>
                                            <cfif minutes neq 0>#minutes##min# </cfif>
                                        </td>
                                    </cfif>
                                <cfif xml_offtime_ise_giris_tarihi eq 1>
                                    <td>#dateformat(start_date,dateformat_style)#</td>
                                </cfif>
                                <td><cf_workcube_process type='color-status' process_stage='#OFFTIME_STAGE#'></td>
                                <!--- <td style="text-align:center;">
                                    <cfset attributes.employee_id = employee_id>
                                    <cfoutput>#toplam_hakedilen_izin - genel_izin_toplam - old_days#</cfoutput> 
                                </td>--->
                                <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                <td class="text-right"><a href="#request.self#?fuseaction=myhome.my_offtimes_approve&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#"><i class="fa fa-retweet" title="<cf_get_lang dictionary_id='30923.Güncelle'>"></i></a></td>
                                <cfif attributes.fuseaction eq 'myhome.my_offtimes_approve' and isdefined("W_ID") and len(W_ID)> 
                                    <td>
                                        <input class="checkControl" type="checkbox" name="check_id" id="check_id" value="#W_ID#"/>
                                    </td>
                                </cfif>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr height="20">
                            <td colspan="9"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
            <cf_paging
            name="setProcessForm"
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="myhome.my_offtimes_approve#url_str#"
            is_form="1"
            >
        </div>
        <cfif isdefined("attributes.process_filter") and len(attributes.process_filter)>
            <cf_box_footer>
                <div class="col col-12 col-xs-12 text-right">
                    <input type="hidden" name="process_filter" id="process_filter" value="<cfoutput>#attributes.process_filter#</cfoutput>">
                    <input type="hidden" name="process_status" id="process_status" value="<cfoutput>#attributes.process_status#</cfoutput>">
                    <input type="hidden" name="approve_submit" id="approve_submit" value="1">
                    <input type="hidden" name="valid_ids" id="valid_ids" value="">
                    <input type="hidden" name="refusal_ids" id="refusal_ids" value="">
                    <input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                    <input type="hidden" name="fuseaction_reload" id="fuseaction_reload" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                    <cfsavecontent variable="onayla"><cf_get_lang dictionary_id="58475.Onayla"></cfsavecontent>
                    <cfsavecontent variable="reddet"><cf_get_lang dictionary_id="58461.reddet"></cfsavecontent>
                    <cf_workcube_buttons extraButton="1" extraButtonText="#reddet#" extraFunction="setHealthExpenseProcess(2)" update_status="0">
                    <cf_workcube_buttons extraButton="1" extraButtonText="#onayla#" extraFunction="setHealthExpenseProcess(1)" update_status="0">
                </div>
            </cf_box_footer>
        </cfif>
       
    </cf_box>
</cfform>
<script type="text/javascript">
    show_hide_process();
    $(function(){
        $('input[name=checkAll]').click(function(){
            if(this.checked){
                $('.checkControl').each(function(){
                    $(this).prop("checked", true);
                });
            }
            else{
                $('.checkControl').each(function(){
                    $(this).prop("checked", false);
                });
            }
        });
    });
    function setHealthExpenseProcess(type){
        var controlChc = 0;
        $('.checkControl').each(function(){
            if(this.checked){
                controlChc += 1;
            }
        });
        if(controlChc == 0){
            alert("İzin Seçiniz");
            return false;
        }
        if(type == 2){
            $("#check_id:checked").each(function () {
                $(this).attr('name', 'refusal_ids');
            });
        }else{
            $("#check_id:checked").each(function () {
                $(this).attr('name', 'valid_ids');

            });
        }
        $("#setProcessForm").attr("action", "<cfoutput>#request.self#?fuseaction=myhome.emptypopup_upd_list_warning</cfoutput>");
        $('#setProcessForm').submit();
    }
    function kontrol()
    {
        if(!date_check(document.list_offtimes.startdate, document.list_offtimes.finishdate, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
            return false;
        else
            return true;
    }	
    
    function open_graph()
    {
        <cfoutput>
            list_offtimes.action = '#request.self#?fuseaction=myhome.offtime_graph&startdate=#dateformat((date_add("m",-1,CreateDate(year(now()),month(now()),1))))#&finishdate=#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#';
            list_offtimes.submit();
        </cfoutput>
    }
    function delete_offtime(offtime_id)//İzin İptal 20191023ERU
    {
        if (confirm("<cf_get_lang dictionary_id='51682.İzini iptal etmek istediğinize emin misiniz?'>")){
            $.ajax({ 
                type:'POST',  
                url:'V16/myhome/cfc/offtimes.cfc?method=UPDATE_OFFTIMES_CANCEL',
                data: {
                    offtime_id : offtime_id
                },
                success: function (returnData) {  
                    window.location.reload(); 
                },
                error: function () 
                {
                    console.log('CODE:8 please, try again..');
                    return false; 
                }
            });
        }
        else
            return false;
    }
    function show_hide_process(){
        process_status = $('#process_status').val();
        if (process_status != 3){
            document.getElementById('process_div').style.display = 'none';
            document.getElementById('process_filter').value = '';  
        }else{
            document.getElementById('process_div').style.display = '';
        }
    }
</script>