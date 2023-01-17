    <cf_get_lang_set module_name="bank">
    <cfparam name="attributes.keyword_list" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.special_definition_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.start_date2" default="">
    <cfparam name="attributes.finish_date2" default="">
    <cfparam name="attributes.bank_order_type" default="">
    <cfparam name="attributes.list_order_type" default="">
    <cfparam name="attributes.bank_action_date" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.file_status" default="">
    <cfparam name="attributes.account_id_list" default="">
    <cfparam name="attributes.acc_type_id" default="">
    <cfparam name="attributes.old_process_type" default="">
    <cfparam name="attributes.is_havale" default="">
    <cf_xml_page_edit fuseact="bank.popup_upd_assign_order">
    <cfscript> 
		get_money = getMoneyInfo.get();
	</cfscript>
    <cfif (not IsDefined("attributes.event") or attributes.event is 'list')>
        <cf_xml_page_edit fuseact="bank.list_assign_order" default_value="1">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        
        <cfscript>
		
			get_accounts = getAccounts.get
			(
				system_money_info : '',
				account_status :0,
				branch_id : 0,
				keyword : '',
				acc_type : '',
				money_info : '',
				account_id_ : ''
			);
			if(isDefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.employee_id,'_');
				attributes.employee_id = listfirst(attributes.employee_id,'_');
			}
		</cfscript>
        <cfif IsDefined("attributes.form_varmi")>
        	<cfscript>
				get_orders = BankOrderModel.list
				(
					company : attributes.company,
					company_id : iif(len(attributes.company_id),attributes.company_id,0),
					consumer_id : iif(len(attributes.consumer_id),attributes.consumer_id,0),
					employee_id : iif(len(attributes.employee_id),attributes.employee_id,0),
					acc_type_id : iif(len(attributes.acc_type_id),attributes.acc_type_id,0),
					account_id_list : iif(len(attributes.account_id_list),ListFirst(attributes.account_id_list,';'),0),
					keyword_list : attributes.keyword_list,
					is_havale : iif(len(attributes.is_havale),attributes.is_havale,0),
					file_status : iif(len(attributes.file_status),attributes.file_status,-1),
					bank_order_type : iif(len(attributes.bank_order_type),attributes.bank_order_type,0),
					start_date : iif(len(attributes.start_date),attributes.start_date,0),
					finish_date : iif(len(attributes.finish_date),attributes.finish_date,0),
					start_date2 : iif(len(attributes.start_date2),attributes.start_date2,0),
					finish_date2 : iif(len(attributes.finish_date2),attributes.finish_date2,0),
					bank_action_date : iif(len(attributes.bank_action_date),attributes.bank_action_date,0),
					project_id : iif(len(attributes.project_id),attributes.project_id,0),
					project_head : attributes.project_head,
					special_definition_id : iif(len(attributes.special_definition_id),attributes.special_definition_id,0),
					list_order_type : iif(len(attributes.list_order_type),attributes.list_order_type,0),
					maxrows :attributes.maxrows,
					page : attributes.page
				);
			</cfscript>
            <cfparam name="attributes.totalrecords" default="#get_orders.TOTALROWS#">
        <cfelse>
        	<cfparam name="attributes.totalrecords" default="0">
        </cfif>
        <script type="text/javascript">
            function input_control()
            {   
                <cfif xml_select_acc_member>
                    temp_account_id_list = document.getElementById("account_id_list").selectedIndex;
                                
                    if (document.getElementById("account_id_list").options[temp_account_id_list].value.length == 0 &&  document.getElementById("company_id").value.length == 0 &&  document.getElementById("company").value.length == 0 && document.getElementById("consumer_id").value.length == 0)				
                    {
                        alert("<cf_get_lang no ='422.Cari veya Banka Seçiniz '> !");
                        return false;
                    }
                </cfif>
                return true;
            }
            function wrk_select_change()
            {
                var uzunluk = document.getElementsByName('is_control_info').length;
                for(var zz=1; zz<=uzunluk; zz++)
                {
                    if(document.getElementById("checked_value"+zz) != undefined)
                    {
                        if(document.getElementById("checked_value_main").checked == true)
                            document.getElementById("checked_value"+zz).checked = true;
                        else
                            document.getElementById("checked_value"+zz).checked = false;
                    }
                }
            }
            function open_bank_file()
            {
                account_list_ = '';
                var uzunluk = document.getElementsByName('is_control_info').length;
                document.getElementById("checked_value").value = "";
                for(ci=0;ci<uzunluk;ci++)
                {
                    my_obj=(uzunluk==1)?document.getElementById('is_control_info'):document.getElementsByName('is_control_info')[ci];
                    account_id_= (uzunluk==1)?document.getElementById('account_id'):document.getElementsByName('account_id')[ci];
                    if(document.getElementById('checked_value'+(ci+1)) != undefined && document.getElementById('checked_value'+(ci+1)).checked==true)
                    {
                        if(document.getElementById("checked_value").value == "")
                            document.getElementById("checked_value").value = document.getElementById("checked_value"+(ci+1)).value;
                        else
                            document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+(ci+1)).value;
                        
                        if(! list_find(account_list_,account_id_.value))
                            account_list_+=account_id_.value+',';
                    }
                }
                if(account_list_ != '')
                {
                    account_list_ = account_list_.substr(0,(account_list_.length-1));
                }
                if(list_len(account_list_) > 1)
                {
					alertObject({message: "<cf_get_lang no ='33.Farklı Banka Hesabına Ait Islemleri Birlikte Secemezsiniz '> !",closeTime:3000});	
                    return false;
                }
                windowopen('','small','cc_paym');
                bankDirectory.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_make_bankorder_file';
                bankDirectory.target='cc_paym';
                bankDirectory.submit();
                bankDirectory.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order';
                bankDirectory.target='';
                return true;
            }
            function open_print()
            {
                temp_checked_value = 0;
                var order_id_list = '';
                var control_list= new Array();
                var uzunluk = document.getElementsByName('is_control_info').length;
                document.getElementById("checked_value").value = "";
                for (i=1; i <= uzunluk; i++)
                {
                    if(document.getElementById("checked_value"+i) != undefined && document.getElementById("checked_value"+i).checked == true)
                    {
                        if(document.getElementById("checked_value").value == ""){
                            document.getElementById("checked_value").value = document.getElementById("checked_value"+i).value;
                            control_list[i] = i;
                        }
                        else
                        {	
                            control_list[i]= i;
                            document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+i).value;
                        }
                        temp_checked_value = 1;
                        
                        //break;
                    }	
                }
                order_id_list=document.getElementById("checked_value").value;
                for(j in control_list){
                    for(x in control_list){
                        if(document.getElementById("account_id"+j).value != document.getElementById("account_id"+x).value){
                            alertObject({message: "<cf_get_lang dictionary_id='51445.Aynı banka hesabına ait talimatları seçmelisiniz'>!",closeTime:3000});	
                            return false;
                        }
                    }	
                }
                //en az bir talimat secilmeli
                if(temp_checked_value == 0)
                {
                    alertObject({message: "<cf_get_lang dictionary_id='51497.Listeden En Az Bir Tane Yazdırılacak Belge Seçmelisiniz'>!",closeTime:3000});	
                    return false;
                }
                else
                {
                    windowopen('','medium','cc_paym');
                    bankDirectory.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=150&date1='+document.bankDirectory.finish_date.value+'&order_id_list='+order_id_list+'';
                    bankDirectory.target='cc_paym';
                    bankDirectory.submit();
                    bankDirectory.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order';
                    bankDirectory.target='';
                    return true;
                }
            }
            function open_auto_transfer()
            {
                var formName = 'bankDirectory',  // scripttin en başına bir defa yazılacak
                    form  = $('form[name="'+ formName +'"]'); // form'u seçer 
    
                money_list = '';
                bank_order_type_list = '';
                collacted_havale_list = '';
                temp_checked_value = 0;
                var uzunluk = document.getElementsByName('is_control_info').length;
                for(ci=0;ci<uzunluk;ci++)
                {
                    check_my_obj = document.getElementById('checked_value'+(ci+1));
                    if(check_my_obj.disabled == true)
                    {
                        check_my_obj.disabled = false;
                        check_my_obj.checked = false;
                    }
                    money_info_=(uzunluk==1)?document.getElementById('money_info_'):document.getElementsByName('money_info_')[ci];
                    bank_order_info_=(uzunluk==1)?document.getElementById('bank_order_type_'):document.getElementsByName('bank_order_type_')[ci];
                    if(check_my_obj.checked==true)
                    {
                        if(! list_find(money_list,money_info_.value))
                            money_list+=money_info_.value+',';
                        if(! list_find(bank_order_type_list,bank_order_info_.value))
                            bank_order_type_list+=bank_order_info_.value+',';
                        collacted_havale_list += check_my_obj.value+',';
                    }
                }
                if(collacted_havale_list.length>0)	collacted_havale_list = collacted_havale_list.slice(0,collacted_havale_list.length-1);
                if(money_list != '')
                {
                    money_list = money_list.substr(0,(money_list.length-1));
                }
                
                if(bank_order_type_list != '')
                {
                    bank_order_type_list = bank_order_type_list.substr(0,(bank_order_type_list.length-1));
                }
                
                for (i=1; i <= uzunluk; i++)
                {
                    if(document.getElementById('checked_value'+i).checked == true)
                    {
                        temp_checked_value = 1;
                        break;
                    }	
                }
                //en az bir talimat secilmeli
                if(temp_checked_value == 0)
                {
                    alertObject({message: "<cf_get_lang no ='35.Talimat Seciniz'> !",closeTime:3000});
                    return false;
                }
                //talimatlardan havale kaydi olusturabilmek icin havale edilmeyen ve gelen/giden havaleler listelenmelidir.
                if(form.find('select#is_havale').val()  != 2)
                {	alert(form.find('select#is_havale').val());
                    alertObject({message: "<cf_get_lang dictionary_id='51498.Havale Filtresinden Oluşturulmadı Olanları Listeleyiniz'>!",closeTime:3000});
                    return false;
                }
                if(form.find('select#bank_order_type').val() == "")
                {
                    alertObject({message: "<cf_get_lang dictionary_id='51513.Gelen ya da Giden Talimat Seçmelisiniz'>!",closeTime:3000});
                    return false;
                }
                if(!chk_process_cat('bankDirectory')) return false;
                var pro_cat = document.getElementById("process_cat").value;
                if (!(form.find('select#action_to_account_id').val() == '' && list_find("24;25",document.getElementById("ct_process_type_"+pro_cat).value,";")))
                {
                    if(list_len(money_list) > 1)
                    {
                        alertObject({message: "<cf_get_lang no ='30.Farklı Para Birimlerine Ait Islemleri Birlikte Secemezsiniz '> !",closeTime:3000});
                        return false;
                    }
                }
                if(list_len(bank_order_type_list) > 1)
                {
                    alertObject({message: "<cf_get_lang no ='31.Gelen ve Giden Talimat Islemlerini Birlikte Secemezsiniz '> !",closeTime:3000});
                    return false;
                }
                if(form.find('select#process_cat').val() == "")
                {
                    alertObject({message: "<cf_get_lang_main no='1358.İşlem Tipi Seçiniz'>!",closeTime:3000});
                    return false;
                }
                if(list_len(money_list) == 1)
                {
                    if(list_getat(form.find('select#action_to_account_id').val(),2,';') != "" && money_list != list_getat(form.find('select#action_to_account_id').val(),2,';'))
                    {
                        alertObject({message: "<cf_get_lang dictionary_id='51517.Seçilen İşlemler ile Banka Hesabına Ait Para Birimleri Aynı Olmalıdır'>!",closeTime:3000});
                        return false;
                    }
                }
                //toplu gelen veya giden; ya da tekil havale kaydi olusturulacak.
                if(bank_order_type_list == 250) bank_order_type = 1; else bank_order_type = 0;
                
                //secili satirlari checked_value degerine atar
                document.getElementById("checked_value").value = "";
                for (i=1; i <= uzunluk; i++)
                {
                    if(document.getElementById("checked_value"+i) != undefined && document.getElementById("checked_value"+i).checked == true)
                    {
                        if(document.getElementById("checked_value").value == "")
                            document.getElementById("checked_value").value = document.getElementById("checked_value"+i).value;
                        else
                            document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+i).value;
                    }	
                }
                if(list_find("24;25",document.getElementById("ct_process_type_"+pro_cat).value,";"))
                {
                    if(!form.find('input#collacted_transfer').prop( "checked" ))
                    {
                        windowopen('','small','add_gelen_giden');
                        document.getElementById('bankDirectory').action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopupflush_add_autopayment_import&bank_order_type='+bank_order_type+'&money_type='+money_list+'&from_list=1';
                        document.getElementById('bankDirectory').target='add_gelen_giden';
                        document.getElementById('bankDirectory').submit();
                    }
                    else
                    {
                        if(document.getElementById("ct_process_type_"+pro_cat).value == 24)
                            windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=bank.form_add_gelenh&event=addmulti&is_copy=1&from_assign_order=1&collacted_havale_list="+collacted_havale_list+"&collacted_process_cat="+pro_cat+"&collacted_bank_account="+list_getat(document.getElementById('action_to_account_id').value,1,';'),"wwide");
                        else if(document.getElementById("ct_process_type_"+pro_cat).value == 25)
                            windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=bank.form_add_gidenh&event=addmulti&is_copy=1&from_assign_order=1&collacted_havale_list="+collacted_havale_list+"&collacted_process_cat="+pro_cat+"&collacted_bank_account="+list_getat(document.getElementById('action_to_account_id').value,1,';'),"wwide");
                    }
                }
                return true;
            }
        </script>
    </cfif>
    <cfif  IsDefined("attributes.event") >
       	<cfscript>
			get_credit_limits=getCreditLimits.get();
			if(attributes.event is 'addin' or attributes.event is 'addout')
			{
				attributes.bank_order_id1="";
				attributes.is_paid="";
				attributes.account_id1="";
				attributes.from_branch_id1="";
				attributes.credit_limit_id1="";
				attributes.limit_head1="";
				attributes.employee_id1="";
				attributes.acc_type_id1="";
				attributes.company_id1="";
				attributes.consumer_id1="";
				attributes.action_bank_account1="";
				attributes.special_definition_id1="";
				attributes.project_id1="";
				attributes.assetp_id1="";
				attributes.action_value1="";
				attributes.OTHER_MONEY_VALUE1="";
				attributes.payment_date1=now();
				attributes.ACTION_DETAIL1="";
				attributes.old_process_type="";
				attributes.bank_order_id="";
				process_cat="";
				action_date = now();
			}
		</cfscript>
        <cfif  attributes.event is 'addin' or attributes.event is 'updin' > 
               
            <script type="text/javascript">
                function kontrol_due_option()
                {
                    if(document.bankDirectory.due_option.value == 2)
                        due_day_tr.style.display='';
                    else
                        due_day_tr.style.display='none';
                }
                
                function kontrol()
                {	
                    if (!chk_process_cat('bankDirectory')) return false;
                    if(!check_display_files('bankDirectory')) return false;
                    if(!chk_period(document.bankDirectory.action_date,'İşlem')) return false;
                    if(!acc_control()) return false;
                    kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
                    return true;
                }
                function account_load()
                { 
                    if(document.getElementById('consumer_id').value!='')
                    {	
                        var id=document.getElementById('consumer_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&consumer_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                    else if(document.getElementById('company_id').value!='')
                    {
                        var id=document.getElementById('company_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&company_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                    else if(document.getElementById('employee_id').value!='')
                    {
                        var id=document.getElementById('employee_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&employee_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                }
                $( document ).ready(function() {
                    kur_ekle_f_hesapla('account_id');
                    <cfif attributes.event eq 'addin'>
                        kontrol_due_option();
                    </cfif>
                });
            </script>
        </cfif>
        <cfif  attributes.event is 'addout' or attributes.event is 'updout'>
            <script type="text/javascript">
                function kontrol_due_option()
                {
                    if(document.bankDirectory.due_option.value == 2)
                        due_day_tr.style.display='';
                    else
                        due_day_tr.style.display='none';
                }
                function kontrol()
                {	
                    //deger1=list_getat(document.bankDirectory.account_id.value,2,';');
                    deger1 = document.getElementById("currency_id").value;
                    if(!chk_process_cat('bankDirectory')) return false;
                    if(!check_display_files('bankDirectory')) return false;
                    if(!chk_period(document.bankDirectory.action_date,'İşlem')) return false;
                    if(!acc_control()) return false;
                    kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
                    <cfif attributes.event eq 'addout'>
                        if ((document.bankDirectory.money_type_id.value != '')&&(deger1 != document.bankDirectory.money_type_id.value))
                        {
                            if (!confirm("<cf_get_lang no ='383.Banka para birimi ödeme emrinin para biriminden farklı'>!"))
                            return false;
                        }
                    </cfif>
                    return true;
                }
                function account_load()
                { 
                    if ($('#consumer_id').val().length)
                    {	
                        var id=document.getElementById('consumer_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&consumer_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                    else if ($('#company_id').val().length)
                    {
                        var id=document.getElementById('company_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&company_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                     else if ($('#employee_id').val().length)
                    {
                        var id=document.getElementById('employee_id').value;
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&employee_id='+id,'bank_list',1,'İlişkili Hesaplar');
                    }
                }
            </script>
        </cfif>  
    </cfif>
    <cfif  IsDefined("attributes.event") && (attributes.event is 'updin' || attributes.event is 'updout' || attributes.event eq 'del')>
        <cfscript>
			if(IsDefined('attributes.id'))
				iid = attributes.id ;
			else 
				iid = attributes.bank_order_id ;
				
			get_order = BankOrderModel.get
			(
				id:iid,
				old_process_type : iif(IsDefined('attributes.old_process_type') and len(attributes.old_process_type),attributes.old_process_type,0),
				event : attributes.event
			);
			if(len(get_order.company_id))
				account_branch = BankOrderModel.company_bank(id : get_order.company_id);
			else if(len(get_order.consumer_id))
				account_branch = BankOrderModel.consumer_bank(id : get_order.company_id);
			control_bank = controlBank.get(id : get_order.bank_order_id);
			attributes.bank_order_id1 = get_order.bank_order_id;
            attributes.is_paid = get_order.is_paid;
            attributes.account_id1 = get_order.account_id;
            attributes.from_branch_id1 = get_order.from_branch_id;
            attributes.credit_limit_id1 = get_order.credit_limit_id;
            attributes.limit_head1 = get_credit_limits.limit_head;
            attributes.employee_id1 = get_order.employee_id;
            attributes.acc_type_id1 = get_order.acc_type_id;
            attributes.company_id1 = get_order.company_id;
            attributes.consumer_id1 = get_order.consumer_id;
            attributes.action_bank_account1 = get_order.action_bank_account;
            attributes.special_definition_id1 = get_order.special_definition_id;
            attributes.project_id1 = get_order.project_id;
            attributes.assetp_id1 = get_order.assetp_id;
            attributes.action_value1 = get_order.action_value;
            attributes.OTHER_MONEY_VALUE1 = get_order.OTHER_MONEY_VALUE;
            attributes.payment_date1 = get_order.payment_date;
            attributes.ACTION_DETAIL1 = get_order.ACTION_DETAIL;
            process_cat=get_order.BANK_ORDER_TYPE_ID;
            old_process_type=get_order.bank_order_type;
            action_date = get_order.action_date;
		</cfscript>
    </cfif>
    <cfif  IsDefined("attributes.event") and attributes.event is 'updin'>
        <cfif len(GET_ORDER.ORDER_ID)>
			<cfscript>
                get_order_info = getOrderInfo.get(id : GET_ORDER.ORDER_ID);
			</cfscript>
        </cfif>
    </cfif>
    <cfif  IsDefined("attributes.event") and attributes.event is 'updout'>
        <cfscript>
			control_payment = BankOrderModel.controlPayment(id : get_order.bank_order_id);
		</cfscript>
        <cfif control_payment.recordcount eq 1>
            <cfscript>
				get_camp_head = getCampHead.get(id : control_payment.campaign_id);
			</cfscript>
        </cfif>
    </cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(IsDefined("attributes.event") and attributes.event neq 'del')
	{ 
		WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
		WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
		if( attributes.event is 'updout' || attributes.event is 'addout')
			WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 250;
		else
			WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 251;
		WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
		
		WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		if( attributes.event is 'updout' || attributes.event is 'addout')
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addout,updout';
		else
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addin,updin';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ORDERS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BANK_ORDER_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-2','item-5','item-9','item-11']";
   }
   else if (not IsDefined("attributes.event") or attributes.event eq 'list')
   {
	    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ORDERS';
		WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BANK_ORDER_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";	
	}
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_assign_order';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_assign_order.cfm';
	
	WOStruct['#attributes.fuseaction#']['updout'] = structNew();
	WOStruct['#attributes.fuseaction#']['updout']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updout']['fuseaction'] = 'bank.list_assign_order';
	WOStruct['#attributes.fuseaction#']['updout']['filePath'] = 'bank/form/FormBankOrder.cfm';
	WOStruct['#attributes.fuseaction#']['updout']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['updout']['nextEvent'] = 'bank.list_assign_order&event=updout&bank_order_id=';
	WOStruct['#attributes.fuseaction#']['updout']['parameters'] = 'bank_order_id=##attributes.bank_order_id##';
	WOStruct['#attributes.fuseaction#']['updout']['Identity'] = '##attributes.bank_order_id##';
	WOStruct['#attributes.fuseaction#']['updout']['recordQuery'] = 'get_order';
	WOStruct['#attributes.fuseaction#']['updout']['formName'] = 'bankDirectory';
	
	WOStruct['#attributes.fuseaction#']['updout']['buttons']['update'] = 1;
    WOStruct['#attributes.fuseaction#']['updout']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	if(IsDefined("attributes.event") and attributes.event is 'updout')
	{
		if (control_payment.recordcount eq 0 and control_bank.recordcount eq 0 )
		{
			WOStruct['#attributes.fuseaction#']['updout']['buttons']['delete'] = 1;
		}
	}
	WOStruct['#attributes.fuseaction#']['updin'] = structNew();
	WOStruct['#attributes.fuseaction#']['updin']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updin']['fuseaction'] = 'bank.list_assign_order';
	WOStruct['#attributes.fuseaction#']['updin']['filePath'] = 'bank/form/FormBankOrder.cfm';
	WOStruct['#attributes.fuseaction#']['updin']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['updin']['nextEvent'] = 'bank.list_assign_order&event=updin&bank_order_id=';
	WOStruct['#attributes.fuseaction#']['updin']['parameters'] = 'bank_order_id=##attributes.bank_order_id##';
	WOStruct['#attributes.fuseaction#']['updin']['Identity'] = '##attributes.bank_order_id##';
	WOStruct['#attributes.fuseaction#']['updin']['recordQuery'] = 'get_order';
	WOStruct['#attributes.fuseaction#']['updin']['formName'] = 'bankDirectory';
	
	WOStruct['#attributes.fuseaction#']['updin']['buttons']['update'] = 1;
    WOStruct['#attributes.fuseaction#']['updin']['buttons']['updateFunction'] = 'kontrol() && validate()';
	if(IsDefined("attributes.event") && attributes.event is 'updin' && control_bank.recordcount eq 0)
	{
		WOStruct['#attributes.fuseaction#']['updin']['buttons']['delete'] = 1;
	}
	WOStruct['#attributes.fuseaction#']['addout'] = structNew();
	WOStruct['#attributes.fuseaction#']['addout']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addout']['fuseaction'] = 'bank.list_assign_order';
	WOStruct['#attributes.fuseaction#']['addout']['filePath'] = 'bank/form/FormBankOrder.cfm';
	WOStruct['#attributes.fuseaction#']['addout']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['addout']['nextEvent'] = 'bank.list_assign_order&event=updout&bank_order_id=';
	WOStruct['#attributes.fuseaction#']['addout']['formName'] = 'bankDirectory';
	
	WOStruct['#attributes.fuseaction#']['addout']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addout']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addout']['buttons']['saveFunction'] = 'kontrol() && validate()';
	
	WOStruct['#attributes.fuseaction#']['addin'] = structNew();
	WOStruct['#attributes.fuseaction#']['addin']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addin']['fuseaction'] = 'bank.list_assign_order';
	WOStruct['#attributes.fuseaction#']['addin']['filePath'] = 'bank/form/FormBankOrder.cfm';
	WOStruct['#attributes.fuseaction#']['addin']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['addin']['nextEvent'] = 'bank.list_assign_order&event=updin&bank_order_id=';
	WOStruct['#attributes.fuseaction#']['addin']['formName'] = 'bankDirectory';
	
	WOStruct['#attributes.fuseaction#']['addin']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addin']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addin']['buttons']['saveFunction'] = 'kontrol() && validate()';
	
	if( IsDefined("attributes.event") &&  (attributes.event is 'updout' || attributes.event is 'updin' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_assign_order&bank_order_id=#get_order.bank_order_id#&old_process_type=#get_order.bank_order_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_assign_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_assign_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_assign_order';
	}
	if(IsDefined("attributes.event") && (attributes.event is 'updout' || attributes.event is 'updin'))
	{
		if(attributes.event is 'updout')
			eventName='updout';
		else
			eventName='updin';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_ORDER_ID" action_id="#get_order.bank_order_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_order.bank_order_id#&process_cat=#get_order.bank_order_type#','page','popup_list_card_rows')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['icons']['add']['text'] = '#lang_array_main.item[170]#';
		if(attributes.event is 'updout')
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updout']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_assign_order&event=addout";
		else
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updin']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_assign_order&event=addin";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['icons']['print']['text'] = '#lang_array_main.item[62]#';
	    tabMenuStruct['#attributes.fuseaction#']['tabMenus'][eventName]['icons']['print']['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#get_order.bank_order_id#&print_type=157</cfoutput>','page')";
	  	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
<cfif isdefined('attributes.event') and isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif listFind('addout,updout,addin,updin,del',attributes.event)>
        <cfif attributes.event eq 'updout'>
            <cfif IsDefined('get_order') and not get_order.recordcount>
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang no='133.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı'> !",closeTime:3000});
                </script>
                <cfabort>
            </cfif>
        </cfif>
        <cfif attributes.event eq 'addin'>
            <cfscript>
				kontrol = getControlBillNo.get();
			</cfscript>
            <cfif not kontrol.recordcount>
                <script type="text/javascript">
                    alertObject({message: "<a href='<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>' ><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'></a>",closeTime:3000});
                </script>
                <cfabort>
            </cfif>
        </cfif>
        <cfif attributes.event eq 'del'>
            <cfscript>
				control_bank_order = getOrderId.get(orderId: attributes.bank_order_id,old_process_type : attributes.old_process_type);
			</cfscript>
            <cfif not control_bank_order.recordcount>
                <br/><font class="txtbold">Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı !</font>
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang dictionary_id='48794.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı'>!",closeTime:3000});
                </script>
                <cfabort>
            <cfelseif (CONTROL_BANK_ORDER.IS_PAID eq 1)>
                <script type="text/javascript">
                   alertObject({message: "<cf_get_lang no ='408.Silmek İstediğiniz Banka Talimatı İçin Oluşturulmuş Giden Havale Kaydı Bulunmaktadır'>!",closeTime:3000});
                </script>
                <cfabort>
            </cfif>
        </cfif>
        <cfif IsDefined("attributes.active_period") and attributes.active_period neq session.ep.period_id>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!",closeTime:3000});
            </script>
            <cfabort>
        </cfif>
        <cfif IsDefined("is_account") and is_account eq 1>
            <cfif len(attributes.COMPANY_ID)><!--- firmanın muhasebe kodu --->
                <cfset borclu_hesap = GET_COMPANY_PERIOD(attributes.COMPANY_ID)>
            <cfelseif len(attributes.CONSUMER_ID) ><!---bireysel uyenin muhasebe kodu--->
                <cfset borclu_hesap = GET_CONSUMER_PERIOD(attributes.CONSUMER_ID)>
            <cfelseif len(attributes.EMPLOYEE_ID) ><!---çalışanın muhasebe kodu--->
                <cfset borclu_hesap = GET_EMPLOYEE_PERIOD(attributes.EMPLOYEE_ID, attributes.ACC_TYPE_ID)>
            </cfif>
            <cfif not len(borclu_hesap)>
                <script type="text/javascript">
                    alertObject({message :"<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>",closeTime:3000});
                </script>
                <cfabort>
            </cfif>
            <cfif len(attributes.account_id)>
                <cfscript>
					get_bank_order_code = getBankOrderCode.get(account_id : attributes.account_id);
				</cfscript>
                <cfif not len(get_bank_order_code.ACCOUNT_ORDER_CODE)>

                    <script type="text/javascript">
                        alertObject({message :"<cf_get_lang no ='388.Seçtiğiniz Banka Hesabının Talimat Muhasebe Kodu Seçilmemiş'>!",closeTime:3000});
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
        </cfif>
        <cfif attributes.event eq 'del'>
             <cfscript>
				control_bank_order = getOrderId.get(orderId: attributes.bank_order_id,old_process_type : attributes.old_process_type);
			</cfscript>
            <cfif not control_bank_order.recordcount>
                <br/><font class="txtbold">Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı !</font>
                <cfexit method="exittemplate">
            <cfelseif (CONTROL_BANK_ORDER.IS_PAID eq 1)>
                <script type="text/javascript">
                    alertObject({message :"<cf_get_lang no ='408.Silmek İstediğiniz Banka Talimatı İçin Oluşturulmuş Giden Havale Kaydı Bulunmaktadır'>!",closeTime:3000});
                </script>
                <cfabort>
            </cfif>
        </cfif>
    </cfif>
   <cfif attributes.event is 'addin'>
    	<cfset attributes.acc_type_id = "">
		<cfscript>
            if(listlen(attributes.employee_id,'_') eq 2)
            {
                attributes.acc_type_id = listlast(attributes.employee_id,'_');
                attributes.employee_id = listfirst(attributes.employee_id,'_');
			}
				get_process_type = getProcessCat.get(process_cat : attributes.process_cat);
				process_type = get_process_type.PROCESS_TYPE;
				is_account = get_process_type.IS_ACCOUNT;
				is_cari = get_process_type.IS_CARI;
				if(is_account eq 1)
				{
					if(len(attributes.company_id))
						alacakli_hesap = get_company_period(attributes.company_id);	
					else if (len(attributes.consumer_id))
						alacakli_hesap = get_consumer_period(attributes.consumer_id);
					else if (len(attributes.employee_id))
						alacakli_hesap = get_employee_period(attributes.employee_id, attributes.acc_type_id);
					if(len(attributes.account_id))
						get_bank_order_code = getBankOrderCode.get(account_id : attributes.account_id);
				}
            
			if(len(attributes.company_id))
				get_bank = getCompanyBank.get(company_id : attributes.company_id,currency_id : attributes.currency_id);
			else
				get_bank = getCompanyBank.get(consumer_id : attributes.consumer_id,currency_id : attributes.currency_id);
        </cfscript>
        <cf_date tarih='attributes.PAYMENT_DATE'>
        <cf_date tarih='attributes.action_date'>
		<cfscript>
            attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
            attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
            attributes.system_amount = filterNum(attributes.system_amount);
            paper_currency_multiplier = '';
            for(s_sy=1; s_sy lte attributes.kur_say; s_sy = s_sy+1)
            {
                'attributes.txt_rate1_#s_sy#' = filterNum(evaluate('attributes.txt_rate1_#s_sy#'),session.ep.our_company_info.rate_round_num);
                'attributes.txt_rate2_#s_sy#' = filterNum(evaluate('attributes.txt_rate2_#s_sy#'),session.ep.our_company_info.rate_round_num);
                if( evaluate("attributes.hidden_rd_money_#s_sy#") is attributes.money_type)
                    paper_currency_multiplier = evaluate('attributes.txt_rate2_#s_sy#/attributes.txt_rate1_#s_sy#');
            }
        </cfscript>
        <cfif not isdefined("attributes.copy_order_count") or attributes.copy_order_count eq "">
			<cfset attributes.copy_order_count = 1>
            <cfset attributes.due_option = 3>
        </cfif>
        <cfset temp_order_count = attributes.copy_order_count-1>
        <cfloop from="0" to="#temp_order_count#" index="i">
        	<cfset temp_action_date = attributes.action_date>
            <cfif attributes.due_option eq 1>
                <cfset temp_payment_date = dateadd('m',i,attributes.payment_date)>
            <cfelseif attributes.due_option eq 2>
                <cfset temp_payment_date = dateadd('d',(i*attributes.due_day),attributes.payment_date)>
            <cfelseif attributes.due_option eq 3>
                <cfset temp_payment_date = attributes.payment_date>
            </cfif>
            <cfscript>
				add = BankOrderModel.add
				(
					process_type : process_type,
					process_cat : form.process_cat,
					list_bank : iif(len(attributes.list_bank),attributes.list_bank,0),
					branch_id : iif(len(attributes.branch_id),attributes.branch_id,0),
					ORDER_AMOUNT : iif(len(attributes.order_amount),attributes.order_amount,0),
					currency_id : iif(len(attributes.currency_id),"attributes.currency_id",DE("")),
					account_id : iif(len(attributes.account_id),attributes.account_id,0),
					company_id : iif(len(attributes.company_id),attributes.company_id,0),
					consumer_id : iif(len(attributes.consumer_id),attributes.consumer_id,0),
					employee_id : iif(len(attributes.employee_id),attributes.employee_id,0),
					acc_type_id : iif(len(attributes.acc_type_id),attributes.acc_type_id,0),
					MEMBER_BANK_ID : iif(len(get_bank.member_bank_id),get_bank.member_bank_id,0),
					project_name : attributes.project_name,
					project_id : iif(len(attributes.project_id),attributes.project_id,0),
					OTHER_CASH_ACT_VALUE : iif(len(attributes.OTHER_CASH_ACT_VALUE),attributes.OTHER_CASH_ACT_VALUE,0),
					money_type : iif(len(attributes.money_type),"attributes.money_type",DE("")),
					action_detail : attributes.ACTION_DETAIL,
					asset_id : iif(len(attributes.asset_id),attributes.asset_id,0),
					asset_name : attributes.asset_name,
					credit_limit : iif(len(attributes.credit_limit),attributes.credit_limit,0),
					special_definition_id : iif(len(attributes.special_definition_id),attributes.special_definition_id,0),
					action_date : temp_action_date,
					payment_date : temp_payment_date,
					recordcount : iif(len(get_bank.recordcount),get_bank.recordcount,0)
				);
				currency_id=attributes.currency_id;
				if (isDefined('attributes.branch_id'))
				{
					to_branch_id=attributes.branch_id;
				}
				else
				{
					to_branch_id=listgetat(session.ep.user_location,2,'-');
				}
				currency_multiplier = '';
				if(isDefined('attributes.kur_say') and len(attributes.kur_say))
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
						if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
							currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		
				if(is_account eq 1)
				{
					if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
						str_card_detail = '#attributes.ACTION_DETAIL#';
					else
						str_card_detail = 'Gelen Banka Talimatı';
					muhasebeci
					(
						action_id : MAX_ID.IDENTITYCOL,
						workcube_process_type : process_type,
						workcube_process_cat:form.process_cat,
						islem_tarihi : temp_action_date,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						fis_detay : 'GELEN BANKA TALİMATI',
						borc_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
						borc_tutarlar : attributes.system_amount,
						other_amount_borc : attributes.ORDER_AMOUNT,
						other_currency_borc : currency_id,
						alacak_hesaplar : alacakli_hesap,
						alacak_tutarlar : attributes.system_amount,
						other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
						other_currency_alacak : attributes.money_type,
						currency_multiplier : currency_multiplier,
						fis_satir_detay : str_card_detail,
						to_branch_id : to_branch_id,
						acc_project_id : attributes.project_id,
						account_card_type : 13
					);
				}
		
				if(is_cari eq 1)
				{
					if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
						act_detail = '#attributes.ACTION_DETAIL#';
					else
						act_detail = '';
					carici
						(
						action_id : MAX_ID.IDENTITYCOL,
						workcube_process_type : process_type,
						action_table : 'BANK_ORDERS',
						process_cat : form.process_cat,
						islem_tarihi : temp_action_date,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						from_employee_id : attributes.employee_id,
						acc_type_id : attributes.acc_type_id,
						islem_tutari : attributes.system_amount,
						action_currency : session.ep.money,
						other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
						other_money : attributes.money_type,
						currency_multiplier : currency_multiplier,
						islem_detay : 'Gelen Banka Talimatı',
						account_card_type : 13,
						action_detail : act_detail,
						due_date: temp_payment_date,
						to_account_id : attributes.account_id,
						to_branch_id : to_branch_id,
						project_id : attributes.project_id,
						is_processed : 0, //banka talimatının havaleye çekilmedigini gösteriyor.
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						rate2:paper_currency_multiplier
						);
				}
				f_kur_ekle_action(action_id:add,process_type:0,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
				fark = 8 - len(add);
				seri_no = add;
				if(fark > 0)
				{
					for(i=0;i<fark;i++)
						seri_no ='0'+seri_no;
				}
				else
					seri_no=add;
				upd_ = BankOrderModel.updSeriNo
				(
					seri_no : seri_no,
					max_id : add
				);
			</cfscript>
        </cfloop>
            <cfset attributes.actionId = add>
    <cfelseif attributes.event eq 'updin'>
    	<cfset attributes.acc_type_id = "">
		<cfscript>
            if(listlen(attributes.employee_id,'_') eq 2)
            {
                attributes.acc_type_id = listlast(attributes.employee_id,'_');
                attributes.employee_id = listfirst(attributes.employee_id,'_');
			}
				get_process_type = getProcessCat.get(process_cat : attributes.process_cat);
				process_type = get_process_type.PROCESS_TYPE;
				is_account = get_process_type.IS_ACCOUNT;
				is_cari = get_process_type.IS_CARI;
				if(is_account eq 1)
				{
					if(len(attributes.company_id))
						alacakli_hesap = get_company_period(attributes.company_id);	
					else if (len(attributes.consumer_id))
						alacakli_hesap = get_consumer_period(attributes.consumer_id);
					else if (len(attributes.employee_id))
						alacakli_hesap = get_employee_period(attributes.employee_id, attributes.acc_type_id);
					if(len(attributes.account_id))
						get_bank_order_code = getBankOrderCode.get(account_id : attributes.account_id);
				}
            
			if(len(attributes.company_id))
				get_bank = getCompanyBank.get(company_id : attributes.company_id,currency_id : attributes.currency_id);
			else
				get_bank = getCompanyBank.get(consumer_id : attributes.consumer_id,currency_id : attributes.currency_id);
        </cfscript>
        <cf_date tarih='attributes.PAYMENT_DATE'>
        <cf_date tarih='attributes.action_date'>
        <cfscript>
            attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
            attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
            attributes.system_amount = filterNum(attributes.system_amount);
            paper_currency_multiplier = '';
            for(s_sy=1; s_sy lte attributes.kur_say; s_sy = s_sy+1)
            {
                'attributes.txt_rate1_#s_sy#' = filterNum(evaluate('attributes.txt_rate1_#s_sy#'),session.ep.our_company_info.rate_round_num);
                'attributes.txt_rate2_#s_sy#' = filterNum(evaluate('attributes.txt_rate2_#s_sy#'),session.ep.our_company_info.rate_round_num);
                if( evaluate("attributes.hidden_rd_money_#s_sy#") is attributes.money_type)
                    paper_currency_multiplier = evaluate('attributes.txt_rate2_#s_sy#/attributes.txt_rate1_#s_sy#');
            }
			upd = BankOrderModel.upd
			(
				process_cat : attributes.process_cat,
				list_bank : iif(len(attributes.list_bank),attributes.list_bank,0),
				branch_id : iif(len(attributes.branch_id),attributes.branch_id,0),
				ORDER_AMOUNT : iif(len(attributes.order_amount),attributes.order_amount,0),
				currency_id : iif(len(attributes.currency_id),"attributes.currency_id",DE("")),
				account_id : iif(len(attributes.account_id),attributes.account_id,0),
				company_id : iif(len(attributes.company_id),attributes.company_id,0),
				consumer_id : iif(len(attributes.consumer_id),attributes.consumer_id,0),
				employee_id : iif(len(attributes.employee_id),attributes.employee_id,0),
				acc_type_id : iif(len(attributes.acc_type_id),attributes.acc_type_id,0),
				MEMBER_BANK_ID : iif(len(get_bank.member_bank_id),get_bank.member_bank_id,0),
				project_name : attributes.project_name,
				project_id : iif(len(attributes.project_id),attributes.project_id,0),
				OTHER_CASH_ACT_VALUE : iif(len(attributes.OTHER_CASH_ACT_VALUE),attributes.OTHER_CASH_ACT_VALUE,0),
				money_type : iif(len(attributes.money_type),"attributes.money_type",DE("")),
				action_detail : attributes.ACTION_DETAIL,
				asset_id : iif(len(attributes.asset_id),attributes.asset_id,0),
				asset_name : attributes.asset_name,
				credit_limit : iif(len(attributes.credit_limit),attributes.credit_limit,0),
				special_definition_id : iif(len(attributes.special_definition_id),attributes.special_definition_id,0),
				action_date : attributes.action_date,
				payment_date : attributes.payment_date,
				bank_order_type : 251 ,
				id : attributes.bank_order_id
			
			);
			
			if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
			{
				attributes.project_id = "";
				attributes.project_name = "";
			}
			currency_id=attributes.currency_id;
			if (isDefined('attributes.branch_id'))
			{
				to_branch_id=attributes.branch_id;
			}
			else
			{
				to_branch_id=listgetat(session.ep.user_location,2,'-');
			}
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		
			if(is_account eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = 'Gelen Banka Talimatı';
				muhasebeci (
					action_id : upd,
					workcube_process_type : process_type,
					workcube_old_process_type : form.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type : 13,
					company_id:attributes.company_id,
					consumer_id:attributes.consumer_id,
					islem_tarihi : attributes.ACTION_DATE,
					fis_satir_detay : str_card_detail,
					borc_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
					borc_tutarlar : attributes.system_amount,
					other_amount_borc : attributes.ORDER_AMOUNT,
					other_currency_borc : currency_id,
					alacak_hesaplar : alacakli_hesap,
					alacak_tutarlar : attributes.system_amount,
					other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_currency_alacak : form.money_type,
					currency_multiplier : currency_multiplier,
					to_branch_id :  to_branch_id,
					acc_project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
					fis_detay : 'GELEN BANKA TALİMATI'
				);
			}
			else
				muhasebe_sil (action_id:upd,process_type:old_process_type);
		
			if(is_cari eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					act_detail = '#attributes.ACTION_DETAIL#';
				else
					act_detail = '';
				carici
					(
					action_id : upd,
					workcube_process_type : process_type,
					workcube_old_process_type : form.old_process_type,
					action_table : 'BANK_ORDERS',
					process_cat : form.process_cat,
					islem_tarihi : attributes.ACTION_DATE,
					to_account_id : attributes.account_id,
					to_branch_id :  to_branch_id,
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_money : form.money_type,
					currency_multiplier : currency_multiplier,
					action_detail : act_detail,
					islem_detay : 'Gelen Banka Talimatı',
					account_card_type : 13,
					due_date: attributes.PAYMENT_DATE,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.employee_id,
					acc_type_id : attributes.acc_type_id,
					project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
					is_processed : attributes.is_havale,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			else
				cari_sil(action_id:upd,process_type:old_process_type);

    		f_kur_ekle_action(action_id:upd,process_type:1,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
			attributes.actionId = upd;
		</cfscript>
    <cfelseif attributes.event is 'del'>
    	<cfscript>
			cari_sil(action_id:attributes.bank_order_id,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:attributes.bank_order_id,process_type:attributes.old_process_type);
			del = BankOrderModel.del(id : attributes.bank_order_id);
			attributes.actionId = attributes.bank_order_id;
		</cfscript>
    <cfelseif attributes.event is 'addout'>
    	<cfscript>
			get_process_type = getProcessCat.get(process_cat : attributes.process_cat);
    	</cfscript>
        <cfif not isdefined("is_from_premium")>
            <cf_date tarih='attributes.PAYMENT_DATE'>
        </cfif>
        <cf_date tarih='attributes.ACTION_DATE'>
        <cfscript>
            process_type = get_process_type.PROCESS_TYPE;
            is_account = get_process_type.IS_ACCOUNT;
            is_cari = get_process_type.IS_CARI;
			attributes.acc_type_id = "";
			if(isDefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
            {
                attributes.acc_type_id = listlast(attributes.employee_id,'_');
                attributes.employee_id = listfirst(attributes.employee_id,'_');
            }
        </cfscript>
        <cfif (is_account eq 1)>
            <cfif len(attributes.COMPANY_ID)><!--- firmanın muhasebe kodu --->
                <cfset borclu_hesap = GET_COMPANY_PERIOD(attributes.COMPANY_ID)>
            <cfelseif len(attributes.CONSUMER_ID)><!---bireysel uyenin muhasebe kodu--->
                <cfset borclu_hesap = GET_CONSUMER_PERIOD(attributes.CONSUMER_ID)>
            <cfelseif len(attributes.EMPLOYEE_ID) ><!---çalışanın muhasebe kodu--->
                <cfset borclu_hesap = GET_EMPLOYEE_PERIOD(attributes.EMPLOYEE_ID, attributes.ACC_TYPE_ID)>
            </cfif>>
			<cfscript>
				if(len(attributes.account_id))
					get_bank_order_code = getBankOrderCode.get(account_id : attributes.account_id);
					if(len(attributes.company_id))
						get_bank = getCompanyBank.get(company_id : attributes.company_id,currency_id : attributes.currency_id);
					else
						get_bank = getCompanyBank.get(consumer_id : attributes.consumer_id,currency_id : attributes.currency_id);
						paper_currency_multiplier = 0;
			</cfscript>
		</cfif>
        <cfscript>
				if(not isDefined("is_from_makeage"))
				{
					attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
					attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
					attributes.system_amount = filterNum(attributes.system_amount);
					for(d_sy=1; d_sy lte attributes.kur_say; d_sy=d_sy+1)
					{
						'attributes.txt_rate1_#d_sy#' = filterNum(evaluate('attributes.txt_rate1_#d_sy#'),session.ep.our_company_info.rate_round_num);
						'attributes.txt_rate2_#d_sy#' = filterNum(evaluate('attributes.txt_rate2_#d_sy#'),session.ep.our_company_info.rate_round_num);
						if(evaluate("attributes.hidden_rd_money_#d_sy#") is attributes.money_type)
							paper_currency_multiplier = evaluate('attributes.txt_rate2_#d_sy#/attributes.txt_rate1_#d_sy#');
					}
				}
				if(isdefined("attributes.branch_id") and len(attributes.branch_id))
					branch_id_info = attributes.branch_id;
				else
					branch_id_info = listgetat(session.ep.user_location,2,'-');
            </cfscript>
            <cfif not isdefined("paper_currency_multiplier")><cfset paper_currency_multiplier = 0></cfif>
				<cfif not isdefined("attributes.copy_order_count") or attributes.copy_order_count eq "">
                    <cfset attributes.copy_order_count = 1>
                    <cfset attributes.due_option = 3>
                </cfif>
                <cfset temp_order_count = attributes.copy_order_count-1>
                <cfloop from="0" to="#temp_order_count#" index="i">
                    <cfset temp_action_date = attributes.action_date>
                    <cfif attributes.due_option eq 1>
                        <cfset temp_payment_date = date_add('m',i,attributes.payment_date)>
                    <cfelseif attributes.due_option eq 2>
                        <cfset temp_payment_date = date_add('d',(i*attributes.due_day),attributes.payment_date)>
                    <cfelseif attributes.due_option eq 3>
                        <cfset temp_payment_date = attributes.payment_date>
                    </cfif>
                    <cfscript>
						add = BankOrderModel.add
						(
							process_type : process_type,
							process_cat : form.process_cat,
							list_bank : iif(len(attributes.list_bank),attributes.list_bank,0),
							from_branch_id : iif(len(attributes.branch_id),attributes.branch_id,0),
							ORDER_AMOUNT : iif(len(attributes.order_amount),attributes.order_amount,0),
							currency_id : iif(len(attributes.currency_id),"attributes.currency_id",DE("")),
							account_id : iif(len(attributes.account_id),attributes.account_id,0),
							company_id : iif(len(attributes.company_id),attributes.company_id,0),
							consumer_id : iif(len(attributes.consumer_id),attributes.consumer_id,0),
							employee_id : iif(len(attributes.employee_id),attributes.employee_id,0),
							acc_type_id : iif(len(attributes.acc_type_id),attributes.acc_type_id,0),
							project_name : attributes.project_name,
							project_id : iif(len(attributes.project_id),attributes.project_id,0),
							OTHER_CASH_ACT_VALUE : iif(len(attributes.OTHER_CASH_ACT_VALUE),attributes.OTHER_CASH_ACT_VALUE,0),
							money_type : iif(len(attributes.money_type),"attributes.money_type",DE("")),
							action_detail : attributes.ACTION_DETAIL,
							asset_id : iif(len(attributes.asset_id),attributes.asset_id,0),
							asset_name : attributes.asset_name,
							credit_limit : iif(len(attributes.credit_limit),attributes.credit_limit,0),
							special_definition_id : iif(len(attributes.special_definition_id),attributes.special_definition_id,0),
							action_date : temp_action_date,
							payment_date : temp_payment_date
						);
						if(not isDefined("is_from_makeage"))
						{
							currency_multiplier = '';
							if(isDefined('attributes.kur_say') and len(attributes.kur_say))
								for(mon=1;mon lte attributes.kur_say;mon=mon+1)
									if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
										currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						}			
						if(is_account eq 1)
						{
							if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
								str_card_detail = '#attributes.ACTION_DETAIL#';
							else
								str_card_detail = 'Giden Banka Talimatı';
								
							//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
							GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
							str_fark_gelir = get_no_.fark_gelir;
							str_fark_gider = get_no_.fark_gider;
							str_max_round = 0.1;
							str_round_detail = 'GİDEN BANKA TALİMATI';
										
							muhasebeci
							(
								action_id : add,
								workcube_process_type : process_type,
								workcube_process_cat:form.process_cat,
								islem_tarihi : temp_action_date,
								fis_detay : 'GİDEN BANKA TALİMATI',
								company_id : attributes.company_id,
								consumer_id : attributes.consumer_id,
								borc_hesaplar : borclu_hesap,
								borc_tutarlar : attributes.system_amount,
								other_amount_borc : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
								other_currency_borc :attributes.money_type,
								alacak_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
								alacak_tutarlar : attributes.system_amount,
								other_amount_alacak : attributes.ORDER_AMOUNT,
								other_currency_alacak : attributes.currency_id,
								fis_satir_detay: str_card_detail,
								currency_multiplier : currency_multiplier,
								from_branch_id : branch_id_info,
								account_card_type : 13,
								dept_round_account :str_fark_gider,
								claim_round_account : str_fark_gelir,
								max_round_amount :str_max_round,
								acc_project_id : attributes.project_id,
								round_row_detail:str_round_detail				
							);
						}		
						if(is_cari eq 1)
						{
							if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
								act_detail = '#attributes.ACTION_DETAIL#';
							else
								act_detail = '';
							if (isdefined("attributes.order_id") and len(attributes.order_id))
								paper_no_info = '#MAX_ID.IDENTITYCOL#';
							else
								paper_no_info = '';
							carici
								(
								action_id : add,
								workcube_process_type : process_type,	
								action_table : 'BANK_ORDERS',			
								process_cat : form.process_cat,
								islem_tarihi : temp_action_date,				
								to_cmp_id : attributes.company_id,	
								to_consumer_id : attributes.consumer_id,
								to_employee_id : iif(isdefined("attributes.employee_id") and len(attributes.employee_id),'attributes.employee_id',de('')),
								acc_type_id : attributes.acc_type_id,
								islem_tutari : attributes.system_amount,
								action_currency : session.ep.money,				
								other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
								other_money : attributes.money_type,
								currency_multiplier : currency_multiplier,
								action_detail : act_detail,
								islem_detay : 'Ödeme Emri(Giden Banka Talimatı)',					
								account_card_type : 13,
								due_date: temp_payment_date,
								from_account_id : attributes.account_id,
								from_branch_id : branch_id_info,
								project_id : attributes.project_id,
								islem_belge_no : paper_no_info,
								is_processed : 0, //banka banka talimatının havaleye çekilmedigini gösteriyor.
								assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
								rate2: paper_currency_multiplier
								);
						}
						f_kur_ekle_action(action_id:add,process_type:0,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
						fark = 8 - len(add);
						seri_no = add;
						if(fark > 0)
						{
							for(i=0;i<fark;i++)
								seri_no ='0'+seri_no;
						}
						else
							seri_no=add;
						upd_ = BankOrderModel.updSeriNo
						(
							seri_no : seri_no,
							max_id : add
						);
						if(isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.order_row_id") and len(attributes.order_row_id))
						{
							upd_closed_ = BankOrderModel.upd_closed(id : attributes.order_id);
							if(is_cari eq 1)
							{
								get_cari_info = BankOrderModel.GET_CARI_INFO(id : add ,process_type: process_type);
								if(len(GET_CARI_INFO.recordcount) and (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)))
									upd_closed = BankOrderModel.upd_closed(row_id : 0 ,action_id: GET_CARI_INFO.CARI_ACTION_ID , amount : P_ORDER_VALUE , other_amount :OTHER_P_ORDER_VALUE,id:attributes.order_id);
								else if(len(GET_CARI_INFO.recordcount))
								{
									add_closed_row = BankOrderModel.ADD_CLOSED_ROW
									(
										order_id : attributes.order_id,
										CARI_ACTION_ID : GET_CARI_INFO.CARI_ACTION_ID,
										identitycol : add,
										process_type : process_type,
										system_amount : attributes.system_amount,
										other_cash_act_value : attributes.other_cash_act_value,
										money_type : attributes.money_type,
										temp_payment_date :temp_payment_date
									);
									if(isdefined("attributes.order_row_id") and len(attributes.order_row_id))
									{
											get_closed = getClosed.get(id : attributes.order_id);
											upd_cari_closed = BankOrderModel.UPD_CARI_CLOSED(id : attributes.order_id,ORDER_DEBT_AMOUNT_VALUE :P_ORDER_DEBT_AMOUNT_VALUE ,ORDER_CLAIM_AMOUNT_VALUE :P_ORDER_CLAIM_AMOUNT_VALUE);
											upd_closed = BankOrderModel.upd_closed(row_id : add_closed_row , amount : P_ORDER_VALUE , other_amount :OTHER_P_ORDER_VALUE , id : attributes.order_id);
									}
								}
							}
						}
					</cfscript>
       			</cfloop>
                <cfset attributes.actionId = add>
        <cfelseif attributes.event is 'updout'>
        	<cf_date tarih='attributes.PAYMENT_DATE'>
            <cf_date tarih='attributes.ACTION_DATE'>
			<cfset attributes.acc_type_id = ''> 
			<cfscript>
                if(listlen(attributes.employee_id,'_') eq 2)
                {
                    attributes.acc_type_id = listlast(attributes.employee_id,'_');
                    attributes.employee_id = listfirst(attributes.employee_id,'_');
                }
				get_process_type = getProcessCat.get(process_cat : attributes.process_cat);
				process_type = get_process_type.PROCESS_TYPE;
				is_cari =get_process_type.IS_CARI;
				is_account = get_process_type.IS_ACCOUNT;
            </cfscript>
            <cfif (is_account eq 1)>
				<cfif len(attributes.COMPANY_ID)><!--- firmanın muhasebe kodu --->
                    <cfset borclu_hesap = GET_COMPANY_PERIOD(attributes.COMPANY_ID)>
                <cfelseif len(attributes.CONSUMER_ID) ><!---bireysel uyenin muhasebe kodu--->
                    <cfset borclu_hesap = GET_CONSUMER_PERIOD(attributes.CONSUMER_ID)>
                <cfelseif len(attributes.EMPLOYEE_ID) ><!---çalışanın muhasebe kodu--->
                    <cfset borclu_hesap = GET_EMPLOYEE_PERIOD(attributes.EMPLOYEE_ID, attributes.ACC_TYPE_ID)>
                </cfif>
                <cfif len(attributes.account_id)>
                    <cfscript>
						get_bank_order_code = getBankOrderCode.get(account_id : attributes.account_id);
					</cfscript>
                </cfif>
            </cfif>
            <cfscript>
				if(len(attributes.account_id))
					if(len(attributes.company_id))
						get_bank = getCompanyBank.get(company_id : attributes.company_id,currency_id : attributes.currency_id);
					else
						get_bank = getCompanyBank.get(consumer_id : attributes.consumer_id,currency_id : attributes.currency_id);
					paper_currency_multiplier = '';
					if(not isDefined("is_from_makeage"))
					{
						attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
						attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
						attributes.system_amount = filterNum(attributes.system_amount);
						for(e_sy=1; e_sy lte attributes.kur_say; e_sy=e_sy+1)
						{
							'attributes.txt_rate1_#e_sy#' = filterNum(evaluate('attributes.txt_rate1_#e_sy#'),session.ep.our_company_info.rate_round_num);
							'attributes.txt_rate2_#e_sy#' = filterNum(evaluate('attributes.txt_rate2_#e_sy#'),session.ep.our_company_info.rate_round_num);
							if(evaluate("attributes.hidden_rd_money_#e_sy#") is attributes.money_type)
								paper_currency_multiplier = evaluate('attributes.txt_rate2_#e_sy#/attributes.txt_rate1_#e_sy#');
						}
					}
					if(isdefined("attributes.branch_id") and len(attributes.branch_id))
						branch_id_info = attributes.branch_id;
					else
						branch_id_info = listgetat(session.ep.user_location,2,'-');
						
					upd = BankOrderModel.upd
					(
						process_cat : attributes.process_cat,
						list_bank : iif(len(attributes.list_bank),attributes.list_bank,0),
						from_branch_id : iif(len(attributes.branch_id),attributes.branch_id,0),
						ORDER_AMOUNT : iif(len(attributes.order_amount),attributes.order_amount,0),
						currency_id : iif(len(attributes.currency_id),"attributes.currency_id",DE("")),
						account_id : iif(len(attributes.account_id),attributes.account_id,0),
						company_id : iif(len(attributes.company_id),attributes.company_id,0),
						consumer_id : iif(len(attributes.consumer_id),attributes.consumer_id,0),
						employee_id : iif(len(attributes.employee_id),attributes.employee_id,0),
						acc_type_id : iif(len(attributes.acc_type_id),attributes.acc_type_id,0),
						MEMBER_BANK_ID : iif(len(get_bank.member_bank_id),get_bank.member_bank_id,0),
						project_name : attributes.project_name,
						project_id : iif(len(attributes.project_id),attributes.project_id,0),
						OTHER_CASH_ACT_VALUE : iif(len(attributes.OTHER_CASH_ACT_VALUE),attributes.OTHER_CASH_ACT_VALUE,0),
						money_type : iif(len(attributes.money_type),"attributes.money_type",DE("")),
						action_detail : attributes.ACTION_DETAIL,
						asset_id : iif(len(attributes.asset_id),attributes.asset_id,0),
						asset_name : attributes.asset_name,
						credit_limit : iif(len(attributes.credit_limit),attributes.credit_limit,0),
						special_definition_id : iif(len(attributes.special_definition_id),attributes.special_definition_id,0),
						action_date : attributes.action_date,
						payment_date : attributes.payment_date,
						bank_order_type : 250 ,
						id : attributes.bank_order_id
					
					);
					
					
					if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
					{
						attributes.project_id = "";
						attributes.project_name = "";
					}
					currency_multiplier = '';
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
								currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								
					if(is_account eq 1)
					{
						if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
							str_card_detail = '#attributes.ACTION_DETAIL#';
						else
							str_card_detail = 'Giden Banka Talimatı';
						muhasebeci (
							action_id : upd,
							workcube_process_type : process_type,
							workcube_old_process_type : form.old_process_type,
							workcube_process_cat:form.process_cat,
							company_id : attributes.company_id,
							consumer_id : attributes.consumer_id,
							account_card_type : 13,
							islem_tarihi : attributes.ACTION_DATE,
							fis_satir_detay : str_card_detail,
							borc_hesaplar : borclu_hesap,
							borc_tutarlar : attributes.system_amount,
							other_amount_borc : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
							other_currency_borc : form.money_type,
							alacak_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
							alacak_tutarlar : attributes.system_amount,
							other_amount_alacak : attributes.ORDER_AMOUNT,
							other_currency_alacak : attributes.currency_id,
							currency_multiplier : currency_multiplier,
							from_branch_id : branch_id_info,
							acc_project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
							fis_detay : 'GİDEN BANKA TALİMATI'
						);	
					}
					else
						muhasebe_sil (action_id:form.bank_order_id,process_type:form.old_process_type);
				
					if(is_cari eq 1)
					{
						is_processed = attributes.is_havale;
						if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
							act_detail = '#attributes.ACTION_DETAIL#';
						else
							act_detail = '';
						carici
							(
							action_id : upd,
							workcube_process_type : process_type,	
							workcube_old_process_type : form.old_process_type,	
							action_table : 'BANK_ORDERS',			
							process_cat : form.process_cat,
							islem_tarihi : attributes.ACTION_DATE,				
							from_account_id : attributes.account_id,			
							from_branch_id : branch_id_info,
							islem_tutari : attributes.system_amount,
							action_currency : session.ep.money,				
							other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
							other_money : form.money_type,
							islem_detay : 'Ödeme Emri(Giden Banka Talimatı)',					
							currency_multiplier : currency_multiplier,
							action_detail : act_detail,
							account_card_type : 13,
							due_date: attributes.PAYMENT_DATE,		
							to_cmp_id : attributes.company_id,	
							to_consumer_id : attributes.consumer_id,
							to_employee_id : attributes.employee_id,
							acc_type_id : attributes.acc_type_id,
							project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
							is_processed : is_processed,
							assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
							rate2:paper_currency_multiplier
							);
					}
					else
						cari_sil(action_id:upd,process_type:form.old_process_type);
				
					f_kur_ekle_action(action_id:upd,process_type:1,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
					attributes.actionId = upd;
			</cfscript>
    	</cfif>
    </cfif> 