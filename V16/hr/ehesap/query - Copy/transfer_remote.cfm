<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not len(attributes.remote_file)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile
			action = "upload" 
			fileField = "remote_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>");
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
				alert("<cf_get_lang dictionary_id='59615.Dosya Okunamadı'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>

	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya1 = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya1);
	</cfscript>

	<cfif line_count eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='44524.Dosya Geçersiz veya Satır Sayısı Hatalı. Lütfen Dosyanızı Kontrol Ediniz'>!");
		</script>
		<cfabort>
	</cfif>
	<cfset tablo_ = "REMOTE_WORKING_DAY">
		
	<cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset sira_ = trim(listgetat(dosya1[i],1,';'))>
			<cfset tc_kimlik_ = trim(listgetat(dosya1[i],2,';'))>
			<cfset name_ = trim(listgetat(dosya1[i],3,';'))>				
			<cfset baslangic_ = trim(listgetat(dosya1[i],4,';'))>
			<cfset bitis_ = trim(listgetat(dosya1[i],5,';'))>
			<cfset yil_ = trim(listgetat(dosya1[i],6,';'))>
            <cfset gun_ = trim(listgetat(dosya1[i],7,';'))>
			<!--- <cfif gun_ gt 15>
				<script type="text/javascript">
					alert("<cfoutput>#getLang('','Girilen değer 0-15 aralığında olmalıdır!',63060)#(#getLang('','Uzaktan Çalışma Gün',63061)#)</cfoutput>");
					history.back();
				</script>
				<cfabort>
			</cfif> --->
			<cfif gun_ contains ','>
				<cfset gun_ = replace(gun_,',','.',"all")>
			</cfif>
			<cfcatch type="Any">
				<cfoutput>#i#.<cf_get_lang dictionary_id='44849.Satır Verilerini Okuma Aşamasında Hata Var.'><br/></cfoutput>	
				<cfset kont=0>
			</cfcatch>  
		</cftry>
	
		<cfif kont eq 1>
			<cfquery name="get_employee_id" datasource="#dsn#" maxrows="1">
				SELECT
					EI.EMPLOYEE_ID,
					EO.IN_OUT_ID
				FROM
					EMPLOYEES_IDENTY EI,
					EMPLOYEES_IN_OUT EO
				WHERE
					EO.EMPLOYEE_ID = EI.EMPLOYEE_ID 
					AND EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_kimlik_#">
				ORDER BY
					EO.IN_OUT_ID DESC
			</cfquery>
			<cfif not get_employee_id.recordcount>
				<cfoutput>#i#.<cf_get_lang dictionary_id='63414.Satırdaki Kişi Kartı veya Giriş Çıkışı Bulunamadı'>!<br/></cfoutput>	
				<cfset kont=0>
			<cfelse>
				<cfset this_in_out = get_employee_id.in_out_id>
				<cfset this_employee = get_employee_id.EMPLOYEE_ID>
			</cfif>
		</cfif>
		<cfif kont eq 1>
			<cfquery name="check_ssk" datasource="#dsn#">
				SELECT
					*
				FROM
					#tablo_#
				WHERE
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">
					AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">
					AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
			</cfquery>
		    <cfif not check_ssk.recordcount>
				<cfquery name="add_remote" datasource="#dsn#">
					INSERT INTO
						#tablo_#
					(
						EMPLOYEE_ID,
						PERIOD_YEAR,
						<cfloop from="1" to="12" index="aaa">
							M#aaa#,
						</cfloop>
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP,
						IN_OUT_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">,
						<cfloop from="1" to="12" index="aaa">
							<cfif aaa lt baslangic_ or aaa gt bitis_>
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#gun_#">,
							</cfif>
						</cfloop>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
					)
				</cfquery>
			<cfelse>	
				<cfquery name="upd_remote" datasource="#dsn#">
					UPDATE 
						#tablo_#
					SET
						<cfloop from="1" to="12" index="aaa">
							<cfif aaa lt baslangic_ or aaa gt bitis_>
								M#aaa# = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
							<cfelse>
								M#aaa# = <cfqueryparam cfsqltype="cf_sql_integer" value="#gun_#">,
							</cfif>
						</cfloop>
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
					WHERE
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">
						AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">
						AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
				</cfquery>
                <cfoutput>#i-1#.<cf_get_lang dictionary_id='44851.kişi bitti'>...</cfoutput><br/>
		    </cfif>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='44852.İmport İşlemi Başarıyla Tamamlandı!'>");
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.remote_working_day_import</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->