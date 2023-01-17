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
	
	<cfset file_size = cffile.filesize>
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
		alert("<cf_get_lang dictionary_id='63330.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfscript>
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
		
		emp_no = trim(Listgetat(satir,1,";"));
		emp_tckimlik_no = Trim(Listgetat(satir,4,";"));
		
		relative_name =trim(Listgetat(satir,5,";"));
		relative_surname = trim(Listgetat(satir,6,";"));
		yakinlik = trim(Listgetat(satir,7,";"));
		marriage_date = trim(Listgetat(satir,8,";"));
		relative_tckimlik =trim(Listgetat(satir,9,";"));
		relative_cinsiyet = trim(Listgetat(satir,10,";"));
		relative_dogum_tarihi = trim(Listgetat(satir,11,";"));
		relative_dogum_yeri = trim(Listgetat(satir,12,";"));
		relative_vergi = trim(Listgetat(satir,13,";"));
		relative_validity = trim(Listgetat(satir,14,";"));
		education_status = trim(Listgetat(satir,15,";"));
		child_help = trim(Listgetat(satir,16,";"));
		disabled_relative = trim(Listgetat(satir,17,";"));
		is_married = trim(Listgetat(satir,18,";"));
		corporation_employee = trim(Listgetat(satir,19,";"));
		is_retired = trim(Listgetat(satir,20,";"));
		work_status = trim(Listgetat(satir,21,";"));
		education_level = trim(Listgetat(satir,22,";"));
		kindergarden_support = trim(Listgetat(satir,23,";"));
		is_commitment_not_assurance = trim(Listgetat(satir,24,";"));
		is_policy = trim(Listgetat(satir,25,";"));
		
		if(len(relative_dogum_tarihi) and isdate(relative_dogum_tarihi))
			{
			relative_dogum_yil = trim(listgetat(relative_dogum_tarihi,3,'.'));
			relative_dogum_ay = trim(listgetat(relative_dogum_tarihi,2,'.'));
			relative_dogum_gun = trim(listgetat(relative_dogum_tarihi,1,'.'));
			}	
		if(len(marriage_date) and isdate(marriage_date))
			{
			marriage_date_yil = trim(listgetat(marriage_date,3,'.'));
			marriage_date_ay = trim(listgetat(marriage_date,2,'.'));
			marriage_date_gun = trim(listgetat(marriage_date,1,'.'));
			}	
		if(len(relative_validity) and isdate(relative_validity))
		{
			relative_validity = Replace(relative_validity,'.','/','all');
		}	
	</cfscript>

    <cfif not len(emp_tckimlik_no)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63415.satırda Çalışan TC Kimlik No alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(yakinlik)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63416.satırda Çalışan Yakınlık Derecesi alanını kontrol ediniz'>.</cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(relative_tckimlik)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63417.satırda Çalışan Yakın TC Kimlik No alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(relative_dogum_tarihi)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63418.satırda Çalışan Yakın Doğum Tarihi alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(relative_vergi)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63419.satırda Çalışan Yakın Vergi Durumu alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(relative_validity)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63420.satırda Çalışan Yakın Geçerlilik Tarihi alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    <cfif not len(education_status)>
    	<cfoutput>#i-1#. <cf_get_lang dictionary_id='63421.satırda Okuyor / Okumuyor alanını kontrol ediniz.'></cfoutput><br />
    	<cfset error_flag = 1>
    </cfif>
    
	<cfcatch type="Any">
		<cfoutput>#i-1#</cfoutput>. <cf_get_lang dictionary_id='44947.1. adımda sorun oluştu.'><br/>
		<cfset error_flag = 1>
	</cfcatch>
</cftry>
<cf_date tarih='relative_validity'>
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
				<!--- E.EMPLOYEE_NO = '#emp_no#' AND --->
				EI.TC_IDENTY_NO = '#emp_tckimlik_no#'
		</cfquery>
		<cfif get_emp_.recordcount>
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_RELATIVES
						(
						EMPLOYEE_ID,
						NAME,
						SURNAME,
						SEX,
						RELATIVE_LEVEL,
						BIRTH_DATE,
						BIRTH_PLACE,
						TC_IDENTY_NO,
						DISCOUNT_STATUS,
						MARRIAGE_DATE,
                        VALIDITY_DATE,
                        EDUCATION_STATUS,
						CHILD_HELP,
						DISABLED_RELATIVE,
						IS_MARRIED,
						CORPORATION_EMPLOYEE,
						IS_RETIRED,
						WORK_STATUS,
						EDUCATION,
						KINDERGARDEN_SUPPORT,
						IS_COMMITMENT_NOT_ASSURANCE,
						IS_ASSURANCE_POLICY,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
						)
					VALUES
						(
						#get_emp_.EMPLOYEE_ID#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(relative_name,50)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(relative_surname,50)#">,
						<cfif len(relative_cinsiyet)>#relative_cinsiyet# <cfelse> NULL </cfif>,
						#yakinlik#,
						<cfif len(relative_dogum_tarihi) and isdate(relative_dogum_tarihi)>#createodbcdatetime(createdate(relative_dogum_yil,relative_dogum_ay,relative_dogum_gun))#<cfelse>NULL</cfif>,
						<cfif len(relative_dogum_yeri)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(relative_dogum_yeri,50)#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#relative_tckimlik#">,
						#relative_vergi#,
						<cfif len(marriage_date) and isdate(marriage_date)>#createodbcdatetime(createdate(marriage_date_yil,marriage_date_ay,marriage_date_gun))#<cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#relative_validity#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#education_status#">,
						<cfif len(child_help)><cfqueryparam cfsqltype="cf_sql_integer" value="#child_help#"><cfelse>NULL</cfif>,
						<cfif len(disabled_relative)><cfqueryparam cfsqltype="cf_sql_integer" value="#disabled_relative#"><cfelse>NULL</cfif>,
						<cfif len(is_married)><cfqueryparam cfsqltype="cf_sql_integer" value="#is_married#"><cfelse>NULL</cfif>,
						<cfif len(corporation_employee)><cfqueryparam cfsqltype="cf_sql_integer" value="#corporation_employee#"><cfelse>NULL</cfif>,
						<cfif len(is_retired)><cfqueryparam cfsqltype="cf_sql_integer" value="#is_retired#"><cfelse>NULL</cfif>,
						<cfif len(work_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#work_status#"><cfelse>NULL</cfif>,
						<cfif len(education_level)><cfqueryparam cfsqltype="cf_sql_integer" value="#education_level#"><cfelse>NULL</cfif>,
						<cfif len(kindergarden_support)><cfqueryparam cfsqltype="cf_sql_integer" value="#kindergarden_support#"><cfelse>NULL</cfif>,
						<cfif len(is_commitment_not_assurance)><cfqueryparam cfsqltype="cf_sql_integer" value="#is_commitment_not_assurance#"><cfelse>NULL</cfif>,
						<cfif len(is_policy)><cfqueryparam cfsqltype="cf_sql_integer" value="#is_policy#"><cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)
			</cfquery>
		<cfelse>
			<cfoutput>#i-1#</cfoutput>. <cf_get_lang dictionary_id='63360.satır 2. adımda ilgili çalışan bulunamadı.'><br/>
		</cfif>	
		<cfset satir_no = satir_no + 1>
 		<cfcatch type="Any">
			<cfoutput>#i-1#</cfoutput>. <cf_get_lang dictionary_id='44948.2. adımda sorun oluştu.'><br/>
			<cfset error_flag = 1>
		</cfcatch>
	</cftry>
</cfif>
</cfloop>
<cfoutput>#satir_no# ** <cf_get_lang dictionary_id='52261.İmport Edildi'> !!!</cfoutput>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_relative';
</script>