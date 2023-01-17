<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.add_cari_to_cari">

<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>

<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
	<cfset process_cat = "">
    <cfset action_date = dateformat(now(),'dd/mm/yyyy')>
	<script type="text/javascript">
		$(function(){
			kur_ekle_f_hesapla('ACTION_CURRENCY_ID');
			ayarla_gizle_goster();
			
			validate().set();
		
		});
		function ayarla_gizle_goster()
		{
			if(document.add_cari_to_cari.process_cat.options[document.add_cari_to_cari.process_cat.selectedIndex].value)
			{
				var selected_ptype = document.add_cari_to_cari.process_cat.options[document.add_cari_to_cari.process_cat.selectedIndex].value;				
				var get_is_process_currency = wrk_safe_query('ch_get_process_cat','dsn3',0,selected_ptype);
				if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
				{
					$('#tr_system_price').show();
					temp_system_val =  $('#system_amount').val();
					$('#system_amount').remove();
					$('<input>').attr({
						type: 'text',
						id: 'system_amount',
						name: 'system_amount',
						style: 'width:100px;text-align:right;',
						value: temp_system_val
					}).appendTo('#td_system_price');
				}
				else
					$('#tr_system_price').hide();
			}
			else
				$('#tr_system_price').hide();
		}
	
		function kontrol()
		{
			if(!paper_control(add_cari_to_cari.paper_number,'CARI_TO_CARI')) return false;
			if(!chk_process_cat('add_cari_to_cari')) return false;
			if(!check_display_files('add_cari_to_cari')) return false;
			if(!chk_period(add_cari_to_cari.action_date,'İşlem')) return false;
			x = (200 - add_cari_to_cari.action_detail.value.length);
			if( x < 0 )
			{ 
				alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			if(document.add_cari_to_cari.to_company_name.value == '' || (document.add_cari_to_cari.to_company_id.value == '' && document.add_cari_to_cari.to_consumer_id.value == ''  && document.add_cari_to_cari.to_employee_id.value == ''))
			{
				alert("<cf_get_lang no='186.Borçlu Hesap Girmelisiniz'>!");
				return false;
			}
			if(document.add_cari_to_cari.from_company_name.value == '' || (document.add_cari_to_cari.from_company_id.value == '' && document.add_cari_to_cari.from_consumer_id.value == ''  && document.add_cari_to_cari.from_employee_id.value == ''))
			{
				alert("<cf_get_lang no='184.Alacaklı Hesap Girmelisiniz'>!");
				return false;
			}
			process=document.add_cari_to_cari.process_cat.value;
			var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
			if(get_process_cat.IS_ACCOUNT ==1)
			{			
				if (document.add_cari_to_cari.to_member_code.value=="")
				{ 
					alert ("<cf_get_lang dictionary_id='54478.Seçtiğiniz Üyenin(Borç) Muhasebe Kodu Secilmemiş'>!");
					return false;
				}
				else if (document.add_cari_to_cari.from_member_code.value=="")
				{ 
					alert ("<cf_get_lang dictionary_id='54480.Seçtiğiniz Üyenin(Alacak) Muhasebe Kodu Secilmemiş'>!");
					return false;
				}
			}
			//sysytem amount kontrolu
			if(document.getElementById("system_amount") != undefined && document.getElementById("system_amount").value == '')
			{
				alert("<cf_get_lang dictionary_id='59079.Sistem Tutarı Girmelisiniz'>!");
				return false;
			}
			return true;
		}
	</script>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
    <cfquery name="get_note" datasource="#dsn2#">
        SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.id#
    </cfquery>
    <cfset process_cat = get_note.process_cat>
    <cfset action_date = dateFormat(get_note.action_date,'dd/mm/yyyy')>
    <cfquery name="get_process_cat" datasource="#dsn3#">
        SELECT IS_PROCESS_CURRENCY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_note.process_cat#
    </cfquery>
    <cfif not get_note.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    
    <cfset to_member_code = ''>
    <cfset from_member_code = ''>
    <cfif len(get_note.to_consumer_id)>
        <cfquery name="get_to_consumer_code" datasource="#dsn2#">
            SELECT
                ACCOUNT_CODE
            FROM
                #dsn_alias#.CONSUMER_PERIOD
            WHERE
                CONSUMER_ID = #get_note.to_consumer_id#
                AND	PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfset to_member_code = get_to_consumer_code.ACCOUNT_CODE>
    </cfif>
    <cfif len(get_note.from_consumer_id)>
        <cfquery name="get_from_consumer_code" datasource="#dsn2#">
            SELECT
                ACCOUNT_CODE
            FROM
                #dsn_alias#.CONSUMER_PERIOD
            WHERE
                CONSUMER_ID = #get_note.from_consumer_id#
                AND	PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfset from_member_code = get_from_consumer_code.ACCOUNT_CODE>
    </cfif>
    <cfif len(get_note.to_cmp_id)>
        <cfquery name="get_to_company_code" datasource="#dsn2#">
            SELECT
                ACCOUNT_CODE
            FROM
                #dsn_alias#.COMPANY_PERIOD
            WHERE
                COMPANY_ID = #get_note.to_cmp_id#
                AND	PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfset to_member_code = get_to_company_code.ACCOUNT_CODE>
    </cfif>
    <cfif len(get_note.from_cmp_id)>
        <cfquery name="get_from_company_code" datasource="#dsn2#">
            SELECT
                ACCOUNT_CODE
            FROM
                #dsn_alias#.COMPANY_PERIOD
            WHERE
                COMPANY_ID = #get_note.from_cmp_id#
                AND	PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfset from_member_code = get_from_company_code.ACCOUNT_CODE>
    </cfif>
    <cfif len(get_note.to_employee_id)>
        <cfquery name="get_to_employee_code" datasource="#dsn2#">
            SELECT
                EIOP.ACCOUNT_CODE
            FROM
                #dsn_alias#.EMPLOYEES_IN_OUT EIO,
                <cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
                    #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
                <cfelse>
                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
                </cfif>
            WHERE
                EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_note.to_employee_id#">
                <cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
                    AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
                <cfelse>
                    AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
                </cfif>
                <cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
                    AND EIOP.ACC_TYPE_ID = #get_note.acc_type_id#
                </cfif>
                AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfset to_member_code = get_to_employee_code.ACCOUNT_CODE>
    </cfif>
    <cfif len(get_note.from_employee_id)>
        <cfquery name="get_from_employee_code" datasource="#dsn2#">
            SELECT
                EIOP.ACCOUNT_CODE
            FROM
                #dsn_alias#.EMPLOYEES_IN_OUT EIO,
                <cfif len(get_note.from_acc_type_id) and get_note.from_acc_type_id neq 0>
                    #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
                <cfelse>
                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
                </cfif>
            WHERE
                EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_note.from_employee_id#">
                <cfif len(get_note.from_acc_type_id) and get_note.acc_type_id neq 0>
                    AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
                <cfelse>
                    AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
                </cfif>
                <cfif len(get_note.from_acc_type_id) and get_note.from_acc_type_id neq 0>
                    AND EIOP.ACC_TYPE_ID = #get_note.from_acc_type_id#
                </cfif>
                AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfset from_member_code = get_from_employee_code.ACCOUNT_CODE>
    </cfif>
    <script type="text/javascript">
		$( document ).ready(function() {
				kur_ekle_f_hesapla('ACTION_CURRENCY_ID');
				ayarla_gizle_goster();
				
			});
		function ayarla_gizle_goster()
		{
			if(document.add_cari_to_cari.process_cat.options[document.add_cari_to_cari.process_cat.selectedIndex].value)
			{
				var selected_ptype = document.add_cari_to_cari.process_cat.options[document.add_cari_to_cari.process_cat.selectedIndex].value;				
				var get_is_process_currency = wrk_safe_query('ch_get_process_cat','dsn3',0,selected_ptype);
				
				str2_ = "SELECT TOP 1 ACTION_VALUE FROM CARI_ROWS WHERE PROCESS_CAT = '"+ selected_ptype +"' AND ACTION_ID = '"+ document.getElementById("action_id").value +"'";
				var get_act_value = wrk_query(str2_,'dsn2');
				if(get_act_value.recordcount)
					temp_system_val = get_act_value.ACTION_VALUE;
				
				if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
				{	
					$('#tr_system_price').show();
					if(temp_system_val == undefined)
						temp_system_val =  $('#system_amount').val();
					temp_system_val = commaSplit(temp_system_val,2);
					$('#system_amount').remove();
					$('<input>').attr({
						type: 'text',
						id: 'system_amount',
						name: 'system_amount',
						style: 'width:100px;text-align:right;',
						value: temp_system_val
					}).appendTo('#td_system_price');
				}
				else
					$('#tr_system_price').hide();
			}
			else
				$('#tr_system_price').hide();
		}
		
		function del_kontrol()
		{
			if(!chk_period(add_cari_to_cari.action_date,'İşlem')) return false;
			else return true;
		}
		
		function kontrol()
		{
			if(!chk_process_cat('add_cari_to_cari')) return false;
			if(!check_display_files('add_cari_to_cari')) return false;
			if(!chk_period(add_cari_to_cari.action_date,'İşlem')) return false;
			x = (200 - add_cari_to_cari.action_detail.value.length);
			if( x < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='59026.Açıklama'>"+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
				return false;
			}
			if(document.add_cari_to_cari.to_company_name.value == '' || (document.add_cari_to_cari.to_company_id.value == '' && document.add_cari_to_cari.to_consumer_id.value == ''  && document.add_cari_to_cari.to_employee_id.value == ''))
			{
				alert("<cf_get_lang no='186.Borçlu Hesap Girmelisiniz'>!");
				return false;
			}
			if(document.add_cari_to_cari.from_company_name.value == '' || (document.add_cari_to_cari.from_company_id.value == '' && document.add_cari_to_cari.from_consumer_id.value == ''  && document.add_cari_to_cari.from_employee_id.value == ''))
			{
				alert("<cf_get_lang no='184.Alacaklı Hesap Girmelisiniz'>!");
				return false;
			}
			process=document.add_cari_to_cari.process_cat.value;
				var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
				if(get_process_cat.IS_ACCOUNT ==1)
				{
					if (document.add_cari_to_cari.to_member_code.value=="")
					{ 
						alert ("<cf_get_lang dictionary_id='54481.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş'>!");
						return false;
					}
					else if (document.add_cari_to_cari.from_member_code.value=="")
					{ 
						alert ("<cf_get_lang dictionary_id='54481.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş'>!");
						return false;
					}
				}
			//sysytem amount kontrolu
			if(document.getElementById("system_amount") != undefined && document.getElementById("system_amount").value == '')
			{
				alert("<cf_get_lang dictionary_id='59079.Sistem Tutarı Girmelisiniz'>!");
				return false;
			}
			return true;
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 28;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatCallFunction'] = 'ayarla_gizle_goster()';
	
	//WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'CARI_TO_CARI';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = "change_money_info('add_cari_to_cari','action_date')";
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2; // Transaction icin yapildi.
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_caris';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_cari_to_cari';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_cari_to_cari.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_cari_to_cari.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_add_cari_to_cari&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_cari_to_cari';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_add_cari_to_cari';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/upd_cari_to_cari.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_cari_to_cari.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_add_cari_to_cari&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_note';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_cari_to_cari';
	
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';

	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.form_add_cari_to_cari&action_id=#attributes.id#&process_type=#get_note.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_debit_claim.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_debit_claim.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.form_add_cari_to_cari';
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_note.action_type_id#','page','add_cari_to_cari')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "myPopup('printPage');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPriceForCompany';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item3','item11','item13']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>