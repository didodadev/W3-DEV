<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<!--- aynı hesap numarası ile kayıt yapılabilsin kontrolü--->
<cfset is_account_control = 0>
<cfquery name="xml_property" datasource="#dsn#">
    SELECT 
        PROPERTY_VALUE
    FROM 
        FUSEACTION_PROPERTY
    WHERE 
        PROPERTY_NAME = 'xml_account_control' AND
        FUSEACTION_NAME = 'objects.popup_form_add_bank_cons' AND
        OUR_COMPANY_ID = 1	
</cfquery>

<cfscript>
	if (xml_property.recordcount and len(xml_property.PROPERTY_VALUE))
		is_account_control = xml_property.PROPERTY_VALUE;
	ayirac=';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#',' #ayirac# #ayirac# ','all');
	dosya = Replace(dosya,'#ayirac##ayirac#',' #ayirac# #ayirac# ','all');
	dosya = Replace(dosya,'#ayirac#',' #ayirac# ','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset j = 1>
	<cfset error_flag = 0>
    <cftry>
        <cfscript>
            satir=dosya[i]&'  ;';
			
            sira_no = trim(Listgetat(satir,1,";"));
            calisan_name = trim(Listgetat(satir,2,";"));
            emp_tckimlik_no =trim(Listgetat(satir,3,";"));
            bank_id = trim(Listgetat(satir,4,";"));
            bank_adi = trim(Listgetat(satir,5,";"));
            sube_adi = trim(Listgetat(satir,6,";"));
            sube_kodu = trim(Listgetat(satir,7,";"));
            hesap_no = trim(Listgetat(satir,8,";"));
            para_birimi = trim(Listgetat(satir,9,";"));
            iban_no = trim(Listgetat(satir,10,";"));
            swift_code = trim(Listgetat(satir,11,";"));
            ortak_hesap_ad = trim(Listgetat(satir,12,";"));
            ortak_hesap_soyad = trim(Listgetat(satir,13,";"));
            is_standart = trim(Listgetat(satir,14,";"));
        </cfscript>
        
        <cfif not len(emp_tckimlik_no)>
            <cfoutput>#i#. <cf_get_lang dictionary_id='63356.satırda TC Kimlik No alanını kontrol ediniz.'></cfoutput><br />
            <cfset error_flag = 1>
       	</cfif>
        <cfif  not len(bank_id)>
        	<cfoutput>#i#. <cf_get_lang dictionary_id='63357.satırda Banka IDsi alanını kontrol ediniz.'></cfoutput><br />
            <cfset error_flag = 1>
       	</cfif>
        <cfif not len(is_standart)>
       		<cfoutput>#i#. <cf_get_lang dictionary_id='63358.satırda Banka Hesabını Standart Yap alanını kontrol ediniz.'></cfoutput><br />
            <cfset error_flag = 1>
        </cfif>
        <cfif not len(hesap_no) and not len(iban_no)>
        	<cfoutput>#i#. <cf_get_lang dictionary_id='63359.satırda Hesap no ya da IBAN no giriniz.'></cfoutput><br />
            <cfset error_flag = 1>
        </cfif>
        
        <cfcatch type="Any">
            <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'>.<br/>
            <cfset error_flag = 1>
        </cfcatch>
    </cftry>
    
    <cfif error_flag neq 1>
        <cftry>
            <cfquery name="get_emp_" datasource="#dsn#" maxrows="1">
                SELECT
                    E.EMPLOYEE_ID
                FROM
                    EMPLOYEES E,
                    EMPLOYEES_IDENTY EI
                WHERE
                    E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
                    EI.TC_IDENTY_NO = '#emp_tckimlik_no#'
            </cfquery>
            <cfif get_emp_.recordcount>
                <cfset emp_id_ = get_emp_.EMPLOYEE_ID>
                <cfif is_standart eq 1>
                    <cfquery name="upd_" datasource="#dsn#">
                        UPDATE EMPLOYEES_BANK_ACCOUNTS SET DEFAULT_ACCOUNT = 0 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id_#">
                    </cfquery>
                </cfif>
                <cfset bank_id2 =  #bank_id#>
                <cfquery name="GET_BANK_INFO" datasource="#DSN#">
                	SELECT * FROM SETUP_BANK_TYPES WHERE BANK_ID = #bank_id2#
                </cfquery>
                <cfif GET_BANK_INFO.recordcount>
                	<cfset bank_name =  GET_BANK_INFO.BANK_NAME>
				</cfif>
                <cfif is_account_control eq 1>	
                    <cfquery name="control_" datasource="#dsn#">
                        SELECT 
                            E.EMPLOYEE_NAME,
                            E.EMPLOYEE_SURNAME
                        FROM 
                            EMPLOYEES_BANK_ACCOUNTS EBA,
                            EMPLOYEES E
                        WHERE
                            <cfif len(bank_id)>EBA.BANK_ID = #bank_id# AND</cfif>
                            EBA.BANK_ACCOUNT_NO = '#hesap_no#' AND
                            EBA.IBAN_NO = <cfif len(iban_no)>'#iban_no#'<cfelse>NULL</cfif> AND
                            EBA.BANK_BRANCH_CODE = '#sube_kodu#' AND
                            EBA.EMPLOYEE_ID = E.EMPLOYEE_ID 
                    </cfquery>
                    <cfif control_.recordcount>
                        <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.Satır'>.<cf_get_lang dictionary_id='56809.Bu Banka Hesabı Kullanılmaktadır!Lütfen Kontrol Ediniz'> <cf_get_lang dictionary_id='30368.Çalışan'>:<cfoutput>#control_.employee_name# #control_.employee_surname#</cfoutput><br />
                    </cfif>
                </cfif>
                <cfif is_account_control eq 0 or (is_account_control eq 1 and isdefined('control_') and control_.recordcount eq 0)>
                    <cfquery name="add_" datasource="#dsn#">
                        INSERT INTO EMPLOYEES_BANK_ACCOUNTS 
                            (
                            EMPLOYEE_ID,
                            BANK_ID,
                            BANK_NAME,
                            BANK_BRANCH_NAME,
                            BANK_BRANCH_CODE,
                            BANK_ACCOUNT_NO,
                            MONEY,
                            DEFAULT_ACCOUNT,
                            IBAN_NO,
                            BANK_SWIFT_CODE,
                            JOIN_ACCOUNT_NAME,
                            JOIN_ACCOUNT_SURNAME,
                            TC_IDENTY_NO,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                            )
                            VALUES
                            (
                            #emp_id_#,
                            #bank_id#,
                            <cfif len(bank_adi)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#bank_adi#">,
                            <cfelse>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#bank_name#">,
                            </cfif>
                            <cfif len(sube_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#sube_adi#"><cfelse>NULL</cfif>,
                            <cfif len(sube_kodu)><cfqueryparam cfsqltype="cf_sql_varchar" value="#sube_kodu#"><cfelse>NULL</cfif>,
                            <cfif len(hesap_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hesap_no#"><cfelse>NULL</cfif>,
                            <cfif len(para_birimi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#para_birimi#"><cfelse>NULL</cfif>,
                            #is_standart#,
                            <cfif len(iban_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#iban_no#"><cfelse>NULL</cfif>,
                            <cfif len(swift_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#swift_code#"><cfelse>NULL</cfif>,
                            <cfif len(ortak_hesap_ad)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ortak_hesap_ad#"><cfelse>NULL</cfif>,
                            <cfif len(ortak_hesap_soyad)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ortak_hesap_soyad#"><cfelse>NULL</cfif>,
                            <cfif len(emp_tckimlik_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_tckimlik_no#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                            )
                    </cfquery>
                </cfif>
            <cfelse>
                <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63360.satır 2. adımda ilgili çalışan bulunamadı.'><br/>
            </cfif>	
            <cfset satir_no = satir_no + 1>
            <cfcatch type="Any">
                <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='44948.2. adımda sorun oluştu.'><br/>
                <cfset error_flag = 1>
            </cfcatch>
        </cftry>
    </cfif>
</cfloop>
<cfoutput>#satir_no# ** <cf_get_lang dictionary_id='62781.satır import edildi'> !!!</cfoutput>
<script>
    window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_banks';
</script>

