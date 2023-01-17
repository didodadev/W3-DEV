<cf_get_lang_set module_name="sales">
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfinclude template="../query/get_req.cfm">
<cfif not get_opportunity.recordcount>
	<br />
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> Şirketinizde Böyle Bir Numune Bulunamadı !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
	<cfexit method="exittemplate">
</cfif>
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset GET_COUNTRY_1 = cmp.getCountry()>
<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfinclude template="/V16/sales/query/get_opp_currencies.cfm">
<cfinclude template="/V16/sales/query/get_probability_rate.cfm">
<cfinclude template="/V16/sales/query/get_moneys.cfm">
<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
<cfinclude template="/V16/sales/query/get_rival_preference_reasons.cfm">
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
</cfquery>
<cfset contact_flag = 0>
<cfif len(get_opportunity.partner_id)>
	<cfscript>
		member_id = '#get_opportunity.partner_id#';
		contact_type = "p" ;
		contact_id = '#get_opportunity.partner_id#';
		dsp_account =0;
		contact_flag = 1;
	</cfscript>
<cfelseif len(get_opportunity.consumer_id)>
	<cfscript>
		member_id = '#get_opportunity.consumer_id#';
		contact_id = '#get_opportunity.consumer_id#';
  		contact_type = "c";
  		dsp_account = 0;
		contact_flag = 1;
	</cfscript>	
</cfif>
<cfif contact_flag>
	<cfinclude template="/V16/objects/query/get_contact_simple.cfm">
	<cfset sector_cat_id = get_contact_simple.sector_cat_id>
	<cfset company_size_cat_id = get_contact_simple.company_size_cat_id>
<cfelse>
	<cfset sector_cat_id = "">
	<cfset company_size_cat_id = "">
</cfif>


<cfset pageHead = "#getlang('textile',5)#: #get_opportunity.req_no#">
<cf_catalystHeader>
<cfinclude template="detail_req.cfm">
<script type="text/javascript">
//$('.carousel').carousel();
	function kontrol()
	{
		/*
		
		
		if(document.upd_opp.action_date != undefined && document.upd_opp.action_date.value != "")
		{
			if (!date_check(document.upd_opp.opp_date,document.getElementById('action_date'),"Kazanılma Tarihi, Başvuru Tarihinden Önce Olamaz !"))
			return false;
		}
		if(document.getElementById('opp_invoice_date') != undefined && document.getElementById('opp_invoice_date').value != "")
		{
			if (!date_check(document.upd_opp.opp_date,document.upd_opp.opp_invoice_date,"Fatura Tarihi, Başvuru Tarihinden Önce Olamaz !"))
			return false;
		}
		 */
		if (document.upd_opp.member_id.value == '')
		{
			alert ("<cf_get_lang no ='254.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
		 if (document.upd_opp.opportunity_type_id[upd_opp.opportunity_type_id.selectedIndex].value == '')
		{
			alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>!");
			return false;
		}
		if (document.upd_opp.sales_emp_id.value == '' || document.upd_opp.sales_emp.value == '')
		{
			alert ("Müşteri Temsilcisi Seçiniz");
			return false;
		}
		/*
		var n = $("#body_olcu a").length;
        if (n==0)
        {
            alert("Ölçü tablosu ekleyiniz!")
            return false;

        }
			*/
		return (process_cat_control());
	}
	
	function unformat_fields()
	{
		upd_opp.income.value = filterNum(upd_opp.income.value);
		upd_opp.cost.value = filterNum(upd_opp.cost.value);
		return true;
	}
	function addSubscription()
	{
		document.getElementById('add_subscription_contract').submit();	
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->