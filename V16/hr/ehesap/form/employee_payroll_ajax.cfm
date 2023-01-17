<cfset start_date_ = CreateODBCDatetime('#attributes.sal_year#-#attributes.sal_mon#-01')>
<cfset son_gun = daysinmonth(start_date_)>
<cfset finish_date_ = CreateODBCDatetime('#attributes.sal_year#-#attributes.sal_mon#-#son_gun#')>
<cfset url_str = ''>
<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfset url_str = '#url_str#&employee_id=#attributes.employee_id#'>
</cfif>
<cfif isdefined('attributes.in_out_id') and len(attributes.in_out_id)>
	<cfset url_str = '#url_str#&in_out_id=#attributes.in_out_id#'>
</cfif>
<!---İzinler --->
<cf_grid_list style="display:" id="gizli1">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th><cf_get_lang dictionary_id='53027.Tarihler'></td>
            <th width="15"><cf_get_lang dictionary_id="57490.Gün"></th>
            <th class="text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=add#url_str#</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
        </tr>
    </thead>
    <cfquery name="get_offtime" datasource="#dsn#">
        SELECT
            OFFTIME.OFFTIME_ID,
            OFFTIME.TOTAL_HOURS,
            OFFTIME.STARTDATE,
            OFFTIME.FINISHDATE,
            EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME AS NAME,
            SETUP_OFFTIME.OFFTIMECAT,
            SETUP_OFFTIME.IS_PAID,
            SETUP_OFFTIME.EBILDIRGE_TYPE_ID
        FROM
            OFFTIME,
            SETUP_OFFTIME,
            EMPLOYEES
        WHERE
            OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
            OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
            OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
            OFFTIME.VALID = 1
            AND
            (
                (
                OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND
                OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,finish_date_)#">
                )
            OR
                (
                OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND
                OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#">
                )
            )
        ORDER BY 
            OFFTIME.STARTDATE ASC
    </cfquery>	
    <tbody>
    <cfset izin_gun_toplam=0>
        <cfif get_offtime.recordcount>
        <!--- çalışma saati başlangıç ve bitişleri al--->
        <cfquery name="get_work_time" datasource="#dsn#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
                (PROPERTY_NAME = 'start_hour_info' OR
                PROPERTY_NAME = 'start_min_info' OR
                PROPERTY_NAME = 'finish_hour_info' OR
                PROPERTY_NAME = 'finish_min_info'
                )	
        </cfquery>
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
        <cfif get_work_time.recordcount>	
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
                OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfif len(get_hours.recordcount) and len(get_hours.WEEKLY_OFFDAY)>
            <cfset this_week_rest_day_ = get_hours.WEEKLY_OFFDAY>
        <cfelse>
            <cfset this_week_rest_day_ = 1>
        </cfif>
            <cfoutput query="get_offtime">
            <tr>
                <td>#OFFTIMECAT#</td>
                <td>#NAME#</td>
                <td>
                    <cfif (startdate lt now() and finishdate gt now()) or (startdate eq now() and finishdate gt now())>
                        <font color="##FF0000">
                        #dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#)
                        - 
                        #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)
                        </font>
                    <cfelse>
                        #dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#)
                        - 
                        #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)
                    </cfif>											
                </td>
                <td>
                    <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                        SELECT SATURDAY_ON,DAY_CONTROL,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtime.startdate#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtime.startdate#">
                    </cfquery>
                    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
                        <cfset saturday_on = get_offtime_cat.SATURDAY_ON>
                    <cfelse>
                        <cfset saturday_on = 1>
                    </cfif>
					<cfif get_offtime_cat.recordcount and len(get_offtime_cat.SUNDAY_ON)>
                        <cfset sunday_on = get_offtime_cat.SUNDAY_ON>
                    <cfelse>
                        <cfset sunday_on = 0>
                    </cfif>
                    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.PUBLIC_HOLIDAY_ON)>
                        <cfset public_holiday_on = get_offtime_cat.PUBLIC_HOLIDAY_ON>
                    <cfelse>
                        <cfset public_holiday_on = 0>
                    </cfif>
                    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.DAY_CONTROL)>
                        <cfset day_control_ = get_offtime_cat.DAY_CONTROL>
                    <cfelse>
                        <cfset day_control_ = 0>
                    </cfif>
                    <cfscript>
						add_sunday_total = 0;
                        temporary_sunday_total_ = 0;
                        temporary_offday_total_ = 0;
                        temporary_halfday_total = 0;
                        temporary_halfofftime = 0;
						izin_start_hour_ = "";
						izin_finish_hour_ = "";
                        //total_izin_ = dateformat(finishdate)-dateformat(startdate)+1;
                        temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0);
						temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0);
                    	total_izin_ = fix(temp_finishdate-temp_startdate)+1;
						izin_startdate_ = date_add("h", session.ep.time_zone, startdate); 
                        izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
                        fark = 0;
                        fark2 = 0;
                       	if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))
						{
							izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
						}
						else
						{
							izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
						}
						if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style))
						{
							izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);
						}
						else
						{
							izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);	
						}
						
						if(izin_start_hour_ gt timeformat('#start_hour#:#start_min#',timeformat_style))
						{
							fark = fark+datediff("n",izin_start_hour_,timeformat('#finish_hour#:#finish_min#',timeformat_style));
							fark = fark/60;
						}
						else 
						{
							fark = fark+datediff("n",izin_start_hour_,timeformat('#start_hour#:#start_min#',timeformat_style));
							fark = fark/60;
						}
						fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),izin_finish_hour_);
						fark2 = fark2/60;
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
                            daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
                            
                            if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
                            temporary_sunday_total_ = temporary_sunday_total_ + 1;
                            else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
                            temporary_sunday_total_ = temporary_sunday_total_ + 1;
                            else if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode_#') and public_holiday_on eq 0)
                            temporary_offday_total_ = temporary_offday_total_ + 1;
                            //else if(daycode_ is '#dateformat(dateadd("h",2,finishdate),dateformat_style)#' and day_control_ gt 0 and timeformat(dateadd("h",2,finishdate),'HH') lt day_control_)
                            //temporary_halfday_total = temporary_halfday_total + 1;
                            if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')) //yarım günlük genel tatiller
                            {	
                                temporary_halfofftime = temporary_halfofftime + 1; 
                            }
							if (dayofweek(temp_izin_gunu_) eq 1 and sunday_on eq 1)//pazar gunu ise ve pazar gunleri dahil edilsin secili ise
							{
								add_sunday_total = add_sunday_total+1;	
							}
                        }
                        if(get_offtime.is_paid neq 1 and get_offtime.ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez  
                            {
                                izin_gun = total_izin_ - (0.5 * temporary_halfday_total); //+ (0.5 * temporary_halfofftime)
                            }
                        else
                            {
                                izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime)+add_sunday_total;
                            }
                    </cfscript>
                    #izin_gun# <cfset izin_gun_toplam=izin_gun_toplam+izin_gun>											
                </td>
                <td class="text-center">
                    <a onClick="windowopen('#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#','medium');" href="javascript://" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                </td>
            </tr>	
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id="59586.İzin başlangıç/bitiş saatleri tanımlı değil. İzin Ekle Xmlden seçmelisniz."></td>
            </tr>
        </cfif>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
<cfquery name="get_worktimes_xml" datasource="#dsn#">
    SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
    WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = 'ehesap.list_ext_worktimes' AND
		PROPERTY_NAME = 'is_extwork_type'	
</cfquery>
<cfif get_worktimes_xml.PROPERTY_VALUE eq 1>
    <cfquery name="get_emp_ext_worktimes" datasource="#dsn#">
        SELECT 
            EMPLOYEES_EXT_WORKTIMES.EWT_ID,
            EMPLOYEES_EXT_WORKTIMES.START_TIME,EMPLOYEES_EXT_WORKTIMES.END_TIME,EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
            EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME AS NAME
        FROM 
            EMPLOYEES_EXT_WORKTIMES,
            EMPLOYEES
        WHERE 
            EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND 
            EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            EMPLOYEES_EXT_WORKTIMES.START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND	 
            EMPLOYEES_EXT_WORKTIMES.END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,finish_date_)#">	 
        ORDER BY START_TIME ASC
    </cfquery>
<cfelse>
    <cfquery name="get_emp_ext_worktimes" datasource="#dsn#">
    	SELECT
        	EO.WORKTIMES_ID AS EWT_ID,
          	EO.OVERTIME_PERIOD,
            EO.OVERTIME_MONTH,
            EO.OVERTIME_VALUE_0,
            EO.OVERTIME_VALUE_1,
            EO.OVERTIME_VALUE_2,
            EO.OVERTIME_VALUE_3,
            E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAME
        FROM
        	EMPLOYEES_OVERTIME EO INNER JOIN EMPLOYEES_IN_OUT EIO
            ON EO.IN_OUT_ID = EIO.IN_OUT_ID 
            INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
        	EO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            EO.OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
            EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
    </cfquery>
</cfif>
<!---Fazla Mesailer --->
<cf_grid_list style="display:none" id="gizli2">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <cfif get_worktimes_xml.PROPERTY_VALUE eq 1>
                <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
                <th width="40"><cf_get_lang dictionary_id='57501.Başl'></th>
                <th width="40"><cf_get_lang dictionary_id='57502.Bitiş'></th>
                <th width="70"><cf_get_lang dictionary_id='54049.Fark (Dk)'></th>
                <th width="80"><cf_get_lang dictionary_id='58651.Türü'></th> 
                <th class="text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add#url_str#</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></i></a></th>
			<cfelse>
				<th><cf_get_lang dictionary_id="47404.Dönemi"></th>
				<th><cf_get_lang dictionary_id="58724.Ay"></th>
				<th><cf_get_lang dictionary_id='53014.Normal Gün'></th>
				<th><cf_get_lang dictionary_id='53015.Hafta Sonu'></th>
				<th><cf_get_lang dictionary_id='53016.Resmi Tatil'></th>
				<th><cf_get_lang dictionary_id='54251.Gece Çalışması'></th>
                <th class="text-center" nowrap><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_all_overtime#url_str#</cfoutput>','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></i></a></th>
            </cfif>
        </tr>
    </thead>
    <tbody>
        <cfset sayfa_dakika = 0>
        <cfset toplam_mesai = 0>
        <cfif get_emp_ext_worktimes.recordcount>
        <cfoutput query="get_emp_ext_worktimes">
            <tr>
                <td>#NAME#</td>
				<cfif get_worktimes_xml.PROPERTY_VALUE eq 1>                
                    <td>#dateformat(START_TIME,dateformat_style)#</td>
                    <td>#TIMEFORMAT(START_TIME,timeformat_style)#</td>
                    <td>#TIMEFORMAT(END_TIME,timeformat_style)#</td>
                    <td>#datediff("n",START_TIME,END_TIME)#</td>
                    <td>
                        <cfif day_type eq 0>
                            <cf_get_lang dictionary_id='53014.Normal Gün'>
                        <cfelseif day_type eq 1>
                            <cf_get_lang dictionary_id='53015.Hafta Sonu'>
                        <cfelseif day_type eq 2>
                            <cf_get_lang dictionary_id='53016.Resmi Tatil'>
                        <cfelseif day_type eq 3>
                            <cf_get_lang dictionary_id='54251.Gece Çalışması'>
                        </cfif>											
                    </td>
                    <td id="fm_row_td_#EWT_ID#" class="text-center">
                        <div style="display:;" id="fm_row_#EWT_ID#"></div>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="41830.Fazla Mesai Siliyorsunuz ! Emin misiniz?"></cfsavecontent>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#EWT_ID#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='53019.Çalışan Fazla Mesai Süresi Güncelle'>"></i></a>
                        <a href="javascript://" onClick="if(confirm('#message#')) AjaxPageLoad('#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktime&EWT_ID=#EWT_ID#','fm_row_#EWT_ID#',1,'Siliniyor',''); else return false;"><img src="/images/delete_list.gif" title="Sil"></a>											
                    </td>
                    <cfset sayfa_dakika = sayfa_dakika + datediff("n",START_TIME,END_TIME)>											
                <cfelse>
                	<td>#overtime_period#</td>
                	<td>#overtime_month#</td>
                	<td>#overtime_value_0#</td>
                	<td>#overtime_value_1#</td>
                	<td>#overtime_value_2#</td>
                	<td>#overtime_value_3#</td>
                    <td id="fm_row_td_#EWT_ID#" class="text-center">
                        <div style="display:;" id="fm_row_#EWT_ID#"></div>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="41830.Fazla Mesai Siliyorsunuz! Emin misiniz?"></cfsavecontent>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_all_overtime&overtime_id=#EWT_ID#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='53019.Çalışan Fazla Mesai Süresi Güncelle'>"></i></a>
                        <a href="javascript://" onClick="if(confirm('#message#')) AjaxPageLoad('#request.self#?fuseaction=ehesap.emptypopup_del_overtime&overtime_id=#EWT_ID#','fm_row_#EWT_ID#',1,'Siliniyor',''); else return false;"><img src="/images/delete_list.gif" title="Sil"></a>											
                    </td>
                    <cfset toplam_mesai = toplam_mesai + overtime_value_0 + overtime_value_1 + overtime_value_2 + overtime_value_3>
                </cfif>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
    <tfoot>
        <cfoutput>
        	<cfif get_worktimes_xml.PROPERTY_VALUE eq 1>
            <tr>
                <td colspan="4" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
                <td class="txtboldblue" colspan="3">#sayfa_dakika# <cf_get_lang dictionary_id='58827.Dk'> <br/>(#int(sayfa_dakika/60)# <cf_get_lang dictionary_id='57491.saat'> <cfif sayfa_dakika gt (int(sayfa_dakika/60)*60)>#sayfa_dakika - (int(sayfa_dakika/60) * 60)#</cfif> <cf_get_lang dictionary_id='58827.Dk'>)</td>
            </tr>
            </cfif>
        </cfoutput>
    </tfoot>
</cf_grid_list>
<!--- Ödenekler--->
<cf_grid_list style="display:none" id="gizli3">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='53290.Ödenek Türü'></th>
            <th style="width:70px;"><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
            <th style="width:50px;"><cf_get_lang dictionary_id="53133.bitiş ay"></th>
            <th width="50"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
        </tr>
    </thead>
    <cfquery name="get_payments" datasource="#dsn#">
        SELECT
            SG.SPP_ID,
            AMOUNT_PAY,
            E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAME,
            START_SAL_MON,
            END_SAL_MON,
            COMMENT_PAY,
            METHOD_PAY
        FROM
            SALARYPARAM_PAY SG,
            EMPLOYEES_IN_OUT EIO,
            EMPLOYEES E
        WHERE
            SG.IN_OUT_ID = EIO.IN_OUT_ID AND
            EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            (
                (START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
                OR
                (END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
                OR
                (	
                    END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> OR 
                    START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> 
                )
            )
            AND SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">										
    </cfquery>
    <tbody>
        <cfset odenek_toplam_tutar=0>
        <cfif get_payments.recordcount>
            <cfoutput query="get_payments">
            <tr>
                <td>#name#</td>
                <td>#COMMENT_PAY#</td>
                <td>#listgetat(ay_list(),START_SAL_MON)#</td>
                <td>#listgetat(ay_list(),END_SAL_MON)#</td>
                <td style="text-align:right;" nowrap="nowrap"><cfif listfindnocase('2,3,4',METHOD_PAY)>%</cfif>#TLFormat(AMOUNT_PAY,2)#</td>
                <cfset odenek_toplam_tutar=odenek_toplam_tutar+AMOUNT_PAY>
                <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_payments&event=upd&id=#spp_id#&is_payment=1','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="4" class="formbold"><cf_get_lang dictionary_id ='57492.Toplam'>:</td>
            <td style="text-align:right;"><cfoutput>#TLFormat(odenek_toplam_tutar,2)#</cfoutput></td>
            <td></td>
        </tr>
    </tfoot>
</cf_grid_list>
<!--- Kesintiler--->
<cf_grid_list style="display:none" id="gizli4">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="100"><cf_get_lang dictionary_id='53275.Kesinti Türü'></th>
            <th style="width:70px;"><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
            <th style="width:50px;"><cf_get_lang dictionary_id="53133.bitiş ay"></th>
            <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='38977.Kesintiler'>"></i></a></th>
        </tr>
    </thead>
    <cfquery name="get_interruption" datasource="#DSN#">
        SELECT	
            SG.SPG_ID,
            SG.START_SAL_MON,
            SG.END_SAL_MON,
            SG.AMOUNT_GET,
            SG.COMMENT_GET,
            E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAME,
            SG.METHOD_GET,
            SG.IN_OUT_ID
        FROM 
            SALARYPARAM_GET SG,
            EMPLOYEES_IN_OUT EIO,
            EMPLOYEES E
        WHERE
            SG.IN_OUT_ID = EIO.IN_OUT_ID AND
            EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            SG.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
             (
                (START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
                OR
                (END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
                OR
                (	
                    END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> OR 
                    START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
                )
            ) 
    </cfquery>
    <tbody>
        <cfset kesinti_toplam_tutar=0>
        <cfif get_interruption.recordcount>
            <cfoutput query="get_interruption">
            <tr>
                <td>#name#</td>
                <td>#COMMENT_GET#</td>
                <td>#listgetat(ay_list(),START_SAL_MON)#</td>
                <td>#listgetat(ay_list(),END_SAL_MON)#</td>
                <td style="text-align:right;"><cfif METHOD_GET eq 2>%</cfif>#TLFormat(AMOUNT_GET)#</td>
                <cfset kesinti_toplam_tutar=kesinti_toplam_tutar+AMOUNT_GET>
                <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_interruption&event=upd&id=#spg_id#&is_interruption=1','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="4" class="formbold"><cf_get_lang dictionary_id ='57492.Toplam'>:</td>
            <td style="text-align:right;"><cfoutput>#TLFormat(kesinti_toplam_tutar,2)#</cfoutput></td>
            <td></td>
        </tr>
    </tfoot>
</cf_grid_list>
<!--- Vergi İstisnaları--->
<cf_grid_list style="display:none" id="gizli5">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="150"><cf_get_lang dictionary_id='53615.İstisna Türü'></th>
            <th style="width:70px;"><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
            <th style="width:50px;"><cf_get_lang dictionary_id="53133.bitiş ay"></th>
            <th width="50"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>');"><i class="fa fa-plus"title="<cf_get_lang dictionary_id='53085.Vergi İstisnaları'>"></i></a></th>
        </tr>
    </thead>
    <cfquery name="get_tax_exceptions" datasource="#dsn#">
    SELECT DISTINCT
        ET.TAX_EXCEPTION_ID,
        ET.TAX_EXCEPTION,
        ET.AMOUNT,
        ET.START_MONTH,
        ET.FINISH_MONTH,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
    FROM
        SALARYPARAM_EXCEPT_TAX ET,
        EMPLOYEES_IN_OUT EIO,
        EMPLOYEES E
    WHERE
        ET.IN_OUT_ID = EIO.IN_OUT_ID AND
        EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
        ET.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
        ET.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
        (
            (START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
            OR
            (FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND FINISH_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">)
            OR
            (	
                FINISH_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> OR 
                START_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
            )
        )									
    </cfquery>	
    <tbody>
        <cfset istisna_toplam_tutar=0>
        <cfif get_tax_exceptions.recordcount>
            <cfoutput query="get_tax_exceptions">
            <tr>
                <td>#employee_name# #employee_surname#</td>
                <td>#tax_exception#</td>
                <td>#listgetat(ay_list(),START_MONTH)#</td>
                <td>#listgetat(ay_list(),FINISH_MONTH)#</td>
                <td style="text-align:right;">#TLFormat(AMOUNT)#</td>
                <cfset istisna_toplam_tutar=istisna_toplam_tutar+AMOUNT>
                <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_tax_except&event=upd&id=#tax_exception_id#&is_tax_except=1','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td> 
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
    <tfoot>
        <tr>
            <td class="formbold" colspan="4"><cf_get_lang dictionary_id='57492.Toplam'></td>
            <td style="text-align:right;"><cfoutput>#TLFormat(istisna_toplam_tutar)#</cfoutput></td>
            <td>&nbsp;</td>
        </tr>
    </tfoot>
</cf_grid_list>
<!--- PDKS Listesi--->
<cf_grid_list style="display:none" id="gizli6">
    <thead>
        <tr>
            <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
            <th width="75"><cf_get_lang dictionary_id ='56887.Pdks No'></th>
            <th width="150"><cf_get_lang dictionary_id ='57576.Çalışan'></th>
            <th width="100"><cf_get_lang dictionary_id ='57453.Şube'></th>
            <th width="150"><cf_get_lang dictionary_id ='29496.Gün Tipi'></th>
            <th width="100"><cf_get_lang dictionary_id ='57628.Giriş Tarihi'></th>
            <th width="100"><cf_get_lang dictionary_id ='29438.Çıkış Tarihi'></th>
            <th class="text-center"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.list_emp_daily_in_out_row&event=add#url_str#</cfoutput>','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
        </tr>
    </thead>
    <cfquery name="get_daily_in_out" datasource="#dsn#">
        SELECT
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            EIO.PDKS_NUMBER,
            ED.IN_OUT_ID,
            ED.ROW_ID,
            ED.FILE_ID,
            ED.IS_WEEK_REST_DAY,
            ED.BRANCH_ID,
            ED.START_DATE,
            ED.FINISH_DATE,
            B.BRANCH_NAME
        FROM
            EMPLOYEE_DAILY_IN_OUT ED,
            EMPLOYEES E,
            EMPLOYEES_IN_OUT EIO,
            BRANCH B
        WHERE
            ED.IN_OUT_ID = EIO.IN_OUT_ID AND
            ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            ED.BRANCH_ID = B.BRANCH_ID AND
            ED.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            (
                (ED.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND ED.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,finish_date_)#">) OR ED.START_DATE IS NULL
            )
            AND
            ((ED.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND ED.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,finish_date_)#">) OR ED.FINISH_DATE IS NULL)
            AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
    </cfquery>
    <tbody>
        <cfif get_daily_in_out.recordcount>
        <cfoutput query="get_daily_in_out">
            <tr>
                <td>#currentrow#</td>
                <td>#PDKS_NUMBER#</td>
                <td>#employee_name# #employee_surname#</td>
                <td>#branch_name#</td>
                <td><cfif not Len(IS_WEEK_REST_DAY)>
                        <cf_get_lang dictionary_id="53727.Çalışma Günü">
                        <cfelseif IS_WEEK_REST_DAY eq 0>
                            <cf_get_lang dictionary_id="58867.Hafta Tatili">
                        <cfelseif IS_WEEK_REST_DAY eq 1>
                            <cf_get_lang dictionary_id="29482.Genel Tatil">
                        <cfelseif IS_WEEK_REST_DAY eq 2>
                            <cf_get_lang dictionary_id="55837.Genel Tatil Hafta Tatili">
                        <cfelseif IS_WEEK_REST_DAY eq 3>
                            <cf_get_lang dictionary_id="55840.Ücretli İzin Hafta Tatili">
                        <cfelseif IS_WEEK_REST_DAY eq 4>
                            <cf_get_lang dictionary_id="55844.Ücretsiz İzin Hafta Tatili">
                    </cfif>
                </td>
                <td><cfif len(get_daily_in_out.start_date)>#dateformat(get_daily_in_out.start_date,dateformat_style)# (#timeformat(get_daily_in_out.start_date,timeformat_style)#)<cfelse>-</cfif></td>
                <td><cfif len(get_daily_in_out.finish_date)>#dateformat(get_daily_in_out.finish_date,dateformat_style)# (#timeformat(get_daily_in_out.finish_date,timeformat_style)#)<cfelse>-</cfif></td>
                <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.list_emp_daily_in_out_row&event=upd&row_id=#row_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
<script type="text/javascript">
	document.getElementById("total_offtime").innerHTML="<cfoutput>#izin_gun_toplam# <cf_get_lang dictionary_id="57490.gün"></cfoutput>";
	<cfif get_worktimes_xml.property_value eq 1>
		document.getElementById("total_ext_work").innerHTML="<cfoutput>#sayfa_dakika# <cf_get_lang dictionary_id='58827.Dk'> (#int(sayfa_dakika/60)# <cf_get_lang dictionary_id='57491.saat'> <cfif sayfa_dakika gt (int(sayfa_dakika/60)*60)>#sayfa_dakika - (int(sayfa_dakika/60) * 60)#</cfif> <cf_get_lang dictionary_id='58827.Dk'>)</cfoutput>";
	<cfelse>
		document.getElementById("total_ext_work").innerHTML="<cfoutput>#toplam_mesai# <cf_get_lang dictionary_id='57491.saat'></cfoutput>";
	</cfif>
	document.getElementById("total_pay").innerHTML="<cfoutput>#TLFormat(odenek_toplam_tutar)#</cfoutput>";
	document.getElementById("total_int").innerHTML="<cfoutput>#TLFormat(kesinti_toplam_tutar)#</cfoutput>";
	document.getElementById("total_tax").innerHTML="<cfoutput>#TLFormat(istisna_toplam_tutar)#</cfoutput>";
	document.getElementById("total_pdks").innerHTML="<cfoutput>#get_daily_in_out.recordcount# <cf_get_lang dictionary_id='57483.Kayıt'></cfoutput>";
</script>
