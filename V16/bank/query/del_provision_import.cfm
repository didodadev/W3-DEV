<cfset CRLF = Chr(13)&Chr(10)><!--- satır atlama karakteri --->
<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT SOURCE_SYSTEM,FILE_NAME,FILE_CONTENT FROM FILE_IMPORTS WHERE PROCESS_TYPE = -7 AND I_ID = #attributes.export_import_id# AND IMPORTED = 1
</cfquery>
<cfif GET_IMPORT.recordcount>
	<cfif not len(GET_IMPORT.FILE_CONTENT)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='389.Şifrenizi Kontrol Ediniz'>!");
			wrk_opener_reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfif isdefined("attributes.key_type")>
		<cfset file_content_result = Decrypt(GET_IMPORT.FILE_CONTENT,attributes.key_type,"CFMX_COMPAT","Hex")>
	<cfelse>
		<cfset file_content_result = GET_IMPORT.FILE_CONTENT>
	</cfif>
	<cfset kontrol_part = left(file_content_result,6)>
	<cfset dosya = ListToArray(file_content_result,CRLF)>
	<cfif not(IsNumeric(kontrol_part) or kontrol_part eq "HEADER" or left(kontrol_part,3) eq "H20" or left(kontrol_part,1) eq "O" or left(kontrol_part,2) eq "HM")><!--- encrypt in doğru açılması kontrolu --->
		<script type="text/javascript">
			alert("<cf_get_lang no ='389.Şifrenizi Kontrol Ediniz'>!");
			wrk_opener_reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfscript>
		if (listfind("2,4,5,6,10",GET_IMPORT.SOURCE_SYSTEM,','))//TPOS - TEB - İşbank - YKB		
			ArrayDeleteAt(dosya,1);//header satırını silmek için
		else if(GET_IMPORT.SOURCE_SYSTEM eq 3){//HSBC
			for(i = 1; i lte 3; i=i+1)
				ArrayDeleteAt(dosya,1);}//header satırını silmek için
		line_count = ArrayLen(dosya);
	</cfscript>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfif GET_IMPORT.SOURCE_SYSTEM eq 2><!--- HSBC --->
				<cfscript>//ilk satırdan dönem kontrolu
					satir = dosya[1];
					prov_row_id = oku(satir,Find(".",satir)+1,Find(" ",satir)-1);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript"><!--- Belge kontrolu --->
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,1,Find(".",satir)-1);//invoice idsi
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 1><!--- GARANTI text format--->
				<cfscript>// ilk satırdan dönem kontrolu
					satir = dosya[1];
					prov_row_id = oku(satir,451,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,481,30);
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 3><!--- GARANTI TPOS format--->
				<cfscript>// ilk satırdan dönem kontrolu
					satir = dosya[1];
					prov_row_id = oku(satir,90,10);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-2#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,100,10);
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 4><!--- TEB format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = oku(satir,42,20);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,62,255);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 5><!--- İşBankası format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = ListGetAt(oku(satir,133,30),2,'.');//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-2#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = ListGetAt(oku(satir,133,30),1,'.');//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 6><!--- YKB format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = ListGetAt(oku(satir,96,74),2,'.');//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = ListGetAt(oku(satir,96,74),1,'.');//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 10><!--- Banksoft format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = oku(satir,4,15);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,171,50);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 7><!--- Akbank format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = oku(satir,376,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,406,30);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 8><!--- denizbank format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = oku(satir,376,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,406,30);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.SOURCE_SYSTEM eq 9><!--- ing format--->
				<cfscript>// ilk satırdan dönem kontrolu 
					satir = dosya[1];
					prov_row_id = oku(satir,376,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='406.Lütfen Döneminizi Kontrol Ediniz'>!");
						wrk_opener_reload();
						window.close();
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,406,30);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_PAID = 0,
							CARI_ACTION_ID = NULL,
							CARI_PERIOD_ID = NULL,
							CARI_ACT_TYPE = NULL,
							CARI_ACT_ID = NULL,
							CARI_ACT_TABLE = NULL,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
							AND 
							(
								<!---CARI_ACT_ID IS NULL
								OR--->
								(
									CARI_ACT_ID IS NOT NULL
									AND CARI_ACT_TYPE = 241
									AND CARI_ACT_ID IN
									(
										SELECT 
											CREDITCARD_PAYMENT_ID 
										FROM 
											#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
										WHERE 
											FILE_IMPORT_ID = #attributes.export_import_id# AND
											ACTION_PERIOD_ID = #session.ep.period_id#
									)
								)
							)
					</cfquery>
				</cfloop>
			</cfif>
			<cfquery name="DEL_CREDIT_CARD_PAY_ROWS" datasource="#dsn2#">
				DELETE FROM 
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS 
				WHERE 
					CREDITCARD_PAYMENT_ID IN 
					(
						SELECT 
							CREDITCARD_PAYMENT_ID 
						FROM 
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
						WHERE 
							FILE_IMPORT_ID = #attributes.export_import_id# AND
							ACTION_PERIOD_ID = #session.ep.period_id#
					)
			</cfquery>
			<cfquery name="DEL_CREDIT_CARD_PAY_MONEY" datasource="#dsn2#">
				DELETE FROM 
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY 
				WHERE 
					ACTION_ID IN 
					(
						SELECT 
							CREDITCARD_PAYMENT_ID 
						FROM 
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
						WHERE 
							FILE_IMPORT_ID = #attributes.export_import_id# AND
							ACTION_PERIOD_ID = #session.ep.period_id#
					)
			</cfquery>
			<cfquery name="DEL_CARI_ROWS" datasource="#dsn2#">
				DELETE FROM 
					CARI_ROWS 
				WHERE 
					ACTION_TYPE_ID = 241 AND
					ACTION_ID IN 
					(
						SELECT 
							CREDITCARD_PAYMENT_ID 
						FROM 
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
						WHERE 
							FILE_IMPORT_ID = #attributes.export_import_id# AND
							ACTION_PERIOD_ID = #session.ep.period_id#
					)
			</cfquery>
			<cfquery name="GET_CARD_ID" datasource="#dsn2#">
				 SELECT
					CARD_ID
				 FROM
					ACCOUNT_CARD
				 WHERE
					ACTION_TYPE = 241 AND
					ACTION_ID IN 
					(
						SELECT 
							CREDITCARD_PAYMENT_ID 
						FROM 
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
						WHERE 
							FILE_IMPORT_ID = #attributes.export_import_id# AND
							ACTION_PERIOD_ID = #session.ep.period_id#
					)
			</cfquery>
			<cfif GET_CARD_ID.RECORDCOUNT>
				<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#dsn2#">
					DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
				<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#dsn2#">
					DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
				<cfquery name="DEL_ACCOUNT_CARD" datasource="#dsn2#">
					DELETE FROM ACCOUNT_CARD WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
			</cfif>
			<cfquery name="DEL_CREDIT_CARD_PAY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE FILE_IMPORT_ID = #attributes.export_import_id# AND ACTION_PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<cfquery name="DEL_CREDIT_CARD_PAY" datasource="#dsn2#">
				UPDATE FILE_IMPORTS SET IMPORTED = 0 WHERE I_ID = #attributes.export_import_id#
			</cfquery>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		opener.location.reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='414.Bu Belge İçin Import İşlemi Geri Alınmıştır'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_multi_provision_import</cfoutput>';
	</script>
	<cfabort>
</cfif>	
