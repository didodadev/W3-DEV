<cfparam name="attributes.our_company_ids" default="">
<cfsetting showdebugoutput="yes">
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cfset result="">
<cftry>
	<cffile action = "upload" fileField = "asset" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
			alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cfscript>
	ayirac = ';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	error_list = "";
	required_field_flag = 0;
	required_field_flag_code = 0;
</cfscript>

<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			is_name_control = 0;
			is_code_control = 0;
			brand_code = trim(listgetat(satir,1,';'));
			brand_name = trim(listgetat(satir,2,';'));
			if(listlen(satir,';') gte 3)
				brand_detail = trim(listgetat(satir,3,';'));
			else
				brand_detail = '';
			if (not len(brand_name))
			{
				required_field_flag = 1;
			}
			if (not len(brand_code))
			{
				required_field_flag_code = 1;
			}
		</cfscript>
        <cfif required_field_flag eq 1>
            <cfset result=result & i & ". " &getLang('','settings',63255)&"\n">
            <cfcontinue>
        </cfif>
        <cfif required_field_flag_code eq 1>
            <cfset result=result & i & ". " &getLang('','settings',63254)&"\n">
            <cfcontinue>
        </cfif>
        <cfquery name="brandnameControl" datasource="#dsn1#">
        	SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_NAME = '#brand_name#'
        </cfquery>
        <cfquery name="brandcodeControl" datasource="#dsn1#">
        	SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_CODE = '#brand_code#'
        </cfquery>
        <cfif brandnameControl.recordcount gt 0>
        	<cfset is_name_control = 1>
        </cfif>
		<cfif brandcodeControl.recordcount gt 0>
        	<cfset is_code_control = 1>
        </cfif>
		<cfif is_name_control eq 1>
            <cfset result=result & i & ". " &getLang('','settings',63253)&"\n">
            <cfcontinue>
        </cfif>
		<cfif is_code_control eq 1>
            <cfset result=result & i & ". " &getLang('','settings',63252)&"\n">
            <cfcontinue>
        </cfif>
        <cfcatch type="Any">
            <cfset result=result & i & ". " &getLang('','settings',63251)&"\n">
            <cfcontinue>
        </cfcatch> 
    </cftry>
    <cftry>
    	<cfif is_name_control eq 0 and is_code_control eq 0>
            <cfquery name="insertBrands" datasource="#dsn1#" result="insertBrand_result">
                INSERT INTO PRODUCT_BRANDS
                (
                    BRAND_CODE,
                    BRAND_NAME,
                    DETAIL,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    IS_ACTIVE      
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#brand_code#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#brand_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#brand_detail#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    1
                )
            </cfquery> 
            <cfif len (attributes.our_company_ids)>
                <cfloop from="1" to="#ListLen(attributes.our_company_ids)#" index="j">
                    <cfquery name="insertCompanyBrand" datasource="#dsn1#">
                        INSERT INTO PRODUCT_BRANDS_OUR_COMPANY
                        (
                            BRAND_ID,
                            OUR_COMPANY_ID
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#insertBrand_result.generatedkey#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.our_company_ids,j)#">
                        )
                    </cfquery>
                </cfloop>
            </cfif>
            <!--- <cfset is_name_control = 0>
            <cfset is_code_control = 0> --->
        </cfif>
        <cfcatch>
            <cfset result=result & i & ". " &getLang('','settings',63250)&"\n">
            <cfcontinue>
        </cfcatch>
    </cftry>
    <cfset result=result & i & ". " &getLang('','settings',63249)&"\n">
</cfloop>
<script>
    alert("<cfoutput>#result#</cfoutput>");
	location.href = document.referrer;
</script>