<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
	SELECT 
    	SUBSCRIPTION_HEAD,
        SUBSCRIPTION_ID,
    	SUBSCRIPTION_STAGE,
        SUBSCRIPTION_TYPE_ID,
        MONTAGE_DATE,
        MONTAGE_EMP_ID,
        SHIP_COORDINATE_1,
        SHIP_COORDINATE_2,
        SHIP_ADDRESS,
        START_DATE,
        FINISH_DATE,
        PAYMENT_TYPE_ID,
        CONTRACT_NO, 
        PARTNER_ID,
        CONSUMER_ID,
        SALES_PARTNER_ID,
        SALES_CONSUMER_ID,
        SALES_EMP_ID,
        REF_PARTNER_ID,
        REF_CONSUMER_ID,
        REF_EMPLOYEE_ID,
        CONTACT_COUNTY_ID,
        CONTACT_CITY_ID,
        CONTACT_COUNTRY_ID,
        INVOICE_COUNTY_ID,
        INVOICE_CITY_ID,
        INVOICE_COUNTRY_ID,
        SHIP_COUNTY_ID,
        SHIP_CITY_ID,
        SHIP_COUNTRY_ID
    FROM 
    	SUBSCRIPTION_CONTRACT 
    WHERE 
    	SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
</cfquery>
<cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
	SELECT
  		STAGE,
		PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS
	WHERE
		PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_stage#">
</cfquery>
<cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
	SELECT SUBSCRIPTION_TYPE_ID,SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE WHERE SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_type_id#">
</cfquery>

<cfset county_list = ''>
<cfset city_list = ''>
<cfset country_list = ''>

<cfset county_list = Listappend(county_list,'#get_subscription.ship_county_id#,#get_subscription.invoice_county_id#,#get_subscription.contact_county_id#',',')>
<cfset city_list = ListAppend(city_list,'#get_subscription.ship_city_id#,#get_subscription.invoice_city_id#,#get_subscription.contact_city_id#',',')>
<cfset country_list = ListAppend(country_list,'#get_subscription.ship_country_id#,#get_subscription.invoice_country_id#,#get_subscription.contact_country_id#',',')>

<cfset county_list = ListSort(ListDeleteDuplicates(county_list),'Numeric','ASC',',')>
<cfset city_list = ListSort(ListDeleteDuplicates(city_list),'Numeric','ASC',',')>
<cfset country_list = ListSort(ListDeleteDuplicates(country_list),'Numeric','ASC',',')>
<cfif len(county_list)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
	</cfquery>
	<cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
<cfelse>
	<cfset main_county_list = ''>
</cfif>

<cfif len(city_list)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
	</cfquery>
	<cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
</cfif>

<cfif len(country_list)>
	<cfquery name="GET_COUNTRY" datasource="#DSN#">
		SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
	</cfquery>
	<cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
</cfif>

<cfif get_subscription.recordcount>
	<table border="0" cellspacing="1" cellpadding="2" class="color-border" style="width:100%">
    	<tr class="color-row">
        	<td>
                <table style="width:100%">
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title" style="width:100px;"><cf_get_lang_main no='821.Tanım'></td>
                        <td colspan="3"><cfoutput>#get_subscription.subscription_head#</cfoutput></td>
                    </tr>
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang_main no='45.Müşteri'></td>
                        <td><cfif len(get_subscription.partner_id)>
                                <cfoutput>#get_par_info(get_subscription.partner_id,0,1,0)#</cfoutput>
                            <cfelse>
                                <cfoutput>#get_cons_info(get_subscription.consumer_id,2,0)#</cfoutput>
                            </cfif>
                        </td>
                        <td class="form-title"><cf_get_lang_main no='166.Yetkili'></td>
                        <td><cfif len(get_subscription.partner_id)>
                                <cfoutput>#get_par_info(get_subscription.partner_id,0,-1,0)#</cfoutput>
                            <cfelse>
                                <cfoutput>#get_cons_info(get_subscription.consumer_id,0,0)#</cfoutput>
                            </cfif>
                        </td> 
                    </tr>
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title">Referans Müşteri</td>
                        <td><cfoutput>#get_par_info(get_subscription.ref_partner_id,0,1,0)#</cfoutput></td>
                        <td class="form-title"><cf_get_lang_main no='166.Yetkili'></td>
                        <td><cfif len(get_subscription.ref_partner_id)>
                                <cfoutput>#get_par_info(get_subscription.ref_partner_id,0,-1,0)#</cfoutput>
                            <cfelseif len(get_subscription.ref_consumer_id)>
                                <cfoutput>#get_cons_info(get_subscription.ref_consumer_id,0,0)#</cfoutput>
                            <cfelseif len(get_subscription.ref_employee_id)>
                                <cfoutput>#get_emp_info(get_subscription.ref_employee_id,0,0)#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                   <tr class="color-row" style="height:20px;">
                        <td class="form-title">Satış Temsilcisi</td>
                        <td><cfif len(get_subscription.sales_emp_id)>
                                <cfoutput>#get_emp_info(get_subscription.sales_emp_id,0,0)#</cfoutput>
                            </cfif>
                        </td>
                        <td class="form-title">Satış Ortağı</td>
                        <td><cfif len(get_subscription.sales_partner_id)>
                                <cfoutput>#get_par_info(get_subscription.sales_partner_id,0,-1,0)#</cfoutput>
                            <cfelseif len(get_subscription.sales_consumer_id)>
                                <cfoutput>#get_cons_info(get_subscription.sales_consumer_id,1,0)#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                   <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
                        <td><cfoutput>#get_service_stage.stage#</cfoutput></td>
                        <td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
                        <td><cfoutput>#get_subscription_type.subscription_type#</cfoutput></td>
                    </tr>
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
                        <td>
                            <cfif len(get_subscription.payment_type_id)>
                                <cfquery name="GET_PAYMENT_TYPE" datasource="#DSN#">
                                    SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.payment_type_id#">
                                </cfquery>
                                <cfoutput>#get_payment_type.paymethod#</cfoutput>
                            </cfif>
                        </td>
                        <td class="form-title">Sözleşme No</td>
                        <td><cfoutput>#get_subscription.contract_no#</cfoutput></td>
                    </tr> 
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang_main no='336.İptal Tarihi'></td>
                        <td><cfoutput>#dateformat(get_subscription.finish_date,'dd/mm/yyyy')#</cfoutput></td>
                        <td class="form-title"><cf_get_lang_main no='335.Sözleşme Tarihi'></td>
                        <td><cfoutput>#dateformat(get_subscription.start_date,'dd/mm/yyyy')#</cfoutput></td>
                    </tr>
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></td>
                        <td><cfoutput>#dateformat(get_subscription.montage_date,'dd/mm/yyyy')#</cfoutput></td>
                        <td class="form-title"><cf_get_lang dictionary_id='60560.Kurulum Çalışanı'></td>
                        <td><cfif len(get_subscription.montage_emp_id)>
                                <cfoutput>#get_emp_info(get_subscription.montage_emp_id,0,0)#</cfoutput>
                            </cfif> 
                        </td>
                    </tr>
                    <tr class="color-row" style="height:20px;">
                        <td class="form-title"><cf_get_lang_main no='1137.Koordinatlar'></td>
                        <td colspan="3">
                            <cfoutput>
                                <cf_get_lang_main no='1141.E'> :
                                #get_subscription.ship_coordinate_1#
                                <cf_get_lang_main no='1179.B'> :
                                #get_subscription.ship_coordinate_2#
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class="color-row" style="vertical-align:top;"><cfinclude template="subscription_rows.cfm"></td>
        </tr>
        <tr>
        	<td class="color-row" style="vertical-align:top;"><cfinclude template="../../objects2/sale/subscription_relation_asset.cfm"></td>
        </tr>
        <tr>
        	<td class="color-row" style="vertical-align:top;"><cfinclude template="subscription_related_services.cfm"></td>
        </tr>
    </table>
</cfif>

