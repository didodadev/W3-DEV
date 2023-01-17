<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="myhome.list_myweek">
    <script type="text/javascript">
        function call(dd)
        {
            for(yy=1;yy<=dd;yy++)
            {
                add_row();
            }
        }
    </script>
    <cfscript>
        if (isdefined('url.yil'))
            tarih = url.yil;
        else
            tarih = dateformat(now(),'yyyy');
        if (isdefined('url.ay'))
            tarih=tarih&'-'&url.ay;
        else
            tarih=tarih&'-'&dateformat(now(),'mm');
        
        if (isdefined('url.gun'))
            tarih=tarih&'-'&url.gun;
        else
            tarih=tarih&'-'&dateformat(now(),'d');
        
        fark = (-1)*(dayofweek(tarih)-2);
        if (fark EQ 1) fark = -6;
     
        last_week = date_add('d',fark-1,tarih);
        first_day = date_add('d',fark,tarih);
        second_day = date_add('d',1,first_day);
        third_day = date_add('d',2,first_day);
        fourth_day = date_add('d',3,first_day);
        fifth_day = date_add('d',4,first_day);
        sixth_day = date_add('d',5,first_day);
        seventh_day = date_add('d',6,first_day);
        next_week = date_add('d',7,first_day);
        attributes.to_day = date_add('h',-session.ep.time_zone, first_day);
    </cfscript>
    <cfquery name="get_activity" datasource="#dsn#">
        SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="get_time_cost_cats" datasource="#dsn#">
        SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
    </cfquery>
    <cfquery name="get_process_stage" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID,
            PT.IS_STAGE_BACK,
            PTR.LINE_NUMBER
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.upd_myweek%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="get_time_cost" datasource="#DSN#">
        SELECT 
            TCO.*,
            PTR.LINE_NUMBER,
            (SELECT PP.PROJECT_HEAD FROM PRO_PROJECTS PP WHERE PP.PROJECT_ID = TCO.PROJECT_ID) PROJECT_HEAD,
            (SELECT PW.WORK_HEAD FROM PRO_WORKS PW WHERE PW.WORK_ID = TCO.WORK_ID) WORK_HEAD,
            (SELECT EC.EXPENSE FROM #dsn2_alias#.EXPENSE_CENTER EC WHERE EC.EXPENSE_ID = TCO.EXPENSE_ID) EXPENSE,
            (SELECT SERVICE.SERVICE_NO FROM #dsn3_alias#.SERVICE WHERE SERVICE.SERVICE_ID = TCO.SERVICE_ID) SERVICE_HEAD,
            (SELECT EVENT.EVENT_HEAD FROM EVENT WHERE EVENT.EVENT_ID = TCO.EVENT_ID) EVENT_HEAD,
            (SELECT SC.SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = TCO.SUBSCRIPTION_ID) SUBSCRIPTION_NO,
            (SELECT TC.CLASS_NAME FROM TRAINING_CLASS TC WHERE TC.CLASS_ID = TCO.CLASS_ID) CLASS_NAME
        FROM 
            TIME_COST TCO
            LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = TCO.TIME_COST_STAGE
        WHERE 
            TCO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
            TCO.EVENT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('h',-session.ep.time_zone,next_week)#"> AND
            TCO.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">
        ORDER BY
            TCO.EVENT_DATE
    </cfquery>
    <script type="text/javascript">
        row_count=<cfoutput>#get_time_cost.recordcount#</cfoutput>;
        function sil(sy)
        {	
            var my_element=document.getElementById('row_kontrol'+sy);
            my_element.value=0;
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
        function add_row()
        {
            row_count++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
            newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);
            newRow.className = 'color-row';
            document.getElementById('record_num').value=row_count;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" value="" id="time_cost_id' + row_count +'" name="time_cost_id' + row_count +'"><input type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><div style="float:right"><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("id","today" + row_count + "_td");
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<input type="text" name="today' + row_count +'" id="today' + row_count +'" class="boxtext" maxlength="10" style="width:73px;" validate="eurodate" required="yes" value="<cfoutput>#DateFormat(date_add('h',session.ep.time_zone,Now()),'dd/mm/yyyy')#</cfoutput>">';
            wrk_date_image('today' + row_count);
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<input type="text" name="total_time_hour' + row_count +'" id="total_time_hour' + row_count +'" <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>maxlength="2"<cfelse>range="0,999"</cfif> validate="integer" style="width:30px;" class="boxtext" onKeyup="isNumber(this);return(FormatCurrency(this,event,0));">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<input type="text" name="total_time_minute' + row_count +'" id="total_time_minute' + row_count +'" maxlength="2" validate="integer" style="width:30px;" range="0,59" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<select name="process_stage' + row_count +'"  id="process_stage' + row_count +'" style="width:70px;"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<select name="time_cost_cat' + row_count +'"  id="time_cost_cat' + row_count +'" style="width:70px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option><cfoutput query="get_time_cost_cats"><option value="#time_cost_cat_id#">#time_cost_cat#</option></cfoutput></select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<select name="overtime_type' + row_count +'"  id="overtime_type' + row_count +'" style="width:70px;"><option value="1"><cf_get_lang no='1529.Normal'></option><option value="2"><cf_get_lang no='790.Fazla Mesai'></option><option value="3"><cf_get_lang no='715.Hafta Sonu'></option><option value="4"><cf_get_lang no='716.Resmi Tatil'></option></select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.innerHTML = '<input type="text" name="comment' + row_count +'" id="comment' + row_count +'" maxlength="300" style="width:300px;" class="boxtext">';
            
            <cfloop list="#ListDeleteDuplicates(xml_list_myweek_rows)#" index="xlr">
                <cfswitch expression="#xlr#">
                    <cfcase value="1">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="">';
                        newCell.innerHTML += '<input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="">';
                        newCell.innerHTML += '<input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="">';
                        newCell.innerHTML += '<input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="" onFocus="AutoComplete_Create(\'member_name'+ row_count +'\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'get_member_autocomplete\',\'1,2\',\'CONSUMER_ID,PARTNER_ID,COMPANY_ID\',\'consumer_id' + row_count +',partner_id' + row_count +',company_id' + row_count +'\',\'my_week_timecost\',3,116);"  style="width:110px;" class="boxtext">';
                        newCell.innerHTML += '<a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"></a>';
                    </cfcase>
                    <cfcase value="2">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" id="project'+ row_count +'" name="project'+ row_count +'" value="" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID,PARTNER_ID,COMPANY_ID,MEMBER_NAME,CONSUMER_ID\',\'project_id'+ row_count +',partner_id' + row_count +',company_id' + row_count +',member_name'+ row_count +',consumer_id'+ row_count +'\',\'my_week_timecost\',3,116);" style="width:116px;" class="boxtext"> <a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                    <cfcase value="3">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" id="work_id' + row_count +'" value=""><input type="text" name="work_head' + row_count +'" id="work_head' + row_count +'" value="" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,116);" style="width:128px;" class="boxtext"> <a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                    <cfcase value="4">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<select name="activity' + row_count +'" id="activity' + row_count +'" style="width:150px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_activity"><option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option></cfoutput></select>';
                    </cfcase>
                    <cfcase value="5">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="expense_id' + row_count +'" id="expense_id' + row_count +'" value=""><input type="text" name="expense' + row_count +'" id="expense' + row_count +'" value="" onFocus="AutoComplete_Create(\'expense' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'\',\'EXPENSE_ID\',\'expense_id' + row_count +'\',\'my_week_timecost\',3,116);" style="width:116px;" class="boxtext"> <a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                    <cfcase value="6">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="service_id' + row_count +'" id="service_id' + row_count +'" value=""><input type="text" name="service_head' + row_count +'" id="service_head' + row_count +'" value=""  onFocus="AutoComplete_Create(\'service_head' + row_count +'\',\'SERVICE_NO,SERVICE_HEAD\',\'SERVICE_NO,SERVICE_HEAD\',\'get_service\',\'\',\'SERVICE_ID\',\'service_id' + row_count +'\',\'\',3,116);"  style="width:116px;" class="boxtext"> <a href="javascript://" onClick="pencere_ac_service('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                    <cfcase value="7">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="event_id' + row_count +'" id="event_id' + row_count +'" value=""><input type="text" name="event_head' + row_count +'" id="event_head' + row_count +'" value="" onFocus="AutoComplete_Create(\'event_head' + row_count +'\',\'EVENT_HEAD\',\'EVENT_HEAD\',\'get_event\',\'\',\'EVENT_ID\',\'event_id' + row_count +'\',\'\',3,116);" style="width:116px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_event('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></div>';
                    </cfcase>
                    <cfcase value="8">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="subscription_id' + row_count +'" id="subscription_id' + row_count +'" value="">';
                        newCell.innerHTML += '<input type="text" name="subscription_no' + row_count +'" id="subscription_no' + row_count +'" value="" onFocus="AutoComplete_Create(\'subscription_no' + row_count +'\',\'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD\',\'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD\',\'get_subscription\',\'2\',\'SUBSCRIPTION_ID\',\'subscription_id' + row_count +'\',\'\',3,116);" style="width:116px;" class="boxtext"> <a href="javascript://" onClick="pencere_ac_subscription('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                    <cfcase value="9">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<input type="hidden" name="class_id' + row_count +'" id="class_id' + row_count +'" value=""><input type="text" name="class_name' + row_count +'" id="class_name' + row_count +'" style="width:116px;" onFocus="AutoComplete_Create(\'class_name' + row_count +'\',\'CLASS_NAME\',\'CLASS_NAME\',\'get_training_class\',\'2\',\'CLASS_ID\',\'class_id' + row_count +'\',\'\',3,116);" class="boxtext"> <a href="javascript://" onClick="pencere_ac_class('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
                    </cfcase>
                </cfswitch>
            </cfloop>
        }
        function pencere_ac_project(no)
        {
            if(eval('my_week_timecost.consumer_id'+no) != undefined)
                var project_str_ = 'company_id=my_week_timecost.company_id' + no +'&consumer_id=my_week_timecost.consumer_id' + no +'&company_name=my_week_timecost.member_name' + no+'&partner_id=my_week_timecost.partner_id' + no+'';
            else
                var project_str_ = '';
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&'+project_str_+'&project_id=my_week_timecost.project_id' + no +'&project_head=my_week_timecost.project' + no,'list');
        }
        function pencere_ac_service(no)
        {
            if(eval('my_week_timecost.consumer_id'+no) != undefined)
                var service_str_ = 'field_comp_id=my_week_timecost.company_id' + no +'';
            else
                var service_str_ = '';
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_crm&'+service_str_+'&field_id=my_week_timecost.service_id' + no +'&field_name=my_week_timecost.service_head' + no,'list');
        }
        function pencere_ac_event(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_events&field_id=my_week_timecost.event_id' + no +'&field_name=my_week_timecost.event_head' + no,'list');
        }
        function pencere_ac_expense(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=my_week_timecost.expense_id' + no +'&is_invoice=1&field_name=my_week_timecost.expense' + no,'list');
        }
        function pencere_detail_work(no)
        {	
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_updwork&id='+eval("document.my_week_timecost.work_id"+no).value,'list');
        }
        
        function pencere_ac_work(no)
        {
            if(eval('my_week_timecost.consumer_id'+no) != undefined)
                var service_str1_ = 'comp_id=my_week_timecost.company_id'+ no +'&comp_name=my_week_timecost.member_name' + no +'';
            else
                var service_str1_ = '';
            if(eval('my_week_timecost.project_id'+no) != undefined)
                var service_str2_ = 'field_pro_id=my_week_timecost.project_id' + no +'&field_pro_name=my_week_timecost.project' + no +'';
            else
                var service_str2_ = '';
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&'+service_str1_+'&'+service_str2_+'&field_id=my_week_timecost.work_id' + no +'&field_name=my_week_timecost.work_head' + no,'list');
        }
    
        function pencere_ac_subscription(no)
        {
            if(eval('my_week_timecost.consumer_id'+no) != undefined)
                var service_str_ = 'field_company_id=my_week_timecost.company_id' + no +'&field_company_name=my_week_timecost.member_name' + no+'';
            else
                var service_str_ = '';
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&'+service_str_+'&field_id=my_week_timecost.subscription_id' + no +'&field_no=my_week_timecost.subscription_no' + no,'list');
        }
        function pencere_ac_class(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_training_classes&field_id=my_week_timecost.class_id' + no +'&field_name=my_week_timecost.class_name' + no,'list');
        }
        function pencere_ac_company(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=my_week_timecost.consumer_id' + no +'&field_comp_id=my_week_timecost.company_id' + no +'&field_member_name=my_week_timecost.member_name' + no +'&field_partner=my_week_timecost.partner_id' + no+'&select_list=2,3','list');
        }
        
        function kontrol_et()
        {
            if(row_count != 0)
            {
                var minsPerHour = 60;
                var minsPerDay = 24 * minsPerHour;
                var currentDate = null;
                var dateList = new Array();
                var myTimeCostList = new Array();
                for(i=1; i <= document.getElementById('record_num').value; i++)
                {
                    deger_row_kontrol = eval("document.my_week_timecost.row_kontrol"+i);
                    deger_comment = eval("document.my_week_timecost.comment"+i);
                    deger_total_time_hour = eval("document.my_week_timecost.total_time_hour"+i);
                    deger_total_time_minute = eval("document.my_week_timecost.total_time_minute"+i);
                    if(eval("document.my_week_timecost.project_id"+i != undefined))
                        deger_project = eval("document.my_week_timecost.project_id"+i);
                    else
                        deger_project = '';
                    if(eval("document.my_week_timecost.work_id"+i != undefined))
                        deger_work = eval("document.my_week_timecost.work_id"+i);
                    else
                        deger_work = '';
                    <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
                    if (deger_row_kontrol.value == 1)
                    {
                        if(document.getElementById("total_time_hour"+i).value == "") document.getElementById("total_time_hour"+i).value = 0;
                        if(document.getElementById("total_time_minute"+i).value == "") document.getElementById("total_time_minute"+i).value = 0;
                        
                        var today_i = trim(String(document.getElementById("today"+i).value)); //date_add fonksiyonu sebebiyle tarih basinda bosluk oluyordu trim edildi fbs
                        var total_hour_i = document.getElementById("total_time_hour"+i).value;
                        var total_minute_i = document.getElementById("total_time_minute"+i).value;
                        
                        if(total_hour_i != 0 || total_minute_i != 0)
                        {
                            if(myTimeCostList[today_i] != undefined)
                                myTimeCostList[today_i] = parseInt(myTimeCostList[today_i]) + (parseInt(total_hour_i*minsPerHour) + parseInt(total_minute_i));
                            else
                                myTimeCostList[today_i] = (parseInt(total_hour_i*minsPerHour) + parseInt(total_minute_i));
                        }
                        if(parseInt(myTimeCostList[today_i]) > parseInt(minsPerDay))
                        {
                            alert("(" + today_i + ") <cf_get_lang no='1144.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>!");
                            return false;
                        }
                        else
                        {
                            if(document.getElementById("total_time_hour"+i).value == 0) document.getElementById("total_time_hour"+i).value = "";
                            if(document.getElementById("total_time_minute"+i).value == 0) document.getElementById("total_time_minute"+i).value = "";	
                        }
                        
                        /* 20130313 fbs kaldirdi, yanlis hesapliyordu
                        currentDate = eval("document.my_week_timecost.today"+i).value;
                        var dateIndex = -1;
                        for (d = 0; d < dateList.length; d++)
                        {
                            if (String(dateList[d].date) == String(currentDate))
                            {
                                dateIndex = d;
                                break;
                            }
                        }
                        if (trim(deger_total_time_hour.value).length == 0 && trim(deger_total_time_hour.value).length != 0){deger_total_time_hour.value = "0"};
                        if (trim(deger_total_time_hour.value).length != 0 && trim(deger_total_time_minute.value).length == 0){deger_total_time_minute.value = "0"};
                        
                        if (dateIndex != -1)
                        {
                            dateList[dateIndex].totalMinutes = eval(dateList[dateIndex].totalMinutes) + eval(Number(deger_total_time_hour.value) * minsPerHour) + eval(Number(deger_total_time_minute.value));
                        }
                        else 
                        {
                            dateList.push({date: String(currentDate), totalMinutes: eval(Number(deger_total_time_hour.value) * minsPerHour) + eval(Number(deger_total_time_minute.value))});
                            dateIndex = dateList.length - 1;
                        }
                        
                        if (dateList[dateIndex].totalMinutes > minsPerDay)
                        {
                            alert("<cf_get_lang no='1144.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>");
                            return false;
                        }
                        */
                    }
                    </cfif>
    
                    if(deger_row_kontrol.value == 1)
                    {
                        <cfif x_required_project eq 1>
                        if((deger_total_time_hour.value != "" || deger_total_time_minute.value != "") && deger_project.value == "")
                        {
                            alert(i + ". <cf_get_lang no='1580.Satır İçin Lütfen Proje Seçiniz'>!");
                            return false;
                        }
                        </cfif>
                        <cfif x_required_work eq 1>
                        if((deger_total_time_hour.value != "" || deger_total_time_minute.value != "") && deger_work.value == "")
                        {
                            alert(i + ".<cf_get_lang no='1581.Satır İçin Lütfen İş Seçiniz'>!");
                            return false;
                        }
                        </cfif>
                        if(deger_total_time_minute.value < 0 || deger_total_time_minute.value > 59)
                        { 
                            alert ("<cf_get_lang no ='873.1 ile 59 arası girebilirsiniz'>!");
                            return false;
                        }
                    }
                }
            }
            <cfif browserDetect() contains 'Firefox'>
                return newRows();
            </cfif>
			$( document ).ready(function() {
				return process_cat_control();
			});
			return true;
        }
    </script>
    <cfset date_list = " ">
    <cfloop query="get_time_cost">
        <cfif (datediff("d", EVENT_DATE, first_day) gte 0) and (datediff("d", first_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, first_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, second_day) gte 0) and (datediff("d", second_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, second_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, third_day) gte 0) and (datediff("d", third_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, third_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, fourth_day) gte 0) and (datediff("d", fourth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, fourth_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, fifth_day) gte 0) and (datediff("d", fifth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, fifth_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, sixth_day) gte 0) and (datediff("d", sixth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, sixth_day, ",")></cfif>
        <cfif (datediff("d", EVENT_DATE, seventh_day) gte 0) and (datediff("d", seventh_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, seventh_day, ",")></cfif>
    </cfloop>
    <cfset date_list = listsort(date_list, "text", "asc", ",")>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function newRows()
		{
			for(i=1;i<=row_count;i++)
			{   
				document.my_week_timecost.appendChild(document.getElementById('comment' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('total_time_hour' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('total_time_minute' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('project_id' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('project' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('service_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('service_head' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('event_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('event_head' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('expense_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('expense' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('consumer_id' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('partner_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('company_id' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('member_name' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('work_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('work_head' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('subscription_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('subscription_no' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('class_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('class_name' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('today' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('time_cost_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('row_kontrol' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('overtime_type' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('activity' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('time_cost_cat' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('process_stage' + i + ''));
			}
		return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.upd_myweek';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/form/list_myweek.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.upd_myweek';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/list_myweek.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_my_week_timecost.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.upd_myweek';
</cfscript>
