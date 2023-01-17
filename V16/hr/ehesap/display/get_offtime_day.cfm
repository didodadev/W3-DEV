<cfsetting showdebugoutput="no">
<cfif listFindNoCase('0',attributes.type)>
	<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
        SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
    </cfquery>
    <cfset offday_list_ = ''>
    <cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
    <cfoutput query="GET_GENERAL_OFFTIMES">
        <cfscript>
            offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
            offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
            offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
            for (mck=0; mck lt offday_gun; mck=mck+1)
            {
                temp_izin_gunu = date_add("d",mck,offday_startdate);
                daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
                if(not listfindnocase(offday_list_,'#daycode#'))
                offday_list_ = listappend(offday_list_,'#daycode#');
                if(GET_GENERAL_OFFTIMES.is_halfofftime is 1)
                {
                    halfofftime_list = listappend(halfofftime_list,'#daycode#');
                }
            }
        </cfscript>
    </cfoutput>	
    <cfquery name="get_hours" datasource="#dsn#">
        SELECT		
            OUR_COMPANY_HOURS.WEEKLY_OFFDAY
        FROM
            OUR_COMPANY_HOURS
        WHERE
            OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.OUR_COMPANY_ID = #session.ep.company_id#
    </cfquery>
    
    <cfif len(get_hours.recordcount) and len(get_hours.WEEKLY_OFFDAY)>
        <cfset this_week_rest_day_ = get_hours.WEEKLY_OFFDAY>
    <cfelse>
        <cfset this_week_rest_day_ = 1>
    </cfif>
    <cfset startdate = dateFormat(attributes.start_date,'dd.mm.yyyy')>
    <cf_date tarih="startdate">
    <cfset finishdate = dateFormat(attributes.finish_date,'dd.mm.yyyy')>
    <cf_date tarih="finishdate">
    <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
        SELECT SATURDAY_ON,DAY_CONTROL FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #startdate#  AND FINISHDATE >= #startdate#
    </cfquery>
    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
        <cfset saturday_on = get_offtime_cat.SATURDAY_ON>
    <cfelse>
        <cfset saturday_on = 1>
    </cfif>
    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.DAY_CONTROL)>
        <cfset day_control_ = get_offtime_cat.DAY_CONTROL>
    <cfelse>
        <cfset day_control_ = 0>
    </cfif>
    <cfquery name="get_work_time" datasource="#dsn#">
        SELECT 
            PROPERTY_VALUE,
            PROPERTY_NAME
        FROM
            FUSEACTION_PROPERTY
        WHERE
            OUR_COMPANY_ID = #session.ep.company_id# AND
            FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
            (PROPERTY_NAME = 'start_hour_info' OR
            PROPERTY_NAME = 'start_min_info' OR
            PROPERTY_NAME = 'finish_hour_info' OR
            PROPERTY_NAME = 'finish_min_info'
            )	
    </cfquery>
    <cfif get_work_time.recordcount>
        <cfloop query="get_work_time">	
            <cfif PROPERTY_NAME eq 'start_hour_info'>
                <cfset start_hour = PROPERTY_VALUE>
            <cfelseif PROPERTY_NAME eq 'start_min_info'>
                <cfset start_min = PROPERTY_VALUE>
            <cfelseif PROPERTY_NAME eq 'finish_hour_info'>
                <cfset finish_hour = PROPERTY_VALUE>
            <cfelseif PROPERTY_NAME eq 'finish_min_info'>
                <cfset finish_min = PROPERTY_VALUE>
            </cfif>
        </cfloop>
    <cfelse>
        <cfset start_hour = '00'>
        <cfset start_min = '00'>
        <cfset finish_hour = '00'>
        <cfset finish_min = '00'>
    </cfif>
    <cfquery name="GET_OFFTIME_INFO" datasource="#DSN#">


        SELECT IS_PAID,EBILDIRGE_TYPE_ID FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = #attributes.izinType#
    </cfquery>
    <cfscript>
        temporary_sunday_total_ = 0;
        temporary_offday_total_ = 0;
        temporary_halfday_total = 0;
        temporary_halfofftime = 0;
        //total_izin_ = (dateformat(finishdate,'dd.mm.yyyy')-dateformat(startdate,'dd.mm.yyyy'))+1;
        total_izin_ = datediff('d',dateFormat(startdate,'dd.mm.yyyy'),dateFormat(finishdate,'dd.mm.yyyy'))+1;
        if(total_izin_ lte 0) total_izin_=1;
        
        izin_startdate_ = date_add("h", session.ep.time_zone, startdate); 
        izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
        fark = 0;
        fark2 = 0;
        if(dateformat(izin_startdate_,dateformat_style) eq dateformat(izin_finishdate_,dateformat_style))
        {
            fark = fark+datediff("n",timeformat(izin_startdate_,timeformat_style),timeformat(izin_finishdate_,timeformat_style));
            fark = fark/60;
        }
        else
        {
            if(timeformat(izin_startdate_,timeformat_style) gt timeformat('#start_hour#:#start_min#',timeformat_style))
            {
                fark = fark+datediff("n",timeformat(izin_startdate_,timeformat_style),timeformat('#finish_hour#:#finish_min#',timeformat_style));
                fark = fark/60;
            }
            else 
            {
                fark = fark+datediff("n",timeformat(izin_startdate_,timeformat_style),timeformat('#start_hour#:#start_min#',timeformat_style));
                fark = fark/60;
            }
            fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),timeformat(izin_finishdate_,timeformat_style));
            fark2 = fark2/60;
        }
        if(fark gt 0 and fark lte day_control_)
        {
            temporary_halfday_total = temporary_halfday_total + 1;
        }
        if(fark2 gt 0 and fark2 lte day_control_)
        {
            temporary_halfday_total = temporary_halfday_total + 1;
        }
        for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
        {
            temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
            daycode_ = '#dateformat(temp_izin_gunu_,'dd.mm.yyyy')#';
            
            if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
            temporary_sunday_total_ = temporary_sunday_total_ + 1;
            else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
            temporary_sunday_total_ = temporary_sunday_total_ + 1;
            else if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode_#'))
            temporary_offday_total_ = temporary_offday_total_ + 1;
            //else if(daycode_ is '#dateformat(dateadd("h",2,finishdate),dateformat_style)#' and day_control_ gt 0 and timeformat(dateadd("h",2,finishdate),'HH') lt day_control_)
            //temporary_halfday_total = temporary_halfday_total + 1;
            if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')) //yarım günlük genel tatiller
            {	
                temporary_halfofftime = temporary_halfofftime + 1; 
            }
        }
    </cfscript>
</cfif>
<cfif attributes.type eq 0>
	<cfset count = attributes.active_row>
	<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and datecompare(dateFormat(attributes.start_date,'dd.mm.yyyy'),dateFormat(attributes.finish_date,'dd.mm.yyyy')) neq 1>
		<cf_date tarih="attributes.start_date">
		<cf_date tarih="attributes.finish_date">
		<cfscript>
        if(GET_OFFTIME_INFO.is_paid neq 1 and GET_OFFTIME_INFO.ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez  
            {
                izin_gun = total_izin_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime);
            }
        else
            {
                izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime);
            }
		</cfscript>
		<input type="text" name="<cfoutput>offtime_day#count#</cfoutput>" id="<cfoutput>offtime_day#count#</cfoutput>" value="<cfoutput>#izin_gun#</cfoutput>" onblur="<cfoutput>get_finishdate(#count#);</cfoutput>"  />
	<cfelse>
		<script>alert("<cf_get_lang dictionary_id='41814.Tarih değerlerini doğru giriniz'>!");</script>
		<input type="text" name="<cfoutput>offtime_day#count#</cfoutput>" id="<cfoutput>offtime_day#count#</cfoutput>" value="" onblur="<cfoutput>get_finishdate(#count#);</cfoutput>"  />
	</cfif>
<cfelseif attributes.type eq 1>
	<cfset count = attributes.active_row>
	<cfif isdefined("attributes.start_date") and isdefined("attributes.off_day")>
		<cf_date tarih="attributes.start_date">
		<cfset yeni_tarih=dateadd('d',attributes.off_day,attributes.start_date)>
		<input type="text" name="<cfoutput>finishdate#count#</cfoutput>" id="<cfoutput>finishdate#count#</cfoutput>" readonly="yes" style="width:65px;" value="<cfoutput>#dateformat(yeni_tarih,dateformat_style)#</cfoutput>" maxlength="10">
        <cf_wrk_date_image date_field="finishdate#count#" call_function="get_offtime_day" call_parameter="#count#">
	</cfif>
<cfelseif attributes.type eq 2>
	<cfset count = attributes.active_row>
	<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.emp_in_out")>
			<cfset izin_sayilmayan = 0>
			<cfset genel_izin_toplam = 0>
			<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
			SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
			</cfquery>
			<cfquery name="get_emp" datasource="#dsn#">
				SELECT 
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					E.KIDEM_DATE,
					E.IZIN_DATE,
					EI.BIRTH_DATE,
					E.GROUP_STARTDATE
				FROM
					EMPLOYEES E,
					EMPLOYEES_IDENTY EI
				WHERE 
					E.EMPLOYEE_ID=#attributes.emp_id# AND
					EI.EMPLOYEE_ID=E.EMPLOYEE_ID
			</cfquery>
            <!--- <cfhttp url="#fusebox.server_machine_list#/V16/settings/cfc/employee_offtimes.cfc?method=F_Employee_Offtime" result = "response" method="get">
                <cfhttpparam type = "formfield" name = "employee_id" value = "#attributes.emp_id#">
                <cfhttpparam type = "formfield" name = "is_view_last_year" value = "1">
            </cfhttp> --->
            <cfset getComponent = createObject("component","V16.settings.cfc.employee_offtimes") />
            <cfset get_offt= getComponent.F_Employee_Offtime(employee_id: attributes.emp_id, is_view_last_year : 1)/>
            <cfset wrkxml_data = get_offt> 
            
            <!---<cfwddx action="wddx2cfml" input="#response.filecontent#" output="wrkxml_data">
			ws = CreateObject("webservice", "#fusebox.server_machine_list#/web_services/employee_offtimes.cfc?wsdl");
			wrkxml_data=ws.F_Employee_Offtime(employee_id:"#attributes.emp_id#",is_view_last_year:"1");
            --->
            <div class="form-group">
                <div class="input-group">
                    <input type="text" name="<cfoutput>used_offtime#count#</cfoutput>" id="<cfoutput>used_offtime#count#</cfoutput>" value="<cfoutput><cfif wrkxml_data is 'Tanımsız'>0<cfelse>#listlast(wrkxml_data,'-')#</cfif></cfoutput>"  />
                    -<input type="text" name="<cfoutput>remain_offtimes#count#</cfoutput>" id="<cfoutput>remain_offtimes#count#</cfoutput>" value="<cfoutput><cfif wrkxml_data is 'Tanımsız'>0<cfelse>#listfirst(wrkxml_data,'-')#</cfif></cfoutput>"  />   
                    <span class="input-group-addon" href="javascript://" onclick="<cfoutput>get_used_offtime(#count#)</cfoutput>"><i class="fa fa-bookmark-o"></i></span>
                </div>
            </div>
        <cfelse>
            <script>alert("<cf_get_lang dictionary_id='31183.Çalışan seçiniz'>!")</script>
            <div class="form-group">
                <div class="input-group">
                    <input type="text" name="<cfoutput>used_offtime#count#</cfoutput>" id="<cfoutput>used_offtime#count#</cfoutput>" value=""  />
                    <input type="text" name="<cfoutput>remain_offtimes#count#</cfoutput>" id="<cfoutput>remain_offtimes#count#</cfoutput>" value=""  />
                    <span class="input-group-addon" href="javascript://" onclick="<cfoutput>get_used_offtime(#count#)</cfoutput>"><i class="fa fa-bookmark-o"></i></span>
                </div>
            </div>
        </cfif>
</cfif>