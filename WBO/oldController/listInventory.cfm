<cfset toplam_ilkdeger1 = 0>
<cfset toplam_ilkdeger_doviz1 = 0>
<cfset toplam_sondeger1 = 0>
<cfset toplam_sondeger_doviz1 = 0>
<cfset toplam_deger1 = 0>
<cfset toplam_deger_doviz1 = 0>
<cfset son_toplam_deger1 = 0>
<cfset son_toplam_deger_doviz1 = 0>
<cfset output_type = '1182,66,83'>
<cfset input_type = '118,65,82,1181'>
<cfset value = '0'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.bill_no" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.account_name" default="">
<cfparam name="attributes.amor_method" default="">
<cfparam name="attributes.record_date_1" default="">
<cfparam name="attributes.record_date_2" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.entry_date_1" default="">
<cfparam name="attributes.entry_date_2" default="">
<cfparam name="attributes.output_date_1" default="">
<cfparam name="attributes.output_date_2" default="">
<cfparam name="attributes.inventory_type" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfif isdefined("attributes.form_varmi")>
	<cfquery name="get_invent" datasource="#dsn3#">
        WITH CTE1 AS (
            SELECT
                I.INVENTORY_ID,
                I.ACCOUNT_ID,
                I.AMOUNT,
                ISNULL(I.AMOUNT_2,0) AS AMOUNT_2,
                I.LAST_INVENTORY_VALUE,
                ISNULL(I.LAST_INVENTORY_VALUE_2,0) AS LAST_INVENTORY_VALUE_2,
                I.INVENTORY_NAME,
                I.RECORD_DATE,
                I.ENTRY_DATE,
                I.INVENTORY_NUMBER,
                I.AMORTIZATON_METHOD,
                ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) MIKTAR
            FROM
                INVENTORY I
            WHERE
                I.INVENTORY_ID IS NOT NULL	
                <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
                    AND I.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                </cfif>
                <cfif isdate(attributes.record_date_1)>
                    AND I.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date_1#">
                </cfif>
                <cfif isdate(attributes.record_date_2)>
                    AND I.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.record_date_2)#">
                </cfif>
                <cfif len(attributes.entry_date_1)>
                    AND I.ENTRY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date_1#">
                </cfif>
                <cfif isdate(attributes.entry_date_2)>
                    AND I.ENTRY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.entry_date_2)#">
                </cfif>
                <cfif isdate(attributes.output_date_1)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.output_date_1#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" value="#output_type#">))
                </cfif>
                <cfif isdate(attributes.output_date_2)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.output_date_2)#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" value="#output_type#">))
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND I.INVENTORY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
                <cfif isDefined("attributes.invent_no") and len(attributes.invent_no)>
                    AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invent_no#%">
                </cfif>  
                <cfif isDefined("attributes.bill_no") and len(attributes.bill_no)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.bill_no#%">)
                </cfif>  
                <cfif isDefined("attributes.amor_method") and len(attributes.amor_method)>
                    AND I.AMORTIZATON_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.amor_method#">
                </cfif>
                <cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
                    AND I.INVENTORY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_type#">
                </cfif> 
                <cfif isDefined("attributes.account_id") and len(attributes.account_id)>
                    AND I.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">
                </cfif>
                <cfif isDefined("attributes.invent_status") and len(attributes.invent_status)>
                    <cfif attributes.invent_status eq 1>
                        AND I.LAST_INVENTORY_VALUE > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                    <cfelse>
                        AND 
                        (
                            I.LAST_INVENTORY_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                            OR 
                            ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        )
                    </cfif>
                </cfif>
           )
           ,
           CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (   ORDER BY 
                                                    <cfif Len(attributes.sort_type) and attributes.sort_type eq 1>
                                                        INVENTORY_NAME DESC
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 2>
                                                        INVENTORY_NUMBER
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 3>
                                                        INVENTORY_NUMBER DESC
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 4>
                                                        ENTRY_DATE 
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 5>
                                                        ENTRY_DATE DESC
                                                    <cfelse>
                                                        INVENTORY_NAME
                                                    </cfif>
                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
						)
			SELECT
				CTE2.*
                <cfif attributes.page neq 1>
                	,xxx.toplam_ilkdeger
                    ,xxx.toplam_ilkdeger_doviz 
                    ,xxx.toplam_sondeger 
					,xxx.toplam_sondeger_doviz 
 					,xxx.toplam_deger 
					,xxx.toplam_deger_doviz
					,xxx.son_toplam_deger
					,xxx.son_toplam_deger_doviz 
                </cfif>
			FROM
				CTE2
                <cfif attributes.page neq 1>
                    OUTER APPLY
                    (
                        SELECT 
                            SUM(AMOUNT) AS toplam_ilkdeger ,
                            SUM(amount_2) AS toplam_ilkdeger_doviz ,
                            SUM(LAST_INVENTORY_VALUE) AS toplam_sondeger ,
                            SUM( LAST_INVENTORY_VALUE_2) AS toplam_sondeger_doviz ,
                            SUM((MIKTAR * amount)) AS toplam_deger ,
                            SUM((MIKTAR * amount_2)) AS toplam_deger_doviz ,
                            SUM((MIKTAR * LAST_INVENTORY_VALUE)) AS son_toplam_deger ,
                            SUM((MIKTAR * LAST_INVENTORY_VALUE_2)) AS son_toplam_deger_doviz 
                        FROM 
                            CTE2 
                        WHERE 
                            RowNum BETWEEN 1 and #attributes.startrow-attributes.maxrows#+(#attributes.maxrows#-1)
                    )  as xxx
                </cfif>
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_invent.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
 <cfquery name="get_our_comp_info" datasource="#dsn#">
    SELECT IS_SUBSCRIPTION_CONTRACT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<script type="text/javascript">
$( document ).ready(function() {
	document.getElementById('keyword').focus();
	});
	function pencere_ac_muhasebe()
	{
		windowopen('index.cfm?fuseaction=objects.popup_account_plan&field_id=form.account_id','list');
	}
	function auto_complate_cari()
	{
		AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','ch_consumer_id,ch_company_id','','3','250');
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.list_inventory';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'inventory/display/list_inventory.cfm';
	
</cfscript>