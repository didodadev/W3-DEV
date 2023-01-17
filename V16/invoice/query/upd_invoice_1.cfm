<!--- 20050302 buradaki dosya siralari performans ve oncelik dusunulerek duzenlendi bilgi disinda degistirmeyin --->
<cfinclude template="check_product_exists.cfm">
<cfscript>
	attributes.acc_type_id = '';
	if(isdefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif isdefined("attributes.note")><cfset note = attributes.note></cfif>
<cfset 	form.basket_rate2 = form.basket_rate2 / form.basket_rate1>
<cfset session_base = evaluate('session.ep')>
<cf_date tarih='attributes.invoice_date'>
<cfif isdefined("attributes.ship_date") and len(attributes.ship_date)>
	<cf_date tarih='attributes.ship_date'>
</cfif>
<cfif isdefined('attributes.realization_date') and isdate(attributes.realization_date)>
	<cf_date tarih='attributes.realization_date'>
</cfif>
<cfset invoice_due_date = "">
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfquery name="GET_UNIQUE" datasource="#dsn2#">
	SELECT 
		INVOICE_ID
	FROM 
		INVOICE
	WHERE 
		INVOICE_NUMBER='#form.invoice_number#' AND
		INVOICE_ID <> #form.invoice_id# AND
		PURCHASE_SALES = 1
</cfquery>
<cfif get_unique.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz Fatura No Kullanılmış Lütfen Kontrol Edin !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template="check_taxes.cfm">
<cfinclude template="get_basket_irs.cfm">

<!--- YO20062802 Gelen fatura tarihine gore vade tarihi bulunur --->
<!--- BK 20070711 Metaldeki vade tarihinin siparisdeki tarihe gore olusmasi icin eklendi  Blok include vade tarihi icin --->
<cfif session.ep.our_company_info.workcube_sector is 'metal' and isdefined("attributes.xml_calc_due_date") and attributes.xml_calc_due_date eq 1>
	<cfinclude template="metal_invoice_due_date.cfm">
<cfelse>
	<cfif isdefined("attributes.basket_due_value_date_") and isdate(attributes.basket_due_value_date_)>
		<cf_date tarih="attributes.basket_due_value_date_">
		<cfset invoice_due_date = '#attributes.basket_due_value_date_#'>
	</cfif>
</cfif>
<cfscript>
	include('get_bill_process_cat.cfm');
	include('check_disc_accs.cfm');
	attributes.currency_multiplier = '';//basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor
	paper_currency_multiplier ='';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cfif is_export_registered eq 1>
	<cfloop from = "1" to = "#attributes.rows_#" index = "r">
		<cfif isDefined("attributes.row_bsmv_amount#r#") and evaluate("attributes.row_bsmv_amount#r#") gt 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57181.İhraç kayıtlı faturada BSMV seçilemez'>!");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="get_ship_id" datasource="#dsn2#"><!--- faturanın kendi irsaliyesi varsa alır ve faturanın kendi irsaliyesi faturayla aynı dönemde olur.--->
	SELECT 
		INV_S.SHIP_ID,
		INV_S.INVOICE_NUMBER,
		INV_S.SHIP_NUMBER,
		INV_S.IS_WITH_SHIP,
		S.SHIP_TYPE
	FROM 
		INVOICE_SHIPS INV_S,
		SHIP S
	WHERE 
		INV_S.SHIP_ID=S.SHIP_ID AND
		INV_S.INVOICE_ID = #form.invoice_id# AND
		INV_S.IS_WITH_SHIP=1 
</cfquery>
<cfif not included_irs and not isdefined('xml_import') and not isdefined("is_from_zreport") and Listfind('52,53,531,62,5311,533',invoice_cat,',')>
	<cfif get_ship_id.recordcount>
		<cfquery name="GET_SALE_SHIP" datasource="#dsn2#">
			SELECT SHIP_ID,SHIP_NUMBER FROM SHIP WHERE PURCHASE_SALES = 1 AND SHIP_NUMBER = '#form.invoice_number#' AND SHIP_ID <> #get_ship_id.ship_id#
		</cfquery>
		<cfif GET_SALE_SHIP.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no='35.Girdiğiniz İrsaliye Numarası Kullanılıyor'>!");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfquery name="GET_INV_INFO" datasource="#dsn2#"><!--- upd_invoice_3 de cari kapamalar için kullanılıyor silmeyiniz --->
	SELECT NETTOTAL,DUE_DATE FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="get_customer_info" datasource="#DSN2#">
		SELECT
			SALES_COUNTY,
			COMPANY_VALUE_ID AS CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID,
			PROFILE_ID
		FROM
			#dsn_alias#.COMPANY
		WHERE
			COMPANY_ID=#attributes.company_id#
	</cfquery>
	<cfif len(get_customer_info.profile_id) and not (inv_profile_id is 'YOLCUBERABERFATURA' or inv_profile_id is 'IHRACAT')><cfset inv_profile_id = get_customer_info.profile_id></cfif>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_customer_info" datasource="#DSN2#">
		SELECT
			SALES_COUNTY,
			CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID,
			PROFILE_ID
		FROM
			#dsn_alias#.CONSUMER
		WHERE
			CONSUMER_ID=#attributes.consumer_id#
	</cfquery>
	<cfif len(get_customer_info.profile_id) and not (inv_profile_id is 'YOLCUBERABERFATURA' or inv_profile_id is 'IHRACAT')><cfset inv_profile_id = get_customer_info.profile_id></cfif>
</cfif>

<!--- Satış çalışanının takımı alınıyor --->
<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
	<cfquery name="get_branch_id" datasource="#dsn#">
		SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id#
	</cfquery>
	<cfquery name="get_team_id" datasource="#dsn#">
		SELECT 
			SZTR.TEAM_ID 
		FROM 
			SALES_ZONES_TEAM_ROLES SZTR,
			SALES_ZONES_TEAM SZT
		WHERE 
			SZTR.TEAM_ID = SZT.TEAM_ID
			AND SZTR.POSITION_CODE IN(SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.EMPO_ID#)
			AND SZT.SALES_ZONES IN(SELECT SZ_ID FROM SALES_ZONES WHERE RESPONSIBLE_BRANCH_ID = #get_branch_id.branch_id#)
	</cfquery>
	<cfif get_team_id.recordcount>
		<cfset emp_team_id = get_team_id.team_id>
	<cfelse>
		<cfset emp_team_id = ''>
	</cfif>
</cfif>

<cfswitch expression="#invoice_cat#">
	<cfcase value="50"><cfset str_line_detail = "#attributes.comp_name# VERİLEN VADE FARKI FATURASI" ></cfcase>
	<cfcase value="52"><cfset str_line_detail = "#attributes.comp_name# PERAKENDE SATIŞ FATURASI" ></cfcase>
	<cfcase value="53"><cfset str_line_detail = "#attributes.comp_name# TOPTAN SATIŞ FATURASI" ></cfcase>
	<cfcase value="56"><cfset str_line_detail = "#attributes.comp_name# VERİLEN HİZMET FATURASI" ></cfcase>
	<cfcase value="57"><cfset str_line_detail = "#attributes.comp_name# VERİLEN PROFORMA FATURASI" ></cfcase>
	<cfcase value="58"><cfset str_line_detail = "#attributes.comp_name# VERİLEN FİYAT FARKI FATURASI" ></cfcase>
	<cfcase value="62"><cfset str_line_detail = "#attributes.comp_name# ALIM İADE FATURASI" ></cfcase>
	<cfcase value="531"><cfset str_line_detail = "#attributes.comp_name# İHRACAT FATURASI" ></cfcase>
	<cfcase value="680"><cfset str_line_detail = "#attributes.comp_name# SERBEST MESLEK MAKBUZU - SATIS" ></cfcase>
	<cfcase value="640"><cfset str_line_detail = "#attributes.comp_name# MÜSTAHSİL MAKBUZU - SATIS" ></cfcase>
	<cfcase value="533"><cfset str_line_detail = "#attributes.comp_name# KDV DEN MUAF SATIŞ FATURASI" ></cfcase>
	<cfcase value="5311"><cfset str_line_detail = "#attributes.comp_name# İHRAÇ KAYITLI SATIŞ FATURASI" ></cfcase>
	<cfcase value="5312"><cfset str_line_detail = "#attributes.comp_name# BAVUL TİCARETİ SATIŞ FATURASI" ></cfcase>
	<cfdefaultcase><cfset str_line_detail = " " ></cfdefaultcase>
</cfswitch>
