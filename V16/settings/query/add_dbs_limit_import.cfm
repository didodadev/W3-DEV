<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
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
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder_##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cfscript>
	CRLF = Chr(13) & Chr(10);	// satir atlama karakteri
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfloop from="1" to="#line_count#" index="i">
	<cfset kont = 1>
	<cftry>
		<cfscript>
			money_type = '';
			satir = dosya[i];
			member_no = oku(satir,1,20);						//musteri no
			member_name = oku(satir,21,40);						//musteri unvan
			branch_code = oku(satir,66,5);						//banka sube kodu
			limit_value = val(oku(satir,71,15));				//limit tutari
			available_limit_value = val(oku(satir,86,15));		//kullanilabilir limit tutari
			credit_used_value = val(oku(satir,101,15));			//krediden kullanilan tutar
			money_type = oku(satir,116,3);						//kur bilgisi
		</cfscript>
		<cfif money_type eq 'TRY'><cfset money_type = 'TL'></cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. Satırda Sorun Oluştu!!<br/>
		</cfcatch>  
	</cftry>
	<cfquery name="get_company_id" datasource="#dsn#">
		SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = '#member_no#'
	</cfquery>
	<cfquery name="get_money_type" datasource="#dsn#">
		SELECT MONEY FROM SETUP_MONEY WHERE MONEY = '#money_type#' AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfquery name="get_bank_branch_id" datasource="#dsn3#">
		SELECT BANK_BRANCH_ID FROM BANK_BRANCH WHERE BANK_ID = #attributes.bank_id# AND BRANCH_CODE = '#branch_code#'
	</cfquery>
	<cfset get_dbs_limit.recordcount = 0>
	<cfif get_bank_branch_id.recordcount and get_money_type.recordcount and get_company_id.recordcount and len(attributes.bank_id)>
		<cfquery name="get_dbs_limit" datasource="#dsn#">
			SELECT 
				DBS_LIMIT_ID 
			FROM
				COMPANY_CREDIT_DBS
			WHERE
				COMPANY_ID = #get_company_id.company_id#
				AND BANK_ID = #attributes.bank_id#
				AND BRANCH_ID = #get_bank_branch_id.bank_branch_id#
				AND CURRENCY_ID = '#get_money_type.money#'
				AND OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfif get_company_id.recordcount neq 0 and get_bank_branch_id.recordcount neq 0 and get_money_type.recordcount neq 0>
				<cfif get_dbs_limit.recordcount>
					<cfquery name="upd_company_credit" datasource="#dsn#">
						UPDATE
							COMPANY_CREDIT_DBS
						SET
							IS_OLD = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
							LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#limit_value#">,
							AVAILABLE_LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#available_limit_value#">,
							CREDIT_USED_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#credit_used_value#">,
							IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
							UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
						WHERE 
							DBS_LIMIT_ID = #get_dbs_limit.dbs_limit_id#	
					</cfquery>
				<cfelse>
					<cfquery name="add_company_credit" datasource="#dsn#">
						INSERT INTO
							COMPANY_CREDIT_DBS
							(
								COMPANY_ID,
								OUR_COMPANY_ID,
								BANK_ID,
								BRANCH_ID,
								LIMIT,
								AVAILABLE_LIMIT,
								CREDIT_USED_AMOUNT,
								CURRENCY_ID,
								IS_ACTIVE,	
								IS_OLD,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE	
							)
						VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_id.company_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_bank_branch_id.bank_branch_id#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#limit_value#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#available_limit_value#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#credit_used_value#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							)
					</cfquery>
				</cfif>
			</cfif>
			<cfoutput>
				<cfif get_company_id.recordcount eq 0>
					#i#.<cf_get_lang_main no='1096.Satir'>: Üye Kodu Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
					<cfset kont=0>
					<br />
				<cfelseif get_bank_branch_id.recordcount eq 0>
					#i#.<cf_get_lang_main no='1096.Satir'>: Şube Kodu Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
					<cfset kont=0>
					<br />
				<cfelseif get_money_type.recordcount eq 0>
					#i#.<cf_get_lang_main no='1096.Satir'>: Para Birimi Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
					<cfset kont=0>
					<br />
				</cfif>
			</cfoutput>	
			<cfif kont eq 1>
				<cfoutput>#i#.Satır Import Edildi<br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<!--- is old alanı 1 olanlar yani bu dosyadan import edilmeyenler ve dosyada olmayan carilerin satırları pasif yapılıyor --->
<cfquery name="upd_to_passive" datasource="#dsn#">
	UPDATE COMPANY_CREDIT_DBS SET IS_ACTIVE = 0 WHERE BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#"> AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_OLD = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
</cfquery>
<!--- güncelleme işleminden sonra is_old alanı default 1 set ediliyor --->
<cfquery name="upd_to_old" datasource="#dsn#">
	UPDATE COMPANY_CREDIT_DBS SET IS_OLD = 1 WHERE BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#"> AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

