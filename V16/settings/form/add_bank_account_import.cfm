<!--- Banka Hesabi Import h.gul --->
<cfsavecontent variable="title"><cf_get_lang dictionary_id='45161.Banka Hesabı Aktarım'></cfsavecontent>
<cfif not isdefined('attributes.uploaded_file')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#title#">
			<cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_bank_account_import" enctype="multipart/form-data" method="post">
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-file_format">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<select name="file_format" id="file_format">
								<option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-uploaded_file">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="file" name="uploaded_file" id="uploaded_file" required="yes" message="#getLang('','Dosya Yüklemelisiniz','61842')#!">
						</div>
					</div>
					<div class="form-group" id="item-sample_file">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<a  href="/IEF/standarts/import_example_file/Banka_Hesabi_aktarim.csv"><cf_get_lang dictionary_id='43675.İndir'></a>
						</div>
					</div>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>
					<!--- <div class="form-group col col-4">
						<label></label>
					</div> --->
					<div class="form-group" id="item-explanation">
						<p>
							<cf_get_lang dictionary_id='57629.Açıklama'>: <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>.<br/>
							<cf_get_lang dictionary_id='44193.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
						</p>
						<p><cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 18</p>
						<p><cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;</p>
						<p>
							1- <cf_get_lang dictionary_id='57453.Şube'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) (<cf_get_lang dictionary_id='45100.Eğer birden fazla şube ile ilişkili ise virgül ile ayrılarak ID ler girilsin'>.)<br/>
							2- <cf_get_lang dictionary_id='59007.IBAN Kodu'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							3- <cf_get_lang dictionary_id='44334.Hesap Adı'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							4- <cf_get_lang dictionary_id='44713.Banka Adı'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							5- <cf_get_lang dictionary_id='58933.Banka Şubesi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							6- <cf_get_lang dictionary_id='58178.Hesap No'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							7- <cf_get_lang dictionary_id='45101.Hesap Türü'> (<cf_get_lang dictionary_id='29447.Kredili'>:1,<cf_get_lang dictionary_id='29446.Ticari'>:2, <cf_get_lang dictionary_id='57798.Vadeli'>:3)<br/>
							8- <cf_get_lang dictionary_id='29448.Döviz Cinsi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							9- <cf_get_lang dictionary_id='58963.Kredi Limiti'><br/>
							10- <cf_get_lang dictionary_id='58811.Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							11- <cf_get_lang dictionary_id='45102.Banka Talimatı Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							12- <cf_get_lang dictionary_id='45103.Verilen Çek Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							13- <cf_get_lang dictionary_id='45104.Takas Çeki Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							14- <cf_get_lang dictionary_id='45105.Takas Senedi Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
							15- <cf_get_lang dictionary_id='45106.Teminattaki Çekler Muhasebe Kodu'><br/>
							16- <cf_get_lang dictionary_id='45107.Teminattaki Senetler Muhasebe Kodu'><br/>
							17- <cf_get_lang dictionary_id='62774.Karşılıksız Çekler Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br />
							18- <cf_get_lang dictionary_id='62775.Protestolu Senetler Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br />
							19- <cf_get_lang dictionary_id='57629.Açıklama'><br/>
							20- <cf_get_lang dictionary_id='57756.Durum'> (<cf_get_lang dictionary_id='57493.Aktif'>:1, <cf_get_lang dictionary_id='57494.Pasif'>:0)<br/>
						</p>
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function="kontrol()">
					</cf_box_footer>  
				</div>
			</cfform>
		</cf_box>
	</div>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfif not DirectoryExists("#upload_folder#temp#dir_seperator#")>
		<cfdirectory action="create" directory="#upload_folder#temp#dir_seperator#">
	</cfif>
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
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
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
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
		counter = 0;
		liste = "";
	</cfscript>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset branch_id = trim(listgetat(dosya[i],1,';'))>
			<cfset account_owner_customer_no = trim(listgetat(dosya[i],2,';'))>
			<cfset account_name = trim(listgetat(dosya[i],3,';'))>
			<cfset account_bank_id = trim(listgetat(dosya[i],4,';'))>
			<cfset account_branch_id = trim(listgetat(dosya[i],5,';'))>
			<cfset account_no = trim(listgetat(dosya[i],6,';'))>
			<cfset account_type = trim(listgetat(dosya[i],7,';'))>
			<cfset account_currency_id = trim(listgetat(dosya[i],8,';'))>
			<cfset account_credit_limit = trim(listgetat(dosya[i],9,';'))>
			<cfset account_id = trim(listgetat(dosya[i],10,';'))>
			<cfset bank_order = trim(listgetat(dosya[i],11,';'))>
			<cfset v_account_id = trim(listgetat(dosya[i],12,';'))>
			<cfset exchange_code_id = trim(listgetat(dosya[i],13,';'))>
			<cfset v_exchange_code_id = trim(listgetat(dosya[i],14,';'))>
			<cfset guaranty_code_id = trim(listgetat(dosya[i],15,';'))>
			<cfset v_guaranty_code_id = trim(listgetat(dosya[i],16,';'))>
			<cfset karsiliksiz_cekler_code = trim(listgetat(dosya[i],17,';'))>
			<cfset protestolu_senetler_code = trim(listgetat(dosya[i],18,';'))>
			<cfset account_detail = trim(listgetat(dosya[i],19,';'))>
			<cfif (listlen(dosya[i],';') gte 20)>
				<cfset status = trim(listgetat(dosya[i],20,';'))>
			<cfelse>
				<cfset status = ''>
			</cfif>
			<cfcatch type="Any">
				<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
				<cfset kont=0>
			</cfcatch>
		</cftry>
		<cfif len(account_type)>
			<cfset account_type_ = account_type>
		</cfif>
		<cfif len(account_bank_id) and isnumeric(account_bank_id)>
			<cfquery name="get_bank" datasource="#dsn#">
				SELECT BANK_ID,BANK_CODE FROM SETUP_BANK_TYPES WHERE BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_bank_id#"> ORDER BY BANK_NAME
			</cfquery>
		<cfelse>
			<cfset get_bank.bank_code = ''>
		</cfif>
		<cfif len(account_branch_id) and len(account_bank_id)>
			<cfquery name="get_account_branch" datasource="#dsn3#">
				SELECT BANK_BRANCH_ID ACCOUNT_BRANCH_ID,BRANCH_CODE FROM BANK_BRANCH WHERE BANK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_branch_id#"> AND BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_bank_id#">
			</cfquery>
		<cfelse>
			<cfset get_account_branch.account_branch_id = ''>
			<cfset get_account_branch.branch_code = ''>
		</cfif>
		<cfif len(account_id)>
			<cfquery name="get_account_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE IN ('#account_id#')
			</cfquery>
		<cfelse>
			<cfset get_account_id.account_id = ''>
		</cfif>
		<cfif len(account_currency_id)>
			<cfquery name="get_currency" datasource="#dsn2#">
				SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_currency_id#">
			</cfquery>
		<cfelse>	
			<cfset get_currency.money = ''>
		</cfif>
		<cfif len(bank_order)>
			<cfquery name="get_bank_order" datasource="#dsn2#">
				SELECT ACCOUNT_CODE BANK_ORDER FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bank_order#">
			</cfquery>
		<cfelse>
			<cfset get_bank_order.bank_order = ''>
		</cfif>
		<cfif len(v_account_id)>
			<cfquery name="get_v_account_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE V_ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_account_id#">
			</cfquery>
		<cfelse>
			<cfset get_v_account_id.v_account_id = ''>
		</cfif>
		<cfif len(exchange_code_id)>
			<cfquery name="get_exchange_code_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE EXCHANGE_CODE_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#exchange_code_id#">
			</cfquery>
		<cfelse>
			<cfset get_exchange_code_id.exchange_code_id = ''>
		</cfif>
		<cfif len(v_exchange_code_id)>
			<cfquery name="get_v_exchange_code_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE V_EXCHANGE_CODE_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_exchange_code_id#">
			</cfquery>
		<cfelse>
			<cfset get_v_exchange_code_id.v_exchange_code_id = ''>
		</cfif>
		<cfif len(guaranty_code_id)>
			<cfquery name="get_guaranty_code_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE GUARANTY_CODE_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#guaranty_code_id#">
			</cfquery>
		<cfelse>
			<cfset get_guaranty_code_id.guaranty_code_id = ''>
		</cfif>
		<cfif len(v_guaranty_code_id)>
			<cfquery name="get_v_guaranty_code_id" datasource="#dsn2#">
				SELECT ACCOUNT_CODE V_GUARANTY_CODE_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_guaranty_code_id#">
			</cfquery>
		<cfelse>
			<cfset get_v_guaranty_code_id.v_guaranty_code_id = ''>
		</cfif>
		<cfif len(karsiliksiz_cekler_code)>
			<cfquery name="get_karsiliksiz_cekler_code" datasource="#dsn2#">
				SELECT ACCOUNT_CODE KARSILIKSIZ_CEKLER_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#karsiliksiz_cekler_code#">
			</cfquery>
		<cfelse>
			<cfset get_karsiliksiz_cekler_code.karsiliksiz_cekler_code = ''>
		</cfif>
		<cfif len(protestolu_senetler_code)>
			<cfquery name="get_protestolu_senetler_code" datasource="#dsn2#">
				SELECT ACCOUNT_CODE PROTESTOLU_SENETLER_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#protestolu_senetler_code#">
			</cfquery>
		<cfelse>
			<cfset get_protestolu_senetler_code.protestolu_senetler_code = ''>
		</cfif>
		<cfif len(status) and status eq 1>
			<cfset status_ = 1>
		<cfelse>
			<cfset status_ = 0>
		</cfif>
		
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cftry>
					<cfquery name="ADD_ACCOUNT" datasource="#dsn3#" result="MAX_ID">
						INSERT INTO
							ACCOUNTS
						(
							ACCOUNT_STATUS,
							ACCOUNT_TYPE,
							ACCOUNT_NAME,
							ACCOUNT_BRANCH_ID,
							ACCOUNT_OWNER_CUSTOMER_NO,
							ACCOUNT_CREDIT_LIMIT,
							ACCOUNT_CURRENCY_ID,
							ACCOUNT_NO,
							ACCOUNT_ACC_CODE,
							V_CHEQUE_ACC_CODE,
							CHEQUE_EXCHANGE_CODE,
							VOUCHER_EXCHANGE_CODE,
							CHEQUE_GUARANTY_CODE,
							VOUCHER_GUARANTY_CODE,
							ACCOUNT_ORDER_CODE,
							ISOPEN,
							ACCOUNT_DETAIL,
							BANK_CODE,
							BRANCH_CODE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							PROTESTOLU_SENETLER_CODE,
							KARSILIKSIZ_CEKLER_CODE						
						)
						VALUES
						( 
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#status_#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_type_#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_name#">,
							<cfif len(get_account_branch.account_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_branch.account_branch_id#"></cfif>,
							<cfif len(account_owner_customer_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#account_owner_customer_no#"></cfif>,
							<cfif len(account_credit_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#account_credit_limit#"><cfelse>0</cfif>,
							<cfif len(get_currency.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_currency.money#"></cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_no#">,
							<cfif len(get_account_id.account_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_id.account_id#"></cfif>,
							<cfif len(get_v_account_id.v_account_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_v_account_id.v_account_id#"></cfif>,
							<cfif len(get_exchange_code_id.exchange_code_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_exchange_code_id.exchange_code_id#"></cfif>,
							<cfif len(get_v_exchange_code_id.v_exchange_code_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_v_exchange_code_id.v_exchange_code_id#"></cfif>,
							<cfif len(get_guaranty_code_id.guaranty_code_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_guaranty_code_id.guaranty_code_id#"><cfelse>NULL</cfif>,
							<cfif len(get_v_guaranty_code_id.v_guaranty_code_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_v_guaranty_code_id.v_guaranty_code_id#"><cfelse>NULL</cfif>,
							<cfif len(get_bank_order.bank_order)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_bank_order.bank_order#"></cfif>,
							0,
							<cfif len(account_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#account_detail#"><cfelse>NULL</cfif>,
							<cfif len(get_bank.bank_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_bank.bank_code#"><cfelse>NULL</cfif>,
							<cfif len(get_account_branch.branch_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_branch.branch_code#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif len(get_protestolu_senetler_code.protestolu_senetler_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_protestolu_senetler_code.protestolu_senetler_code#"></cfif>,
							<cfif len(get_karsiliksiz_cekler_code.karsiliksiz_cekler_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_karsiliksiz_cekler_code.karsiliksiz_cekler_code#"></cfif>
						)
					</cfquery>
					<cfquery name="ADD_ACCOUNT_CONTROL" datasource="#dsn3#">
						INSERT INTO
							ACCOUNTS_OPEN_CONTROL
							(
								ACCOUNT_ID,
								IS_OPEN,
								PERIOD_ID
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
								0,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
							)
					</cfquery>
					<cfloop from="1" to="#listlen(branch_id)#" index="brnch_index">
						<cfquery name="ADD_ACCOUNT_BRANCH" datasource="#dsn3#">
							INSERT INTO
								ACCOUNTS_BRANCH
								(
									ACCOUNT_ID,
									BRANCH_ID
								)
								VALUES
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(branch_id,brnch_index)#">
								)
						</cfquery>
					</cfloop>
					<cfcatch type="any">
						<cfoutput>
							#i#. <cf_get_lang dictionary_id='59292.Satırdaki'> ;  <br/>
							<cfif not len(get_account_branch.account_branch_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='58933.Banka Şubesi'> <cf_get_lang dictionary_id='58527.ID'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif> 
							<cfif not len(get_currency.money)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='29448.Döviz Cinsi'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(account_owner_customer_no)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='59007.IBAN Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif> 
							<cfif not len(account_no)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='58178.Hesap No'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not isDefined('account_type_')>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45101.Hesap Türü'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_account_id.account_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='58811.Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_v_account_id.v_account_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45103.Verilen Çek Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_exchange_code_id.exchange_code_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45104.Takas Çeki Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_v_exchange_code_id.v_exchange_code_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45105.Takas Senedi Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_bank_order.bank_order)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45102.Banka Talimatı Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_protestolu_senetler_code.protestolu_senetler_code)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='62775.Protestolu Senetler Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
							<cfif not len(get_karsiliksiz_cekler_code.karsiliksiz_cekler_code)>
								&nbsp;&nbsp;&nbsp;&nbsp;*<cf_get_lang dictionary_id='45106.Teminattaki Çekler Muhasebe Kodu'> <cf_get_lang dictionary_id='33274.Eksik'>.<br/>
							</cfif>
						</cfoutput>	
						<cfset kont=0>
					</cfcatch>
				</cftry>
				<cfif kont eq 1>
					<cfoutput>#i#. <cf_get_lang dictionary_id='62781.satır import edildi'>... <br/></cfoutput>
				</cfif>
			</cftransaction>
		</cflock>
	</cfloop>
</cfif>
