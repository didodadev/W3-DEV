<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
 	<cfparam name="attributes.is_mix_pocket" default="">
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT MONEY FROM SETUP_MONEY
    </cfquery>
    <cfif not isdefined('attributes.uploaded_file')>
        <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
            SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
        </cfquery>
	</cfif>
<cfset money_list = ValueList(get_money.money)>
</cfif>  
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")> 
   <cfif not isdefined('attributes.uploaded_file')>
   		<script type="text/javascript">
			function kontrol()
			{
				if(formimport.uploaded_file.value.length==0)
				{
					alert("Belge Seçmelisiniz!");
					return false;
				}
					return true;
			}
		</script>
   </cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.price_import';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/query/price_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/price_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.price_import';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'priceImportController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE_STANDART';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'product';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-file_format','item-uploaded_file','item-startdate']";

</cfscript>