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
		<cfset member_code = trim(listgetat(dosya[i],1,';'))>
		<cfset detail = trim(listgetat(dosya[i],2,';'))>
		<cfset invoice_number = trim(listgetat(dosya[i],3,';'))>
		<cfset invoice_date = trim(listgetat(dosya[i],4,';'))>
		<cfset due_date = trim(listgetat(dosya[i],5,';'))>
		<cfset action_value = trim(listgetat(dosya[i],6,';'))>
		<cfset other_action_value = trim(listgetat(dosya[i],7,';'))>
		<cfset money_type = trim(listgetat(dosya[i],8,';'))>
		<cfif (listlen(dosya[i],';') gte 9)>
			<cfset paymethod_id = trim(listgetat(dosya[i],9,';'))>
		<cfelse>
			<cfset paymethod_id = ''>
		</cfif>
		<cfif isdefined("invoice_date") and len(invoice_date)>
			<cf_date tarih="invoice_date">
		</cfif>
		<cfif isdefined("due_date") and len(due_date)>
			<cf_date tarih="due_date">
		</cfif>
		<cfif money_type eq 'TRY'>
			<cfset money_type = 'TL'>
		</cfif>
		<!--- odeme yontemi --->
		<cfquery name="get_paymethod" datasource="#dsn#">
			SELECT PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymethod_id#">
		</cfquery>
		<!--- company id --->
		<cfquery name="get_company_id" datasource="#dsn#">
			SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
		</cfquery>
		<!--- para birimi --->
		<cfquery name="get_money_type" datasource="#dsn#">
			SELECT MONEY FROM SETUP_MONEY WHERE MONEY = '#money_type#' AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<!--- invoice_id --->
		<cfif len(invoice_number)>
			<cfquery name="get_invoice_id" datasource="#dsn2#">
				SELECT INVOICE_ID FROM INVOICE WHERE INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_number#">
			</cfquery>
		</cfif>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cfif get_company_id.recordcount neq 0 and get_paymethod.recordcount neq 0 and get_money_type.recordcount neq 0>
					<!--- fatura odeme plani satirlari kaydet --->
					<cfquery name="add_invoice_payment_plan_row" datasource="#dsn3#">
						INSERT INTO
							INVOICE_PAYMENT_PLAN
							(
								PERIOD_ID,
								COMPANY_ID,
								INVOICE_NUMBER,
								INVOICE_ID,
								ACTION_DETAIL,
								INVOICE_DATE,
								DUE_DATE,
								ACTION_VALUE,
								OTHER_ACTION_VALUE,
								PAYMENT_VALUE,
								OTHER_MONEY,
								PAYMENT_METHOD_ROW,
								IS_ACTIVE,
								IS_BANK,
								IS_BANK_IPTAL,
								IS_PAID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
						VALUES
							(
								#session.ep.period_id#,
								#get_company_id.COMPANY_ID#,
								<cfif len(invoice_number)>'#invoice_number#'<cfelse>NULL</cfif>,
								<cfif isdefined("get_invoice_id") and get_invoice_id.recordcount>#get_invoice_id.invoice_id#<cfelse>NULL</cfif>,
								<cfif len(detail)>'#detail#'<cfelse>NULL</cfif>,
								<cfif len(invoice_date)>#invoice_date#<cfelse>NULL</cfif>,
								<cfif len(due_date)>#due_date#<cfelse>NULL</cfif>,
								<cfif len(action_value)>#action_value#<cfelse>0</cfif>,
								<cfif len(other_action_value)>#other_action_value#<cfelse>0</cfif>,
								<cfif len(other_action_value)>#other_action_value#<cfelse>0</cfif>,
								'#get_money_type.MONEY#',
								#get_paymethod.PAYMETHOD_ID#,
								1,
								0,
								0,
								0,
								#now()#,
								#session.ep.userid#,
								'#cgi.remote_addr#'
							)
					</cfquery>
				</cfif>
				<cfoutput>
					<cfif get_company_id.recordcount eq 0>
						#i-1#.<cf_get_lang_main no='1096.Satir'>: Üye Kodu Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
						<cfset kont=0>
						<br />
					<cfelseif get_paymethod.recordcount eq 0>
						#i-1#.<cf_get_lang_main no='1096.Satir'>: Ödeme Yöntemi ID Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
						<cfset kont=0>
						<br />
					<cfelseif get_money_type.recordcount eq 0>
						#i-1#.<cf_get_lang_main no='1096.Satir'>: Para Birimi Eksik ya da Hatalı Olduğu İçin Import Yapılamadı!
						<cfset kont=0>
						<br />
					</cfif>
					<br />
				</cfoutput>	
				<cfif kont eq 1>
					<cfoutput>#i-1#. Satır İmport Edildi.<br/></cfoutput>
				</cfif>
			</cftransaction>
		</cflock>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
		</cfcatch>  
	</cftry>
</cfloop>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_invoice_payment_plan_import</cfoutput>";
</script>
