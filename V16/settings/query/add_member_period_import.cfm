<cfset donem_db = '#dsn#_#ListGetAt(attributes.PERIOD_ID,2,',')#_#ListGetAt(attributes.PERIOD_ID,3,',')#'> 
<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
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
	ayirac=';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#',' #ayirac# #ayirac# ','all');
	dosya = Replace(dosya,'#ayirac##ayirac#',' #ayirac# #ayirac# ','all');
	dosya = Replace(dosya,'#ayirac#',' #ayirac# ','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfset searched_field = attributes.referans_type >
<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
		column = 1;
		error_flag = 0;
		counter = counter + 1;
		satir=dosya[i]&'  ;';
		//member_type = bireysel mi kurumsal mı
		member_type = trim(Listgetat(satir,column,ayirac));
		if( not len(member_type)) member_type = 'B';
		column = column + 1;
		//öncelik limi?
		period_default = trim(Listgetat(satir,column,ayirac));
		if (not len(period_default)) period_default = 0;
		column = column + 1;
		//member_code =cari veya özel kod
		member_code = trim(Listgetat(satir,column,ayirac));
		if(not len(member_code)) member_code = '';
		column = column + 1;
		//muhasebe kodu
		account_code = trim(Listgetat(satir,column,ayirac));
		if(not len(account_code)) account_code = '';
		column = column + 1;
		//konsinye kodu
		konsinye_code = trim(Listgetat(satir,column,ayirac));
		if(not len(konsinye_code)) konsinye_code = '';
		column = column + 1;
		//Alıcı
		if (trim(member_type) is 'B' or trim(member_type) is 'b')
			is_buyer = '0' ;
		else
			is_buyer = trim(Listgetat(satir,column,ayirac));
		column = column + 1;
		//satıcı
		if (trim(member_type) is 'B' or trim(member_type) is 'b')
			is_seller = '0' ;
		else
			is_seller = trim(Listgetat(satir,column,ayirac));
		column = column + 1;
		//avans hesap kodu
		advance_payment_code = trim(Listgetat(satir,column,ayirac));
		if(not len(advance_payment_code)) advance_payment_code = '';
		column = column + 1;
		//satış hesabı
		sales_account = trim(Listgetat(satir,column,ayirac));
		if(not len(sales_account)) sales_account = '';
		column = column + 1; 	
		//alış hesabı
		purchase_account = trim(Listgetat(satir,column,ayirac));
		if(not len(purchase_account)) purchase_account = '';
		column = column + 1;	
		//alınan teminat hesabı
		received_guarantee_account = trim(Listgetat(satir,column,ayirac));
		if(not len(received_guarantee_account)) received_guarantee_account = '';
		column = column + 1;	
		//verilen teminat hesabı
		given_guarantee_account = trim(Listgetat(satir,column,ayirac));
		if(not len(given_guarantee_account)) given_guarantee_account = '';
		column = column + 1;	
		//alınan avans hesabı
		received_advance_account = trim(Listgetat(satir,column,ayirac));
		if(not len(received_advance_account)) received_advance_account = '';
		column = column + 1;	
		//ihraç kayıtlı satış hesabı
		export_registered_sales_account = trim(Listgetat(satir,column,ayirac));
		if(not len(export_registered_sales_account)) export_registered_sales_account = '';
		column = column + 1;
		//ihraç kayıtlı alış hesabı
		export_registered_buy_account = trim(Listgetat(satir,column,ayirac));
		if(not len(export_registered_buy_account)) export_registered_buy_account = '';
		column = column + 1;  
		if (trim(member_type) is 'B' or trim(member_type) is 'b')
			{
				MEMBER_ID = 'CONSUMER_ID';
				SELECT_TABLE_NAME = 'CONSUMER';
				INSERT_TABLE_NAME = 'CONSUMER_PERIOD';
			}
		else
			{
				MEMBER_ID = 'COMPANY_ID';
				SELECT_TABLE_NAME = 'COMPANY';
				INSERT_TABLE_NAME = 'COMPANY_PERIOD';
			}
		//writeoutput('#member_type#-#period_default#--#member_code#-#account_code#-#konsinye_code#-#is_buyer#-#is_seller#<br/>');
		</cfscript>
		<cfcatch type="Any">  
			<cfset liste=ListAppend(liste,#i#&'. satırda okuma sırasında hata oldu ',',')>
			<cfset error_flag=1>
		</cfcatch>
	</cftry>
 	<cfif len(member_code) and error_flag eq 0>
		<cfquery name="GET_MEMBER_INFO" datasource="#DSN#">
			SELECT #MEMBER_ID# FROM #SELECT_TABLE_NAME# WHERE  #searched_field# = '#trim(member_code)#'
		</cfquery>
		<cfif GET_MEMBER_INFO.recordcount>
			<!--- <cfquery name="RECORD_CONTROL" datasource="#DSN#"><!--- Daha önceden aynı şartlara uyan kayıt yoksa eğer kayıt yap --->
				SELECT ACCOUNT_CODE FROM #INSERT_TABLE_NAME# WHERE #MEMBER_ID# = #Evaluate("GET_MEMBER_INFO.#MEMBER_ID#")# AND PERIOD_ID = #ListGetAt(attributes.PERIOD_ID,1,',')#
			</cfquery> --->
			<!--- <cfif RECORD_CONTROL.recordcount> --->
			<cfquery name="DELETE_ACCOUNT_CODE" datasource="#dsn#">
				DELETE FROM #INSERT_TABLE_NAME# WHERE #MEMBER_ID# = #Evaluate("GET_MEMBER_INFO.#MEMBER_ID#")# AND PERIOD_ID = #ListGetAt(attributes.PERIOD_ID,1,',')#
			</cfquery>
			<!--- </cfif> --->
			<!--- <cfif RECORD_CONTROL.recordcount AND LEN(RECORD_CONTROL.ACCOUNT_CODE)><!--- Daha önceden bir kayıt varsa --->
				<cfset liste=ListAppend(liste,#i#&'. satırdaki üyenin muhasebe kaydı var',',')>
				<cfset error_flag=1>
			<cfif RECORD_CONTROL.recordcount eq 0> --->
				<cfif len(trim(konsinye_code))>
					<cfquery name="KONSINYE_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(konsinye_code)#'
					</cfquery>
				</cfif>
                <cfif len(trim(advance_payment_code))>
					<cfquery name="ADVANCE_PAYMENT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(advance_payment_code)#'
					</cfquery>
				</cfif>
				<cfif len(trim(sales_account))>
					<cfquery name="SALES_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(sales_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(purchase_account))>
					<cfquery name="PURCHASE_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(purchase_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(received_guarantee_account))>
					<cfquery name="RECEIVED_GUARANTEE_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(received_guarantee_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(given_guarantee_account))>
					<cfquery name="GIVEN_GUARANTEE_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(given_guarantee_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(received_advance_account))>
					<cfquery name="RECEIVED_ADVANCE_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(received_advance_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(export_registered_sales_account))>
					<cfquery name="EXPORT_REGISTERED_SALES_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(export_registered_sales_account)#'
					</cfquery>
				</cfif>
				<cfif len(trim(export_registered_buy_account))>
					<cfquery name="EXPORT_REGISTERED_BUY_ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(export_registered_buy_account)#'
					</cfquery>
				</cfif>  
				<cfif len(trim(account_code))><!--- Hesap kodu zorunlu alan. --->
					<cfquery name="ACCOUNT_CODE_CONTROL" datasource="#donem_db#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(account_code)#'
					</cfquery>
					<cfif ACCOUNT_CODE_CONTROL.recordcount>
						<cfquery name="INSERT_ACCOUNT_CODE" datasource="#DSN#">
							INSERT INTO 
								#INSERT_TABLE_NAME#
							(
								#MEMBER_ID#,
								PERIOD_ID,
								ACCOUNT_CODE
								<cfif len(trim(konsinye_code)) and KONSINYE_CODE_CONTROL.recordcount>
									,KONSINYE_CODE
								</cfif>
                                <cfif len(trim(advance_payment_code)) and ADVANCE_PAYMENT_CODE_CONTROL.recordcount>
                                	,ADVANCE_PAYMENT_CODE
								</cfif>
								<cfif len(trim(sales_account)) and SALES_ACCOUNT_CODE_CONTROL.recordcount>
                                	,SALES_ACCOUNT
                                </cfif>
								<cfif len(trim(purchase_account)) and PURCHASE_ACCOUNT_CODE_CONTROL.recordcount>
                                	,PURCHASE_ACCOUNT
								</cfif>
								<cfif len(trim(received_guarantee_account)) and RECEIVED_GUARANTEE_ACCOUNT_CODE_CONTROL.recordcount>
                                	,RECEIVED_GUARANTEE_ACCOUNT
								</cfif>
								<cfif len(trim(given_guarantee_account)) and GIVEN_GUARANTEE_ACCOUNT_CODE_CONTROL.recordcount>
                                	,GIVEN_GUARANTEE_ACCOUNT
								</cfif>
								<cfif len(trim(received_advance_account)) and RECEIVED_ADVANCE_ACCOUNT_CODE_CONTROL.recordcount>
                                	,RECEIVED_ADVANCE_ACCOUNT
								</cfif>
								<cfif len(trim(export_registered_sales_account)) and EXPORT_REGISTERED_SALES_ACCOUNT_CODE_CONTROL.recordcount>
                                	,EXPORT_REGISTERED_SALES_ACCOUNT
								</cfif>
								<cfif len(trim(export_registered_buy_account)) and EXPORT_REGISTERED_BUY_ACCOUNT_CODE_CONTROL.recordcount>
                                	,EXPORT_REGISTERED_BUY_ACCOUNT
								</cfif>
							)
							VALUES
							(
								#Evaluate("GET_MEMBER_INFO.#MEMBER_ID#")#,
								#ListGetAt(attributes.PERIOD_ID,1,',')#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(account_code)#">
								<cfif len(trim(konsinye_code)) and KONSINYE_CODE_CONTROL.recordcount>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(konsinye_code)#"></cfif>
								<cfif len(trim(advance_payment_code)) and ADVANCE_PAYMENT_CODE_CONTROL.recordcount>
                               		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(advance_payment_code)#">
								</cfif>
								<cfif len(trim(sales_account)) and SALES_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sales_account)#">
								</cfif>
								<cfif len(trim(purchase_account)) and PURCHASE_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(purchase_account)#">
								</cfif>
								<cfif len(trim(received_guarantee_account)) and RECEIVED_GUARANTEE_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(received_guarantee_account)#">
								</cfif>	
								<cfif len(trim(given_guarantee_account)) and GIVEN_GUARANTEE_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(given_guarantee_account)#">
								</cfif>	
								<cfif len(trim(received_advance_account)) and RECEIVED_ADVANCE_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(received_advance_account)#">
								</cfif>	
								<cfif len(trim(export_registered_sales_account)) and EXPORT_REGISTERED_SALES_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(export_registered_sales_account)#">
								</cfif>	
								<cfif len(trim(export_registered_buy_account)) and EXPORT_REGISTERED_BUY_ACCOUNT_CODE_CONTROL.recordcount>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(export_registered_buy_account)#">
								</cfif>
                            )
						</cfquery>
						<cfif (trim(member_type) is 'K' or trim(member_type) is 'k') and len(trim(is_buyer)) and len(trim(is_seller)) ><!--- Kurumsal üye ise ve alıcı satıcı alanları dolu ise --->
							<cfquery name="UPDATE_COMPANY_MEMBER" datasource="#dsn#">
								UPDATE
									COMPANY
								SET 	
									 IS_BUYER = #trim(is_buyer)#,
									 IS_SELLER = #trim(is_seller)#
									 <cfif trim(period_default) eq 1>
										 ,PERIOD_ID = #ListGetAt(attributes.PERIOD_ID,1,',')#
									 </cfif>
								WHERE 
									COMPANY_ID = #Evaluate("GET_MEMBER_INFO.#MEMBER_ID#")#
							</cfquery>
						<cfelseif (trim(member_type) is 'B' or trim(member_type) is 'b') and trim(period_default) eq 1>
							<cfquery name="UPDATE_COMPANY_MEMBER" datasource="#dsn#">
								UPDATE
									CONSUMER
								SET 	
									PERIOD_ID = #ListGetAt(attributes.PERIOD_ID,1,',')#
								WHERE 
									CONSUMER_ID = #Evaluate("GET_MEMBER_INFO.#MEMBER_ID#")#
							</cfquery>
						</cfif>
					<cfelse>
						<cfset liste=ListAppend(liste,#i#&'. satırdaki hesap kodu sistemde yok.',',')>
						<cfset error_flag=1>
					</cfif>
				</cfif>
			<!--- <cfelse>
				<cfset liste=ListAppend(liste,#i#&'. satırdaki üyenin birden fazla muhasebe kaydı var ',',')>
				<cfset error_flag=1>
			</cfif>	 --->
		<cfelse>
			<cfset liste=ListAppend(liste,#i#&'. satırda böyle bir üye bulunamadı',',')>
			<cfset error_flag=1>
		</cfif>
	</cfif> 
</cfloop>
<table width="100%" cellpadding="2" cellspacing="1" >
	<tr height="25">
		<td class="txtbold"><cf_get_lang no='2654.Aktarım Sonuçları'></td>
	</tr>
</table>
<table width="100%" cellpadding="2" cellspacing="1" class="color-header">
	<cfif listlen(liste,',') gt 0>
	<cfoutput>
	<tr class="color-list" height="25">
		<td class="txtboldblue">#listlen(liste,',')# kayıtta hatta oluştu. Sorunlu kayıtların no'ları,lütfen bu kayıtları kontrol ediniz</td>
	</tr>
	<cfloop list="#liste#" index="i">
		<tr class="color-row">
			<td>#i#</td>
		</tr>
	</cfloop>
</cfoutput>
	<cfelse>
	<tr class="color-list">
		<td><cfoutput> #counter# !!! sorunsuz kayıt yapıldı</cfoutput></td>
	</tr>
	</cfif>
</table>

