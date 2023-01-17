<cf_get_lang_set module_name="finance">
<cfinclude template="../finance/query/get_money.cfm">
<cfif isdefined("attributes.event") and not attributes.event is "list">
	<cfif not get_money.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang no='407.Sisteme Kayıtlı Döviz Bilgisi Bulunmamaktadır'>!");
            window.close();
        </script>
        <cfabort>
    </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.date1" default="">
    <cfparam name="attributes.date2" default="">
    <cfparam name="attributes.valid_date1" default="">
    <cfparam name="attributes.valid_date2" default="">
    <cfparam name="attributes.money" default="">
    <cfset attributes.ses_id=1>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../finance/query/get_currency_info.cfm">
    <cfelse>
        <cfset get_currency.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_currency.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is "add_other">
	<cfparam name="attributes.record_date" default="#dateformat(now(),'dd/mm/yyyy')#">
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
	<script type="text/javascript">
			$(document).ready(function(){
				document.getElementById('keyword').focus();	
			});
		function kontrol()
		{
			
				if( !date_check(document.getElementById('valid_date1'),document.getElementById('valid_date2'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				if( !date_check(document.getElementById('date1'),document.getElementById('date2'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
			return true;
		}
	</script>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "add_other") >
	<script type="text/javascript">
		function unformat_fields()
		{
			add_currency.amount.value = filterNum(add_currency.amount.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amount2.value = filterNum(add_currency.amount2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amountpp.value = filterNum(add_currency.amountpp.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amountpp2.value = filterNum(add_currency.amountpp2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amountww.value = filterNum(add_currency.amountww.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amountww2.value = filterNum(add_currency.amountww2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amount3.value = filterNum(add_currency.amount3.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency.amount4.value = filterNum(add_currency.amount4.value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById("rate1").value = filterNum(document.getElementById("rate1").value,'#session.ep.our_company_info.rate_round_num#');
		}
		function kontrol()
		{
			if ((document.getElementById("rate1").value =='') || (document.getElementById("rate1").value == 0))
			{
				alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!");
				return false;
			}
			unformat_fields();
			return true;
		}
	</script>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "add") >
	<script type="text/javascript">
	function unformat_fields()
	{
		var fld=document.add_currency.amount;
		var fld2=document.add_currency.amount2;
		var fld3=document.add_currency.amountpp;
		var fld4=document.add_currency.amountpp2;
		var fld5=document.add_currency.amountww;
		var fld6=document.add_currency.amountww2;
		var fld7=document.add_currency.amount3;
		var fld8=document.add_currency.amount4;
		fld.value=filterNum(fld.value,'#session.ep.our_company_info.rate_round_num#');
		fld2.value=filterNum(fld2.value,'#session.ep.our_company_info.rate_round_num#');
		fld3.value=filterNum(fld3.value,'#session.ep.our_company_info.rate_round_num#');
		fld4.value=filterNum(fld4.value,'#session.ep.our_company_info.rate_round_num#');
		fld5.value=filterNum(fld5.value,'#session.ep.our_company_info.rate_round_num#');
		fld6.value=filterNum(fld6.value,'#session.ep.our_company_info.rate_round_num#');
		fld7.value=filterNum(fld7.value,'#session.ep.our_company_info.rate_round_num#');
		fld8.value=filterNum(fld8.value,'#session.ep.our_company_info.rate_round_num#');
		document.getElementById("rate1").value = filterNum(document.getElementById("rate1").value,'#session.ep.our_company_info.rate_round_num#');
	}
	function kontrol()
	{
		if ((document.getElementById("rate1").value =='') || (document.getElementById("rate1").value == 0))
		{
			alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount2").value =='') || (document.getElementById("amount2").value == 0))
		{
			alert("<cf_get_lang no='416.Alış Karşılığı Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount").value =='') || (document.getElementById("amount").value == 0))
		{
			alert("<cf_get_lang no='417.Satış karşılığı Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_currencies';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/form_add_currency_info.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_currency_info_act.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_currencies';
	
	WOStruct['#attributes.fuseaction#']['add_other'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_other']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_other']['fuseaction'] = 'finance.list_currencies';
	WOStruct['#attributes.fuseaction#']['add_other']['filePath'] = 'finance/form/form_add_currency_info.cfm';
	WOStruct['#attributes.fuseaction#']['add_other']['queryPath'] = 'finance/query/add_currency_hist_info_act.cfm';
	WOStruct['#attributes.fuseaction#']['add_other']['nextEvent'] = 'finance.list_currencies';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_currencies';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_currency_history.cfm';
	
</cfscript>
