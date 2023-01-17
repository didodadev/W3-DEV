<cfif not DirectoryExists("#upload_folder#settings#dir_seperator#")>

    <cfdirectory action="create" directory="#upload_folder#settings#dir_seperator#">

</cfif>
<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
<cftry>
    
    <cffile action = "upload" 
            filefield = "uploaded_file" 
            destination = "#upload_folder_#"
            nameconflict = "MakeUnique"  
            mode="777" charset="utf-8">
    <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
    <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
    <cfset file_size = cffile.filesize>
    <cfcatch type="Any">
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
            history.back();
        </script>
        <cfabort>
    </cfcatch>  
</cftry>

<cftry>
    <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
    <cffile action="delete" file="#upload_folder_##file_name#">
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
</cftry>

<cfscript>
    CRLF = Chr(13) & Chr(10);// satır atlama karakteri
    dosya = Replace(dosya,';;','; ;','all');
    dosya = Replace(dosya,';;','; ;','all');
    dosya = ListToArray(dosya,CRLF);
    line_count = ArrayLen(dosya);
</cfscript>

<cfloop from="2" to="#line_count#" index="i">
    <cfset kont=1>
    <cftry>
        <cfset complaint_id = trim(listgetat(dosya[i],1,';'))>
        <cfset complaint_price = trim(listgetat(dosya[i],2,';'))>
        <cfset price_currency = trim(listgetat(dosya[i],3,';'))>
        <cfset tax_rate = trim(listgetat(dosya[i],4,';'))>
        <cfset discount_rate = trim(listgetat(dosya[i],5,';'))>
        <cfcatch type="Any">
            <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
            <cfset error_flag = 1>
            <script>
                window.location.href="<cfoutput>#request.self#?fuseaction=hr.health_prices_import</cfoutput>";
            </script>
        </cfcatch>
    </cftry>

    <cfquery name="CONTROL_COMPLAINT" datasource=#dsn#>
        SELECT COMPLAINT_ID FROM SETUP_COMPLAINTS WHERE COMPLAINT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#complaint_id#">
    </cfquery>
    <cfif CONTROL_COMPLAINT.recordCount lt 1>
        <script type="text/javascript">
            alert("<cfoutput>#i#</cfoutput>. Satırdaki Tedavi Tipi Bulunamadı, Lütfen Kontrol Ediniz!");
            history.back();
        </script>
        <cfabort>
    </cfif>

    <cftransaction>
        <cftry>
            <!--- Tedavi Fiyat Kontrolü --->
            <cfquery name="CONTROL_COMPLAINT_PRICE" datasource=#dsn#>
                SELECT COMPLAINT_ID FROM COMPLAINT_PRICE WHERE COMPLAINT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#complaint_id#">
            </cfquery>
            <cfif CONTROL_COMPLAINT_PRICE.recordCount>
                <!--- Tedavi Fiyatı Tabloda Varsa Günceller --->
                <cfquery name="upd_commplaint_price" datasource="#dsn#">
                    UPDATE 
                        COMPLAINT_PRICE
                    SET
                        HEALTH_PRICE_PROTOCOL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_protocol#">,
                        COMPLAINT_PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(complaint_price)#">,
                        COMPLAINT_PRICE_MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#price_currency#">,
                        PRICE_START_DATE = <cfqueryparam cfsqltype="timestamp" value="#now()#">,
                        DISCOUNT_RATE = <cfif len(discount_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(discount_rate)#"><cfelse>NULL</cfif>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="timestamp" value="#now()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                        COMPLAINT_TAX_RATE = <cfif len(tax_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(tax_rate)#"><cfelse>NULL</cfif>,
                        PRODUCT_ID = <cfif len(attributes.product_name) and len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
                        COMPANY_ID = <cfif len(attributes.company) and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>
                    WHERE
                        COMPLAINT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#complaint_id#">
                </cfquery>
            <cfelse>
                <!--- Tedavi Fiyatı Tabloda Yoksa Ekler --->
                <cfquery name="add_commplaint_price" datasource="#dsn#">
                    INSERT INTO COMPLAINT_PRICE
                        (
                            COMPLAINT_ID,
                            HEALTH_PRICE_PROTOCOL_ID,
                            COMPLAINT_PRICE,
                            COMPLAINT_PRICE_MONEY,
                            PRICE_START_DATE,
                            DISCOUNT_RATE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            COMPLAINT_TAX_RATE,
                            PRODUCT_ID,
                            COMPANY_ID
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#complaint_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_protocol#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(complaint_price)#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#price_currency#">,
                            <cfqueryparam cfsqltype="timestamp" value="#now()#">,
                            <cfif len(discount_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(discount_rate)#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                            <cfif len(tax_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(tax_rate)#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.product_name) and len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.company) and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfif>
            <cfcatch>
                <cfoutput>
                    #i#. Satırda Sorun Oluştu. 
                </cfoutput>	
                <cfset kont=0>
            </cfcatch>
        </cftry> 
    </cftransaction>
</cfloop>
<cfoutput><cf_get_lang dictionary_id='44145.Aktarım Başarı İle Yapılmıştır'> <br/></cfoutput>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.health_prices_import</cfoutput>";
</script>