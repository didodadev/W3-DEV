<cfparam name="attributes.cat" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif isdefined("attributes.start_date") and not len(attributes.start_date)>
	<cfset attributes.start_date = "">
<cfelse>
    <cfset attributes.start_date = dateadd('d',-7,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif isdefined("attributes.finish_date") and not len(attributes.finish_date)>
	<cfset attributes.finish_date = "">
<cfelse>
	<cfset attributes.finish_date = dateadd('d',7,attributes.start_date)>
</cfif>
<cfif isdefined('attributes.form_exist')>
	<cfscript>
        getCredit_=createobject("component","credit.cfc.credit");
        getCredit_.dsn3=#dsn3#;
		getStockbondData = getCredit_.getStockbondData(
			start_date : attributes.start_date ,
			finish_date : attributes.finish_date ,
			cat : attributes.cat ,
			company_id : attributes.company_id ,
			company_name : attributes.company_name ,
			employee_id : attributes.employee_id ,
			employee_name : attributes.employee_name ,
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
		);
    </cfscript>
    <cfparam name="attributes.totalrecords" default="#getStockbondData.QUERY_COUNT#">
<cfelse>
	<cfset getStockbondData.recordcount = 0>	
    <cfparam name="attributes.totalrecords" default="0">
</cfif>
<script>
   $('#employee_name').focus();
   function kontrol()
	{
		if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
			return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_stockbond_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'credit/display/list_stockbond_actions.cfm';
</cfscript>

