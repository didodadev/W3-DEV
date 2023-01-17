<cf_xml_page_edit fuseact="objects.popup_add_serial_operations">
    <cfsetting showdebugoutput="no">
    <cfif attributes.action_type is 'del'>
        <cfquery name="GET_SERIAL_INFO_ADD" datasource="#DSN3#">
            SELECT
                SG.STOCK_ID,
                SG.SPECT_ID,
                SG.GUARANTY_ID, 
                SG.SERIAL_NO
            FROM
                SERVICE_GUARANTY_NEW AS SG
            WHERE
                <cfif listfindnocase('171,1719',attributes.process_cat,',')>
                    SG.STOCK_ID = #attributes.stock_id# AND
                </cfif>
                <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>SG.SPECT_ID = #attributes.spect_id# AND</cfif>
                <cfif listfindnocase('171,1719',attributes.process_cat,',') and isdefined("attributes.main_process_id")>
                    MAIN_PROCESS_ID = #attributes.main_process_id# AND
                    MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                    MAIN_SERIAL_NO = '#attributes.main_serial_no#' AND
                </cfif>
                SG.PROCESS_ID = #attributes.process_id# AND
                SG.PROCESS_CAT = #attributes.process_cat# AND
                SG.PERIOD_ID = #session_base.period_id# AND
                SG.SERIAL_NO = '#attributes.serial_no#'
                <cfif attributes.process_cat eq 116>
                    AND IN_OUT = 0
                </cfif>
        </cfquery>
        <cfif GET_SERIAL_INFO_ADD.recordcount>
            <cfset attributes.guaranty_id = GET_SERIAL_INFO_ADD.GUARANTY_ID>
            <cfinclude template="del_serial_info.cfm">
            <cfquery name="GET_ALL_SERIES" datasource="#DSN3#">
                SELECT
                    SG.SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW AS SG
                WHERE
                    SG.PROCESS_ID = #attributes.process_id# AND
                    SG.PROCESS_CAT = #attributes.process_cat# AND
                    SG.PERIOD_ID = #session_base.period_id# AND
                    SG.STOCK_ID = #GET_SERIAL_INFO_ADD.STOCK_ID#
                    <!---<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>
                        AND SG.SPECT_ID = #GET_SERIAL_INFO_ADD.SPECT_ID#
                    </cfif>--->
                    <cfif listfindnocase('171,1719',attributes.process_cat,',') and isdefined("attributes.main_process_id")>
                        AND MAIN_PROCESS_ID = #attributes.main_process_id#
                        AND MAIN_PROCESS_TYPE = #attributes.main_process_cat# 
                        AND MAIN_SERIAL_NO = '#attributes.main_serial_no#' 
                    </cfif>
                    <cfif attributes.process_cat eq 116>
                        AND IN_OUT = 0
                    </cfif>
            </cfquery>
            <cfif listfindnocase('171',attributes.process_cat,',') and not isdefined("attributes.rel")><!--- Üretim sonucu çıkarma üst seri --->
            <cfquery name="del_sub_rel" datasource="#dsn3#">
                DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID IN ( SELECT 
                                                                            GUARANTY_ID 
                                                                        FROM 
                                                                            SERVICE_GUARANTY_NEW 
                                                                        WHERE 
                                                                            MAIN_SERIAL_NO = '#attributes.serial_no#' 
                                                                            AND PROCESS_CAT = 1719 
                                                                            AND PERIOD_ID = #session_base.period_id#
                                                                            AND MAIN_PROCESS_ID = #attributes.process_id#
                                                                            AND MAIN_PROCESS_TYPE = #attributes.process_cat#
                                                                            )
            </cfquery>
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        if(#GET_ALL_SERIES.recordcount#!='')
                        serial_record_ = #GET_ALL_SERIES.recordcount#;
                        else
                        serial_record_ = 0;
                        var fark_ = total_record_ -  serial_record_;
                        if(fark_<1)
                            {
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = true;}
                        else{
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = false;}
                        document.getElementById('seri_list').value =  '#valuelist(GET_ALL_SERIES.SERIAL_NO)#';		
                        document.getElementById('delete_old_serial_no').value = '';
                        
                        document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#"><a class="tableyazi" onclick="open_detail_div(\'#cc#\',#GET_SERIAL_INFO_ADD.STOCK_ID#,#GET_SERIAL_INFO_ADD.SPECT_ID#)">#cc#</a><br /></cfloop>';		
                       <cfif not isDefined("is_line")>
                        location.reload();
                        </cfif>
                        document.getElementById('serial_no_fark_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = total_record_ -  serial_record_;
                        document.getElementById('son_fark_').value = total_record_ -  serial_record_;
                        <!---document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';--->				</cfoutput>
                </script>
            <cfelseif  listfindnocase('171',attributes.process_cat,',') and isdefined("attributes.rel")>
                <cfquery name="GET_ALL_SERIES" datasource="#dsn3#">
                    SELECT 
                        SERIAL_NO
                    FROM 
                        SERVICE_GUARANTY_NEW
                    WHERE
                        MAIN_PROCESS_ID = #attributes.main_process_id# AND
                        MAIN_PROCESS_NO = '#attributes.main_process_no#' AND
                        MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                        MAIN_SERIAL_NO = '#attributes.main_serial_no#' AND
                        STOCK_ID = #attributes.stock_id# AND
                        PROCESS_ID = #attributes.process_id# AND
                        PROCESS_CAT = #attributes.process_cat# AND
                        PERIOD_ID = #session_base.period_id#
                </cfquery>
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        if(#GET_ALL_SERIES.recordcount#!='')
                        serial_record_ = #GET_ALL_SERIES.recordcount#;
                        else
                        serial_record_ = 0;
                        var fark_ = total_record_ -  serial_record_;
                        if(fark_<1){
                            if(document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                            document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#').disabled = true;}
                        else{
                            if(document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                            document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#').disabled = false;}
                        if(fark_<1){
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = true;}
                        else{
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = false;}
                        if(document.getElementById('delete_old_serial_no#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                        document.getElementById('delete_old_serial_no#GET_SERIAL_INFO_ADD.STOCK_ID#').value = '';
                        if(document.getElementById('delete_old_serial_no')!= null)
                        document.getElementById('delete_old_serial_no').value = '';
                        document.getElementById('serial_no_mylist_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#"><a class="tableyazi" onclick="open_detail_div(\'#cc#\')">#cc#</a><br /></cfloop>';		
                        document.getElementById('serial_no_fark_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = total_record_ -  serial_record_;
                        document.getElementById('son_fark_').value = total_record_ -  serial_record_;
                       // document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';			
                    </cfoutput>
                </script>
            <cfelseif  listfindnocase('1719',attributes.process_cat,',')><!---Üst Sarf Çıkarma--->
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        if(#GET_ALL_SERIES.recordcount#!='')
                            serial_record_ = #GET_ALL_SERIES.recordcount#;
                        else
                            serial_record_ = 0;
                        var fark_ = total_record_-serial_record_;
                        if(fark_<1){
                            if( document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                            document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#').disabled = true;}
                        else{
                            if(document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                            document.getElementById('add_new_serial_no_button#GET_SERIAL_INFO_ADD.STOCK_ID#').disabled = false;}
                        if(document.getElementById('delete_old_serial_no#GET_SERIAL_INFO_ADD.STOCK_ID#')!= null)
                        document.getElementById('delete_old_serial_no#GET_SERIAL_INFO_ADD.STOCK_ID#').value = '';
                        if(document.getElementById('delete_old_serial_no')!= null)
                        document.getElementById('delete_old_serial_no').value = '';
                        if(fark_<1){
                            if( document.getElementById('sarf_add_new_serial_no_button')!= null)
                            {
                            document.getElementById('sarf_add_new_serial_no_button').disabled = true;
                            //document.getElementById('sarf_add_new_serial_no').readOnly = true;
                            }
                            }
                        else{
                            if(document.getElementById('sarf_delete_old_serial_no_button')!= null)
                            {
                            document.getElementById('sarf_delete_old_serial_no_button').disabled = false;
                            document.getElementById('sarf_delete_old_serial_no').value = '';
                            //document.getElementById('sarf_delete_old_serial_no').readOnly = true;
                            }
                            
                            }
                        document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#">#cc#<br /></cfloop>';		
                        document.getElementById('sarf_div').style.display = '';
                        document.getElementById('serial_no_fark_#GET_SERIAL_INFO_ADD.STOCK_ID#').innerHTML = total_record_- serial_record_;
                    </cfoutput>
                </script>
            <cfelse>
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        
                        serial_record_ = parseInt(#GET_ALL_SERIES.recordcount#);
                        
                        fark_ = total_record_ - serial_record_;
                        document.getElementById('delete_old_serial_no').value = '';
                        //document.getElementById('serial_no_amount_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = total_record_;
                        document.getElementById('serial_no_record_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = serial_record_;
                        document.getElementById('serial_no_fark_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = fark_;
                        document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';	
                    </cfoutput>
                </script>
                <cfif isdefined("serial_operation_warning") and listlen(serial_operation_warning)>
                    <cfquery name="get_emails" datasource="#dsn#">
                        SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> '' AND POSITION_CODE IN (#serial_operation_warning#)
                    </cfquery>
                    <cfquery datasource="#dsn#" name="get_sender_mail">
                        SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session_base.userid# AND EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> ''
                    </cfquery>
                
                    <cfif get_emails.recordcount and get_sender_mail.recordcount>
                        <cfoutput query="get_emails">
                            <cfset attributes.mail_content_to = get_emails.EMPLOYEE_EMAIL>
                            <cfset attributes.mail_content_from = get_sender_mail.EMPLOYEE_EMAIL>
                            <cfset attributes.mail_content_subject = "Seri No İşlem Ekranı">
                            <cfset attributes.mail_content_additor = "#get_emails.EMPLOYEE_NAME# #get_emails.EMPLOYEE_SURNAME#">
                            <cfset attributes.mail_record_emp = "#get_sender_mail.EMPLOYEE_NAME# #get_sender_mail.EMPLOYEE_SURNAME#">
                            <cfset attributes.mail_record_date= DateFormat(date_add('h',2,now()), dateformat_style) & " " & TimeFormat(date_add('h',2,now()), timeformat_style)>
                            <cfsavecontent variable="attributes.mail_content_info"><cf_get_lang_main no='1745.bilgilendirme'></cfsavecontent>
                                <cfif cgi.server_port eq 443>
                                    <cfset user_domain = "https://#cgi.server_name#">
                                <cfelse>
                                    <cfset user_domain = "http://#cgi.server_name#">
                                </cfif>
                                <cfset attributes.mail_content_link = '#user_domain##request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#attributes.process_id#'>
                            <cfinclude template="../../design/template/info_mail/mail_content.cfm">
                        </cfoutput>
                    </cfif>
                </cfif>
            </cfif>
        <cfelse>
            <script>
                alert('Kayıtlı Olmayan Bir Seri ile İşlem Yapmaya Çalıştınız!');
            </script>
        </cfif>
    <cfelseif attributes.action_type is 'relation'>
        <cfquery name="get_count" datasource="#dsn3#">
            SELECT 
                GUARANTY_ID,
                STOCK_ID
            FROM 
                SERVICE_GUARANTY_NEW
            WHERE
                MAIN_PROCESS_ID = #attributes.main_process_id# AND
                MAIN_PROCESS_NO = '#attributes.main_process_no#' AND
                MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                MAIN_SERIAL_NO = '#attributes.main_serial_no#' AND
                STOCK_ID = #attributes.stock_id# AND
                PROCESS_ID IN (#attributes.process_id#) AND
               <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)> PROCESS_CAT = #attributes.process_cat# AND</cfif>
                PERIOD_ID = #session_base.period_id# AND
                SERIAL_NO = '#attributes.serial_no#'
            ORDER BY 
                UPDATE_DATE desc
        </cfquery>
           <cfquery name="upd_old_rec" datasource="#dsn3#">
                UPDATE
                    SERVICE_GUARANTY_NEW
                SET
                    MAIN_PROCESS_ID = NULL,
                    MAIN_PROCESS_NO = NULL,
                    MAIN_PROCESS_TYPE = NULL,
                    MAIN_SERIAL_NO = NULL,
                    UPDATE_DATE = #NOW()#,
                    UPDATE_EMP = #session_base.userid#
                WHERE
                    GUARANTY_ID = #get_count.GUARANTY_ID#
            </cfquery>
                 <cfquery name="GET_ALL_SERIES" datasource="#dsn3#">
                    SELECT 
                        SERIAL_NO
                    FROM 
                        SERVICE_GUARANTY_NEW
                    WHERE
                        MAIN_PROCESS_ID = #attributes.main_process_id# AND
                        MAIN_PROCESS_NO = '#attributes.main_process_no#' AND
                        MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                        MAIN_SERIAL_NO = '#attributes.main_serial_no#' AND
                        STOCK_ID = #attributes.stock_id# AND
                        PROCESS_ID IN (#attributes.process_id#) AND
                        <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)> PROCESS_CAT = #attributes.process_cat# AND</cfif>
                        PERIOD_ID = #session_base.period_id#
                </cfquery>
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#get_count.STOCK_ID#').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        if(#GET_ALL_SERIES.recordcount#!='')
                        serial_record_ = #GET_ALL_SERIES.recordcount#;
                        else
                        serial_record_ = 0;
                        var fark_ = total_record_ -  serial_record_;
                        document.getElementById('delete_old_serial_no#get_count.STOCK_ID#').value = '';
                        document.getElementById('serial_no_list_#get_count.STOCK_ID#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#">#cc#<br /></cfloop>';		
                        document.getElementById('serial_no_fark_#get_count.STOCK_ID#').innerHTML = total_record_ -  serial_record_;
    <!---				    document.getElementById('serial_no_list_#GET_SERIAL_INFO_ADD.STOCK_ID#<cfif len(GET_SERIAL_INFO_ADD.SPECT_ID)>_#GET_SERIAL_INFO_ADD.SPECT_ID#</cfif>').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';			
    --->				</cfoutput>
                </script>
    <cfelseif attributes.action_type is 'add'>
        <cfif listfindnocase('1719',attributes.process_cat,',') or isdefined("is_product")><!---Üretime Giren Mamuller için Sarf tipi --->
            <!---Garanti Kategorisi için tablodaki ilk değeri alıyoruz ?? --->
            <cfquery name="get_cat" datasource="#dsn#">
                   SELECT TOP 1 GUARANTYCAT_ID FROM SETUP_GUARANTY
            </cfquery> 
            <cfquery name="control" datasource="#dsn3#">
                SELECT
                    SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    PROCESS_ID = #attributes.process_id# AND
                    PROCESS_CAT = #attributes.process_cat# AND
                    PERIOD_ID = #session_base.period_id# AND
                    STOCK_ID = #attributes.stock_id#
                    <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
                        AND SPECT_ID = #attributes.spect_id#
                    </cfif>
                UNION ALL
                SELECT
                    SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    PROCESS_CAT = 111 AND
                    MAIN_PROCESS_TYPE = 171 AND
                    PERIOD_ID = #session_base.period_id# AND
                    STOCK_ID = #attributes.stock_id#
                    <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
                        AND SPECT_ID = #attributes.spect_id#
                    </cfif>
            </cfquery>
            <cfset old_deger = valuelist(control.serial_no)>
            <cfif listfindnocase(old_deger,attributes.serial_no)>
                <script>
                    alert("<cfoutput>#attributes.serial_no#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                    document.getElementById('add_new_serial_no').value = '';
                </script>
                <cfabort>
            </cfif>
            <cfquery name="get_old_rows" datasource="#dsn3#">
                SELECT 
                    ORDER_.EXIT_DEP_ID,
                    ORDER_.EXIT_LOC_ID,
                       ORDER_.RESULT_NO,
                    ORDER_.START_DATE AS DELIVER_DATE,
                    ORDER_ROW.STOCK_ID,
                    ORDER_ROW.SPECT_ID
                FROM 
                    PRODUCTION_ORDER_RESULTS ORDER_ ,
                    PRODUCTION_ORDER_RESULTS_ROW ORDER_ROW
                WHERE
                    ORDER_.PR_ORDER_ID = #attributes.main_process_id# AND
                    ORDER_.PR_ORDER_ID = ORDER_ROW.PR_ORDER_ID AND
                    ORDER_ROW.STOCK_ID = #attributes.stock_id#
                    <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
                        AND ORDER_ROW.SPECT_ID = #attributes.spect_id#
                    </cfif>
            </cfquery>
            <cfset attributes.guaranty_cat1 = get_cat.GUARANTYCAT_ID>
            <cfset attributes.serial_no_start_number1 = attributes.serial_no>
            <cfset attributes.guaranty_startdate1 = dateformat(get_old_rows.DELIVER_DATE,dateformat_style)>
            <cfset attributes.stock_id1 =  attributes.stock_id>
            <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
                <cfset attributes.spect_id = attributes.spect_id>
            <cfelse>
                <cfset attributes.spect_id = ''>
            </cfif>
            <cfset attributes.guaranty_purchasesales1 = 0>
            <cfscript>
                add_serial_no
                (
                session_row : 1,
                process_type : attributes.process_cat, 
                process_number : attributes.process_no,
                process_id : attributes.process_id,
                dpt_id : get_old_rows.EXIT_DEP_ID,
                loc_id : get_old_rows.EXIT_LOC_ID,
                main_stock_id : '',
                spect_id : attributes.spect_id,
                main_process_id : attributes.main_process_id,
                main_process_no : attributes.main_process_no,
                main_process_cat : attributes.main_process_cat,
                main_serial_no : attributes.main_serial_no
                );
            </cfscript>
            <cfquery name="GET_ALL_SERIES" datasource="#DSN3#">
                   SELECT
                    SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    PROCESS_ID = #attributes.process_id# AND
                    PROCESS_CAT = #attributes.process_cat# AND
                    PERIOD_ID = #session_base.period_id# AND
                    STOCK_ID = #attributes.stock_id# AND
                    <cfif len(attributes.spect_id)>SPECT_ID = #attributes.spect_id# AND</cfif>
                    MAIN_PROCESS_ID = #attributes.main_process_id# AND
                    MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                    MAIN_SERIAL_NO = '#attributes.main_serial_no#'
            </cfquery>
            <script>
                <cfoutput>
                    var is_empty = 0;
                    total_record_ = document.getElementById('serial_no_amount_#attributes.stock_id#').innerHTML;	
                    //total_record_ = 1;	
                    total_record_ = parseInt(total_record_);
                    if(#GET_ALL_SERIES.recordcount#!='')
                        serial_record_ = parseInt(#GET_ALL_SERIES.recordcount#);
                    else
                        serial_record_ = 0;
                    var fark_ = total_record_ - serial_record_;
                    if(fark_<1 && (document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#')!= undefined ||document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#')!= null))
                    document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#').disabled = true;
                    else if(fark_>=1 && (document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#')!= undefined||document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#')!= null))
                    document.getElementById('add_new_serial_no_button#attributes.STOCK_ID#').disabled = false;
                    if(fark_<1 && (document.getElementById('sarf_add_new_serial_no_button')!= undefined ||document.getElementById('sarf_add_new_serial_no_button')!= null))
                    {
                    document.getElementById('sarf_add_new_serial_no_button').disabled = true;
                    //document.getElementById('sarf_add_new_serial_no').readOnly = true;
                    }
                    else if(fark_>=1 && (document.getElementById('sarf_delete_old_serial_no_button')!= undefined||document.getElementById('sarf_delete_old_serial_no_button')!= null))
                    {
                    document.getElementById('sarf_delete_old_serial_no_button').disabled = false;
                    //document.getElementById('sarf_delete_old_serial_no').readOnly = true;
                    }
                    document.getElementById('serial_no_fark_#attributes.stock_id#').innerHTML = fark_;
                    //document.getElementById('serial_no_list_#attributes.stock_id#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#">#cc#<br /></cfloop>';		
                    if(document.getElementById('serial_no_list_#attributes.stock_id#'))document.getElementById('serial_no_list_#attributes.stock_id#').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';	
                    else if(document.getElementById('serial_no_mylist_#attributes.stock_id#'))	document.getElementById('serial_no_mylist_#attributes.stock_id#').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';		
                    <cfif isdefined("stock_list")>
                        <cfloop list="#stock_list#" index="cc">
                            if(trim(document.getElementById('serial_no_fark_#cc#').innerHTML)!=0)
                                is_empty = 1;
                        </cfloop>
                    </cfif>
                    if(is_empty == 0)
                            document.getElementById('search_serial_no').focus();
                    if(document.getElementById('add_new_serial_no#attributes.STOCK_ID#')!= undefined )
                        document.getElementById('add_new_serial_no#attributes.STOCK_ID#').value = '';
                </cfoutput>
            </script>
            <cfabort>
        </cfif>
        <cfif listfindnocase('171',attributes.process_cat,',') and not isdefined("attributes.is_product")><!---Üretim Sonucu ekleme Üst Seri--->
            <!---Garanti Kategorisi için tablodaki ilk değeri alıyoruz ?? --->
            <cfquery name="get_cat" datasource="#dsn#">
                   SELECT TOP 1 GUARANTYCAT_ID FROM SETUP_GUARANTY
            </cfquery> 
            <cfquery name="control" datasource="#dsn3#">
                SELECT
                    SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    PROCESS_ID = #attributes.process_id# AND
                    PROCESS_CAT = #attributes.process_cat# AND
                    PERIOD_ID = #session_base.period_id# AND
                    STOCK_ID = #attributes.stock_id#
                    <cfif len(attributes.spect_id)>
                        AND SPECT_ID = #attributes.spect_id#
                    </cfif>
            </cfquery>
            <cfset old_deger = valuelist(control.serial_no)>
            <cfif listfindnocase(old_deger,attributes.serial_no)>
                <script>
                    alert("<cfoutput>#attributes.serial_no#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                    document.getElementById('add_new_serial_no').value = '';
                </script>
                <cfabort>
            </cfif>
            <cfquery name="get_old_rows" datasource="#dsn3#">
                SELECT 
                    ORDER_.PRODUCTION_DEP_ID ENTER_DEP_ID,
                    ORDER_.PRODUCTION_LOC_ID ENTER_LOC_ID,
                       ORDER_.RESULT_NO,
                    ORDER_.START_DATE AS DELIVER_DATE,
                    ORDER_ROW.STOCK_ID,
                    ORDER_ROW.SPECT_ID,
                    ORDER_ROW.WRK_ROW_ID
                FROM 
                    PRODUCTION_ORDER_RESULTS ORDER_ ,
                    PRODUCTION_ORDER_RESULTS_ROW ORDER_ROW
                WHERE
                    ORDER_.PR_ORDER_ID = #attributes.process_id# AND
                    ORDER_.PR_ORDER_ID = ORDER_ROW.PR_ORDER_ID AND
                    ORDER_ROW.STOCK_ID = #attributes.stock_id#
                    <cfif len(attributes.spect_id)>
                        AND (ORDER_ROW.SPECT_ID = #attributes.spect_id# OR ORDER_ROW.SPEC_MAIN_ID = #attributes.spect_id#)
                    </cfif>
            </cfquery>
            <cfset attributes.guaranty_cat1 = get_cat.GUARANTYCAT_ID>
            <cfset attributes.serial_no_start_number1 = attributes.serial_no>
            <cfset attributes.guaranty_startdate1 = dateformat(get_old_rows.DELIVER_DATE,dateformat_style)>
            <cfset attributes.stock_id1 =  attributes.stock_id>
            <cfif len(attributes.spect_id)>
                <cfset attributes.spect_id = attributes.spect_id>
            <cfelse>
                <cfset attributes.spect_id = ''>
            </cfif>
            <cfset attributes.guaranty_purchasesales1 = 0>
            <cfscript>
                add_serial_no
                (
                session_row : 1,
                process_type : attributes.process_cat, 
                process_number : get_old_rows.RESULT_NO,
                process_id : attributes.process_id,
                dpt_id : get_old_rows.ENTER_DEP_ID,
                loc_id : get_old_rows.ENTER_LOC_ID,
                main_stock_id : '',
                spect_id : attributes.spect_id,
                wrk_row_id: get_old_rows.wrk_row_id
                );
            </cfscript>
            <cfquery name="GET_ALL_SERIES" datasource="#DSN3#">
                SELECT
                    SG.SERIAL_NO
                FROM
                    SERVICE_GUARANTY_NEW AS SG
                WHERE
                    SG.PROCESS_ID = #attributes.process_id# AND
                    SG.PROCESS_CAT = #attributes.process_cat# AND
                    SG.PERIOD_ID = #session_base.period_id# AND
                    SG.STOCK_ID = #attributes.stock_id#
                   <!--- <cfif len(attributes.spect_id)>
                        AND SG.SPECT_ID = #attributes.spect_id#
                    </cfif>--->
            </cfquery>
            <script>
                <cfoutput>
                    total_record_ = document.getElementById('serial_no_amount_#attributes.stock_id#').innerHTML;		
                    total_record_ = parseInt(total_record_);
                    if(#GET_ALL_SERIES.recordcount#!='')
                        serial_record_ = parseInt(#GET_ALL_SERIES.recordcount#);
                    else
                        serial_record_ = 0;
                    var fark_ = total_record_ - serial_record_;
                    if(fark_<1)
                    {
                        if(document.getElementById('add_new_serial_no_button')!= null)
                        document.getElementById('add_new_serial_no_button').disabled = true;
                        document.getElementById('search_serial_no').focus();
                    }
                    else
                    {
                        if(document.getElementById('add_new_serial_no_button')!= null)
                        document.getElementById('add_new_serial_no_button').disabled = false;
                    }
                        document.getElementById('add_new_serial_no').value = '';
                        document.getElementById('seri_list').value =  '#valuelist(GET_ALL_SERIES.SERIAL_NO)#';		
                        document.getElementById('serial_no_fark_#attributes.stock_id#').innerHTML = fark_;
                        document.getElementById('serial_no_list_#attributes.stock_id#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES.SERIAL_NO)#"><a class="tableyazi" onclick="open_detail_div(\'#cc#\',#attributes.stock_id#)">#cc#</a><br /></cfloop>';
                        document.getElementById('add_new_serial_no').focus();
                        <cfif not isDefined("is_line")>
                        location.reload();
                        </cfif>
                        document.getElementById('son_fark_').value = total_record_ -  serial_record_;
                </cfoutput>
            </script>
            <cfabort>
        </cfif>
        <cfif listfindnocase('116',attributes.process_cat,',')>
            <cfquery name="get_seri_kontrol_alis" datasource="#dsn3#">
                SELECT
                    SERIAL_NO,
                    RECORD_DATE,
                    GUARANTY_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID,
                    STOCK_ID,
                    SPECT_ID,
                    PURCHASE_GUARANTY_CATID
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    PROCESS_CAT IN (110,113,76,77,81,82,84,114,115,171,811,1190,116) AND
                    STOCK_ID = #attributes.stock_id#
                    AND IN_OUT = 1
                    AND SERIAL_NO = '#attributes.serial_no#'
                    <cfif len(attributes.spect_id) and attributes.process_cat neq 116>
                        AND SPECT_ID = #attributes.spect_id#
                    </cfif>
                    AND
                        SERIAL_NO NOT IN (SELECT S2.SERIAL_NO FROM SERVICE_GUARANTY_NEW S2 WHERE <cfif attributes.process_cat eq 116> S2.IN_OUT = 0 AND<cfelse> S2.IS_SALE = 1 AND </cfif> S2.STOCK_ID = #attributes.stock_id# <cfif len(attributes.spect_id) and attributes.process_cat neq 116>AND S2.SPECT_ID = #attributes.spect_id#</cfif>)
                ORDER BY
                    GUARANTY_ID DESC
            </cfquery>
            <cfif get_seri_kontrol_alis.recordcount>
                <cfif isdefined("attributes.process_id") and attributes.process_id neq 0>
                    <cfquery name="GET_OLD_CONTROL" datasource="#DSN3#">
                        SELECT
                            EXIT_AMOUNT QUANTITY
                        FROM
                            #dsn2_alias#.STOCK_EXCHANGE
                        WHERE
                            STOCK_EXCHANGE_ID = #attributes.process_id# AND
                            EXIT_STOCK_ID = #attributes.stock_id#
                    </cfquery>
                <cfelse>
                    <cfset GET_OLD_CONTROL.QUANTITY = attributes.amount>
                </cfif>
                <cfif isdefined("attributes.process_id") and attributes.process_id neq 0>
                    <cfquery name="GET_ALL_SERIES_CONTROL" datasource="#DSN3#">
                        SELECT
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            SG.PROCESS_ID = #attributes.process_id# AND
                            SG.PROCESS_CAT = #attributes.process_cat# AND
                            SG.PERIOD_ID = #session_base.period_id# AND
                            SG.STOCK_ID = #attributes.stock_id#
                            AND SG.IN_OUT = 0
                    </cfquery>
                <cfelse>
                    <cfset GET_ALL_SERIES_CONTROL.recordcount = 0>
                </cfif>
                <cfif len(GET_OLD_CONTROL.QUANTITY) and GET_ALL_SERIES_CONTROL.recordcount gte GET_OLD_CONTROL.QUANTITY>
                    <script>
                        alert('Bu Ürün İçin Seri Adedi Tamamlanmıştır!');
                    </script>
                    <cfabort>
                </cfif>	
                <cfif isdefined("attributes.process_id") and attributes.process_id neq 0>
                    <cfquery name="get_old_rows" datasource="#dsn3#">
                        SELECT
                           PROCESS_DATE AS DELIVER_DATE,
                           EXCHANGE_NUMBER AS SHIP_NUMBER,
                           EXIT_DEPARTMENT_ID DEPARTMENT_IN,
                           EXIT_LOCATION_ID LOCATION_IN,
                           '' AS COMPANY_ID,
                           '' AS CONSUMER_ID,
                           '' AS PARTNER_ID
                        FROM
                            #dsn2_alias#.STOCK_EXCHANGE
                        WHERE
                            STOCK_EXCHANGE_ID = #attributes.process_id# AND
                            EXIT_STOCK_ID = #attributes.stock_id#
                    </cfquery>
                    <cfset attributes.guaranty_cat1 = get_seri_kontrol_alis.PURCHASE_GUARANTY_CATID>
                    <cfset attributes.guaranty_startdate1 = dateformat(get_old_rows.DELIVER_DATE,dateformat_style)>
                    <cfset attributes.stock_id1 = attributes.stock_id>
                    <cfset attributes.spect_id = attributes.spect_id>
                    <cfset attributes.serial_no_start_number1 = get_seri_kontrol_alis.SERIAL_NO>
                    <cfset attributes.guaranty_purchasesales1 = 1>
                    <cfif isdefined("attributes.process_number") and len(attributes.process_number)>
                        <cfset process_no_ = attributes.process_number>
                    <cfelse>
                        <cfset process_no_ = get_old_rows.SHIP_NUMBER>
                    </cfif>
                    <cfscript>
                        add_serial_no
                        (
                        session_row : 1,
                        process_type : attributes.process_cat, 
                        process_number : process_no_,
                        process_id : attributes.process_id,
                        dpt_id : get_old_rows.DEPARTMENT_IN,
                        loc_id : get_old_rows.LOCATION_IN,
                        par_id : get_old_rows.partner_id,
                        con_id : get_old_rows.consumer_id,
                        //main_stock_id : attributes.stock_id1,
                        main_stock_id : '',
                        spect_id : attributes.spect_id,
                        comp_id : get_old_rows.company_id,
                        is_in_out : 0
                        )
                        ;
                    </cfscript>
                <cfelse>
                    <cfset attributes.guaranty_cat1 = get_seri_kontrol_alis.PURCHASE_GUARANTY_CATID>
                    <cfset attributes.stock_id1 = attributes.stock_id>
                    <cfset attributes.spect_id = attributes.spect_id>
                    <cfset attributes.serial_no_start_number1 = get_seri_kontrol_alis.SERIAL_NO>
                    <cfset attributes.guaranty_purchasesales1 = 1>
                    <cfscript>
                        add_serial_no
                        (
                        session_row : 1,
                        process_type : attributes.process_cat, 
                        process_number : attributes.process_number,
                        process_id : attributes.process_id,
                        wrk_row_id : attributes.wrk_row_id,
                        //main_stock_id : attributes.stock_id1,
                        main_stock_id : '',
                        spect_id : attributes.spect_id,
                        is_in_out : 0
                        )
                        ;
                    </cfscript>
                </cfif>
                <cfquery name="GET_ALL_SERIES_CONTROL" datasource="#DSN3#">
                    SELECT
                        SG.SERIAL_NO
                    FROM
                        SERVICE_GUARANTY_NEW AS SG
                    WHERE
                        SG.PROCESS_ID = #attributes.process_id# AND
                        SG.PROCESS_CAT = #attributes.process_cat# AND
                        SG.PERIOD_ID = #session_base.period_id# AND
                        SG.STOCK_ID = #attributes.stock_id#
                        AND SG.IN_OUT = 0
                </cfquery>
                <script>
                    <cfoutput>
                        total_record_ = document.getElementById('serial_no_amount_#attributes.stock_id#').innerHTML;		
                        total_record_ = parseInt(total_record_);
                        if(#GET_ALL_SERIES_CONTROL.recordcount#!='')
                            serial_record_ = parseInt(#GET_ALL_SERIES_CONTROL.recordcount#);
                        else
                            serial_record_ = 0;
                        var fark_ = total_record_ - serial_record_;
                        if(fark_<1)
                        {
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = true;
                        }
                        else
                        {
                            if(document.getElementById('add_new_serial_no_button')!= null)
                            document.getElementById('add_new_serial_no_button').disabled = false;
                        }
                            document.getElementById('add_new_serial_no').value = '';
                            document.getElementById('serial_no_fark_#attributes.stock_id#').innerHTML = fark_;
                            document.getElementById('serial_no_list_#attributes.stock_id#').innerHTML = '<cfloop index="cc" list="#valuelist(GET_ALL_SERIES_CONTROL.SERIAL_NO)#">#cc#<br /></cfloop>';
                            document.getElementById('add_new_serial_no').focus();
                    </cfoutput>
                </script>
            <cfelse>
                <script>
                    alert('Alışı Olmayan Seri No Çıkış Yapmaya Çalıştınız veya Spect Farklılıkları Var!');
                    history.back();
                </script>
            </cfif>
        </cfif>
        <cfif listfindnocase('71,141,81,811',attributes.process_cat,',')>
            <cfquery name="get_old_rows" datasource="#dsn3#">
                SELECT DISTINCT
                    SHIP_ROW.STOCK_ID,
                    SHIP_ROW.SPECT_VAR_ID,
                    SHIP.DELIVER_DATE,
                    SHIP.SHIP_NUMBER,
                    ISNULL(SHIP.DEPARTMENT_IN,DELIVER_STORE_ID) DEPARTMENT_IN,
                    ISNULL(SHIP.LOCATION_IN,LOCATION) LOCATION_IN,
                    SHIP.DELIVER_STORE_ID DEPARTMENT_OUT,
                    SHIP.LOCATION LOCATION_OUT,
                    ISNULL(SHIP.LOCATION_IN,LOCATION) LOCATION_OUT,
                    SHIP.PARTNER_ID,
                    SHIP.CONSUMER_ID,
                    SHIP.COMPANY_ID,
                    ISNULL(SHIP_ROW.AMOUNT,0) AS QUANTITY
                FROM
                    #dsn2_alias#.SHIP SHIP,
                    #dsn2_alias#.SHIP_ROW SHIP_ROW
                WHERE
                    SHIP.SHIP_ID = #attributes.process_id# AND
                    SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                    SHIP.SHIP_TYPE = #attributes.process_cat#
            </cfquery>
            <cfquery name="get_seri_kontrol_alis" datasource="#dsn3#"><!--- satis isleminde alis var mi?--->
                SELECT TOP 1
                    GUARANTY_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID,
                    STOCK_ID,
                    SPECT_ID,
                    PURCHASE_GUARANTY_CATID,
                    UNIT_ROW_QUANTITY,
                    LOT_NO
                FROM 
                    SERVICE_GUARANTY_NEW
                WHERE 
                    SERIAL_NO = '#attributes.serial_no#' AND
                    PROCESS_CAT IN (110,76,77,82,84,87,114,115,171,811,74,75,140,113) AND
                    STOCK_ID IN (#valuelist(get_old_rows.STOCK_ID)#)
                ORDER BY
                    GUARANTY_ID DESC
            </cfquery>
            <cfset seri_alis_pass = 0>
            
            <cfif get_seri_kontrol_alis.recordcount>
                <cfoutput query="get_old_rows">
                    <cfif seri_alis_pass eq 0>
                        <cfif STOCK_ID eq get_seri_kontrol_alis.STOCK_ID and not len(SPECT_VAR_ID) and not len(get_seri_kontrol_alis.SPECT_ID)>
                            <cfset seri_alis_pass = 1>
                            <cfset islem_stock_id_ = STOCK_ID>
                            <cfset islem_spect_id_ = ''>
                        <cfelseif STOCK_ID eq get_seri_kontrol_alis.STOCK_ID and SPECT_VAR_ID eq get_seri_kontrol_alis.SPECT_ID>
                            <cfset seri_alis_pass = 1>
                            <cfset islem_stock_id_ = STOCK_ID>
                            <cfset islem_spect_id_ = SPECT_VAR_ID>
                        <cfelseif listfindnocase('81,811',attributes.process_cat,',')>
                            <cfset seri_alis_pass = 1>
                            <cfset islem_stock_id_ = STOCK_ID>
                            <cfset islem_spect_id_ = SPECT_VAR_ID>
                        </cfif>
                    </cfif>
                </cfoutput>
            </cfif>
           <!---  <cfdump var="#seri_alis_pass#" abort> --->
            <cfif seri_alis_pass eq 1>
                <cfquery name="get_seri_kontrol_satis" datasource="#dsn3#"><!--- satis isleminde alis var mi?--->
                    SELECT
                        UNIT_ROW_QUANTITY
                    FROM 
                        SERVICE_GUARANTY_NEW
                    WHERE 
                        SERIAL_NO = '#attributes.serial_no#' AND
                        STOCK_ID = #islem_stock_id_#
                        <cfif len(islem_spect_id_)>
                            AND SPECT_ID = #islem_spect_id_#
                        </cfif>
                        AND IN_OUT = 1
                    ORDER BY
                        GUARANTY_ID DESC
                </cfquery>
                <cfquery name="get_rows2" datasource="#dsn3#">
                    SELECT
                        ISNULL(SUM(UNIT_ROW_QUANTITY),0) AS UNIT_ROW_QUANTITY
                    FROM
                        SERVICE_GUARANTY_NEW
                    WHERE
                        PROCESS_CAT IN (1194,71) AND
                        SERIAL_NO = '#attributes.serial_no#' AND
                        STOCK_ID = #islem_stock_id_#
                        <cfif len(islem_spect_id_)>
                            AND SPECT_ID = #islem_spect_id_#
                        </cfif>
                        AND IN_OUT = 0
                    GROUP BY
                        SERIAL_NO
                </cfquery>
                <cfif get_seri_kontrol_satis.recordCount eq 0>
                    <cfset kontrol_satis_quantity = 0>
                <cfelse>
                    <cfset kontrol_satis_quantity = get_seri_kontrol_satis.UNIT_ROW_QUANTITY>
                </cfif>
                <cfif get_rows2.recordCount eq 0>
                    <cfset get_rows2_quantity = 0>
                    <cfset get_rows2.UNIT_ROW_QUANTITY = 0>
                <cfelse>
                    <cfset get_rows2_quantity = get_rows2.UNIT_ROW_QUANTITY>
                </cfif>
                <cfset row_amount = ( get_old_rows.recordcount ) ? get_old_rows.QUANTITY : 0 >
                <cfset totalUnitQuantity = get_seri_kontrol_alis.UNIT_ROW_QUANTITY - get_rows2_quantity />
                <cfset attributes.quantity = totalUnitQuantity - ((totalUnitQuantity gt row_amount ) ? totalUnitQuantity - row_amount : 0) >
                <cfset attributes.row_lot_no1 = get_seri_kontrol_alis.LOT_NO>
                <!--- <cfdump var="#attributes.quantity#" abort> --->
                <cfif kontrol_satis_quantity - get_rows2_quantity lte 0>
                    <script>
                        alert('Yeterli Miktarda Satışta Olmayan Seri No Çıkış Yapmaya Çalıştınız!');
                    </script>
                <cfelse> 
                    <cfquery name="GET_ALL_SERIES_CONTROL" datasource="#DSN3#">
                        SELECT
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            SG.PROCESS_ID = #attributes.process_id# AND
                            SG.PROCESS_CAT = #attributes.process_cat# AND
                            SG.PERIOD_ID = #session_base.period_id# AND
                            SG.STOCK_ID = #islem_stock_id_#
                            <cfif len(islem_spect_id_)>
                                AND SG.SPECT_ID = #islem_spect_id_#
                            </cfif>
                    </cfquery>
                    <cfquery name="GET_OLD_CONTROL" datasource="#DSN3#">
                        SELECT
                            SUM(SHIP_ROW.AMOUNT) QUANTITY
                        FROM
                            #dsn2_alias#.SHIP SHIP,
                            #dsn2_alias#.SHIP_ROW SHIP_ROW
                        WHERE
                            SHIP.SHIP_ID = #attributes.process_id# AND
                            SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                            SHIP_ROW.STOCK_ID = #islem_stock_id_#
                            <cfif len(islem_spect_id_)>
                                AND SHIP_ROW.SPECT_VAR_ID = #islem_spect_id_#
                            </cfif>
                    </cfquery>	
                    <cfif len(GET_OLD_CONTROL.QUANTITY) and GET_ALL_SERIES_CONTROL.recordcount gte GET_OLD_CONTROL.QUANTITY>
                        <script>
                            alert('Bu Ürün İçin Seri Adedi Tamamlanmıştır!');
                        </script>
                        <cfabort>
                    </cfif>				
                    <cfset attributes.guaranty_cat1 = get_seri_kontrol_alis.PURCHASE_GUARANTY_CATID>
                    <cfset attributes.guaranty_startdate1 = dateformat(get_old_rows.DELIVER_DATE,dateformat_style)>
                    <cfset attributes.stock_id1 = islem_stock_id_>
                    <cfset attributes.spect_id = islem_spect_id_>
                    <cfset attributes.serial_no_start_number1 = attributes.SERIAL_NO>
                    <cfset attributes.guaranty_purchasesales1 = 1>
                    <cfscript>
                        if( listfindnocase('81,811',attributes.process_cat,',') ){ 
                            add_serial_no(
                                            session_row : 1,
                                            process_type : attributes.process_cat, 
                                            process_number : get_old_rows.SHIP_NUMBER,
                                            process_id : attributes.process_id,
                                            dpt_id : get_old_rows.DEPARTMENT_OUT,
                                            loc_id : get_old_rows.LOCATION_OUT,
                                            par_id : get_old_rows.partner_id,
                                            con_id : get_old_rows.consumer_id,
                                            main_stock_id : '',
                                            spect_id : attributes.spect_id,
                                            comp_id : get_old_rows.company_id,
                                            is_in_out : 0,
                                            unit_row_quantity : (isDefined("attributes.add_new_serial_no_amount") and len(attributes.add_new_serial_no_amount)) ? attributes.add_new_serial_no_amount : attributes.quantity
                                        );
                            add_serial_no(
                                            session_row : 1,
                                            process_type : attributes.process_cat, 
                                            process_number : get_old_rows.SHIP_NUMBER,
                                            process_id : attributes.process_id,
                                            dpt_id : get_old_rows.DEPARTMENT_IN,
                                            loc_id : get_old_rows.LOCATION_IN,
                                            par_id : get_old_rows.partner_id,
                                            con_id : get_old_rows.consumer_id,
                                            main_stock_id : '',
                                            spect_id : attributes.spect_id,
                                            comp_id : get_old_rows.company_id,
                                            is_in_out : 1,
                                            unit_row_quantity : (isDefined("attributes.add_new_serial_no_amount") and len(attributes.add_new_serial_no_amount)) ? attributes.add_new_serial_no_amount : attributes.quantity
                                        );
    
                        }else{
                            add_serial_no(
                                            session_row : 1,
                                            process_type : attributes.process_cat, 
                                            process_number : get_old_rows.SHIP_NUMBER,
                                            process_id : attributes.process_id,
                                            dpt_id : get_old_rows.DEPARTMENT_IN,
                                            loc_id : get_old_rows.LOCATION_IN,
                                            par_id : get_old_rows.partner_id,
                                            con_id : get_old_rows.consumer_id,
                                            main_stock_id : '',
                                            spect_id : attributes.spect_id,
                                            comp_id : get_old_rows.company_id,
                                            unit_row_quantity : (isDefined("attributes.add_new_serial_no_amount") and len(attributes.add_new_serial_no_amount)) ? attributes.add_new_serial_no_amount : attributes.quantity
                                        );
                        }
    
                    </cfscript>
                    <cfquery name="GET_ALL_SERIES" datasource="#DSN3#">
                        SELECT
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            SG.PROCESS_ID = #attributes.process_id# AND
                            SG.PROCESS_CAT = #attributes.process_cat# AND
                            SG.PERIOD_ID = #session_base.period_id# AND
                            SG.STOCK_ID = #islem_stock_id_#
                            <cfif len(islem_spect_id_)>
                                AND SG.SPECT_ID = #islem_spect_id_#
                            </cfif>
                    </cfquery>
                    <script>
                        <cfoutput>
                            total_record_ = document.getElementById('serial_no_amount_#islem_stock_id_#<cfif len(islem_spect_id_)>_#islem_spect_id_#</cfif>').innerHTML;		
                            total_record_ = parseInt(total_record_);
                            
                            serial_record_ = parseInt(#GET_ALL_SERIES.recordcount#);
                            
                            fark_ = total_record_ - serial_record_;
                            
                            document.getElementById('serial_no_record_#islem_stock_id_#<cfif len(islem_spect_id_)>_#islem_spect_id_#</cfif>').innerHTML = serial_record_;
                            document.getElementById('serial_no_fark_#islem_stock_id_#<cfif len(islem_spect_id_)>_#islem_spect_id_#</cfif>').innerHTML = fark_;
                            
                            document.getElementById('serial_no_list_#islem_stock_id_#<cfif len(islem_spect_id_)>_#islem_spect_id_#</cfif>').innerHTML = '#valuelist(GET_ALL_SERIES.SERIAL_NO,"<br />")#';			
                        </cfoutput>
                    </script>
                    <cfif isdefined("serial_operation_warning") and listlen(serial_operation_warning)>
                        <cfquery name="get_emails" datasource="#dsn#">
                            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> '' AND POSITION_CODE IN (#serial_operation_warning#)
                        </cfquery>
                        <cfquery datasource="#dsn#" name="get_sender_mail">
                            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid# AND EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> ''
                        </cfquery>
                    
                        <cfif get_emails.recordcount and get_sender_mail.recordcount>
                            <cfoutput query="get_emails">
                                <cfset attributes.mail_content_to = get_emails.EMPLOYEE_EMAIL>
                                <cfset attributes.mail_content_from = get_sender_mail.EMPLOYEE_EMAIL>
                                <cfset attributes.mail_content_subject = "Seri No İşlem Ekranı">
                                <cfset attributes.mail_record_emp = "#get_sender_mail.EMPLOYEE_NAME# #get_sender_mail.EMPLOYEE_SURNAME#">
                                <cfset attributes.mail_content_additor = "#get_emails.EMPLOYEE_NAME# #get_emails.EMPLOYEE_SURNAME#">
                                <cfset attributes.mail_record_date= DateFormat(date_add('h',2,now()), dateformat_style) & " " & TimeFormat(date_add('h',2,now()), timeformat_style)>
                                <cfsavecontent variable="attributes.mail_content_info"><cf_get_lang_main no='1745.bilgilendirme'></cfsavecontent>
                                <cfset attributes.mail_content_link = '#user_domain##request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#attributes.process_id#'>
                                <cfinclude template="../../documents/templates/info_mail/mail_content.cfm">
                            </cfoutput>
                        </cfif>
                    </cfif>
                    <script>
                        window.location.reload()
                    </script>
                </cfif>
            <cfelse>
                <script>
                    alert('Alışı Olmayan Seri No Çıkış Yapmaya Çalıştınız veya Spect Farklılıkları Var!');
                </script>
            </cfif>
        </cfif>
    
    <cfelseif attributes.action_type is 'multi_add'>
        <cfif isdefined("attributes.GUARANTY_IDS") and listlen(attributes.GUARANTY_IDS)>
            <cfif isdefined("attributes.process_cat") and attributes.process_cat eq 171>
                <cfif isdefined("attributes.amount") and listlen(attributes.GUARANTY_IDS) gt attributes.amount>
                    <script>
                        alert('Fazla Seri No Seçtiniz!\nGirilebilecek Seri No Sayısı : <cfoutput>#attributes.amount#</cfoutput>');
                        history.back();
                    </script>
                <cfelse>
                     <cfquery name="set_relation" datasource="#dsn3#">
                        UPDATE
                            SERVICE_GUARANTY_NEW
                        SET
                            MAIN_PROCESS_ID = #attributes.main_process_id#,
                            MAIN_PROCESS_NO = '#attributes.main_process_no#',
                            MAIN_PROCESS_TYPE = #attributes.main_process_cat#,
                            MAIN_SERIAL_NO = '#attributes.main_serial_no#',
                            <cfif len(attributes.spect_id)>SPECT_ID = #attributes.spect_id#,</cfif>
                            UPDATE_DATE = #NOW()#,
                            UPDATE_EMP = #session.ep.userid#
                        WHERE 
                            GUARANTY_ID IN (#attributes.GUARANTY_IDS#)
                    </cfquery>
                    <cfquery name="GET_ALL_SERIES" datasource="#DSN3#">
                        SELECT
                            SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW
                        WHERE
                            PROCESS_ID = #attributes.process_id# AND
                            PROCESS_CAT = #attributes.process_cat# AND
                            PERIOD_ID = #session_base.period_id# AND
                            STOCK_ID = #attributes.stock_id# AND
                            SPECT_ID = #attributes.spect_id# AND
                            MAIN_PROCESS_ID = #attributes.main_process_id# AND
                            MAIN_PROCESS_TYPE = #attributes.main_process_cat# AND
                            MAIN_SERIAL_NO = '#attributes.main_serial_no#'
                    </cfquery>
                    <cfif not isdefined("attributes.noreload")>
                        <script>
                            history.back();
                            //window.close();
                        </script>
                    </cfif>
                <cfabort>
                </cfif>
            <cfelse>
                <cfif isdefined("attributes.process_cat") and attributes.process_cat eq 116>
                    <cfif (isdefined("attributes.process_id") and attributes.process_id neq 0) and (not isdefined("attributes.is_change"))>
                        <cfquery name="GET_OLD_CONTROL" datasource="#DSN3#">
                            SELECT
                                EXIT_AMOUNT QUANTITY
                            FROM
                                #dsn2_alias#.STOCK_EXCHANGE
                            WHERE
                                STOCK_EXCHANGE_ID = #attributes.process_id# AND
                                EXIT_STOCK_ID = #attributes.stock_id#
                        </cfquery>
                    <cfelse>
                        <cfset GET_OLD_CONTROL.QUANTITY = attributes.amount>
                    </cfif>
                <cfelse>
                    <cfquery name="GET_OLD_CONTROL" datasource="#DSN3#">
                        SELECT
                            SUM(SHIP_ROW.AMOUNT) QUANTITY
                        FROM
                            #dsn2_alias#.SHIP SHIP,
                            #dsn2_alias#.SHIP_ROW SHIP_ROW
                        WHERE
                            SHIP.SHIP_ID = #attributes.process_id# AND
                            SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                            SHIP_ROW.STOCK_ID = #attributes.stock_id#
                            <cfif len(attributes.spect_id)>
                                AND SHIP_ROW.SPECT_VAR_ID = #attributes.spect_id#
                            </cfif>
                    </cfquery>
                </cfif>
                <cfif isdefined("attributes.process_id") and attributes.process_id neq 0>
                    <cfquery name="GET_ALL_SERIES_CONTROL" datasource="#DSN3#">
                        SELECT
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            SG.PROCESS_ID = #attributes.process_id# AND
                            SG.PROCESS_CAT = #attributes.process_cat# AND
                            SG.PERIOD_ID = #session_base.period_id# AND
                            SG.STOCK_ID = #attributes.stock_id#
                            <cfif attributes.process_cat eq 116>
                                AND SG.IN_OUT = 0
                            </cfif>
                            <cfif len(attributes.spect_id)>
                                AND SG.SPECT_ID = #attributes.spect_id#
                            </cfif>
                    </cfquery>
                <cfelse>
                    <cfset GET_ALL_SERIES_CONTROL.recordcount = 0>
                </cfif>
                <cfif listlen(attributes.GUARANTY_IDS) gt (GET_OLD_CONTROL.QUANTITY - GET_ALL_SERIES_CONTROL.recordcount) and isdefined("attributes.process_id") and attributes.process_id neq 0>
                    <script>
                        alert('Fazla Seri No Seçtiniz!\nGirilebilecek Seri No Sayısı : <cfoutput>#GET_OLD_CONTROL.QUANTITY - GET_ALL_SERIES_CONTROL.recordcount#</cfoutput>');
                        history.back();
                    </script>
                    <cfabort>
                <cfelse>
                    <cfquery name="GET_SHIP_ROW_AMOUNT" datasource="#DSN3#">
                        SELECT
                            ISNULL(SHIP_ROW.AMOUNT,0) AS QUANTITY
                        FROM
                            #dsn2_alias#.SHIP SHIP,
                            #dsn2_alias#.SHIP_ROW SHIP_ROW
                        WHERE
                            SHIP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                            SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                            SHIP_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                            <cfif len(attributes.spect_id)>
                                AND SHIP_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#">
                            </cfif>
                    </cfquery>
                    <cfset row_amount = ( GET_SHIP_ROW_AMOUNT.recordcount ) ? GET_SHIP_ROW_AMOUNT.QUANTITY : 0 >
                    <cfset remaining_amount = listToArray( attributes.remaining_amount, "," ) />
                    <cfloop list="#attributes.GUARANTY_IDS#" index="my_guaranty_id">
                        <cfquery name="get_seri_kontrol_alis" datasource="#dsn3#">
                            SELECT TOP 1
                                GUARANTY_ID,
                                DEPARTMENT_ID,
                                LOCATION_ID,
                                STOCK_ID,
                                SPECT_ID,
                                PURCHASE_GUARANTY_CATID,
                                SERIAL_NO,
                                LOT_NO,
                                UNIT_ROW_QUANTITY,
                                PROCESS_CAT
                            FROM 
                                SERVICE_GUARANTY_NEW
                            WHERE 
                                GUARANTY_ID = #my_guaranty_id#
                                AND IN_OUT = 1
                        </cfquery>
                        <!--- <cfquery name="get_rows2" datasource="#dsn3#">
                            SELECT
                                ISNULL(SUM(UNIT_ROW_QUANTITY),0) AS UNIT_ROW_QUANTITY
                            FROM
                                SERVICE_GUARANTY_NEW
                            WHERE
                                STOCK_ID = #attributes.stock_id#
                                AND IN_OUT = 0
                                AND SERIAL_NO = '#get_seri_kontrol_alis.SERIAL_NO#'
                                AND PROCESS_CAT <> #get_seri_kontrol_alis.PROCESS_CAT#
                        </cfquery>
                        <cfset totalUnitQuantity = get_seri_kontrol_alis.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY />
                        <cfset attributes.quantity = totalUnitQuantity - ((totalUnitQuantity gt row_amount ) ? totalUnitQuantity - row_amount : 0) >
                        <cfset attributes.quantity = get_seri_kontrol_alis.UNIT_ROW_QUANTITY />
                        <cfset row_amount -= attributes.quantity /> --->
                        <cfset attributes.quantity = remaining_amount[listFind(attributes.GUARANTY_IDS, my_guaranty_id)] />
                        <cfif isdefined("attributes.process_id") and attributes.process_id neq 0>
                            <cfif isdefined("attributes.process_cat") and attributes.process_cat eq 116>
                                <cfquery name="get_old_rows" datasource="#dsn3#">
                                    SELECT
                                       PROCESS_DATE AS DELIVER_DATE,
                                       EXCHANGE_NUMBER AS SHIP_NUMBER,
                                       EXIT_DEPARTMENT_ID DEPARTMENT_IN,
                                       EXIT_LOCATION_ID LOCATION_IN,
                                       '' AS COMPANY_ID,
                                       '' AS CONSUMER_ID,
                                       '' AS PARTNER_ID
                                    FROM
                                        #dsn2_alias#.STOCK_EXCHANGE
                                    WHERE
                                        STOCK_EXCHANGE_ID = #attributes.process_id# AND
                                        EXIT_STOCK_ID = #attributes.stock_id#
                                </cfquery>
                            <cfelse>
                                <cfquery name="get_old_rows" datasource="#dsn3#">
                                    SELECT
                                        SHIP.DELIVER_DATE,
                                        SHIP.SHIP_NUMBER,
                                        ISNULL(SHIP.DEPARTMENT_IN,DELIVER_STORE_ID) DEPARTMENT_IN,
                                        ISNULL(SHIP.LOCATION_IN,LOCATION) LOCATION_IN,
                                        <cfif listfindnocase('81,811',attributes.process_cat,',')>  
                                        SHIP.DELIVER_STORE_ID DEPARTMENT_OUT,
                                        SHIP.LOCATION LOCATION_OUT,
                                        ISNULL(SHIP.LOCATION_IN,LOCATION) LOCATION_OUT,
                                        </cfif>
                                        SHIP.PARTNER_ID,
                                        SHIP.CONSUMER_ID,
                                        SHIP.COMPANY_ID
                                    FROM
                                        #dsn2_alias#.SHIP SHIP
                                    WHERE
                                        SHIP.SHIP_ID = #attributes.process_id#
                                </cfquery>
                            </cfif>
                            <cfset attributes.guaranty_cat1 = get_seri_kontrol_alis.PURCHASE_GUARANTY_CATID>
                            <cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>
                            <cfset attributes.row_lot_no1 = get_seri_kontrol_alis.LOT_NO>
                            </cfif>
                            <cfset attributes.guaranty_startdate1 = dateformat(get_old_rows.DELIVER_DATE,dateformat_style)>
                            <cfset attributes.stock_id1 = attributes.stock_id>
                            <cfset attributes.spect_id = attributes.spect_id>
                            <cfset attributes.serial_no_start_number1 = get_seri_kontrol_alis.SERIAL_NO>
                            <cfset attributes.guaranty_purchasesales1 = 1>
                            <cfif isdefined("attributes.process_number") and len(attributes.process_number)>
                                <cfset process_no_ = attributes.process_number>
                            <cfelse>
                                <cfset process_no_ = get_old_rows.SHIP_NUMBER>
                            </cfif>
                            <!--- sevk irsaliyesi ise çıkış yaptığı seriyi giriş tarafına aktaracağız --->
                            <cfif listfindnocase('81,811',attributes.process_cat,',')>  
                                <cfscript>
                                add_serial_no(
                                                session_row : 1,
                                                process_type : attributes.process_cat, 
                                                process_number : process_no_,
                                                process_id : attributes.process_id,
                                                dpt_id : get_old_rows.DEPARTMENT_OUT,
                                                loc_id : get_old_rows.LOCATION_OUT,
                                                par_id : get_old_rows.partner_id,
                                                con_id : get_old_rows.consumer_id,
                                                main_stock_id : '',
                                                spect_id : attributes.spect_id,
                                                comp_id : get_old_rows.company_id,
                                                is_in_out : 0,
                                                unit_row_quantity : attributes.quantity);
                                add_serial_no(
                                                session_row : 1,
                                                process_type : attributes.process_cat, 
                                                process_number : process_no_,
                                                process_id : attributes.process_id,
                                                dpt_id : get_old_rows.DEPARTMENT_IN,
                                                loc_id : get_old_rows.LOCATION_IN,
                                                par_id : get_old_rows.partner_id,
                                                con_id : get_old_rows.consumer_id,
                                                main_stock_id : '',
                                                spect_id : attributes.spect_id,
                                                comp_id : get_old_rows.company_id,
                                                is_in_out : 1,
                                                unit_row_quantity : attributes.quantity);
                                </cfscript>
                            <cfelse>
                                <cfscript>
                                add_serial_no(
                                                session_row : 1,
                                                process_type : attributes.process_cat, 
                                                process_number : process_no_,
                                                process_id : attributes.process_id,
                                                dpt_id : get_old_rows.DEPARTMENT_IN,
                                                loc_id : get_old_rows.LOCATION_IN,
                                                par_id : get_old_rows.partner_id,
                                                con_id : get_old_rows.consumer_id,
                                                //main_stock_id : attributes.stock_id1,
                                                main_stock_id : '',
                                                spect_id : attributes.spect_id,
                                                comp_id : get_old_rows.company_id,
                                                is_in_out : 0,
                                                unit_row_quantity : attributes.quantity);
                                </cfscript>
                            </cfif>
                        <cfelse>
                            <cfset attributes.guaranty_cat1 = get_seri_kontrol_alis.PURCHASE_GUARANTY_CATID>
                            <cfset attributes.stock_id1 = attributes.stock_id>
                            <cfset attributes.spect_id = attributes.spect_id>
                            <cfset attributes.serial_no_start_number1 = get_seri_kontrol_alis.SERIAL_NO>
                            <cfset attributes.guaranty_purchasesales1 = 1>
                            <cfscript>
                                add_serial_no
                                (
                                session_row : 1,
                                process_type : attributes.process_cat, 
                                process_number : attributes.process_number,
                                process_id : attributes.process_id,
                                wrk_row_id : attributes.wrk_row_id,
                                //main_stock_id : attributes.stock_id1,
                                main_stock_id : '',
                                spect_id : attributes.spect_id,
                                is_in_out : 0,
                                unit_row_quantity : attributes.quantity
                                )
                                ;
                            </cfscript>
                           </cfif>
                    </cfloop>
                    <cfif isdefined("serial_operation_warning") and listlen(serial_operation_warning)>
                        <cfquery name="get_emails" datasource="#dsn#">
                            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> '' AND POSITION_CODE IN (#serial_operation_warning#)
                        </cfquery>
                        <cfquery datasource="#dsn#" name="get_sender_mail">
                            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid# AND EMPLOYEE_EMAIL IS NOT NULL AND EMPLOYEE_EMAIL <> ''
                        </cfquery>
                    
                        <cfif get_emails.recordcount and get_sender_mail.recordcount>
                            <cfoutput query="get_emails">
                                <cfset attributes.mail_content_to = get_emails.EMPLOYEE_EMAIL>
                                <cfset attributes.mail_content_from = get_sender_mail.EMPLOYEE_EMAIL>
                                <cfset attributes.mail_content_subject = "Seri No İşlem Ekranı">
                                <cfset attributes.mail_content_additor = "#get_emails.EMPLOYEE_NAME# #get_emails.EMPLOYEE_SURNAME#">
                                <cfset attributes.mail_record_emp = "#get_sender_mail.EMPLOYEE_NAME# #get_sender_mail.EMPLOYEE_SURNAME#">
                                <cfset attributes.mail_record_date= DateFormat(date_add('h',2,now()), dateformat_style) & " " & TimeFormat(date_add('h',2,now()), timeformat_style)>
                                <cfsavecontent variable="attributes.mail_content_info"><cf_get_lang_main no='1745.bilgilendirme'></cfsavecontent>
                                <cfset attributes.mail_content_link = '#user_domain##request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#attributes.process_id#'>
                                <cfinclude template="../../design/template/info_mail/mail_content.cfm">
                            </cfoutput>
                        </cfif>
                    </cfif>
                    <!--- <cfdump var="#attrib#"> --->
                        <script>
                            window.location.href = '<cfoutput>#cgi.HTTP_REFERER#</cfoutput>';
                        </script>
                    <cfabort>
                </cfif>
            </cfif>
        <cfelse>
            <script>
                alert('Hiçbir Seri No Seçmediniz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfabort>
    