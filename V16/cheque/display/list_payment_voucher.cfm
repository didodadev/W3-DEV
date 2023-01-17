<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_payment_voucher">
<cfparam name="attributes.is_payment" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.paper_type" default="">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        COMPANY_ID, 
        RATE3, 
        DSP_UPDATE_DATE
    FROM 
    	SETUP_MONEY 
    ORDER BY 
    	MONEY_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_catalystHeader>
    <cfform name="add_voucher_action" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_voucher" method="post">
        <!--- Filtreler --->
        <cfinclude template="list_payment_voucher_1.cfm">
        <!--- Yapılan Tahsilatlar --->
        <cfinclude template="list_payment_voucher_4.cfm">
        <!--- Senetler--->
        <cfinclude template="list_payment_voucher_2.cfm">
        <!--- Tahsilat --->
        <cfinclude template="list_payment_voucher_3.cfm">
    </cfform>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">


