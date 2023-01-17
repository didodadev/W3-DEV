<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfinclude template="../myhome/query/get_assetp_demand.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="get_emp_name" datasource="#dsn#">
        SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfinclude template="../correspondence/query/get_assetp_cats.cfm">
    <cfinclude template="../correspondence/query/get_usage_purpose.cfm">
    <cfinclude template="../correspondence/query/get_brand.cfm">
    <cfif fusebox.fuseaction is 'list_assetp_demand'>
        <cfset is_popup=1>  
    <cfelse>
        <cfset is_popup=0>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="myhome.popup_form_upd_assetp_demand">
    <cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.demand_id,accountKey:'wrk')>
    </cfif>
    
    <cfquery name="get_assetp_demand" datasource="#dsn#">
        SELECT 
        	APD.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            SBT.BRAND_TYPE_NAME,
            SBT.BRAND_TYPE_ID,
            SBT.BRAND_ID,
            SB.BRAND_NAME 
        FROM 
        	ASSET_P_DEMAND APD 
            LEFT JOIN EMPLOYEES E ON APD.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN SETUP_BRAND_TYPE SBT ON SBT.BRAND_TYPE_ID = APD.BRAND_TYPE_ID
            LEFT JOIN SETUP_BRAND SB ON SB.BRAND_ID = SBT.BRAND_ID
        WHERE 
        	DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
    </cfquery>
    <cfquery name="get_upper_pos_code" datasource="#dsn#">
        SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp_demand.employee_id#"> 
    </cfquery>
    <cfif len(get_assetp_demand.result_id) and get_assetp_demand.result_id eq 1>
        <cfset valid = 1>
    <cfelseif len(get_assetp_demand.result_id) and get_assetp_demand.result_id eq 0>
        <cfset valid = 2>
    <cfelse>
        <cfset valid = 0>
    </cfif>
    <cfinclude template="../correspondence/query/get_assetp_cats.cfm">
    <cfinclude template="../correspondence/query/get_usage_purpose.cfm">
    <cfinclude template="../correspondence/query/get_brand.cfm">
    <cfquery name="get_asset_p_sub_cats" datasource="#dsn#">
        SELECT 
            ASSETP_SUB_CATID,ASSETP_SUB_CAT 
        FROM 
            ASSET_P_SUB_CAT 
        <cfif isdefined('get_assetp_demand.assetp_catid') and len(get_assetp_demand.assetp_catid)>
            WHERE 
                ASSETP_CATID = #get_assetp_demand.assetp_catid#
        </cfif> ORDER BY ASSETP_SUB_CAT
    </cfquery>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add' or isdefined("attributes.event") and attributes.event is 'upd'>
		function kontrol()
		{
			x = document.add_assetp_demand.cat_id.selectedIndex;
			if (document.add_assetp_demand.cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='429.Varlık Tipi'>!");
				return false;
			}
			if (document.add_assetp_demand.employee_id.value == "")
			{
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='72.Talep Eden '>!");
				return false;
			}
			z = document.add_assetp_demand.usage_purpose_id.selectedIndex;
			if (document.add_assetp_demand.usage_purpose_id[z].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='263.Kullanım Amacı Seçiniz'>!");
				return false;
			}
			if (document.add_assetp_demand.request_date.value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'> !");
				return false;
			}
			
			return process_cat_control();
		}
		function pencere_ac()
		{
			x = document.add_assetp_demand.cat_id.selectedIndex;
			if (document.add_assetp_demand.cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='429.Varlık Tipi'>!");
				return false;
			}
			else
				y = document.add_assetp_demand.cat_id[x].value;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=add_assetp_demand.brand_type_id&field_brand_name=add_assetp_demand.brand_name&cat_id=' + y ,'list','popup_list_brand_type');
		}
		<cfif ListFindNoCase('add,upd',attributes.event)>
			function del_brand()
			{
				document.add_assetp_demand.brand_type_id.value = '';
				document.add_assetp_demand.brand_name.value = '';
				for (i=$('#assetp_sub_catid option').length-1 ; i>-1 ; i--)
			{   
				$('#assetp_sub_catid option').eq(i).remove();
			}	
				url_= '/V16/correspondence/cfc/get_demand.cfc?method=get_assetp_sub_cat_func';			
				$.ajax({
					type: "get",
					url: url_,
					data: {cat_id_ : $('#cat_id ').val()},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							selectBox = $("#assetp_sub_catid").attr('disabled');
							if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
							$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text("Seçiniz"));
							$.each(data_.DATA,function(i){
								$("#assetp_sub_catid").append($("<option></option>").attr("value", data_.DATA[i][0]).text(data_.DATA[i][1]));
								//get_assetp_sub_cat = data_.DATA[i][0];						
								});
						}
						else
							$("#assetp_sub_catid").attr('disabled','disabled');
					}
				});			
			}
		</cfif>
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_assetp_demand';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_assetp_demand.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.list_assetp_demand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'correspondence/form/add_assetp_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'correspondence/query/add_assetp_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_assetp_demand';		

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_assetp_demand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/form_upd_assetp_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_assetp_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_assetp_demand&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'demand_id=##attributes.demand_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.demand_id##';
	
	if(isdefined("attributes.event") and attributes.event is "upd" or isdefined("attributes.event") and attributes.event is "del")
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_assetp_demand&demand_id=#attributes.demand_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'assetcare/query/del_assetp_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'assetcare/query/del_assetp_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_assetp_demand';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ListAssetpDemand';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ASSET_P_DEMAND';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-cat_id','item-employee','item-usage_purpose_id','item-request_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>

