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
		<cfset subscription_no = trim(listgetat(dosya[i],1,';'))>
		<cfset payment_date = trim(listgetat(dosya[i],2,';'))>
		<cfset product = trim(listgetat(dosya[i],3,';'))>
		<cfset paymethod_id = trim(listgetat(dosya[i],4,';'))>
		<cfset quantity = trim(listgetat(dosya[i],5,';'))>
		<cfset amount = trim(listgetat(dosya[i],6,';'))>
		<cfset amount_tax = trim(listgetat(dosya[i],7,';'))>
		<cfset money_type = trim(listgetat(dosya[i],8,';'))>
		<cfset discount = trim(listgetat(dosya[i],9,';'))>
		<cfset discount_amount = trim(listgetat(dosya[i],10,';'))>
		<cfset fat_dah = trim(listgetat(dosya[i],11,';'))>
		<cfif (listlen(dosya[i],';') gte 12)>
			<cfset camp_id = trim(listgetat(dosya[i],12,';'))>
		<cfelse>
			<cfset camp_id = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
			<script>
				window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_payment_plan_import"	
			</script>
		</cfcatch>  
	</cftry>
	<cfif len(payment_date)>
		<cf_date tarih="payment_date">
	</cfif>
	<cfif len(paymethod_id)>
		<cfquery name="get_paymethod" datasource="#dsn#">
			SELECT PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymethod_id#">
		</cfquery>
	<cfelse>
		<cfset get_paymethod.paymethod_id=''>
	</cfif>
	<cfif len(subscription_no)>
		<cfquery name="get_subscription" datasource="#DSN3#">
			SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE IS_ACTIVE = 1 AND (SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subscription_no#"> OR SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subscription_no#">)
		</cfquery>
	<cfelse>	
		<cfset get_subscription.subscription_id = ''>		
	</cfif>
	<cfif len(camp_id)>
		<cfquery name="get_campaign" datasource="#dsn3#">
			SELECT CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
		</cfquery>
	<cfelse>
		<cfset get_campaign.camp_id = ''>
	</cfif>
	<cfif len(product)>
		<cfquery name="get_product" datasource="#DSN3#">
			SELECT P.PRODUCT_ID,P.TAX,P.OTV,P.PRODUCT_NAME,S.STOCK_ID FROM PRODUCT P, STOCKS S WHERE P.PRODUCT_ID = S.PRODUCT_ID AND (<cfif len(product) and isnumeric(product)>P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product#"> OR</cfif> P.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#"> OR P.PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">)
		</cfquery>
		<cfif get_product.recordcount>
			<cfquery name="GET_UNIT" datasource="#DSN3#">
				SELECT MAIN_UNIT,UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">
			</cfquery>
		<cfelse>
			<cfset get_product.product_id = ''>
			<cfset get_product.stock_id = ''>
			<cfset get_product.product_name = ''>
			<cfset get_unit.unit_id = ''>
			<cfset get_unit.main_unit = ''>
			<cfset get_product.tax = 0>
			<cfset get_product.otv = 0>
		</cfif>
	<cfelse>
		<cfset get_product.product_id = ''>
		<cfset get_product.stock_id = ''>
		<cfset get_product.product_name = ''>
		<cfset get_unit.unit_id = ''>
		<cfset get_unit.main_unit = ''>
		<cfset get_product.tax = 0>
		<cfset get_product.otv = 0>
	</cfif>
	<cfif get_product.otv eq ''>
		<cfset otv_ = 0>
	<cfelse>
		<cfset otv_ = get_product.otv>
	</cfif>
	<cfif get_product.tax eq ''>
		<cfset tax_ = 0>
	<cfelse>
		<cfset tax_ = get_product.tax>
	</cfif>
	<!--- <cfset otv_ = get_product.otv> --->
	<cfif len(amount) and not len(amount_tax)>
		<cfset amount_ = amount>
	<cfelseif not len(amount) and len(amount_tax)>
		<cfset amount_ = (amount_tax*100/(tax_+otv_+100))>
	<cfelseif len(amount) and len(amount_tax)>
		<cfset amount_ = amount>
	<cfelse>
		<cfset amount_ = ''>
	</cfif>
	<cfif len(amount_) and len(quantity)>
		<cfset row_total = amount_ * quantity>
	<cfelse>
		<cfset row_total = 0>
	</cfif>
	<cfif len(discount_amount)>
		<cfset disc_amount = discount_amount * quantity>
	<cfelse>
		<cfset disc_amount = 0>
	</cfif>	
	<cfset row_total = row_total - disc_amount>
	<cfif len(discount)>
		<cfset indirim = row_total * discount / 100>
	<cfelse>
		<cfset indirim = 0>
	</cfif>
	
	<cfset row_net_total = row_total - indirim>
	
	<cfif len(fat_dah) and fat_dah eq 1>
		<cfset is_group_inv = 0>
		<cfset is_collected_inv = 1>
	<cfelseif len(fat_dah) and fat_dah eq 0>
		<cfset is_group_inv = 1>
		<cfset is_collected_inv = 0>
	<cfelse>
		<cfset is_group_inv = ''>
		<cfset is_collected_inv = ''>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="add_payment_plan_row" datasource="#dsn3#">
					INSERT INTO
						SUBSCRIPTION_PAYMENT_PLAN_ROW
						(
							SUBSCRIPTION_ID,
							PRODUCT_ID,
							STOCK_ID,
							DETAIL,
							PAYMENT_DATE,
							QUANTITY,
							UNIT_ID,
							UNIT,
							AMOUNT,
							MONEY_TYPE,
							ROW_TOTAL,
							ROW_NET_TOTAL,
							DISCOUNT,
							DISCOUNT_AMOUNT,
							IS_COLLECTED_INVOICE,
							IS_GROUP_INVOICE,
							PAYMETHOD_ID,
							CAMPAIGN_ID,
							IS_PAID,
							IS_BILLED,
							IS_COLLECTED_PROVISION,
							IS_ACTIVE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP
						)
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.stock_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(get_product.product_name,50)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#payment_date#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#quantity#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_unit.unit_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.main_unit#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#amount_#">,
							<cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"></cfif>,
							<cfqueryparam cfsqltype="cf_sql_float" value="#row_total#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#row_net_total#">,
							<cfif len(discount)><cfqueryparam cfsqltype="cf_sql_float" value="#discount#"><cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_float" value="#disc_amount#">,
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#is_collected_inv#">,
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#is_group_inv#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_paymethod.paymethod_id#">,
							<cfif len(camp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_campaign.camp_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
							0,
							0,
							0,
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
						)
				</cfquery>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda
							<cfif not len(subscription_no)>
								Abone No veya Özel Kod Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(product) or get_product.recordcount eq 0>
								Ürün Id, Stok Kodu veya Özel Kod Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(payment_date)>
								Tarih Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(paymethod_id)>
								Ödeme Yöntemi Id Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(quantity)>
								Miktar Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(amount) and not len(amount_tax)>
								Tutar Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(fat_dah)>
								Faturalama Bilgisi Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<cfif not len(money_type)>
								Para Birimi Eksik Olduğu için Import Yapılamadı!
							</cfif>
							<br />
							<script>
								window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_payment_plan_import"	
							</script>
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<br/><cf_get_lang dictionary_id='44493.Aktarım Tamamlandı'>
	<script>
		window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_payment_plan_import"	
	</script>
