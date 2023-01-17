<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.list_bill">
<cfif session.ep.our_company_info.is_efatura>
	<cfinclude template="../fbx_download.cfm">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.EMPO_ID" default="">
<cfparam name="attributes.PARTO_ID" default="">
<cfparam name="attributes.EMP_PARTNER_NAMEO" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.iptal_invoice" default="0">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.budget_record" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.earchive_type" default="">
<cfparam name="attributes.output_type" default="">
<cfparam name="attributes.invoice_type" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif not isdefined("form_varmi")>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date = ''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
	</cfif>
<cfelse>
	<cfset attributes.start_date = ''>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif not isdefined("form_varmi")>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date = ''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
<cfelse>
	<cfset attributes.finish_date = ''>
</cfif>
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih= "attributes.record_date">
</cfif>
<cfset islem_tipi = '48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,690,691,65,66,68,531,532,591'>
<cfif session.ep.our_company_info.workcube_sector eq 'per'>
	<cfset islem_tipi = islem_tipi&',592'>
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfinclude template="../member/query/get_company_cat.cfm">
<cfinclude template="../member/query/get_consumer_cat.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<!--- cfc dosyasında date_add fonksiyonu için fbx_workcube_funcs dosyasını çağırmamak için dateadd işlemini burada yapıyorum py--->
<cfif isdefined("attributes.record_date2") and len(attributes.record_date2)>
	<cfset rec_date1 = date_add('d',1,attributes.record_date2)>
<cfelse>
	<cfset rec_date1 = ''>
</cfif>
<cfif isdefined("attributes.record_date") and len(attributes.record_date)>
	<cfset rec_date2 = date_add('d',1,attributes.record_date)>
<cfelse>
	<cfset rec_date2 = ''>
</cfif>
<cfif isdefined("attributes.form_varmi")>
<cfscript>
	get_bill_action = createObject("component", "invoice.cfc.get_bill");
	get_bill_action.dsn2 = dsn2;
	get_bill_action.dsn_alias = dsn_alias;
	get_bill_action.dsn3_alias = dsn3_alias;
	get_bill = get_bill_action.get_bill_fnc
		(
			listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
			control : '#IIf(IsDefined("attributes.control"),"attributes.control",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			budget_record : '#IIf(IsDefined("attributes.budget_record"),"attributes.budget_record",DE(""))#',
			module_name : '#IIf(IsDefined("fusebox.circuit"),"fusebox.circuit",DE(""))#',
			company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			empo_id : '#IIf(IsDefined("attributes.empo_id"),"attributes.empo_id",DE(""))#',
			parto_id : '#IIf(IsDefined("attributes.parto_id"),"attributes.parto_id",DE(""))#',
			detail : '#IIf(IsDefined("attributes.detail"),"attributes.detail",DE(""))#',
			cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
			card_paymethod_id : '#IIf(IsDefined("attributes.card_paymethod_id"),"attributes.card_paymethod_id",DE(""))#',
			payment_type_id : '#IIf(IsDefined("attributes.payment_type_id"),"attributes.payment_type_id",DE(""))#',
			payment_type : '#IIf(IsDefined("attributes.payment_type"),"attributes.payment_type",DE(""))#',
			belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			department_txt : '#IIf(IsDefined("attributes.department_txt"),"attributes.department_txt",DE(""))#',
			department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
			record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
			record_emp_name : '#IIf(IsDefined("attributes.record_emp_name"),"attributes.record_emp_name",DE(""))#',
			record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			rec_date1 : '#rec_date1#',
			rec_date2 : '#rec_date2#',
			record_date2 : '#IIf(IsDefined("attributes.record_date2"),"attributes.record_date2",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			iptal_invoice : '#IIf(IsDefined("attributes.iptal_invoice"),"attributes.iptal_invoice",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
			is_tevkifat : '#IIf(IsDefined("attributes.is_tevkifat"),"attributes.is_tevkifat",DE(""))#',
			turned_to_total_inv : '#IIf(IsDefined("attributes.turned_to_total_inv"),"attributes.turned_to_total_inv",DE(""))#',
			acc_type_id : '#IIf(IsDefined("attributes.acc_type_id"),"attributes.acc_type_id",DE(""))#',
			oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
			EMP_PARTNER_NAMEO : '#IIf(IsDefined("attributes.EMP_PARTNER_NAMEO"),"attributes.EMP_PARTNER_NAMEO",DE(""))#',
			startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			efatura_type: '#IIf(len(attributes.efatura_type),"attributes.efatura_type",DE(""))#',
			earchive_type: '#IIf(len(attributes.earchive_type),"attributes.earchive_type",DE(""))#',
			output_type: '#IIf(len(attributes.output_type),"attributes.output_type",DE(""))#',
			invoice_type: '#IIf(len(attributes.invoice_type),"attributes.invoice_type",DE(""))#'
			);
	</cfscript>
	<cfif get_bill.recordcount>
		<cfparam name="attributes.totalrecords" default="#get_bill.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfif session.ep.our_company_info.is_earchive>
    <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
        SELECT
            EARCHIVE_INTEGRATION_TYPE
        FROM
            EARCHIVE_INTEGRATION_INFO
        WHERE
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
</cfif>
<script type="text/javascript">
	$( document ).ready(function() {
    	document.getElementById('belge_no').focus();
	});		
	
	function send_print_reset()
	{
		invioce_id_list_ = "";
		for (i=0; i < document.form_print_reset.print_invoice_id.length; i++)
		{
			if(document.form_print_reset.print_invoice_id[i].checked == true)
			{
				invioce_id_list_ = invioce_id_list_ + document.form_print_reset.print_invoice_id[i].value + ',';
			}	
		}
		if(invioce_id_list_.length == 0)
		{
			alert("<cf_get_lang no='390.Güncellenecek Kayıt Bulunamadı ! Print Sıfırlama Yapamazsınız'> !");
			return false;
		}
		
		if(confirm("<cf_get_lang no ='407.Şeçtiğiniz Faturaların Print Sayısı Sıfırlanacaktır Onaylıyormusunuz'> ?"))
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.emptypopup_collected_print_reset&print_invoice_id='+invioce_id_list_,'page');
		else 
			return false;
	}
	
	function input_control()
	{
		<cfif not session.ep.our_company_info.unconditional_list and (isdefined("url.cat") and (url.cat eq 561 or url.cat eq 601 or url.cat eq 56 or url.cat eq 1 or url.cat eq 60 or url.cat eq 0))>
			if (form.start_date.value.length == 0 && form.finish_date.value.length == 0 &&form.belge_no.value.length == 0 && (form.department_id.value.length == 0 || form.department_txt.value.length == 0) && form.cat.value.length == 0 && (form.product_name.value.length == 0 || form.product_id.value.length == 0) && (form.company_id.value.length == 0 || form.company.value.length == 0) )
			{
				alert("<cf_get_lang_main no='114.En az bir alanda filtre etmelisiniz'> !");
				return false;
			}
			else 
				return true;
		<cfelse>
			return true;
		</cfif>
	}
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_bill';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'invoice/display/list_bill.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'invoice/query/list_bill.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'invoice.list_bill';
	
</cfscript>
