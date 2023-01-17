<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   	<cfif fuseaction contains "popup">
	  <cfset is_popup=1>
    <cfelse>
      <cfset is_popup=0>
    </cfif>
    <cfif not isDefined("attributes.pc_status")>
      <cfset attributes.pc_status="">
    </cfif>
    <cfif not isDefined("attributes.price_catid")>
      <cfset attributes.price_catid = "">
    </cfif>
    <cfinclude template="../product/query/get_product_cat.cfm">
    <cfinclude template="../product/query/get_price_cat.cfm">
   	
        <cfinclude template="../product/query/get_price_change.cfm">
        <!--- <cfdump var="#get_price_change#"> --->
    
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_price_change.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
     <cfif get_price_change.recordcount>
			<cfset employee_id_list=''>
            <cfset product_id_list =''>
            <cfset unit_price_list =''>
            <cfset secand_product_id_list =''>
            <cfoutput query="get_price_change" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
                  <cfset employee_id_list=listappend(employee_id_list,record_emp)>
                </cfif>
                <cfif len(product_id) and not listfind(product_id_list,product_id)>
                    <cfset product_id_list=listappend(product_id_list,product_id)>
                </cfif>
                <cfif len(PRODUCT_UNIT_ID) and not listfind(unit_price_list,PRODUCT_UNIT_ID)>
                    <cfset unit_price_list=listappend(unit_price_list,PRODUCT_UNIT_ID)>
                </cfif>
                <cfif len(product_id_list) and not listfind(secand_product_id_list,product_id_list)>
                    <cfset secand_product_id_list=listappend(secand_product_id_list,product_id_list)>
                </cfif>
            </cfoutput>
			<cfif len(employee_id_list)>
                <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                <cfquery name="get_emp_detail" datasource="#dsn#">
                    SELECT
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID IN (#employee_id_list#)
                    ORDER BY
                        EMPLOYEE_ID
                </cfquery>
              </cfif>
			<cfif len(product_id_list)>
               <cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
               <cfset unit_price_list=listsort(unit_price_list,"numeric","ASC",",")>
                    <cfquery name="GET_PR" datasource="#DSN3#">
                        SELECT 
                            PRICE,
                            MONEY,
                            PRODUCT_ID
                        FROM
                            PRICE_STANDART 
                        WHERE
                            PRICESTANDART_STATUS = 1 AND
                            PRODUCT_ID IN(#product_id_list#) AND
                            PURCHASESALES = 1  AND 
                            UNIT_ID IN (#unit_price_list#)  
                            ORDER BY 
                            PRODUCT_ID
                    </cfquery>
                <cfset product_id_list =valuelist(GET_PR.PRODUCT_ID,',')>
            </cfif> 
     </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfinclude template="../product/query/get_price_change_detail.cfm">
    <cfif not GET_PRICE_CHANGE_DET.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
        SELECT 
            COMPETITIVE_ID
        FROM
            PRODUCT_COMP_PERM 
        WHERE 
            POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfset COMPETITIVE_LIST = ValueList(GET_COMPETITIVE_LIST.COMPETITIVE_ID)>
    <cfinclude template="../product/query/get_price_cat.cfm">
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_product_unit.cfm">
    <cfinclude template="../product/query/get_product.cfm">
    <cfif len(get_product.PROD_COMPETITIVE)>
      <cfset attributes.COMPETITIVE_ID=get_product.PROD_COMPETITIVE>
      <cfinclude template="../product/query/get_competitive_name.cfm">
      <cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
      <cfelse>
      <cfset COMPETITIVE_NAME="">
    </cfif>
    
    <cfif len(GET_PRICE_CHANGE_DET.SAME_CHANGE_ID) >
      <cfquery datasource="#DSN3#" name="GET_SAME_ID">
        SELECT 
            PRICE_CATID, 
            PRICE_CHANGE_ID, 
            PRICE, 
            PRICE_KDV, 
            MONEY, 
            IS_KDV 
        FROM 
            PRICE_CHANGE 
        WHERE 
            SAME_CHANGE_ID = #GET_PRICE_CHANGE_DET.SAME_CHANGE_ID#
      </cfquery>
      <cfset price_catlist = valuelist(GET_SAME_ID.PRICE_CATID)>
      <cfset price_list = valuelist(GET_SAME_ID.PRICE)>
      <cfset price_kdv_list = valuelist(GET_SAME_ID.PRICE_KDV)>
      <cfset money_list = valuelist(GET_SAME_ID.MONEY)>
      <cfset kdv_list = valuelist(GET_SAME_ID.IS_KDV)>
    <cfelse>
      <cfset price_catlist = valuelist(GET_PRICE_CHANGE_DET.PRICE_CATID)>
      <cfset price_list = valuelist(GET_PRICE_CHANGE_DET.PRICE)>
      <cfset price_kdv_list = valuelist(GET_PRICE_CHANGE_DET.PRICE_KDV)>
      <cfset money_list = valuelist(GET_PRICE_CHANGE_DET.MONEY)>
      <cfset kdv_list = valuelist(GET_PRICE_CHANGE_DET.IS_KDV)>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfinclude template="../product/query/get_product.cfm">
    <cfinclude template="../product/query/get_price_cat.cfm">
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_product_unit.cfm">
    <cfif len(GET_PRODUCT.PROD_COMPETITIVE)>
      <cfset attributes.COMPETITIVE_ID=GET_PRODUCT.PROD_COMPETITIVE>
      <cfinclude template="../product/query/get_competitive_name.cfm">
      <cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
    <cfelse>
      <cfset COMPETITIVE_NAME="">
    </cfif>
    </cfif>
<cfif isdefined("attributes.event") and attributes.event is 'upd'>
	<script type="text/javascript">
        function unformat_fields()
        {
            if
            (
                document.price.price_cat_list[0].checked == false 
                &&
                document.price.price_cat_list[1].checked == false
                <cfoutput query="get_price_cat">
                &&
                document.price.price_cat_list[#currentrow+1#].checked == false
                </cfoutput>
            )
            {
                window.alert("<cf_get_lang no ='335.En az bir liste seçmelisiniz'> !");
                return false;		
            }
            
            if(document.price.price_cat_list[0].checked == true)
            {
                if(document.price.price_minus_2.value == 0 || document.price.price_minus_2.value == '')
                {
                    window.alert("<cf_get_lang no='336.Seçili listeler için yeni fiyat girmelisiniz'> !");
                    return false;
                }
            }
            price.price_minus_2.value = filterNum(price.price_minus_2.value);
    
            if(document.price.price_cat_list[1].checked == true)
            {
                if(document.price.price_minus_1.value == 0 || document.price.price_minus_1.value == '')
                {
                    window.alert("<cf_get_lang no='336.Seçili listeler için yeni fiyat girmelisiniz'> !");
                    return false;
                }
            }
            price.price_minus_1.value = filterNum(price.price_minus_1.value,4);
    
            <cfoutput query="get_price_cat">
            if(document.price.price_cat_list[#currentrow+1#].checked == true)
            {
                if(document.price.price_#price_catid#.value == 0 || document.price.price_#price_catid#.value == '')
                {
                    window.alert("<cf_get_lang no='336.Seçili listeler için yeni fiyat girmelisiniz'> !");
                    return false;
                }
            }
            price.price_#price_catid#.value = filterNum(price.price_#price_catid#.value,#session.ep.our_company_info.purchase_price_round_num#);
            </cfoutput>
            
            return true;
        }	
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<script type="text/javascript">
		function check_all(deger)
		{
			<cfif get_price_cat.recordcount gt 1>
				for(i=0; i<price.price_cat_list.length; i++)
					price.price_cat_list[i].checked = deger;
			<cfelseif get_price_cat.recordcount eq 1>
				price.price_cat_list.checked = deger;
			</cfif>
		}
			function unformat_fields()
			{
				if
				(
					document.price.price_cat_list[0].checked == false 
					&&
					document.price.price_cat_list[1].checked == false
					<cfoutput query="get_price_cat">
					&&
					document.price.price_cat_list[#currentrow+1#].checked == false
					</cfoutput>
				)
				{
					window.alert("<cf_get_lang no='335.En az bir liste seçmelisiniz'> !");
					return false;		
				}
				
				if(document.price.price_cat_list[0].checked == true)
				{
					if(document.price.price_minus_1.value == 0 || document.price.price_minus_1.value == '')
					{
						window.alert("<cf_get_lang no='336.Seçili listeler için yeni fiyat girmelisiniz'> !");
						return false;
					}
				}
				price.price_minus_1.value = filterNum(price.price_minus_1.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				if(document.price.price_cat_list[1].checked == true)
				{
					if(document.price.price_minus_2.value == 0 || document.price.price_minus_2.value == '')
					{
						window.alert("<cf_get_lang no='336.Seçili listeler için yeni fiyat girmelisiniz'> !");
						return false;
					}
				}
				price.price_minus_2.value = filterNum(price.price_minus_2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				<cfoutput query="get_price_cat">
					if(document.price.price_cat_list[#currentrow+1#].checked == true)
					{
						if(document.price.price_#price_catid#.value == 0 || document.price.price_#price_catid#.value == '')
						{
							window.alert('<cf_get_lang no="336.Seçili listeler için yeni fiyat girmelisiniz"> !');
							return false;
						}
					}
					price.price_#price_catid#.value = filterNum(price.price_#price_catid#.value,#session.ep.our_company_info.purchase_price_round_num#);
				</cfoutput>
				return true;
			}	
		
			function updOtherLists()
			{	
				<cfoutput query="get_price_cat">
					price.price_#price_catid#.value = price.price_minus_2.value;
				</cfoutput>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_price_change';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_price_change.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_price_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_price_change_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_price_change.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_price_change';

	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_price_request';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_price_change_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_price_change.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_price_change';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pid=##product_id##&id=##PRICE_CHANGE_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPriceChangeController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE_CHANGE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-unit_id']";
</cfscript>
