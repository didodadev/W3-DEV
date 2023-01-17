<cfsetting showdebugoutput="no">
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
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			satir=dosya[i];
			model_code = trim(listgetat(satir,1,"#ayirac#"));
			model_name =trim(listgetat(satir,2,"#ayirac#"));
			
			if(listlen(satir,';') neq 2)
			{
				error_list=ListAppend(i,',');
				error_flag=1;
			}
			
		</cfscript>
        <cfif error_flag eq 1>
        	<cfset result=result & i & ". " &getLang('','settings',63251)&"\n">
            <cfcontinue>
        </cfif>
        <cfcatch type="Any">
			<cfset result=result & i & ". " &getLang('','settings',63251)&"\n">
            <cfcontinue>
        </cfcatch>
    </cftry>
    <cftry>
        <cfquery name="importModel" datasource="#dsn1#">
            INSERT INTO PRODUCT_BRANDS_MODEL
            (	
                MODEL_NAME,
                MODEL_CODE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP        
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#model_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#model_code#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    <cfcatch type="any">
		<cfset result=result & i & ". " &getLang('','settings',63250)&"\n">
        <cfcontinue>
    </cfcatch>
    </cftry>
	<cfset result=result & i & ". " &getLang('','settings',63249)&"\n">
    <cfset counter = counter + 1 >
</cfloop>
<cfset error_count = line_count - counter - 1 > 
<cfset result=result & getLang('','settings',57492) & counter & getLang('','settings',63256) & "," & error_count & getLang('','settings',63257)&"\n">
<script>
    alert("<cfoutput>#result#</cfoutput>");
	location.href = document.referrer;
</script>
