<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>    
    <cfset file_web_path = application.systemParam.systemParam().file_web_path>
    <cfinclude  template="../../../WMO/functions.cfc">    
    <cffunction name="preview_template" access="remote" returntype="string" returnFormat="plain">
        <cfargument required="false" type="any" name="id" default="">
        <cftry>

            <cfquery name="GET_FORM" datasource="#dsn3#">
                SELECT
                    IS_STANDART,
                    TEMPLATE_FILE,
                    FORM_ID,
                    NAME,
                    PROCESS_TYPE,
                    MODULE_ID
                FROM 
                    SETUP_PRINT_FILES	
                WHERE
                    FORM_ID = #arguments.form_type#
            </cfquery>

            <cfset attributes.ACTION_ID = #arguments.ACTION_ID#>
            <cfset attributes.ID = #arguments.ID#>
            <cfif get_form.recordcount>
                <cfif get_form.is_standart eq 1>
                    <cfinclude template="/#get_form.template_file#">
                <cfelse>
                    <cfinclude template="#file_web_path#settings/#get_form.template_file#">
                </cfif>
            <cfelse>
                <cf_get_lang dictionary_id='57808.Yazıcı Belgeleri Tanımlı Değil'>!
            </cfif>
            <cfcatch type="any">
                <cfdump  var="#cfcatch#">
                <cfreturn 0>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="receiver_emp" access="remote" returntype="any" returnFormat="json" securejson="false"> 
        <cfargument required="false" type="any" name="wo" default="">
        <cfargument required="false" type="any" name="action_id" default="">        
        <cftry>
            <cfswitch expression="#wo#"> 
                <cfcase value="ehesap.hr_offtime_approve">  
                    <cfset result.status = true>
                    <cfquery name="receiver_emp_query" datasource="#dsn#">
                        SELECT 
                            TOP 1 
                            EOC.EMPLOYEE_ID AS RECEIVER_EMPID,
                            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS RECEIVER_EMP
                        FROM
                            EMPLOYEES_OFFTIME_CONTRACT EOC
                            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EOC.EMPLOYEE_ID
                        WHERE
                            EOC.EMPLOYEES_OFFTIME_CONTRACT_ID = <cfqueryparam value="#action_id#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset result.data = this.returnData(replace(serializeJSON(receiver_emp_query),"//",""))>
                </cfcase>
                <cfdefaultcase>
                    <cfset result.status = false>                    
                </cfdefaultcase> 
            </cfswitch>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.message = #cfcatch#>
            </cfcatch>
        </cftry>
        <cfreturn result>
    </cffunction>
    <cffunction name="runJob" access="remote" returntype="string" returnFormat="json">
        <cfargument required="true" type="any" name="receiver" default="" hint="alıcı id">
        <cfargument required="false" type="any" name="sender" default="" hint="gönderici id">
        <cfargument required="true" type="any" name="folder_prefix" default="" hint="her istekte yenilenen klasor uniq degeri">
        <cfargument required="true" type="any" name="file_prefix" default="" hint="belge ön eki">
        <cfargument required="true" type="any" name="file_name" default="" hint="belge adı">        
        <cfargument required="true" type="any" name="form_type" default="" hint="baskı şablonu id">  
        <cfargument required="true" type="any" name="id" default="" hint="belge id">
        <cfargument required="true" type="any" name="send_mail" default="" hint="mail gönderimi yapılsınmı">
        <cfargument required="true" type="any" name="wo" default="" hint="wo ya göre tabloda is_mail güncellemesi yapılıyor">
        <cfargument required="true" type="any" name="mail_note" default="" hint="mail gönder olarak işaretliyse bu notu maile ekler">
        <cfset result.status = true>
        <cfset result.id = #id#>
        <cftry>            
            <!--- Klasor Konrolu--->       
            <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="folders">
            <cfquery dbtype="query" name="find_folder">
                SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = '#file_prefix#_#folder_prefix#'
            </cfquery>
            <cfif find_folder.RecordCount neq 1>
                <cfdirectory action="create" directory="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#" name="create_folder">
            </cfif>

            <!--- SABLON--->  
            <cfquery name="GET_FORM" datasource="#dsn3#">
                SELECT
                    IS_STANDART,
                    TEMPLATE_FILE,
                    FORM_ID,
                    NAME,
                    PROCESS_TYPE,
                    MODULE_ID
                FROM 
                    SETUP_PRINT_FILES	
                WHERE
                    FORM_ID = #form_type#
            </cfquery>

            <!--- SABLONLARDA KULLANILAN DEGERLER --->
            <cfset attributes.iid = #id#> 
            <cfset attributes.id = #id#>
            <cfset attributes.action_id = #id#>

            <!--- PDF OLUSTUR --->
            <cfdocument filename="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#/#file_name#.pdf" format = "PDF" pagetype="A4" orientation="portrait" marginBottom = "0" marginLeft = "0" marginRight = "0" marginTop = "0">
                <cfif get_form.is_standart eq 1>
                    <cfinclude template="/#get_form.template_file#">
                <cfelse>
                    <cfinclude template="#file_web_path#settings/#get_form.template_file#">
                </cfif>
            </cfdocument> 

            <cfif send_mail eq "true">
            <!--- ALICI BILGISI --->
                <cfquery name="receiver_det" datasource="#dsn#">
                    SELECT 
                        TOP 1 
                        EMPLOYEE_EMAIL AS RECEIVER_MAIL,
                        EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS RECEIVER_NAME
                    FROM
                        EMPLOYEES
                    WHERE
                    EMPLOYEE_ID = <cfqueryparam value="#receiver#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfif len(sender)>                    
                    <cfquery name="sender_det" datasource="#dsn#">
                        SELECT 
                            TOP 1 
                            EMPLOYEE_EMAIL AS SENDER_MAIL,
                            EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS SENDER_NAME
                        FROM
                            EMPLOYEES
                        WHERE
                        EMPLOYEE_ID = <cfqueryparam value="#sender#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset sender_name = sender_det.SENDER_NAME>
                    <cfset sender_mail = sender_det.SENDER_MAIL>
                <cfelse>
                    <cfset sender_name = session.ep.company>
                    <cfset sender_mail = session.ep.company_email>
                </cfif>
                <cfset mail_note_compiler = replace(mail_note,"[receiver]",receiver_det.RECEIVER_NAME,"all")>
                <cfset mail_note_compiler = replace(mail_note_compiler,"[file]",file_name,"all")>
                <cfset mail_note_compiler = replace(mail_note_compiler,"[sender]",sender_name,"all")>
                <cfset mail_note_compiler = REReplace(mail_note_compiler, "\r\n|\n\r|\n|\r", "<br />", "all")>                
                <cfmail to="#receiver_det.RECEIVER_NAME# <#sender_mail#>" from="#sender_name# <#sender_mail#>" subject="📢#file_name#" type="html" mimeattach="#upload_folder#reserve_files\#file_prefix#_#folder_prefix#\#file_name#.pdf">
                    <cfif len(mail_note) eq 0>
                    <p>Merhaba <i>#receiver_det.RECEIVER_NAME#</i></p>
                    <p>Sizin için oluşturulmuş dosya ektedir 📌 <b>#file_name#.pdf</b></p><br>
                    <cfelse>
                    #mail_note_compiler#
                    </cfif>
                    <p>Bu mail <b>Workcube Catalyst</b> <i>Çıktı Merkezi</i>nden Gönderilmiştir. </p>                
                </cfmail>
                <cfswitch expression="#wo#"> 
                    <cfcase value="ehesap.hr_offtime_approve">  
                        <cfquery name="upd_is_mail" datasource="#dsn#">
                            UPDATE EMPLOYEES_OFFTIME_CONTRACT SET IS_MAIL = 1 WHERE EMPLOYEES_OFFTIME_CONTRACT_ID =  <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
                        </cfquery>
                    </cfcase>
                </cfswitch>
            </cfif> 
            <cfreturn Replace(serializeJSON(result),'//','')>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
                <cfreturn Replace(serializeJSON(result),'//','')>
            </cfcatch>
        </cftry>
        <cfdump  var="#receiver_det#">
    </cffunction>
    <cffunction name="zip_pdf" access="remote" returntype="string" returnFormat="json">
        <cfargument required="true" type="any" name="folder_prefix" default="" hint="her istekte yenilenen klasor uniq degeri">
        <cfargument required="true" type="any" name="file_prefix" default="" hint="belge ön eki">
        <cfargument required="true" type="any" name="copy_two" default="" hint="2 nüsha oluşturur sayfa sonlarına 1. ve 2. nüsha yazar.">

        <cfset result = StructNew()> 
        <cfset result.status = true>
         <!--- Zip Konrolu BEGIN --->       
            <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="files">
            <cfquery dbtype="query" name="find_zip">
                SELECT Name FROM files WHERE TYPE='File' AND NAME = '#file_prefix#_#folder_prefix#.zip'
            </cfquery>
            <cfquery dbtype="query" name="find_zip_2">
                SELECT Name FROM files WHERE TYPE='File' AND NAME = '#file_prefix#_#folder_prefix#_copy.zip'
            </cfquery>
            <cfif find_zip.RecordCount eq 1>
                <cfset result.zip_copy = "#file_web_path#reserve_files/#file_prefix#_#folder_prefix#_copy.zip"> 
            </cfif>
            <cfif find_zip_2.RecordCount eq 1>
                <cfset result.zip = "#file_web_path#reserve_files/#file_prefix#_#folder_prefix#.zip"> 
            </cfif>
        <!--- Zip Konrolu END --->    
                <cfif copy_two eq "true" AND find_zip_2.RecordCount neq 1>
                    <cfdirectory action="list" directory="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#" recurse="false" name="copy_pdf"><!--- Kopyalanacak Pdfler --->
                    <!--- Klasor Konrolu BEGIN --->       
                        <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="folders">
                        <cfquery dbtype="query" name="find_folder">
                            SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = '#file_prefix#_#folder_prefix#_copy'
                        </cfquery>
                        <cfif find_folder.RecordCount neq 1>
                            <cfdirectory action="create" directory="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy" name="create_folder"><!--- Kopya Pdf Klasörü --->
                        </cfif>
                    <!--- Klasor Konrolu END --->                      
                    
                    <cfquery dbtype="query" name="copy_pdf_list">
                        SELECT Name FROM copy_pdf WHERE TYPE='File'
                    </cfquery>

                    <cfoutput query="copy_pdf_list"><!--- Oluşan Pdfleri Kopyalar --->
                        <cffile action="copy" source="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#/#Name#" destination="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy/#Name#">
                    </cfoutput>

                    <cfdirectory action="list" directory="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy" recurse="false" name="add_copy_text"><!--- 2. Nüsha Yazısı eklenecekler --->
                    <cfquery dbtype="query" name="add_footer_copy_text">
                        SELECT Name FROM add_copy_text WHERE TYPE='File'
                    </cfquery>
                    <cfoutput query="add_footer_copy_text"><!--- İkinci Nüsha Yazısı Ekleme--->
                        <cfpdf action="addfooter" 
                                source="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy\#Name#"
                                destination = "#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy\#Name#"
                                overwrite="yes"
                                bottomMargin="0.5"
                                text="2. Nusha"
                                align="center"
                                opacity="5"
                            />
                            <cfpdf action="addfooter" 
                                source="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#/#Name#"
                                destination = "#upload_folder#reserve_files/#file_prefix#_#folder_prefix#/#Name#"
                                overwrite="yes"
                                bottomMargin="0.5"
                                text="1. Nusha"
                                align="center"
                                opacity="5"
                            />
                    </cfoutput>
                    <cfzip file="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy.zip" source="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#_copy">                
                    <cfset result.zip_copy = "#file_web_path#reserve_files/#file_prefix#_#folder_prefix#_copy.zip"> 
                <cfelseif copy_two eq "false">
                    <cfset result.zip_copy ="">
                </cfif> 
            <cfif find_zip_2.RecordCount neq 1>
                <cfzip file="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#.zip" source="#upload_folder#reserve_files/#file_prefix#_#folder_prefix#">
                <cfset result.zip = "#file_web_path#reserve_files/#file_prefix#_#folder_prefix#.zip">
            </cfif>
            <cfreturn Replace(serializeJSON(result),'//','')>  
     
    </cffunction>
</cfcomponent>