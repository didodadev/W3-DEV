<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cfif not isdefined("sayac")><cfset sayac=0></cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.cat_id" default="">
    <cfparam name="attributes.stage_id" default="">
    <cfparam name="attributes.activity" default="">
    <cfset temp_startdate = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
    <cfparam name="attributes.startdate" default="#day(temp_startdate)#/#month(temp_startdate)#/#year(temp_startdate)#">
    <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
        <cfset temp_finishdate = date_add('d',7,attributes.startdate)>
        <cfset tmp_finishdate = '#day(temp_finishdate)#/#month(temp_finishdate)#/#year(temp_finishdate)#'>
    <cfelse>
        <cfset tmp_finishdate = ''>
    </cfif>
    <cfparam name="attributes.finishdate" default="#tmp_finishdate#">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    </cfif>
    <cfif isdefined("attributes.is_form_submitted")>
        <cfinclude template="../myhome/query/get_time_cost_detail.cfm">
    <cfelse>
        <cfset get_time_cost.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_time_cost.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfquery name="get_time_cost_cats" datasource="#dsn#">
        SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
    </cfquery>
    <cfquery name="get_process_stage" datasource="#dsn#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="get_activity" datasource="#dsn#">
        SELECT * FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cf_xml_page_edit fuseact="myhome.emptypopup_form_add_timecost">
    <cfquery name="get_time_cost_cats" datasource="#dsn#">
        SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
    </cfquery>
    <cfif isdefined("attributes.is_subscription") or (isdefined("attributes.is_service") and isdefined("attributes.subscription_id") and len(attributes.subscription_id)) or (isdefined("attributes.is_cus_help") and isdefined('attributes.subscription_id') and len(attributes.subscription_id)) or (isdefined("attributes.is_call_service") and isdefined('attributes.subscription_id') and len(attributes.subscription_id))>
        <cfquery name="get_sub" datasource="#dsn3#">
            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
        </cfquery>
	</cfif>
<cfif isdefined("attributes.is_service")>
        <cfquery name="get_service_detail" datasource="#dsn3#">
            SELECT 
                SUBSCRIPTION_ID, 
                PROJECT_ID, 
                SERVICE_COMPANY_ID, 
                SERVICE_PARTNER_ID, 
                SERVICE_CONSUMER_ID, 
                SERVICE_HEAD, 
                START_DATE,
                FINISH_DATE
            FROM 
                SERVICE 
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfif len(get_service_detail.start_date)>
            <cfset adate = dateadd('H',session.ep.time_zone,get_service_detail.start_date)>
            <cfset ahour = datepart("H",adate)>
            <cfset aminute = datepart("N",adate)>
        </cfif>
        <cfif len(get_service_detail.finish_date)>
            <cfset fdate = dateadd('H',session.ep.time_zone,get_service_detail.finish_date)>
            <cfset fhour = datepart("H",fdate)>
            <cfset fminute =  datepart("N",fdate)>
        </cfif>
        <cfset attributes.service_head = get_service_detail.service_head>
        <cfset attributes.project_id = get_service_detail.project_id>
        <cfset attributes.subscription_id = get_service_detail.subscription_id>
        <cfset attributes.service_company_id = get_service_detail.service_company_id>
        <cfset attributes.service_partner_id = get_service_detail.service_partner_id>
        <cfset attributes.service_consumer_id = get_service_detail.service_consumer_id>
        <cfquery name="get_related_work" datasource="#dsn#">
            SELECT TOP 1 WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> ORDER BY WORK_HEAD
        </cfquery>
        <cfset attributes.work_id = get_related_work.work_id>
        <cfset attributes.work_head = get_related_work.work_head>
    </cfif>
    <cfif isdefined("attributes.is_call_service")>
        <cfquery name="get_service_detail" datasource="#dsn#">
            SELECT 
                SUBSCRIPTION_ID, 
                SERVICE_HEAD,
                PROJECT_ID, 
                SERVICE_COMPANY_ID, 
                SERVICE_PARTNER_ID, 
                SERVICE_CONSUMER_ID,  
                START_DATE,
                FINISH_DATE
            FROM 
                G_SERVICE 
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfif len(get_service_detail.start_date)>
            <cfset adate = dateadd('H',session.ep.time_zone,get_service_detail.start_date)>
            <cfset ahour = datepart("H",adate)>
            <cfset aminute = datepart("N",adate)>
        </cfif>
        <cfif len(get_service_detail.finish_date)>
            <cfset fdate = dateadd('H',session.ep.time_zone,get_service_detail.finish_date)>
            <cfset fhour = datepart("H",fdate)>
            <cfset fminute =  datepart("N",fdate)>
        </cfif>
        <cfset attributes.service_head = get_service_detail.service_head>
        <cfset attributes.project_id = get_service_detail.project_id>
        <cfset attributes.subscription_id = get_service_detail.subscription_id>
        <cfset attributes.service_company_id = get_service_detail.service_company_id>
        <cfset attributes.service_partner_id = get_service_detail.service_partner_id>
        <cfset attributes.service_consumer_id = get_service_detail.service_consumer_id>
    </cfif>
    <cfif isdefined("attributes.is_cus_help")>
        <cfquery name="get_cus_help_detail" datasource="#dsn#">
            SELECT SUBSCRIPTION_ID,COMPANY_ID,PARTNER_ID,CONSUMER_ID,CUS_HELP_ID FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
        </cfquery>
        <cfif len(get_cus_help_detail.SUBSCRIPTION_ID)><!--- etkilesimin iliskili oldugu sistem projesini getirir --->
            <cfquery name="get_project_id" datasource="#dsn3#">
                SELECT PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cus_help_detail.subscription_id#">
            </cfquery>
            <cfset attributes.project_id = get_project_id.project_id>
        </cfif>
        <cfset attributes.service_company_id = get_cus_help_detail.company_id>
        <cfset attributes.service_partner_id = get_cus_help_detail.partner_id>
        <cfset attributes.service_consumer_id = get_cus_help_detail.consumer_id>
        <cfset attributes.cus_help_id = get_cus_help_detail.cus_help_id>
    </cfif>
    <!--- Uretim sonucu sayfasindan geliyorsa --->
    <cfif isdefined('attributes.p_order_result_id')>
        <cfquery name="get_p_order_result_id" datasource="#dsn3#">
            SELECT 
                POR.FINISH_DATE,
                POR.START_DATE,
                POR.RESULT_NO,
                POR.PRODUCTION_ORDER_NO,
                POR.PR_ORDER_ID,
                PO.PROJECT_ID 
            FROM 
                PRODUCTION_ORDER_RESULTS POR,
                PRODUCTION_ORDERS PO
            WHERE 
                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_result_id#">
        </cfquery>
        <cfif len(get_p_order_result_id.start_date)>
            <!--- <cfset adate = dateadd('H',session.ep.time_zone,get_p_order_result_id.start_date)> --->
            <cfset ahour = datepart("H",get_p_order_result_id.start_date)>
            <cfset aminute = datepart("N",get_p_order_result_id.start_date)>
        </cfif>
        <cfif len(get_p_order_result_id.finish_date)>
            <!--- <cfset fdate = dateadd('H',session.ep.time_zone,get_p_order_result_id.finish_date)> --->
            <cfset fhour = datepart("H",get_p_order_result_id.finish_date)>
            <cfset fminute =  datepart("N",get_p_order_result_id.finish_date)>
        </cfif>
        <cfset today_ = get_p_order_result_id.finish_date>
        <cfset attributes.project_id = get_p_order_result_id.project_id>
        <cfset attributes.finish_date = get_p_order_result_id.finish_date><!--- tarih ---> 
        <cfset attributes.comment = get_p_order_result_id.result_no><!--- aciklama --->
        <cfset attributes.production_order_no = get_p_order_result_id.production_order_no><!--- uretim sonucu --->
        <cfset attributes.p_order_id = get_p_order_result_id.pr_order_id><!--- uretim sonucu --->
    <cfelse>
        <cfset today_ = now()>
    </cfif>
    <cfif not isdefined('attributes.today')>
        <cfset attributes.today = today_>
    <cfelse>
        <cf_date tarih = "attributes.today">
    </cfif>
    
    <cfif isdefined("attributes.is_service") or isdefined("attributes.is_call_service") or isdefined("attributes.is_cus_help") or isdefined("attributes.is_p_order_result")>
		<!---time_cost_list--->asdasdadsa<cfabort>
        <cfquery name="GET_TIME_COST" datasource="#DSN#">
            SELECT 
                TC.TIME_COST_ID,
                TC.FINISH,
                TC.START,
                TC.FINISH_MIN,
                TC.START_MIN,
                TC.EVENT_DATE,
                TC.EMPLOYEE_ID,
                TC.PARTNER_ID,
                C.NICKNAME,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                SC.SUBSCRIPTION_NO,
                PP.PROJECT_HEAD,
                PW.WORK_HEAD,
                E.EVENT_HEAD,
                EC.EXPENSE,
                TCL.CLASS_NAME,
                TC.CONSUMER_ID,
                TC.EVENT_ID,
                TC.EXPENSE_ID,
                TC.PROJECT_ID,
                TC.CLASS_ID,
                TC.SUBSCRIPTION_ID,
                TC.COMMENT,
                TC.TOTAL_TIME,
                TC.WORK_ID
            FROM 
                TIME_COST TC
                LEFT JOIN COMPANY C ON C.COMPANY_ID = TC.COMPANY_ID 
                LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = TC.PARTNER_ID 
                LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = TC.SUBSCRIPTION_ID 
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = TC.EXPENSE_ID 
                LEFT JOIN TRAINING_CLASS TCL ON TCL.CLASS_ID = TC.CLASS_ID 
                LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = TC.PROJECT_ID 
                LEFT JOIN PRO_WORKS PW ON PW.WORK_ID = TC.WORK_ID 
                LEFT JOIN EVENT E ON E.EVENT_ID = TC.EVENT_ID 
            WHERE 
                <cfif isdefined("attributes.is_service") and isdefined('attributes.service_id') and len(attributes.service_id)>
                    TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
                <cfelseif isdefined('attributes.is_call_service') and isdefined("attributes.service_id") and len(attributes.service_id)>
                    TC.CRM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
                <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                    TC.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
                <cfelseif isdefined('attributes.p_order_result_id') and len(attributes.p_order_result_id)>
                    TC.P_ORDER_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_result_id#">
                </cfif>
                <cfif isDefined("attributes.startdate") and len(attributes.startdate) and isDefined("attributes.finishdate") and len(attributes.finishdate)>
                    AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                    AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>
            ORDER BY
                TC.TIME_COST_ID DESC
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.is_subscription")>
		<!---time_cost_list2--->
        <cfquery name="GET_TIME_COST" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                TIME_COST
            WHERE 
                SUBSCRIPTION_ID=#attributes.subscription_id#
                <cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE) AND isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
                    AND EVENT_DATE >= #attributes.STARTDATE#
                    AND EVENT_DATE <= #attributes.FINISHDATE#
                </cfif>
            ORDER BY
                TIME_COST_ID DESC
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.today")>
		<!---time_cost_list3--->
        <cfif isdefined('attributes.today') and len(attributes.today)>
            <cfset today_first = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),0,0,0)>
            <cfset today_last = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),23,59,59)>
        <cfelse>
            <cfset today_first = createDateTime(year(now()),month(now()),day(now()),0,0,0)>
            <cfset today_last = createDateTime(year(now()),month(now()),day(now()),23,59,59)>
        </cfif>
        <cfquery name="get_time_cost" datasource="#dsn#">
            SELECT
                CASE WHEN TC.COMPANY_ID IS NOT NULL THEN C.MEMBER_CODE WHEN TC.CONSUMER_ID IS NOT NULL THEN CON.MEMBER_CODE END AS MEMBER_CODE,
                PP.PROJECT_NUMBER,
                PP.PROJECT_HEAD,
                TC.TIME_COST_ID,
                TC.COMMENT,
                TC.FINISH,
                TC.START,
                TC.FINISH_MIN,
                TC.START_MIN,
                TC.EXPENSED_MINUTE,
                TC.BUG_ID,
                SA.ACTIVITY_NAME,
                TCC.TIME_COST_CAT,
                PTR.STAGE
            FROM
                TIME_COST TC
                LEFT JOIN COMPANY C ON TC.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN CONSUMER CON ON TC.CONSUMER_ID = CON.CONSUMER_ID
                LEFT JOIN PRO_PROJECTS PP ON TC.PROJECT_ID = PP.PROJECT_ID
                LEFT JOIN SETUP_ACTIVITY SA ON TC.ACTIVITY_ID = SA.ACTIVITY_ID
                LEFT JOIN TIME_COST_CAT TCC ON TC.TIME_COST_CAT_ID = TCC.TIME_COST_CAT_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON TC.TIME_COST_STAGE = PTR.PROCESS_ROW_ID
            WHERE
                TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_first#">
                AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_last#">
                AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
	</cfif>        
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cf_xml_page_edit fuseact="myhome.emptypopup_form_add_timecost">
<cfif fusebox.circuit eq 'myhome'>
		<cfset attributes.time_cost_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.time_cost_id,accountKey:'wrk')>
    </cfif>
    <cfquery name="get_time_cost" datasource="#dsn#">
        SELECT * FROM TIME_COST WHERE TIME_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.time_cost_id#">
    </cfquery>
    <cfquery name="get_activity" datasource="#dsn#">
        SELECT * FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="get_time_cost_cats" datasource="#dsn#">
        SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
    </cfquery>
    <cfsavecontent variable="right_">
        <a target="_blank" href="<cfoutput>#request.self#?fuseaction=myhome.time_cost</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
    </cfsavecontent>
    <cfif len("get_time_cost.event_date")>  
		<!---time_cost_list3--->
        <cfif isdefined('attributes.today') and len(attributes.today)>
            <cfset today_first = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),0,0,0)>
            <cfset today_last = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),23,59,59)>
        <cfelse>
            <cfset today_first = createDateTime(year(now()),month(now()),day(now()),0,0,0)>
            <cfset today_last = createDateTime(year(now()),month(now()),day(now()),23,59,59)>
        </cfif>
        <cfquery name="get_time_cost" datasource="#dsn#">
            SELECT
                CASE WHEN TC.COMPANY_ID IS NOT NULL THEN C.MEMBER_CODE WHEN TC.CONSUMER_ID IS NOT NULL THEN CON.MEMBER_CODE END AS MEMBER_CODE,
                PP.PROJECT_NUMBER,
                PP.PROJECT_HEAD,
                TC.*,
                SA.ACTIVITY_NAME,
                TCC.TIME_COST_CAT,
                PTR.STAGE
            FROM
                TIME_COST TC
                LEFT JOIN COMPANY C ON TC.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN CONSUMER CON ON TC.CONSUMER_ID = CON.CONSUMER_ID
                LEFT JOIN PRO_PROJECTS PP ON TC.PROJECT_ID = PP.PROJECT_ID
                LEFT JOIN SETUP_ACTIVITY SA ON TC.ACTIVITY_ID = SA.ACTIVITY_ID
                LEFT JOIN TIME_COST_CAT TCC ON TC.TIME_COST_CAT_ID = TCC.TIME_COST_CAT_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON TC.TIME_COST_STAGE = PTR.PROCESS_ROW_ID
            WHERE
                TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_first#">
                AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_last#">
                AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery> 
    </cfif>
    <cfif fusebox.circuit eq 'myhome'>
		<cfset time_cost_id_ = contentEncryptingandDecodingAES(isEncode:1,content:time_cost_id,accountKey:'wrk')>
    <cfelse>
        <cfset time_cost_id_ = time_cost_id>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});				
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function saat_kontrol()
		{ 
			start_clock = $('#event_start_clock').val();
			finish_clock = $('#event_finish_clock').val();
			start_minute = $('#event_start_minute').val();
			finish_minute = $('#event_finish_minute').val();
			
			if(!CheckEurodate($('#today').val(),'Girilen Tarih'))
				return false;
			if (time_cost.comment.value == "")
			{
				alert ("<cf_get_lang no ='871.Lütfen Açıklama Giriniz '>!");
				return false;
			}	
			if($('#total_time_minute').val() > 59)
			{
				alert ("<cf_get_lang no ='873.0-59 Arası Giriniz'>");
				return false;
			}	
						
			if (document.time_cost.total_time_hour.value == "" && document.time_cost.total_time_minute.value == "")
			{ 
				if(start_clock != '' || finish_clock != '' || start_minute != '' || finish_minute != '')
				{
					if(start_clock > finish_clock) 
					{
						alert("<cf_get_lang no='652.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
						return false;
					}
					else if((start_clock == finish_clock) && (start_minute ==finish_minute))
					{	
						alert("<cf_get_lang no ='878.Başlangıç Ve  Bitiş Saati Aynı Olamaz'>!");
						return false;
					}
					else if((start_clock == finish_clock) && (start_minute > finish_minute))
					{
						alert("<cf_get_lang no ='652.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
						return false;
					}
					
				}
			}	
				
			x = (300 - document.time_cost.comment.value.length);
			if ( x < 0 )
			{
				alert ("<cf_get_lang no ='217.Açıklama'>"+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
				return false;
			}
			return process_cat_control();
		}			
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function saat_kontrol()
		{
			start_clock = $('#event_start_clock').val();
			finish_clock = $('#event_finish_clock').val();
			start_minute=$('#event_start_minute').val();
			finish_minute=$('#event_finish_minute').val();
			if(!CheckEurodate($('#today').val(),'Girilen Tarih'))
				return false;
			if (time_cost.comment.value == "")
			{
				alert ("<cf_get_lang no ='871.Lütfen Açıklama Giriniz '>!");
				return false;
			}
			if(!CheckEurodate($('#today').val(),'Girilen Tarih'))
				return false;
			if (time_cost.comment.value == "")
			{
				alert ("<cf_get_lang no ='871.Lütfen Açıklama Giriniz '>!");
				return false;
			}	
			if($('#total_time_minute').val() > 59)
			{
				alert ("<cf_get_lang no ='873.0-59 Arası Giriniz'>");
				return false;
			}	
			if(start_clock != '' || finish_clock != '' || start_minute != '' || finish_minute != '')
			{
				if(start_clock > finish_clock)
				{
					alert("<cf_get_lang no='652.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
					return false;
				}
				else if((start_clock == finish_clock) && (start_minute == finish_minute))
				{	
					alert("Başlangıç Saati Bitiş Saatleri Aynı Olamaz!");
					return false;
				}	
				else if((start_clock == finish_clock) && (start_minute > finish_minute))
				{
					alert("Başlangıç Saati Bitiş Saatinden Büyük Olamaz!");
					return false;
				}
			}
						
			x = (300 - document.time_cost.comment.value.length);
			if ( x < 0 )
			{ 
				alert ("Açıklama "+ ((-1) * x) +" Karakter Uzun!");
				return false;
			}
			return process_cat_control();
		}	
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.emptypopup_form_add_timecost';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/display/time_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_time_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.mytime_management&event=add&today=#dateformat(attributes.today,'dd/mm/yyyy')#';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.emptypopup_form_add_timecost';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/display/upd_time_cost.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_time_cost.cfm';
		if(isdefined("attributes.service_id"))
		{ 
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.mytime_management&event=upd&service_id=#service_id#';
		}
		else if(isdefined("attributes.subscription_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.mytime_management&event=upd&subscription_id=#comp_id#';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.mytime_management&event=upd&time_cost_id=#time_cost_id_#';	
		}
	
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'time_cost_id=##time_cost_id_##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.time_cost_id##';
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.mytime_management';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/mytime_management.cfm';
	
	
	if(isdefined("attributes.event") and attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		if (isdefined("attributes.service_id") and len(attributes.service_id))
		{
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.emptypopup_del_time_cost=#attributes.service_id#';
	
		}
		else if (isdefined("attributes.subscription_id"))
		{
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.emptypopup_del_time_cost=#attributes.comp_id#';
	
		}
	
		else
		{
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.emptypopup_del_time_cost=#attributes.time_cost_id#';
	
		}
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'myhome/query/del_time_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'myhome/query/del_time_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.mytime_management';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_time_cost_id';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'MyTimeManagment';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'TIME_COST';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-comment','item-total_time_hour']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
	//// Tab Menus //
//	tabMenuStruct = StructNew();
//	tabMenuStruct['#attributes.fuseaction#'] = structNew();
//	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
//	
//	// Upd //
//	if(isdefined("attributes.event") and attributes.event is 'upd')
//	{
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
//
//	
//		
//						
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1575]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.form_add_expense_plan_request&opp_id=#opp_id#";
//		
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=sales.form_upd_opportunity&action_name=opp_id&action_id=#attributes.opp_id#&relation_papers_type=OPP_ID','list');";
//		
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[398]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.opp_id#&type_id=-16','list');";
//
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[61]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=sales.popup_list_opportunity_history&opp_id=#opp_id#";
//		
//		
//		if (IsDefined("get_opportunity.company_id"))
//		{
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[163]#';
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#get_opportunity.company_id#";
//		}
//		else if (IsDefined("get_opportunity.company_id"))
//		{
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[163]#';
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#get_opportunity.consumer_id#";
//	    }
//		
//		if (IsDefined("get_opportunity.project_id") and get_opportunity.recordcount)
//		{
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[39]#';
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=project.prodetail&id=#get_opportunity.project_id#";
//		}
//		else 
//		{
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[38]#';
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=project.addpro&opp_id=#get_opportunity.opp_id#";
//	    }
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[5]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&opp_id=#opp_id#";
//		
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] =  '#lang_array_main.item[521]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['href'] = "#request.self#?fuseaction=project.addwork&work_fuse=#attributes.fuseaction#&opp_id=#opp_id#&company_id=#get_opportunity.company_id#&partner_id=#get_opportunity.partner_id#";
//
//		if((listgetat(session.ep.user_level,11)) and session.ep.our_company_info.subscription_contract eq 1)
//		{
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array_main.item[1727]#';
//			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=add";
//		}
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['text'] =  '#lang_array.item[636]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_add_workgroup&opp_id=#attributes.opp_id#','list');";
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['text'] = '#lang_array_main.item[2580]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['href'] = "#request.self#?fuseaction=sales.form_add_relation_pbs&opp_id=#get_opportunity.opp_id#";
//		
//		
//		
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add";
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#opp_id#&print_type=#72#','page');";
//		
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['text'] = 'Oklar';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="opportunities" primary_key="opp_id" pointer="opp_id=#opp_id#" dsn_var="DSN3">';
//		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
//	}
</cfscript>
