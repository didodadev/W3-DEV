<cfcomponent extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>    
    <cfset file_web_path = application.systemParam.systemParam().file_web_path>
    
    
    <cffunction name="invoice_pdf" access="remote" returntype="string" returnFormat="json">
        <cfset result = StructNew()> 
        <!--- Klasor Konrolu BEGIN --->       
            <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="folders">
            <cfquery dbtype="query" name="find_folder">
                SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = '#arguments.source#'
            </cfquery>
            <cfif find_folder.RecordCount neq 1>
                <cfdirectory action="create" directory="#upload_folder#reserve_files/#arguments.source#" name="create_folder">
            </cfif>
        <!--- Klasor Konrolu END --->    
        <cftry>
            <cfset result.status = true>
            <cfset result.invoice = #arguments.ID#>
            <cfquery name="GET_MODULE_ID" datasource="#DSN#">
                SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'invoice'
            </cfquery>

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

            <cfset attributes.iid = #arguments.id#>

            <cfset url.iid = #arguments.id#>

            <cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
                SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #ATTRIBUTES.IID#
            </cfquery>
            
            <cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
                <cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
            <cfelse>
                <cfset PRINT_COUNT = 1>
            </cfif>	

            <cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
                UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT# WHERE INVOICE_ID = #ATTRIBUTES.IID#
            </cfquery>

            <cfquery name="get_file_name" datasource="#dsn2#">
                SELECT
                    ISNULL(ISNULL('#arguments.pdf_prefix#_' + FORMAT (I.INVOICE_DATE,'ddMMyyyy') + '_' + right ('00000000'+ltrim(str( convert(varchar,SERIAL_NO)  )),8 ) + '_' + ISNULL(right ('000000'+ltrim(  convert(varchar,SC.SUBSCRIPTION_NO) ),6 ) ,'000000'),convert(varchar,INVOICE_NUMBER) + '_INVOICE'),convert(varchar,INVOICE_ID) + '_INVOICE') FILE_NAME
                FROM 
                    INVOICE I
                    LEFT JOIN #DSN3#.SUBSCRIPTION_CONTRACT SC ON SC. SUBSCRIPTION_ID = I.SUBSCRIPTION_ID
                WHERE
                    I.INVOICE_ID = #ATTRIBUTES.IID#
            </cfquery>            
            
            <cfdocument filename="#upload_folder#reserve_files/#arguments.source#/#get_file_name.FILE_NAME#.pdf" format = "PDF" pagetype="A4" orientation="portrait" marginBottom = "0" marginLeft = "0" marginRight = "0" marginTop = "0">
                <cfif get_form.is_standart eq 1>
                    <cfinclude template="/#get_form.template_file#">
                <cfelse>
                    <cfinclude template="#file_web_path#settings/#get_form.template_file#">
                </cfif>
            </cfdocument>
            <cfreturn Replace(serializeJSON(result),'//','')>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
                <cfreturn Replace(serializeJSON(result),'//','')>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="zip_pdf" access="remote" returntype="string" returnFormat="json">
        <cfset result = StructNew()> 
        <cfset result.status = true>
         <!--- Zip Konrolu BEGIN --->       
            <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="files">
            <cfquery dbtype="query" name="find_zip">
                SELECT Name FROM files WHERE TYPE='File' AND NAME = '#arguments.source#.zip'
            </cfquery>
            <cfquery dbtype="query" name="find_zip_2">
                SELECT Name FROM files WHERE TYPE='File' AND NAME = '#arguments.source#_copy.zip'
            </cfquery>
            <cfif find_zip.RecordCount eq 1>
                <cfset result.zip_copy = "#file_web_path#reserve_files/#arguments.source#_copy.zip"> 
            </cfif>
            <cfif find_zip_2.RecordCount eq 1>
                <cfset result.zip = "#file_web_path#reserve_files/#arguments.source#.zip"> 
            </cfif>
        <!--- Zip Konrolu END --->    
                <cfif arguments.copy_two eq "true" AND find_zip_2.RecordCount neq 1>
                    <cfdirectory action="list" directory="#upload_folder#reserve_files/#arguments.source#" recurse="false" name="copy_pdf"><!--- Kopyalanacak Pdfler --->
                    <!--- Klasor Konrolu BEGIN --->       
                        <cfdirectory action="list" directory="#upload_folder#reserve_files" recurse="false" name="folders">
                        <cfquery dbtype="query" name="find_folder">
                            SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = '#arguments.source#_copy'
                        </cfquery>
                        <cfif find_folder.RecordCount neq 1>
                            <cfdirectory action="create" directory="#upload_folder#reserve_files/#arguments.source#_copy" name="create_folder"><!--- Kopya Pdf Klasörü --->
                        </cfif>
                    <!--- Klasor Konrolu END --->                      
                    
                    <cfquery dbtype="query" name="copy_pdf_list">
                        SELECT Name FROM copy_pdf WHERE TYPE='File'
                    </cfquery>

                    <cfoutput query="copy_pdf_list"><!--- Oluşan Pdfleri Kopyalar --->
                        <cffile action="copy" source="#upload_folder#reserve_files/#arguments.source#/#Name#" destination="#upload_folder#reserve_files/#arguments.source#_copy\#Name#">
                    </cfoutput>

                    <cfdirectory action="list" directory="#upload_folder#reserve_files/#arguments.source#_copy" recurse="false" name="add_copy_text"><!--- 2. Nüsha Yazısı eklenecekler --->
                    <cfquery dbtype="query" name="add_footer_copy_text">
                        SELECT Name FROM add_copy_text WHERE TYPE='File'
                    </cfquery>
                    <cfoutput query="add_footer_copy_text"><!--- İkinci Nüsha Yazısı Ekleme--->
                        <cfpdf action="addfooter" 
                                source="#upload_folder#reserve_files/#arguments.source#_copy\#Name#"
                                destination = "#upload_folder#reserve_files/#arguments.source#_copy\#Name#"
                                overwrite="yes"
                                bottomMargin="0.5"
                                text="2. Nusha"
                                align="center"
                                opacity="5"
                            />
                            <cfpdf action="addfooter" 
                                source="#upload_folder#reserve_files/#arguments.source#/#Name#"
                                destination = "#upload_folder#reserve_files/#arguments.source#/#Name#"
                                overwrite="yes"
                                bottomMargin="0.5"
                                text="1. Nusha"
                                align="center"
                                opacity="5"
                            />
                    </cfoutput>
                    <cfzip file="#upload_folder#reserve_files/#arguments.source#_copy.zip" source="#upload_folder#reserve_files/#arguments.source#_copy">                
                    <cfset result.zip_copy = "#file_web_path#reserve_files/#arguments.source#_copy.zip"> 
                <cfelseif arguments.copy_two eq "false">
                    <cfset result.zip_copy ="">
                </cfif> 
            <cfif find_zip_2.RecordCount neq 1>
                <cfzip file="#upload_folder#reserve_files/#arguments.source#.zip" source="#upload_folder#reserve_files/#arguments.source#">
                <cfset result.zip = "#file_web_path#reserve_files/#arguments.source#.zip">
            </cfif>
            <cfreturn Replace(serializeJSON(result),'//','')>   
     
    </cffunction>
</cfcomponent>