<!--- <cfsavecontent variable="control1">
    <cfdump var="#attributes#">
</cfsavecontent>
<cffile action="write" file = "c:\attributes.html" output="#control1#"></cffile> --->

<cfsetting showdebugoutput="no">
<!--- Default Settings --->
<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
    <cfset member_type  = 'employee'>
    <CFSET member_id = '#attributes.employee_id#'>
    <cfset attributes.member_id = '#attributes.employee_id#'>
<cfelseif  isdefined('attributes.partner_id') and len(attributes.partner_id)>
    <cfset member_type  = 'partner'>
    <CFSET member_id = '#attributes.partner_id#'>
    <cfset attributes.member_id = '#attributes.partner_id#'>
<cfelseif isdefined('attributes.member_id') and len(attributes.member_id)>
    <cfset member_type  = '#attributes.member_type#'>
    <cfset member_id = '#attributes.member_id#'>
<cfelse>
    <cfset member_type = ''>
</cfif>
<cfset comp = createObject("component","cfc.right_menu_fnc")>
<cfif isDefined('URL.process') and URL.process is "default">
	<cfset defaultColumnName = UCase("announcement=1,is_video=1,notes=1,poll_now=1,main_news=1,myworks=1,day_agenda=1,private_agenda=0,department_agenda=0,branch_agenda=0,hr_agenda=0,hr_in_out=0,week_start=1")>	
	<cfset otherColumnName = UCase("pay_claim=0,correspondence=0,internaldemand=0,is_kariyer=0,pot_cons=0,pot_partner=0,hr=0,finished_test_times=0,sureli_is_finishdate=0,orders_come=0,offer_given=0,sell_today=0,promo_head=0,most_sell_stock=0,offer_to_give=0,new_stocks=0,orders_give=0,offer_taken=0,come_again_sip=0,purchase_today=0,more_stocks_id=0,send_order=0,offer_to_take=0,new_product=0,campaign_now=0,pre_invoice=0,service_head=0,call_center_application=0,call_center_interaction=0,spare_part=0,product_orders=0,pay=0,claim=0,old_contracts=0,is_forum=0,is_birthdate=0,attending_workers=0,markets=1,my_valids=0,is_kural_popup=0,my_buyers=0,my_sellers=0,leaving_workers=0,employee_profile=0,branch_profile=0,is_permittion=0,social_media=0,hr_pdks=0")>

	<cfquery name="DEL_SET" datasource="#DSN#">
		DELETE FROM MY_SETTINGS_POSITIONS WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>

	<cfquery name="UPD_SET" datasource="#DSN#">
		UPDATE MY_SETTINGS SET #defaultColumnName#, #otherColumnName# WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	
	<cfset widgetLengthOfColumn = ListToArray("5,37,5",",")>
	<cfset attributes.ini_employee_id = session.ep.userid>
	<cfinclude template="initialize_menu_positions.cfm">
	
	<b><cf_get_lang dictionary_id='50143.Default Değerler Yüklendi'></b>
	<cfabort>
</cfif>

<cfif isdefined('attributes.color')>
	<!--- <script language="javascript">
    	<cfif isdefined("session.ep.design_id") and session.ep.design_id eq 6>
			document.getElementById('page_css').href = '/css/cube_tv_<cfoutput>#attributes.color#</cfoutput>.css';
		<cfelse>
			document.getElementById('page_css').href = '/css/win_ie_<cfoutput>#attributes.color#</cfoutput>.css';
		</cfif>
    </script> --->
    <cfset emp_ = isdefined("attributes.employee_id") ? attributes.employee_id : session.ep.userid> 
     
     <cfquery name="UPD_WRK_SESSION_TO_DB" datasource="#DSN#">
        UPDATE
            WRK_SESSION
        SET
            DESIGN_COLOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color#">
        WHERE
             USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_#">
    </cfquery>
     <cfquery name="UPD_SETT_1" datasource="#DSN#">
        UPDATE
            MY_SETTINGS
        SET
            INTERFACE_COLOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color#">
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_#">
    </cfquery>
    <cfif not isDefined("attributes.employee_id") or (isDefined("attributes.employee_id") and session.ep.userid eq attributes.employee_id)>
        <cfset session.ep.design_color = attributes.color>
    </cfif>
</cfif>
<cfif isdefined("attributes.id")>
    <cfif attributes.id is "left">
        <cfinclude template="my_sett.cfm">
        <cfset emp_emp_ids = "">
        <cfif isdefined("attributes.employee_id")>
            <cfset emp_ = attributes.employee_id>
        <cfelse>
            <cfset emp_ = session.ep.userid>
        </cfif>
        <cfif isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
            <cfset emp_emp_ids = attributes.auth_emps_id>
        <cfelse>
            <cfset emp_emp_ids = listAppend(emp_emp_ids,emp_,',')>
        </cfif>
        <cfif isdefined("attributes.is_dev_mode")>
            <cfset session.ep.lang_change_action = 1>
        <cfelse>
            <cfset session.ep.lang_change_action = 0>
        </cfif>
        <cfquery name="UPD_SETT_1" datasource="#DSN#">
            UPDATE
                MY_SETTINGS
            SET
                <cfif isdefined("attributes.standart_menu_closed") and isdefined("attributes.employee_id")>
                    STANDART_MENU_CLOSED = 1,
                <cfelseif not isdefined("attributes.standart_menu_closed") and isdefined("attributes.employee_id")>
                    STANDART_MENU_CLOSED = 0,
                </cfif>
                TIMEOUT_LIMIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#timeout_limit#">,
                <cfif isdefined("attributes.lang") and len(attributes.lang)>
                    LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.lang#">,
                </cfif>
                MAXROWS = <cfqueryparam cfsqltype="cf_sql_integer" value="#maxrows#">,
                <cfif isdefined("attributes.interface") and len(attributes.interface)>
                INTERFACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interface#">,
                </cfif>
                OZEL_MENU_ID = <cfif isdefined("attributes.interface") and len(attributes.interface) and attributes.interface contains '-'><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.interface,2,'-')#">,<cfelse>0,</cfif>
                MYHOME_QUICK_MENU_PAGE = <cfif isdefined("attributes.myhome_quick_menu_page")>1<cfelse>0</cfif>,				
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">				
            WHERE
                EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">)
        </cfquery>
        
        <cfquery name="UPD_WRK_SESSION_TO_DB" datasource="#DSN#">
            UPDATE
                WRK_SESSION
            SET
                DESIGN_ID = <cfif isdefined('new_interface') and len(new_interface)><cfqueryparam cfsqltype="cf_sql_integer" value="#new_interface#"><cfelse>0</cfif>,
                MENU_ID = <cfif isdefined("attributes.interface") and len(attributes.interface) and attributes.interface contains '-'><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.interface,2,'-')#"><cfelse>0</cfif>,
                DESIGN_COLOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.design_color#">,
                TIMEOUT_MIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#timeout_limit#">,
                MAXROWS = <cfqueryparam cfsqltype="cf_sql_integer" value="#maxrows#">
            WHERE
                USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">)
                AND USER_TYPE = 0
        </cfquery>	
        <cfset structinsert(workcube_app, 'TIMEOUT_MIN', attributes.timeout_limit, true)>
        <cfquery name="UPD_WORKCUBE_APP_TIMEOUT" datasource="#DSN#">
            UPDATE
                WRK_SESSION
            SET
                TIMEOUT_MIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.timeout_limit#"> 
            WHERE
                CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#"> AND
                CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
        </cfquery>
         <cfif isdefined("attributes.interface") and len(attributes.interface)>
            <cfscript>
                session.ep.design_id = '#attributes.interface#';
            </cfscript>
        </cfif>
    <cfif not isdefined("attributes.employee_id") or attributes.employee_id eq session.ep.userid>
        <cfscript>
            upd_workcube_session
            (			
                design_id : ( isdefined("new_interface") and len(new_interface) )  ? new_interface : 0,
                maxrows : maxrows,
                timeout_min : timeout_limit
            );
        </cfscript>
        <cfif isDefined("new_interface") and len(new_interface)>
            <cfset session.ep.design_id = new_interface>
        </cfif>
        <cfset session.ep.maxrows = "#maxrows#">
        <cfset session.ep.timeout_min = "#timeout_limit#">
        <cfif isDefined("attributes.lang") and len(attributes.lang)>
        <cfset session.ep.language = "#attributes.lang#">
        </cfif>
        <cfif isdefined("attributes.interface") and len(attributes.interface) and attributes.interface contains '-'>
            <cfset session.ep.menu_id = listgetat(attributes.interface,2,'-')>
        <cfelse>
            <cfset session.ep.menu_id = 0>
        </cfif>
    </cfif>
    <cfelseif attributes.id is "center_top">
        <cfset emp_emp_ids = "">
        <cfif isdefined("attributes.employee_id")>
            <cfset emp_ = attributes.employee_id>
        <cfelse>
            <cfset emp_ = session.ep.userid>
        </cfif>
        <cfif isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
            <cfset emp_emp_ids = attributes.auth_emps_id>
        <cfelse>
            <cfset emp_emp_ids = listAppend(emp_emp_ids,emp_,',')>
        </cfif>
        <cfquery name="UPD_SETT_2" datasource="#DSN#">
            UPDATE
                MY_SETTINGS
            SET
                AGENDA = <cfif isdefined("attributes.agenda")>1<cfelse>0</cfif>,
                EVENTCAT_ID = <cfif isdefined("attributes.eventcat_idFormAgenda") and len(attributes.eventcat_idFormAgenda)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.eventcat_idFormAgenda#"><cfelse>NULL</cfif>,
                TIME_ZONE = <cfqueryparam cfsqltype="cf_sql_float" value="#time_zone#">,
                <cfif isDefined("attributes.dateFormat")> DATEFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dateFormat#">,</cfif>
                <cfif isDefined("attributes.timeFormat")> TIMEFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.timeFormat#">,</cfif>
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                <cfif isdefined("attributes.week_start")>,WEEK_START = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.week_start#"></cfif>
            WHERE
                EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">)
        </cfquery>
        <cfquery name="upd_wrk_session_to_db" datasource="#DSN#">
            UPDATE
                WRK_SESSION
            SET
                TIME_ZONE = <cfqueryparam cfsqltype="cf_sql_float" value="#session.ep.time_zone#">
                <cfif isDefined("attributes.dateFormat")>, DATEFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dateFormat#"> </cfif>
                <cfif isDefined("attributes.timeFormat")>, TIMEFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.timeFormat#"> </cfif>
                <cfif isdefined("attributes.week_start")>, WEEK_START = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.week_start#"></cfif>
            WHERE
                USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">)
                AND	USER_TYPE = 0						
        </cfquery>
        <cfif isdefined("attributes.week_start") and len(attributes.week_start)>
            <cfset session.ep.week_start = attributes.week_start>
        </cfif>
        <cfif not isdefined("attributes.employee_id")>    
            <cfif isDefined("attributes.dateFormat")><cfset session.ep.dateformat_style = attributes.dateFormat></cfif>
            <cfif isDefined("attributes.timeFormat")><cfset session.ep.timeformat_style = attributes.timeFormat></cfif>
            <cfif isDefined("attributes.time_zone")><cfset session.ep.time_zone = attributes.time_zone></cfif>
        </cfif>
        <cfif member_type is "employee">
            <cfquery name="GET_AGENDA_OPEN" datasource="#DSN#">
                SELECT 
                    AGENDA 
                FROM 
                    MY_SETTINGS 
                WHERE 
                    EMPLOYEE_ID = #attributes.member_id#
            </cfquery>
        <cfelseif member_type is "partner">
            <cfquery name="GET_AGENDA_OPEN" datasource="#DSN#">
                SELECT 
                    IS_AGENDA_OPEN, 
                    TIME_ZONE 
                FROM 
                    COMPANY_PARTNER 
                WHERE 
                    PARTNER_ID = #attributes.member_id#
            </cfquery>
        </cfif>
        <!--- partner a kopyalaninca uyarlanacak --->
        <cfif member_type is "employee">
            <cfif member_id eq session.ep.userid>
                <!--- kendi ajandasina dondü session varsa temizle --->
                    <cfif isdefined("session.agenda_userid")>
                    <cfset deleted = structdelete(session,"agenda_userid")>
                    <cfset deleted = structdelete(session,"agenda_user_type")>
                    <cfset deleted = structdelete(session,"agenda_position_code")>
                </cfif>
                <cfif isdefined("time_zone")>
                    <cfquery name="UPD_AGENDA_STATUS" datasource="#DSN#">
                        UPDATE 
                            EMPLOYEES
                        SET
                            IS_AGENDA_OPEN = <cfif isDefined("IS_AGENDA_OPEN")>1<cfelse>0</cfif>
                        WHERE 
                            EMPLOYEE_ID = #session.ep.userid#
                        </cfquery>
                    <cfquery name="UPD_SETTINGS" datasource="#DSN#">
                        UPDATE 
                            MY_SETTINGS 
                        SET 
                            EVENTCAT_ID = <cfif isdefined("attributes.eventcat_idFormAgenda") and len(attributes.eventcat_idFormAgenda)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.eventcat_idFormAgenda#"><cfelseif isdefined('attributes.eventcat_id') and len(attributes.eventcat_id)>#attributes.eventcat_id#<cfelse>NULL</cfif>,
                            AGENDA = <cfif isDefined("attributes.is_agenda_open")>1<cfelseif isDefined("attributes.agenda")>1<cfelse>0</cfif>,
                            TIME_ZONE = #time_zone#
                        WHERE 
                            EMPLOYEE_ID = #session.ep.userid#
                    </cfquery>
        
                    <cfscript>
                        upd_workcube_session(time_zone : TIME_ZONE);
                        session.ep.time_zone = TIME_ZONE;
                    </cfscript>
                
                </cfif>
            <cfelseif not(isdefined('attributes.PAGE_TYPE') and len(attributes.PAGE_TYPE))>
                <!--- baskasinin ajandasina gecti --->
                <!--- BK 120 gune siline degistirdim. MY_SETTINGS tablosundaki degere bakmali 20080812 <cfif get_agenda_open.is_agenda_open eq 1> --->
                <cfif get_agenda_open.agenda eq 1>
                    <cfset session.agenda_user_type = "e">
                    <!--- Yeni hali --->
                    <cfset attributes.employee_id = member_id><!--- Anlamsiz kisiler getiriyordu diye degistirdim. M.E.Y 20120814 --->
                    <cfset attributes.position_code = "">
                    
                    <!--- Eski hali --->
                    <!---<cfset attributes.position_code = member_id><!--- pozisyona gore bakmali, cunku ziyaret planinda pozisyon seciliyor --->
                    <cfset attributes.employee_id = "">--->
                    <cfinclude template="get_position.cfm">
                    <cfset session.agenda_userid = get_position.employee_id>
                    <cfset session.agenda_position_code = get_position.position_code>
                <cfelse>
                    <script type="text/javascript">
                        alert("<cf_get_lang no='30.Bu kullanıcının ajandası kapalı !'>");
                        history.back();
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
        <cfelseif member_type is "partner">
            <cfif get_agenda_open.is_agenda_open eq 1>
                <cfset session.agenda_userid = member_id>
                <cfset session.agenda_user_type = "p">
                <cfif isdefined("session.agenda_position_code")>
                    <cfset deleted = structdelete(session,"agenda_position_code")>
                </cfif>
            <cfelseif get_agenda_open.is_agenda_open eq 0>
                <script type="text/javascript">
                    alert("<cf_get_lang no='30.Bu kullanıcının ajandası kapalı !'>");
                    history.back();
                </script>
                <cfabort>
            </cfif>
        </cfif>
        
    <cfelseif attributes.id is "right">
        <cfset emp_emp_ids = "">
        <cfif isdefined("attributes.employee_id")>
            <cfset emp_ = attributes.employee_id>
        <cfelse>
            <cfset emp_ = session.ep.userid>
        </cfif>
        <cfif isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
            <cfset emp_emp_ids = attributes.auth_emps_id>
        <cfelse>
            <cfset emp_emp_ids = listAppend(emp_emp_ids,emp_,',')>
        </cfif>
        <cfquery name="UPD_SETT_3" datasource="#DSN#">
            UPDATE
                MY_SETTINGS
            SET
                IS_KARIYER = <cfif isdefined("attributes.is_kariyer")>1<cfelse>0</cfif>,
                SOCIAL_MEDIA = <cfif isdefined("attributes.social_media")>1<cfelse>0</cfif>,
                DAY_AGENDA = <cfif isdefined("attributes.day_agenda")>1<cfelse>0</cfif>,
                PRIVATE_AGENDA = <cfif isdefined("attributes.agenda_type") and attributes.agenda_type eq 1>1<cfelse>0</cfif>,
                DEPARTMENT_AGENDA = <cfif isdefined("attributes.agenda_type") and attributes.agenda_type eq 2>1<cfelse>0</cfif>,
                BRANCH_AGENDA = <cfif isdefined("attributes.agenda_type") and attributes.agenda_type eq 3>1<cfelse>0</cfif>,
                IS_BIRTHDATE = <cfif isdefined("is_birthdate")>1<cfelse>0</cfif>,
                IS_VIDEO = <cfif isdefined("attributes.is_video")>1<cfelse>0</cfif>,
                IS_FORUM = <cfif isdefined("attributes.is_forum")>1<cfelse>0</cfif>,
                INTERNALDEMAND = <cfif isdefined("internaldemand")>1<cfelse>0</cfif>,
                EMPLOYEE_PROFILE = <cfif isdefined("employee_profile")>1<cfelse>0</cfif>,
                BRANCH_PROFILE = <cfif isdefined("branch_profile")>1<cfelse>0</cfif>,
                HR_AGENDA = <cfif isDefined("hr_agenda")>1<cfelse>0</cfif>,
                HR_IN_OUT = <cfif isDefined("hr_in_out")>1<cfelse>0</cfif>,
                CORRESPONDENCE = <cfif isdefined("correspondence")>1<cfelse>0</cfif>,
                NEW_MAILS = <cfif isdefined("new_mails")>1<cfelse>0</cfif>,
                PROMO_HEAD = <cfif isdefined("promo_head")>1<cfelse>0</cfif>,
                MY_VALIDS = <cfif isdefined("my_valids")>1<cfelse>0</cfif>,
                ORDERS_GIVE = <cfif isdefined("orders_give")>1<cfelse>0</cfif>,
                OFFER_TO_TAKE = <cfif isdefined("offer_to_take")>1<cfelse>0</cfif>,
                OFFER_TO_GIVE = <cfif isdefined("offer_to_give")>1<cfelse>0</cfif>,
                IS_KURAL_POPUP = <cfif isdefined("attributes.is_kural_popup")>1<cfelse>0</cfif>,
                ORDERS_COME = <cfif isdefined("orders_come")>1<cfelse>0</cfif>,
                POT_CONS = <cfif isdefined("pot_cons")>1<cfelse>0</cfif>,		
                POT_PARTNER = <cfif isdefined("pot_partner")>1<cfelse>0</cfif>,
                OFFER_GIVEN = <cfif isdefined("offer_given")>1<cfelse>0</cfif>,
                OFFER_TAKEN = <cfif isdefined("offer_taken")>1<cfelse>0</cfif>,
                NEW_PRODUCT = <cfif isdefined("new_product")>1<cfelse>0</cfif>,
                SELL_TODAY = <cfif isdefined("sell_today")>1<cfelse>0</cfif>,
                PURCHASE_TODAY = <cfif isdefined("purchase_today")>1<cfelse>0</cfif>,
                SEND_ORDER = <cfif isdefined("send_order")>1<cfelse>0</cfif>,
                PRE_INVOICE = <cfif isdefined("pre_invoice")>1<cfelse>0</cfif>,
                MORE_STOCKS_ID = <cfif isdefined("more_stocks_id")>1<cfelse>0</cfif>,
                COME_AGAIN_SIP = <cfif isdefined("come_again_sip")>1<cfelse>0</cfif>,
                MOST_SELL_STOCK = <cfif isdefined("most_sell_stock")>1<cfelse>0</cfif>,
                CAMPAIGN_NOW = <cfif isdefined("campaign_now")>1<cfelse>0</cfif>,
                ANNOUNCEMENT = <cfif isdefined("announcement")>1<cfelse>0</cfif>,
                NOTES = <cfif isdefined("notes")>1<cfelse>0</cfif>,
                POLL_NOW = <cfif isdefined("poll_now")>1<cfelse>0</cfif>,
                PRODUCT_ORDERS = <cfif isdefined("product_orders")>1<cfelse>0</cfif>,
                SERVICE_HEAD = <cfif isdefined("service_head")>1<cfelse>0</cfif>,
                MAIN_NEWS = <cfif isdefined("main_news")>1<cfelse>0</cfif>,
                HR = <cfif isdefined("hr")>1<cfelse>0</cfif>,
                PAY = <cfif isdefined("pay")>1<cfelse>0</cfif>,
                CLAIM = <cfif isdefined("claim")>1<cfelse>0</cfif>,
                PAY_CLAIM = <cfif isdefined("pay_claim")>1<cfelse>0</cfif>,
                IS_PERMITTION = <cfif isdefined("is_permittion")>1<cfelse>0</cfif>,
                MARKETS = <cfif isdefined("markets")>1<cfelse>0</cfif>,
                OFFTIME = <cfif isdefined("offtime")>1<cfelse>0</cfif>,
                MYWORKS = <cfif isdefined("myworks")>1<cfelse>0</cfif>,
                MY_BUYERS = <cfif isdefined("my_buyers")>1<cfelse>0</cfif>,
                MY_SELLERS = <cfif isdefined("my_sellers")>1<cfelse>0</cfif>,
                REPORT = <cfif isdefined("report")>1<cfelse>0</cfif>,
                OLD_CONTRACTS = <cfif isdefined("old_contracts")>1<cfelse>0</cfif>,
                NORM_POSITION = <cfif isdefined("norm_position")>1<cfelse>0</cfif>,
                FINISHED_TEST_TIMES = <cfif isdefined("finished_test_times")>1<cfelse>0</cfif>,
                SURELI_IS_FINISHDATE = <cfif isdefined("attributes.sureli_is_finishdate")>1<cfelse>0</cfif>,
                LEAVING_WORKERS = <cfif isdefined("leaving_workers")>1<cfelse>0</cfif>,
                ATTENDING_WORKERS = <cfif isdefined("attending_workers")>1<cfelse>0</cfif>,
                SPARE_PART = <cfif isdefined("spare_part")>1<cfelse>0</cfif>,
                NEW_STOCKS = <cfif isdefined("new_stocks")>1<cfelse>0</cfif>,
                CALL_CENTER_APPLICATION = <cfif isdefined("call_center_application")>1<cfelse>0</cfif>,
                CALL_CENTER_INTERACTION = <cfif isdefined("call_center_interaction")>1<cfelse>0</cfif>,
                <cfif isDefined('attributes.show_milestone')>SHOW_MILESTONE = #attributes.show_milestone#,</cfif>	
                HR_PDKS = <cfif isdefined("MYPDKS")>1<cfelse>0</cfif>,	
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">)
        </cfquery>
    <cfelseif attributes.id is "center_down">
        <cfset emp_emp_ids = "">
        <cfif isdefined("attributes.employee_id")>
            <cfset emp_ = attributes.employee_id>
        <cfelse>
            <cfset emp_ = session.ep.userid>
        </cfif>
        <cfif isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
            <cfset emp_emp_ids = attributes.auth_emps_id>
        <cfelse>
            <cfset emp_emp_ids = listAppend(emp_emp_ids,emp_,',')>
        </cfif>
        <cfloop list="#emp_emp_ids#" index="emp_id">
            <cfif emp_id gt 0>
                <cfscript>
                    comp.dsn3 = dsn3;
                    get_paper = comp.get_paper_fnc(emp_id);
                </cfscript> 
                <cfif not get_paper.recordcount>
                    <cfscript>
                    comp.dsn3 = dsn3;
                    add_paper = comp.add_paper_fnc(emp_id,session.ep.userid);
                </cfscript>  
            </cfif>
                <cfscript>
                    comp.dsn3 = dsn3;
                    if(session.ep.our_company_info.is_efatura){
                        upd_sett_4 = comp.upd_sett_4_fnc(revenue_receipt_no,revenue_receipt_number,attributes.invoice_no,attributes.invoice_number,attributes.e_invoice_no,attributes.e_invoice_number,attributes.ship_no,attributes.ship_number,session.ep.userid,emp_id);
                    }else{
                        upd_sett_4 = comp.upd_sett_4_fnc(revenue_receipt_no,revenue_receipt_number,attributes.invoice_no,attributes.invoice_number,'','',attributes.ship_no,attributes.ship_number,session.ep.userid,emp_id);
                        
                    }
                </cfscript>   
            </cfif>
        </cfloop>
    </cfif>
</cfif>
<cfif attributes.id is "acc_period">
    <cfscript>
        comp.dsn = dsn;
        update_emp = comp.update_emp_fnc(attributes.user_period_idMngPeriod,session.ep.userid,attributes.position_idMngPeriod,attributes.moneyFormat);
    </cfscript>
    <cftry>
        <cfif fusebox.use_stock_speed_reserve><!--- ürün seri rezerve kullanılıyorsa sistemden çıkısta herhangi işlemle ilişkilendirilmemiş rezerveler silinir  --->
            <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
            </cfstoredproc>
        </cfif>
        <cfcatch></cfcatch>
    </cftry>
    <!--- dönem bilgileri alınıyor --->
    <cfscript>
        comp.dsn = dsn;
        periods = comp.periods_fnc(attributes.user_period_idMngPeriod);
    </cfscript>
    <cfif isdefined("FORM.USER_LOCATION_AJAX")>
        <cfset login_action = createObject("component", "WMO.login")>
        <cfset login_action.dsn = dsn/>
        <cfset get_priority_branch_dept = login_action.GET_BRANCH_DEPT(session.ep.position_code,attributes.company_idMngPeriod)>
         <cfset session.ep.USER_LOCATION = FORM.USER_LOCATION_AJAX>
        <cfif (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID) and len(get_priority_branch_dept.LOCATION_ID))>
            <cfset session.ep.USER_LOCATION = '#FORM.USER_LOCATION_AJAX#-#get_priority_branch_dept.LOCATION_ID#'>
        </cfif>
    </cfif>
    <cfscript>
        session.ep.other_money = periods.standart_process_money;
        session.ep.money2 = periods.other_money;
        session.ep.period_year = periods.period_year;
        session.ep.period_id = periods.period_id;
        session.ep.period_is_integrated = periods.is_integrated;
        session.ep.company_id = periods.our_company_id;
        session.ep.company = periods.company_name;
        session.ep.company_email = periods.email;
        session.ep.our_company_info.workcube_sector = periods.workcube_sector;
        session.ep.our_company_info.is_paper_closer = periods.is_paper_closer;
        session.ep.our_company_info.is_cost = periods.is_cost;
        session.ep.our_company_info.is_cost_location = periods.is_cost_location;
        session.ep.our_company_info.guaranty_followup = periods.is_guaranty_followup;
        session.ep.our_company_info.project_followup = periods.is_project_followup;
        session.ep.our_company_info.asset_followup = periods.is_asset_followup;
        session.ep.our_company_info.sales_zone_followup = periods.is_sales_zone_followup;
        session.ep.our_company_info.subscription_contract = periods.is_subscription_contract;
        session.ep.our_company_info.sms = periods.is_sms;
        session.ep.our_company_info.unconditional_list = periods.is_unconditional_list;
        session.ep.our_company_info.spect_type = periods.spect_type;
        session.ep.our_company_info.is_ifrs = periods.is_use_ifrs;
        session.ep.our_company_info.rate_round_num = periods.rate_round_num;
        session.ep.our_company_info.purchase_price_round_num = periods.purchase_price_round_num;
        session.ep.our_company_info.sales_price_round_num = periods.sales_price_round_num;
        session.ep.our_company_info.is_prod_cost_type = periods.is_prod_cost_type;
        session.ep.our_company_info.is_stock_based_cost = periods.is_stock_based_cost;
        session.ep.our_company_info.is_project_group = periods.is_project_group;
        session.ep.our_company_info.special_menu_file = periods.special_menu_file;
        session.ep.our_company_info.is_maxrows_control_off = periods.is_maxrows_control_off;
        session.ep.our_company_info.is_add_informations = periods.is_add_informations;
        session.ep.our_company_info.is_efatura = periods.is_efatura;
        session.ep.our_company_info.is_edefter = periods.is_edefter;
        session.ep.our_company_info.is_lot_no = periods.is_lot_no;
        session.ep.our_company_info.efatura_date = dateFormat(periods.efatura_date,'yyyy-mm-dd');
        session.ep.our_company_info.is_earchive = periods.is_earchive;
        session.ep.our_company_info.earchive_date = dateFormat(periods.earchive_date,'yyyy-mm-dd');
        session.ep.our_company_info.is_eshipment = periods.is_eshipment;
        if ( len(periods.eshipment_date) ) session.ep.our_company_info.eshipment_date = dateFormat(periods.eshipment_date,'yyyy-mm-dd');
        session.ep.company_nick = periods.nick_name;
        session.ep.money = periods.money;	
        get_period_date = cfquery(datasource : "#dsn#", sqlstring : "SELECT PERIOD_DATE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID = #attributes.position_idMngPeriod# AND PERIOD_ID = #periods.period_id#");
        if (len(get_period_date.period_date)) session.ep.period_date = dateformat(get_period_date.period_date,'yyyy-mm-dd');
        else if (len(periods.period_date)) session.ep.period_date = dateformat(periods.period_date,'yyyy-mm-dd');
        else session.ep.period_date = "#periods.period_year#-01-01";
        session.ep.period_start_date = dateFormat(periods.start_date,'yyyy-mm-dd');
        session.ep.period_finish_date = dateFormat(periods.finish_date,'yyyy-mm-dd');
        session.ep.moneyformat_style = attributes.moneyFormat;
    </cfscript>
    <cfscript>
        comp.dsn = dsn;
        upd_wrk_session_to_db = comp.upd_wrk(session.ep.user_location
                                                    ,session.ep.period_year
                                                    ,session.ep.period_id
                                                    ,session.ep.period_is_integrated
                                                    ,session.ep.company_id
                                                    ,session.ep.company
                                                    ,session.ep.company_nick
                                                    ,session.ep.money
                                                    ,session.ep.our_company_info.workcube_sector
                                                    ,session.ep.period_date
                                                    ,session.ep.money2
                                                    ,session.ep.our_company_info.is_add_informations
                                                    ,session.ep.our_company_info.is_efatura
                                                    ,session.ep.our_company_info.is_edefter
                                                    ,session.ep.our_company_info.is_lot_no
                                                    ,session.ep.period_start_date
                                                    ,session.ep.period_finish_date
                                                    ,session.ep.userid
                                                    ,iif(isdefined("attributes.employee_idMngPeriod"),"attributes.employee_idMngPeriod",DE(""))
                                                    ,attributes.moneyFormat
                                                    ,session.ep.our_company_info.is_eshipment
                                                    );
    </cfscript>
    <cfquery name="UPD_SETT_2" datasource="#DSN#">
        UPDATE
            MY_SETTINGS
        SET
            MONEYFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.moneyFormat#">
        WHERE
            EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
    </cfquery>
    
<cfelseif attributes.id is 'dictionary'>
    <cfset session.ep.language = attributes.lang>
    <cfset session.ep.lang = attributes.lang>
    <cfscript>
        comp.dsn = dsn;
        update_session = comp.upd_session(session.ep.userid,attributes.lang);       
    </cfscript>
<cfelseif attributes.id is 'userGroup'>
    
    <cfset position_code = listFirst(attributes.mng_employee_positions,'-') />
    <cfset position_name = listLast(attributes.mng_employee_positions,'-') />
    
    <cfquery name="GET_USER_GROUP" datasource="#dsn#">
        SELECT
            USER_GROUP_PERMISSIONS,
            POWERUSER,
            IS_BRANCH_AUTHORIZATION,
            REPORT_USER_LEVEL
        FROM
            USER_GROUP
        WHERE
            USER_GROUP_ID = #attributes.user_group#
    </cfquery>
    <cfquery name="UPD_SETT_USER_GROUP" datasource="#DSN#">
        UPDATE
            EMPLOYEE_POSITIONS
        SET
            USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.user_group#">,
            WRK_MENU =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.wrk_menu#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">			
        WHERE
            EMPLOYEE_ID = #session.ep.userid#
        UPDATE
            WRK_SESSION
        SET
            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#">,
            POSITION_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#position_name#">,
            USER_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_USER_GROUP.USER_GROUP_PERMISSIONS#">,
            POWER_USER_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_USER_GROUP.POWERUSER#">,
            REPORT_USER_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_USER_GROUP.REPORT_USER_LEVEL#">
        WHERE
            USERID = #session.ep.userid#
    </cfquery>
    <cfquery name="UPD_SETT_INTERFACE" datasource="#DSN#">
        UPDATE
            MY_SETTINGS
        SET
            INTERFACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interface#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">				
        WHERE
            EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfscript>
        session.ep.user_level = '#GET_USER_GROUP.USER_GROUP_PERMISSIONS#';
        session.ep.power_user_level_id = '#GET_USER_GROUP.POWERUSER#';
        session.ep.is_branch_authorization = '#GET_USER_GROUP.IS_BRANCH_AUTHORIZATION#';
        session.ep.menu_id = '#attributes.wrk_menu#';
        session.ep.report_user_level = '#GET_USER_GROUP.REPORT_USER_LEVEL#';
        session.ep.design_id = '#attributes.interface#';
        session.ep.position_code = position_code;
        session.ep.position_name = position_name;
    </cfscript>

<cfelseif attributes.id is 'interface'>
        <cfquery name="UPD_SETT_1" datasource="#DSN#">
        UPDATE
            MY_SETTINGS
        SET
            INTERFACE_ID = <cfif attributes.interface neq 0>5<cfelse>4</cfif>,
            OZEL_MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interface#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">				
        WHERE
            EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfquery name="UPD_WRK_SESSION_TO_DB" datasource="#DSN#">
        UPDATE
            WRK_SESSION
        SET
            MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interface#">
        WHERE
            USERID = #session.ep.userid#
            AND USER_TYPE = 0
    </cfquery>   	
    <cfset session.ep.menu_id = attributes.interface>
</cfif>
<cfif not isdefined("attributes.draggable")>
    <cfif isdefined("attributes.page_type")>
        <cfif isdefined('attributes.from_sec') and attributes.from_sec eq 1>
            <cfset str = '&from_sec=1'>
        <cfelse>
            <cfset str = ''>
        </cfif>
        <cflocation url="#request.self#?fuseaction=objects.popup_list_positions_poweruser&page_type=#attributes.page_type#&employee_id=#attributes.employee_id#&position_id=#attributes.position_id##str#" addtoken="no">
    <cfelse>
        <cfif isdefined("attributes.id") and attributes.id is 'right'>
            <cfif CGI.HTTP_REFERER contains 'myhome.welcome'>
                <script>
                    window.location = '<cfoutput>#cgi.http_referer#</cfoutput>';
                </script>
            <cfelse>
                <script>
                    $('.modal').slideUp(300);
                    $('.modal-backdrop').fadeOut('fast');
                </script>
            </cfif>
        <cfelse>
            <script>
                window.location = '<cfoutput>#cgi.http_referer#</cfoutput>';
            </script>
        </cfif>
    </cfif> 
<cfelse>
    <script>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        location.reload();
    </script>
</cfif>
