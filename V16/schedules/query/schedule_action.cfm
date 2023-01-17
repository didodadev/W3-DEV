<cfsetting requesttimeout="3600">
<cfset tarih_saat = "#dateformat(now(),dateformat_style)# #timeformat(now(),'HH:MM')# GMT">
<cfparam name="mailfrom" default="#listlast(server_detail)#<#listfirst(server_detail)#>">
<cfquery name="GET_ADMIN" datasource="#dsn#">
	SELECT ADMIN_MAIL FROM OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL
</cfquery>
<cfparam name="mailto" default="#get_admin.admin_mail#,#ListFirst(Server_Detail)#">

<cfset system = CreateObject("java", "java.lang.System")>
<cfset system = system.getProperties()>

<cfif ((cgi.REMOTE_ADDR eq '127.0.0.1') or (StructKeyExists(system,'java.rmi.server.hostname') and cgi.REMOTE_ADDR eq system['java.rmi.server.hostname'])) or isdefined("attributes.is_from_upd")>
	<!--- 
	mutlaka workcube kurulu makinanin ustunden calismasini istiyoruz  veya güncellemesinden çalıştır butonuyla gelince çalıştırıyoruz
	bu yuzden system['java.rmi.server.hostname'] ifadesi server IP sini dondurur
	 --->
	<cfquery name="GET_SCHEDULE" datasource="#DSN#">
		SELECT 
			SCHEDULE_NAME,
			SCHEDULE_ID,
            ISNULL(IS_POS_OPERATION,0) IS_POS_OPERATION,
			ISNULL(UPDATE_EMP,RECORD_EMP) RECORD_EMP
		FROM
			SCHEDULE_SETTINGS
		WHERE
			SCHEDULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#">			
	</cfquery>
    <cfif get_schedule.is_pos_operation eq 0><!--- otomatik sanal pos kuralı değilse --->
        <cfquery name="GET_SCHEDULED_REPORTS" datasource="#DSN#">
            SELECT 
                SR.SCHEDULE_PARAMS,
                SR.REPORT_NAME,
                SR.SCHEDULE_STATUS,
                SR.INFORMED_PEOPLE_MAILS,
                R.REPORT_ID,
                R.FILE_NAME
            FROM
                SCHEDULED_REPORTS SR,
                REPORTS R
            WHERE
                SR.SCHEDULE_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.schedule_id#,%">
                AND SR.REPORT_ID = R.REPORT_ID
        </cfquery>
        <cfset company_message = '<br/><hr><font class="css2">
            Bu mesajda, yalnızca  muhatabını ilgilendiren, kişiye veya kuruma özel bilgiler yer alıyor olabilir.<br/>
            Mesajın muhatabı  degilseniz, içeriğini ve varsa ekindeki dosyaları kimseye aktarmayınız ya da kopyalamayınız.<br/>
            Böyle bir durumda lütfen göndereni uyarip, mesajı imha ediniz. Gostermiş olduğunuz hassasiyetten dolayı teşekkür ederiz.<br/><br/>
        
            This e-mail may contain confidential and/or privileged information.<br/>
            If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail.<br/>
            Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.<br/>
            Thank you for your co-operation.<br/><br/>#mailfrom#</font>'>
		<cfoutput query="get_scheduled_reports">
            <cftry>
            <cfscript>
                file_name_for_save = CreateUUID()&'.cfm';
                for(i = 1 ; i lte ListLen(SCHEDULE_PARAMS,'&'); i = i + 1){
                    temp = ListGetAt(SCHEDULE_PARAMS,i,'&');
                        try
                            {
                            if(listlen(temp,"=") gte 2)
                                "attributes.#ListGetAt(temp,1,'=')#"  = ListGetAt(temp,2,'=');
                            else
                                "attributes.#ListGetAt(temp,1,'=')#"  = '';
                            }
                        catch(Any e) 
                            {
                            "attributes.#ListGetAt(temp,1,'=')#"  = '';
                            }
                }
            </cfscript>
            <cfsavecontent variable="cont">
                <!-- sil -->
                <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td height="35" class="headbold" width="99%"><cf_get_lang_main no='22.rapor'>: #REPORT_NAME#
                        	&nbsp; (#dateformat(date_add("h",2,now()),dateformat_style)# #timeformat(date_add("h",2,now()),'HH:mm')# )
                        </td>
                    </tr>
                </table>
                <cfinclude template="#file_web_path#report/#get_scheduled_reports.file_name#">
                <!-- sil -->
            </cfsavecontent>
            
            <cfset cont = ReplaceList(cont,'  ','')>
        
            <cfif listfind('0,2',SCHEDULE_STATUS)>
                <cffile action = "write" file="#upload_folder#report#dir_seperator#saved#dir_seperator##file_name_for_save#" output="#trim(cont)#" charset="utf-8" mode="777">
                <cfquery name="ADD_SAVED_REPORT" datasource="#DSN#">
                    INSERT INTO SAVED_REPORTS
                        (
                            REPORT_ID,
                            REPORT_NAME,
                            FILE_NAME,
                            FILE_SERVER_ID,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP,
                            UPDATE_EMP,
                            UPDATE_DATE,
                            UPDATE_IP
                        )
                    VALUES
                        (
                            '#REPORT_ID#',
                            '#REPORT_NAME#',
                            '#file_name_for_save#',
                            #fusebox.server_machine#,
                            0,
                            #NOW()#,
                            '#CGI.REMOTE_ADDR#',
                            0,
                            #NOW()#,
                            '#CGI.REMOTE_ADDR#'
                        )
                </cfquery>
            </cfif>
            <cfset cont_new = wrk_content_clear(cont)>
            <cfif listfind('1,2',SCHEDULE_STATUS) and Len(INFORMED_PEOPLE_MAILS)>
                <cftry>
                    <cfmail  
                        to = "#INFORMED_PEOPLE_MAILS#"
                        from = "#mailfrom#"
                        subject = "Workcube Report ID: #get_scheduled_reports.REPORT_ID# #tarih_saat#" type="html">
                        <html>
                        <head>
                        <style type="text/css">
                            table{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:##000000;padding:2px;}
                            .color-header{background-color:##a7caed;}
                            .color-list	{background-color:##E6E6FF;}
                            .color-border{background-color:##6699cc;}
                            .color-row{background-color:##f1f0ff;}
                            .label{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:##333333;padding-left: 4px;}
                            .form-title{color:##ffffff;font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;font-weight:bold;padding-left: 2px;}	
                            .tableyazi{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:##0033CC;}          
                            a.tableyazi:visited{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:##0033CC;} 
                            a.tableyazi:active{text-decoration: none;}
                            a.tableyazi:hover{text-decoration: underline; color:##339900;}  
                            a.tableyazi:link{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;padding-left: 2px;color:##0033CC;}
                            .headbold{font-family:Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                        </style>
                        </head>
                        <body>
                        #cont_new#<br/>
                        #company_message#
                        </body>
                        </html>
                    </cfmail>
                    <cfcatch type="any">
                        <cfoutput>#cfcatch.Message#</cfoutput>	
                        <cfmail  
                            to = "#mailto#"
                            from = "#mailfrom#"
                            subject = "Workcube Report Error 1 #cgi.server_name#" type="HTML">
                                SCHEDULE ERROR 1 : #tarih_saat#<br/>
                                Kaydedilecek Rapor Adi : #get_scheduled_reports.report_name#<br/>
                                Çalisacak Rapor ID : #get_scheduled_reports.report_id#<br/>
                                Schedule : #get_schedule.SCHEDULE_NAME#(ID:#get_schedule.schedule_id#)<br/>
                                #cfcatch.Message#
                        </cfmail>		
                    </cfcatch>
                </cftry>
            </cfif>
            <cfcatch>
                <cfoutput>#cfcatch.Message#</cfoutput>
                <cfmail
                    to = "#mailto#"
                    from = "#mailfrom#"
                    subject = "Workcube Report Error 2 #cgi.server_name#" type="HTML">
                        SCHEDULE ERROR 2 : #tarih_saat#<br/>
                        Kaydedilecek Rapor Adi : #get_scheduled_reports.report_name#<br/>
                        Çalisacak Rapor ID : #get_scheduled_reports.REPORT_ID#<br/>
                        Schedule : #get_schedule.SCHEDULE_NAME#(ID:#get_schedule.schedule_id#)<br/>
                        Dosya Içerigini Elde Ederken Problem olustu!!!!<br/>
                        #cfcatch.Message#
                </cfmail>			
            </cfcatch>
            </cftry>
        </cfoutput>
    <cfelse><!--- otomatik sanal pos kuralı ise --->
    	<cfquery name="GET_POS_OPERATION_ROW_" datasource="#DSN#">
            SELECT 
                POS_OPERATION_ID
            FROM
                SCHEDULE_SETTINGS_ROW
            WHERE
                SCHEDULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#">
            ORDER BY
            	ROW_NUMBER
        </cfquery>
		<cfquery name="GET_EMP_NAME" datasource="#DSN#">
			SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_schedule.record_emp#">
		</cfquery>
		<cfquery name="GET_PERIOD_ID" datasource="#DSN#">
			SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = 1 AND PERIOD_YEAR = #year(now())#
		</cfquery>
        <cfset is_from_schedule = 1>
        <cfoutput query="get_pos_operation_row_">
			<cfset operation_error = 0>
			<cfset attributes.pos_operation_id = get_pos_operation_row_.pos_operation_id>
            <cfset session.ep.company_id = 1>
            <cfset session.ep.userid = get_schedule.record_emp>
            <cfset session.ep.period_id = get_period_id.period_id>
            <cfset session.ep.period_year = year(now())>
            <cfset session.ep.money = 'TL'>
            <cfset session.ep.money2 = 'USD'>
            <cfset session.ep.language = 'tr'>
            <cfset session.ep.name = get_emp_name.EMPLOYEE_NAME>
            <cfset session.ep.surname = get_emp_name.EMPLOYEE_SURNAME>
            <cfset session.ep.position_name = '#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#'>
            <cfset session.ep.our_company_info.rate_round_num = 4>
            <cfset session.ep.our_company_info.is_ifrs = 0>
            <cfset session.ep.user_location= '1-1'>
            <cfset session.ep.period_is_integrated= 1>
            <cfset session.ep.period_start_date = "01/01/#session.ep.period_year#">
			<cfset session.ep.period_finish_date ="31/12/#session.ep.period_year#">
            <cfset session.ep.our_company_info.is_edefter = 1>
            <cfinclude template="../../bank/query/add_pos_operation_row.cfm">
            <cfinclude template="../../bank/query/add_pos_operation_action.cfm">
            <cfinclude template="../../bank/query/add_pos_operation_action_remain.cfm">
			<cfif operation_error eq 1><cfabort></cfif>
		</cfoutput>
    </cfif>
<cfelse>
	<cfmail  
		to = "#mailto#"
		from = "#mailfrom#"
		subject = "Workcube Report Error 3 #cgi.server_name#" type="HTML">
			SCHEDULE ERROR 3 : #tarih_saat#<br/> 
			Yetkisiz bir IP Hareketi!!!!<br/>
			IP = #cgi.REMOTE_ADDR#
	</cfmail>
</cfif>
<cfif isdefined("attributes.is_from_upd")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='832.Zaman Ayarlı Görev Çalıştırıldı'> !");
		self.close();
		wrk_opener_reload();
	</script>
</cfif>
