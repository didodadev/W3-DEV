<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 19.08.2020
    Description:
      Seyahat Talebi Formu IK ONAY süreci (action file) eklenmelidir.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE EMPLOYEES_TRAVEL_DEMAND SET MANAGER1_VALID = 1, MANAGER1_EMP_ID = #session.ep.userid#,MANAGER1_POS_CODE = #session.ep.position_code#, MANAGER1_VALID_DATE = #now()# WHERE  TRAVEL_DEMAND_ID = #attributes.action_id#
    </cfquery>
    <cfquery name="get_travel_demand" datasource="#caller.dsn#">
        SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = #attributes.action_id#
    </cfquery>
    <cfquery name="get_employee_mail" datasource="#caller.dsn#">
        SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_travel_demand.EMPLOYEE_ID#
    </cfquery>
    <cfif isDefined("get_travel_demand.manager1_valid") and len(get_travel_demand.manager1_valid)>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='36175.Seyahat Talebi'></cfsavecontent>
        <cfif len(get_employee_mail.EMPLOYEE_EMAIL)>
            <cfmail 
                from="#session.ep.company#<#session.ep.company_email#>"
                to="#get_employee_mail.EMPLOYEE_EMAIL#"
                subject="#message#" type="HTML">
                <cf_get_lang_main no='1368.Sayın'> #get_employee_mail.employee_name# #get_employee_mail.employee_surname#,
                <br/><br/>
                #dateformat(get_travel_demand.departure_date,caller.dateformat_style)# - #dateformat(get_travel_demand.departure_of_date,caller.dateformat_style)# tarihleri arasında seyahat talebiniz birinci amiriniz tarafından <cfif get_travel_demand.manager1_valid eq 1>onaylanmıştır.<cfelse>reddedilmiştir.</cfif> <br/><br/>
                <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=ehesap.list_travel_demands" target="_blank"><cf_get_lang dictionary_id='61162.Seyahat Talebi Takip Ekranı'></a> <br/><br/>
                
                    <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                <br/><br/>
                <cf_get_lang dictionary_id='32345.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
            </cfmail>
        </cfif>
    </cfif>
    <cfquery name="add_offtime" datasource="#caller.dsn#">
        INSERT INTO OFFTIME
        (
            EMPLOYEE_ID,
            OFFTIMECAT_ID,
            STARTDATE,
            FINISHDATE,
            WORK_STARTDATE,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP,
            OFFTIME_STAGE
        )
        VALUES
        (
            <cfif len(get_travel_demand.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_travel_demand.employee_id#"><cfelse>NULL</cfif>,
            1,
            <cfif len(get_travel_demand.flight_departure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_travel_demand.flight_departure_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_travel_demand.departure_date#"></cfif>,
            <cfif len(get_travel_demand.flight_departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_travel_demand.flight_departure_of_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_travel_demand.departure_of_date#"></cfif>,
            <cfif len(get_travel_demand.flight_departure_of_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#caller.date_add("d",1,get_travel_demand.flight_departure_of_date)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#caller.date_add("d",1,get_travel_demand.departure_of_date)#"></cfif>,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            554
        )
    </cfquery>
</cfif>