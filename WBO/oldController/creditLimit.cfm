<cf_get_lang_set module_name="credit">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.account_id" default="">
    <cfparam name="attributes.credit_type" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfscript>
        getCredit_=createobject("component","credit.cfc.credit");
        getCredit_.dsn3=#dsn3#;
    </cfscript>
    <cfif isdefined("attributes.form_submitted")>
        <cfscript>
            getCreditLimit = getCredit_.getCreditLimit
            (
                credit_type : attributes.credit_type ,
                account_id : attributes.account_id , 
                startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
            );
        </cfscript>
        <cfparam name="attributes.totalrecords" default='#getCreditLimit.QUERY_COUNT#'>
    <cfelse> 
        <cfset getCreditLimit.recordcount = 0>
         <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
        SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="get_credit_type" datasource="#dsn#">
        SELECT * FROM SETUP_CREDIT_TYPE
    </cfquery>
    <cfif isdefined("attributes.credit_limit_id")>
        <cfquery name="get_credit_contract" datasource="#dsn3#">
            SELECT * FROM CREDIT_CONTRACT WHERE CREDIT_LIMIT_ID = #attributes.credit_limit_id#
        </cfquery>
    <cfelse>
        <cfset get_credit_contract.recordcount=0>
    </cfif>
    <cfif isdefined("attributes.credit_limit_id")>
        <cfquery name="get_credit_detail" datasource="#dsn3#">
            SELECT * FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #attributes.credit_limit_id#
        </cfquery>
        <cfset account_id = get_credit_detail.account_id>
        <cfset credit_type_ = get_credit_detail.credit_type>
        <cfset credit_limit = get_credit_detail.credit_limit>
        <cfset credit_money = get_credit_detail.money_type>
        <cfset action_detail = get_credit_detail.action_detail>
        <cfset limit_head = get_credit_detail.limit_head>
    <cfelse>
        <cfset account_id = ''>
        <cfset credit_type_ = ''>
        <cfset credit_limit = 0>
        <cfset credit_money = ''>
        <cfset action_detail = ''>
        <cfset limit_head = ''>
    </cfif>
    <script type="text/javascript">
		function kontrol()
		{
			if(document.add_credit_type.account_id.value == '' && (document.add_credit_type.company_id.value == '' || document.add_credit_type.company.value == ''))
			{
				alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1652.Banka Hesabi'> <cf_get_lang_main no='586.veya'> <cf_get_lang no='2.Kredi Kurumu'>!');
				return false;
			}
			if(document.add_credit_type.limit_head.value == '')
			{
				alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1408.Başlık'> !');
				return false;
			}
			if(document.add_credit_type.credit_type.value == '')
			{
				alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='26.Kredi Türü'> !');
				return false;
			}
			if(document.add_credit_type.action_value.value == '' || document.add_credit_type.action_value.value == 0)
			{
				alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1551.Kredi Limiti'> !');
				return false;
			}
			document.add_credit_type.action_value.value = filterNum(document.add_credit_type.action_value.value);
			if (document.add_credit_type.action_currency_id.disabled == true)
				 document.add_credit_type.action_currency_id.disabled = false;
			return true;
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_credit_limit';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'credit/display/list_credit_limit.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.popup_form_add_credit_limit';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'credit/form/add_credit_limit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'credit/query/add_credit_limit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.list_credit_limit';
	
	
	if(IsDefined("attributes.event") and attributes.event eq 'add')
	{
		if(isdefined("attributes.credit_limit_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.emptypopup_del_credit_limit&credit_limit_id=#get_credit_detail.credit_limit_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'credit/query/del_credit_limit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'credit/query/del_credit_limit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.list_credit_limit';
		}
	}
</cfscript>

