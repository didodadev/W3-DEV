<cf_get_lang_set module_name="assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cfparam name="attributes.form_submitted" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.assetp_catid" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.emp_id" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.is_collective_usage" default="">
    <cfparam name="attributes.brand_type_cat_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.make_year" default="">
    <cfparam name="attributes.property" default="">
    <cfparam name="attributes.assetp_sub_catid" default="">
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
    <cfif len(attributes.form_submitted)>
        <cfinclude template="../assetcare/query/get_it_assets.cfm">
    <cfelse>
        <cfset get_asset_it.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_asset_it.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and listfind("add,upd",attributes.event)> 
	<cf_xml_page_edit fuseact="assetcare.form_add_assetp_it">
    <cfinclude template="../assetcare/query/get_assetp_groups.cfm">
    <cfinclude template="../assetcare/query/get_money.cfm">
    <cfif isdefined('attributes.assetp_id')>
        <cfinclude template="../assetcare/query/get_assetp.cfm">
        <cfif attributes.event eq 'upd' and (not get_assetp.recordcount or not(get_assetp.it_asset))>
            <cfset hata  = 10>
            <cfinclude template="../../dsp_hata.cfm">
        <cfelseif attributes.event eq 'upd' and (get_assetp.recordcount or get_assetp.it_asset)>
            <cfinclude template="../assetcare/query/get_assetp_groups.cfm">
            <cfinclude template="../assetcare/query/get_purpose.cfm">
            <cfinclude template="../assetcare/query/get_money.cfm">
            <cfquery name="GET_ASSETP_IT" datasource="#dsn#">
                SELECT ASSETP_ID FROM ASSET_P_IT WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
            </cfquery>
            <cfquery name="KONTROL_" datasource="#DSN#">
                SELECT ASSET_ID FROM CARE_STATES WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.assetp_id#">
            </cfquery>
            <cfquery name="GET_BRAND" datasource="#DSN#">
                SELECT BRAND_ID,BRAND_NAME FROM SETUP_BRAND WHERE IT_ASSET = 1 ORDER BY BRAND_NAME
            </cfquery>
        </cfif>
        <cfif len(get_assetp.department_id)>
            <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
                SELECT
                    DEPARTMENT.DEPARTMENT_HEAD,
                    BRANCH.BRANCH_NAME
                FROM
                    BRANCH,
                    DEPARTMENT
                WHERE
                    DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id#"> AND
                    BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
            </cfquery>
        </cfif>
        <cfif len(get_assetp.assetp_catid)>
        <cfquery name="GET_SUB_CAT" datasource="#dsn#">
               SELECT
                   ASSETP_SUB_CATID,
                   ASSETP_SUB_CAT 
               FROM
                   ASSET_P_SUB_CAT 
               WHERE
                   ASSETP_CATID = #get_assetp.assetp_catid#
           </cfquery>
        </cfif>
        <cfif len(get_assetp.department_id2)>
            <cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
                SELECT
                    DEPARTMENT.DEPARTMENT_HEAD,
                    BRANCH.BRANCH_NAME
                FROM 
                    BRANCH,
                    DEPARTMENT
                WHERE
                    DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id2#"> AND
                    BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
            </cfquery>
        </cfif>
        <cfif len(get_assetp.sup_company_id)>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT 
                    COMPANY_ID,
                    TAXOFFICE,
                    TAXNO,
                    COMPANY_ADDRESS,
                    FULLNAME
                FROM
                    COMPANY
                WHERE 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_company_id#">
            </cfquery>
            <cfif len(get_assetp.sup_partner_id)>
                <cfquery name="GET_PARTNER" datasource="#DSN#">
                    SELECT
                        PARTNER_ID,COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER_SURNAME
                    FROM
                        COMPANY_PARTNER
                    WHERE
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#">
                </cfquery>
            </cfif>
        <cfelseif len(get_assetp.sup_consumer_id)>
            <cfquery name="GET_CONSUMER" datasource="#DSN#">
                SELECT
                    CONSUMER_NAME,
                    CONSUMER_SURNAME,
                    COMPANY,
                    CONSUMER_ID
                FROM
                    CONSUMER
                WHERE
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#">
            </cfquery>		
        </cfif> 
        <cfif len(get_assetp.ASSETP_SUB_CATID)>
            <cfquery name="GET_SUB_CAT" datasource="#dsn#">
                SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid#
            </cfquery>
        </cfif>  
        <cfif len(get_assetp.relation_physical_asset_id)>
            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
            </cfquery>
            <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
            <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
        <cfelse>
            <cfset relation_phy_asset_id = ''>
            <cfset relation_phy_asset = ''>
        </cfif> 
        <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
        <cfset model_yili = get_assetp.make_year>
    </cfif>
    <cfquery name="GET_PURPOSE" datasource="#DSN#">
        SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE
    </cfquery>
</cfif>
<script type="text/javascript">

<cfif not isdefined("attributes.event")>
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	$(document).ready(function(){
		show_hide(care); 
	});
</cfif>

function list_kontrol()
{
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		if(document.assetp_it.branch.value == "")
		document.assetp_it.branch_id.value = "";

		if(document.getElementById("employee_name").value == "")
		document.getElementById("emp_id").value = "";

		if(document.assetp_it.department.value == "")
		document.assetp_it.department_id.value = "";

		if(document.assetp_it.brand_name.value == "")
		document.assetp_it.brand_type_cat_id.value = "";
		return true;			
	<cfelse>
		if (document.assetp_it.assetp.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'> <cf_get_lang_main no='485.Adı'> !");
			return false;
		}
		x = document.assetp_it.assetp_catid.selectedIndex;
		if (document.assetp_it.assetp_catid[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='517.Varlık Tipi'> !");
			return false;
		}
		if(document.assetp_it.sup_comp_name.value =="" && document.assetp_it.sup_partner_name.value =="" )
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='21.Alınan Şirket'> !");
			return false;
		}
		if(document.assetp_it.department.value =="")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='327.Kayıtlı Şube '> !");
			return false;
		}
		
		<cfif not isdefined("attributes.event") and attributes.event is 'upd'>
			if(document.assetp_it.get_date.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'>!");
				return false;
			}
			if(!CheckEurodate(document.assetp_it.get_date.value,"<cf_get_lang no='22.Alış tarihi'>"))
			{
				return false;
			}
			
			if(!date_check(document.assetp_it.get_date,document.assetp_it.date_now,"<cf_get_lang no ='552.Alış Tarihini Kontrol Ediniz'>!"))
			{
				return false;
			}
		</cfif>
		
		if(document.assetp_it.brand_name.value == "" || document.assetp_it.brand_type_id.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'> !");
			return false;
		}
					
		t = document.assetp_it.make_year.selectedIndex;
		if (document.assetp_it.make_year[t].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='813.Model'> !");
			return false;
		}
		
		x = (250 - assetp_it.assetp_detail.value.length);
		if(x < 0)
		{ 
			alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
			return false;
		}
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			
			
			if(document.assetp_it.property[1].checked == true)
			{			
				document.assetp_it.rent_amount.value = filterNum(document.assetp_it.rent_amount.value);
			}
				
			if(document.assetp_it.start_date.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'>!");
				return false;
			}
			
			if(!CheckEurodate(document.assetp_it.start_date.value,"<cf_get_lang no='22.Alış tarihi'>"))
			{
				return false;
			}
			
			if(!date_check(document.assetp_it.start_date,document.assetp_it.date_now,"<cf_get_lang no ='552.Alış Tarihini Kontrol Ediniz'>!"))
			{
				return false;
			}
			
			if(document.assetp_it.property[3].checked == true)
			{			
				document.assetp_it.rent_amount.value = filterNum(document.assetp_it.rent_amount.value);
				document.assetp_it.fuel_amount.value = filterNum(document.assetp_it.fuel_amount.value);
				document.assetp_it.care_amount.value = filterNum(document.assetp_it.care_amount.value);			
			}
			document.assetp_it.assetp_other_money_value.value = filterNum(document.assetp_it.assetp_other_money_value.value);	
			if(process_cat_control())
				if(confirm("<cf_get_lang_main no='2117.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
			else
				return false;
				

		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>		
			document.assetp_it.assetp_other_money_value.value = filterNum(document.assetp_it.assetp_other_money_value.value);
			
			if(document.assetp_it.status.checked == true)
			{
				if(document.assetp_it.department.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='327.Kayıtlı Şube '>!");
					return false;
				}
				
				if($('#emp_id').val()=='' || $('#employee_name').val()=='')
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
					return false;
				}
				
				b = document.assetp_it.assetp_status.selectedIndex;
				if(document.assetp_it.assetp_status[b].value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='344.Durum '>!");
					return false;
				}
			}
			for(i=0;i<=3;i++)
			{
				if(document.assetp_it.property[i].checked==true)
					if(document.assetp_it.property[i].value != document.assetp_it.old_property.value)
					{
						if(confirm("<cf_get_lang no='633.Mülkiyet Alanındaki Değişiklik Araçtaki Belli Bilgileri Silecektir,Emin Misiniz?'>"));
						else return false;
					}	
			}
				document.assetp_it.assetp_other_money_value.value = filterNum(document.assetp_it.assetp_other_money_value.value);	
				if(process_cat_control())
					if(confirm('<cf_get_lang dictionary_id="52217.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişikliklerinizi onaylayın ">!')) return true; else return false;
				else
					return false;	
			
		</cfif>
			
			
			function add_department()
			{
				if( $('#department_id2') && $('#department2'))
				{
					$('#department_id2').val( $('#department_id').val());
					$('#department2').val( $('#department').val());
				}
			} 
			function change_depot()
			{
				$('#department_id2').val( $('#department_id').val() );
				$('#department2').val( $('#department').val() ) ;
			}
			return true;
	</cfif>	
}

function show_hide()
{
	if(document.assetp_it.property[0].checked)
	{
		gizle(outsource);
		gizle(rent);
		document.assetp_it.care_amount.value = "" ;
		document.assetp_it.fuel_amount.value = "" ;
		document.assetp_it.rent_amount.value = "" ;
		document.assetp_it.rent_start_date.value = "" ;
		document.assetp_it.rent_finish_date.value = "" ;
		document.assetp_it.is_care_added[0].checked = true;
		document.assetp_it.is_fuel_added[0].checked = true;
		document.assetp_it.rent_payment_period[0].selected = true;
	}
	if(document.assetp_it.property[1].checked)
	{
		gizle(outsource);
		goster(rent);
		document.assetp_it.care_amount.value = "" ;
		document.assetp_it.fuel_amount.value = "" ;
	}
	if(document.assetp_it.property[2].checked)
	{
		gizle(outsource);
		gizle(rent);
		document.assetp_it.care_amount.value = "" ;
		document.assetp_it.fuel_amount.value = "" ;
		document.assetp_it.rent_amount.value = "" ;
		document.assetp_it.rent_start_date.value = "" ;
		document.assetp_it.rent_finish_date.value = "" ;
		document.assetp_it.is_care_added[0].checked.value = true ;
		document.assetp_it.is_fuel_added[0].checked.value = true ;
		document.assetp_it.rent_payment_period[0].selected = true;
	}
	if(document.assetp_it.property[3].checked)
	{
		goster(outsource);
		goster(rent);
	}
	
	if(document.assetp_it.is_care_added[0].checked)
	{
		gizle(care);
		document.assetp_it.care_amount.value = "" ;
		document.assetp_it.care_amount_currency.selectedIndex = "";
	}
	if(document.assetp_it.is_care_added[1].checked)
	{
		gizle(care);
		document.assetp_it.care_amount.value = "" ;
		document.assetp_it.care_amount_currency.selectedIndex = "";
	}
	if(document.assetp_it.is_care_added[2].checked)
	{
		goster(care);
	}
	if(document.assetp_it.is_fuel_added[0].checked)
	{
		gizle(fuel);
		document.assetp_it.fuel_amount.value = "" ;
		document.assetp_it.fuel_amount_currency.selectedIndex = "";
	}
	if(document.assetp_it.is_fuel_added[1].checked)
	{
		gizle(fuel);
		document.assetp_it.fuel_amount.value = "" ;
		document.assetp_it.fuel_amount_currency.selectedIndex = "";
	}
	if(document.assetp_it.is_fuel_added[2].checked)
	{
		goster(fuel);
	}			
	/*if(document.assetp_it.is_care_added[2].checked || document.assetp_it.is_fuel_added[2].checked)
		goster(limit);
	else
		gizle(limit);*/
}

function get_assetp_sub_cat()
{
	
	for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
		{
				$('#assetp_sub_catid option').eq(i).remove();
		}
		url_= '/V16/assetcare/cfc/assetp_it.cfc?method=GET_ASSETP_SUB_CAT&assetp_catid='+ $("#assetp_catid").val();
		$.ajax({
				url: url_,
				method : 'GET', 
				dataType: "text",
				cache:false,
				async: false,
				success: function( res ) { 
				if (res) { 
					data = $.parseJSON( res ); 
					if(data.DATA.length != 0)
					{
						$.each(data.DATA, function( key, value ) {   
								
							var arg1 = 	value[0] ; //ASSETP_SUB_CATID
							var arg2 = 	value[1] ;//ASSETP_SUB_CAT
							$("#assetp_sub_catid").append("<option value='"+arg1+"'>"+arg2+"</option>");
							
						});
					}
						
				}
			}
		});
}
	
<cfif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
	function fill_department()
	{	
		<cfif x_fill_department eq 1>
				$('#department_id').val("");
				$('#department_id2').val("");
				$('#department').val("");
				$('#department2').val("");
				var member_id=$('#emp_id').val();
			if(member_id!='')
			{
				url_= '/V16/assetcare/cfc/assetp_it.cfc?method=FILL_DEPARTMENTS&member_id='+ member_id;
				$.ajax({
						url: url_,
						method : 'GET', 
						dataType: "text",
						cache:false,
						async: false,
						success: function( res ) { 
						if (res) { 
							data = $.parseJSON( res ); 
							if(data.DATA.length != 0)
							{
								$.each(data.DATA, function( key, value ) {   
										
									var arg1 = 	value[0] ; //DEPARTMENT_ID
									var arg2 = 	value[1] ; //DEPARTMENT_HEAD
									var arg3 = 	value[2] ; //BRANCH_NAME
									$('#department_id').val(arg1);
									$('#department_id2').val(arg1);
									$('#department').val(arg2 +'-'+arg3);
									$('#department2').val(arg2 +'-'+arg3);
									
								});
							}
								
						}
					}
				});
			}
		</cfif>
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_assetp_it';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/form/form_add_assetp_it.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_assetp_it.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_asset_it&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_add_assetp_it';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/form/form_upd_assetp_it.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_assetp_it.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_it&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'assetp_id=##attributes.assetp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.assetp_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_asset_it';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_asset_it.cfm';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		if(not listfindnocase(denied_pages,'assetcare.popup_asset_history')){
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_asset_history&&asset_id=#attributes.assetp_id#','wide')";
			
		}
		if(get_assetp.property eq 2)
		{		
			if(not listfindnocase(denied_pages,'assetcare.popup_upd_asset_contract1')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[332]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#attributes.assetp_id#&property=4','medium')";
			}
		}
		else if(get_assetp.property eq 4)
		{
			if(not listfindnocase(denied_pages,'assetcare.popup_upd_asset_contract1')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[491]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#attributes.assetp_id#&property=2','medium')";
			}
		}
		
		if(get_assetp.motorized_vehicle and (not(get_assetp.it_asset)))
		{
			if(not listfindnocase(denied_pages,'assetcare.popup_vehicle_ship_detail')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[114]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=logistic.popup_vehicle_ship_detail&assetp_id=#attributes.assetp_id#','list')";
			}
			if(not listfindnocase(denied_pages,'assetcare.popup_list_vehicle_km_control')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[132]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_list_vehicle_km_control&assetp_id=#attributes.assetp_id#','list')";
			}
			if(not listfindnocase(denied_pages,'assetcare.popup_add_vehicle_km_control')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[134]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_add_vehicle_km_control&assetp_id=#attributes.assetp_id#','small')";
			}
		}

		if(get_assetp.it_asset and not(get_assetp.motorized_vehicle))
		{
			if(len(get_assetp_it.assetp_id))
			{
				if(not listfindnocase(denied_pages,'assetcare.popup_upd_it_asset')){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[32]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#attributes.assetp_id#','medium')";
				}
			}
			else
			{	
				if(not listfindnocase(denied_pages,'assetcare.popup_upd_it_asset')){	
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[32]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_add_it_asset&asset_id=#attributes.assetp_id#','medium')";	
				}
			}	
		}
		
		if(get_assetp.assetp_reserve)
		{
			if(not listfindnocase(denied_pages,'assetcare.popup_asset_reserve_history')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[1160]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#attributes.assetp_id#','medium')";
			}
		}
		if(not listfindnocase(denied_pages,'assetcare.popup_list_asset_care_nonperiod')){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[29]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&asset_id=#attributes.assetp_id#','list')";		
		}
		if(not listfindnocase(denied_pages,'assetcare.popup_list_asset_cares_report')){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[6]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_cares_report&asset_id=#attributes.assetp_id#','list')";
		}
		if(not listfindnocase(denied_pages,'assetcare.popup_list_asset_cares_report')){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[34]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.list_asset_care&event=add&window=popup&asset_id=#attributes.assetp_id#','wide')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it&event=add&assetp_id=#attributes.assetp_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('index.cfm?fuseaction=objects.popup_print_files&iid=#attributes.assetp_id#&print_type=250','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetcareItController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ASSET_P';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-property','item-assetp','item-sup_company_id','item-sup_partner_id','item-assetp_cat_id','item-department_id','item-make_year','item-brandtypecat','item-start_date','item-status']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

	
</cfscript>
