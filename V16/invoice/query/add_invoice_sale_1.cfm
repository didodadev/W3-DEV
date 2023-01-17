<cf_get_lang_set module_name="invoice">
<cfscript>
	attributes.acc_type_id = '';
	if(isdefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfinclude template = "../../objects/query/session_base.cfm">
<cfset 	form.basket_rate2 = form.basket_rate2 / form.basket_rate1>
<cfif isdefined("attributes.note")>
	<cfset note = attributes.note>
</cfif>
<!--- 20050302 buradaki dosya siralari performans ve oncelik dusunulerek duzenlendi bilgi disinda degistirmeyin --->
<cfif not isdefined('xml_import')>
	<cfinclude template="check_product_exists.cfm">
</cfif>
<cfif not isdefined("is_action_file_")><!--- action file icinde fatura ekleme kullanildiginda sorun oldugundan kaldirildi --->
	<cf_date tarih='attributes.invoice_date'>
</cfif>
<cfif isdefined("attributes.ship_date") and len(attributes.ship_date)>
	<cf_date tarih='attributes.ship_date'>
</cfif>
<cfif isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm)>
	<cf_date tarih='attributes.deliver_date_frm'>
</cfif>
<cfif isdefined('attributes.realization_date') and isdate(attributes.realization_date)>
	<cf_date tarih='attributes.realization_date'>
</cfif>
<cfset invoice_due_date = "">
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined('xml_import') or isdefined("is_from_ship_action")>
	<cfquery name="GET_SALE" datasource="#new_dsn2_group#">
		SELECT
			INVOICE_NUMBER,
			PURCHASE_SALES
		FROM
			INVOICE
		WHERE
			PURCHASE_SALES = 1 AND 
			INVOICE_NUMBER='#form.invoice_number#'
	</cfquery>
	<cfif get_sale.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='34.Girdiğiniz Fatura Numarası Kullanılıyor !'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfinclude template="check_taxes.cfm">
<cfinclude template="get_basket_irs.cfm">

<cfif not isdefined('xml_import') and session_base.our_company_info.workcube_sector is 'metal' and isdefined("attributes.xml_calc_due_date") and attributes.xml_calc_due_date eq 1>
	<cfinclude template="metal_invoice_due_date.cfm">
<cfelse>
	<cfif isdefined("attributes.basket_due_value_date_") and isdate(attributes.basket_due_value_date_)>
		<cf_date tarih="attributes.basket_due_value_date_">
		<cfset invoice_due_date = '#attributes.basket_due_value_date_#'>
	</cfif>
</cfif>
<cfif isdefined("attributes.paper")>
	<cfset paper_num = attributes.paper>
</cfif>
<cfinclude template="get_bill_process_cat.cfm">

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

<cfif not included_irs and not isdefined('xml_import') and not isdefined("is_from_zreport") and Listfind('52,53,531,62,5311,533',invoice_cat,',')>
	<cfquery name="GET_SALE_SHIP" datasource="#new_dsn2_group#">
		SELECT SHIP_ID FROM SHIP WHERE PURCHASE_SALES = 1 AND SHIP_NUMBER = '#form.invoice_number#'
	</cfquery>
	<cfif GET_SALE_SHIP.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='35.Girdiğiniz İrsaliye Numarası Kullanılıyor'>!");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn2_group#">
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
	<cfif len(get_customer_info.profile_id) and not (inv_profile_id is 'YOLCUBERABERFATURA' or inv_profile_id is 'IHRACAT')>
		<cfset inv_profile_id = get_customer_info.profile_id>
    </cfif>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn2_group#">
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
	<cfif len(get_customer_info.profile_id) and not (inv_profile_id is 'YOLCUBERABERFATURA' or inv_profile_id is 'IHRACAT')>
		<cfset inv_profile_id = get_customer_info.profile_id>
    </cfif>
</cfif>

<!--- Satış çalışanının takımı alınıyor --->
<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID) and len(attributes.department_id)>
	<cfquery name="get_branch_id" datasource="#new_dsn2_group#">
		SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id#
	</cfquery>
	<cfquery name="get_team_id" datasource="#dsn#">
		SELECT 
			SZTR.TEAM_ID 
		FROM 
			#dsn_alias#.SALES_ZONES_TEAM_ROLES SZTR,
			#dsn_alias#.SALES_ZONES_TEAM SZT
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

<cfinclude template="check_disc_accs.cfm">
<!--- basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor--->
<cfset attributes.currency_multiplier = ''>
<cfset paper_currency_multiplier = ''>
<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
	<cfloop from="1" to="#attributes.kur_say#" index="mon">
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is session_base.money2>
			<cfset attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money>
			<cfset paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
	</cfloop>	
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
