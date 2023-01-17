<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor --->
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd',attributes.event)>
	<cfif attributes.active_period neq session.ep.period_id>
        <script type="text/javascript">
			alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!"});
        </script>
        <cfabort>
    </cfif>
    <cfquery name="control_paper_no" datasource="#dsn2#">
        SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"> <cfif isdefined('attributes.id')>AND ACTION_ID <> #attributes.ID#</cfif>
    </cfquery>
	<cfif control_paper_no.recordcount>
        <script type="text/javascript">
            alertObject({message: "<cf_get_lang no='401.Aynı Belge No İle Kayıtlı Gelen Havale İşlemi Var'>!"});
        </script>
        <cfabort>
    </cfif>
</cfif>
<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor --->
 
<!--- Sayfa Query'leri ---->
<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_gelenh">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfset process_cat = "">
<cfif attributes.event is 'add'>
    <cfinclude template="../bank/query/control_bill_no.cfm">
	<cfif isdefined("attributes.ID") and len(attributes.ID)>
        <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
            <cfquery name="get_all_cash" datasource="#dsn2#">
                SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
            </cfquery>
            <cfset cash_list = valuelist(get_all_cash.cash_id)>
            <cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
            <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
        </cfif>
        <cfquery name="get_gelenh" datasource="#dsn2#">
            SELECT
                BA.*,
                ISNULL(COM.FULLNAME,ISNULL(CON.CONSUMER_NAME +' '+ CON.CONSUMER_SURNAME,E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME)) FULLNAME,
                PP.PROJECT_HEAD           
            FROM
                BANK_ACTIONS BA
                LEFT JOIN #dsn_alias#.COMPANY COM ON BA.ACTION_FROM_COMPANY_ID = COM.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER CON ON BA.ACTION_FROM_CONSUMER_ID = CON.CONSUMER_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON BA.ACTION_FROM_EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
            WHERE
                ACTION_ID=#attributes.ID#
                <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
                    AND                   
                    (
                        ACTION_TYPE_ID NOT IN (21,22,23) AND
                        (FROM_BRANCH_ID = #control_branch_id# OR
                        TO_BRANCH_ID = #control_branch_id#)
                    )
                </cfif>
        </cfquery>
 
        <cfset company_id = get_gelenh.action_from_company_id>
        <cfset consumer_id = get_gelenh.action_from_consumer_id>
        <cfset emp_id = get_gelenh.ACTION_FROM_EMPLOYEE_ID>
		<cfif not len(get_gelenh.ACTION_FROM_EMPLOYEE_ID)>
        	<cfset member_name = get_gelenh.fullname>
        <cfelse>
			<cfif len(get_gelenh.acc_type_id)>
                <cfset emp_id = "#emp_id#_#get_gelenh.acc_type_id#">
                <cfset member_name=get_emp_info(get_gelenh.ACTION_FROM_EMPLOYEE_ID,0,0,0,get_gelenh.acc_type_id)>
            <cfelse>
                <cfset member_name = get_emp_info(get_gelenh.ACTION_FROM_EMPLOYEE_ID,0,0)>
            </cfif>
        </cfif>
        <cfset from_account_id = get_gelenh.action_to_account_id>   
        <cfset process_cat = get_gelenh.process_cat>
        <cfset to_branch_id = get_gelenh.to_branch_id>
        <cfset special_definition_id = get_gelenh.special_definition_id>
        <cfset acc_department_id = get_gelenh.acc_department_id>
        <cfset project_id = get_gelenh.project_id>
        <cfset project_head = get_gelenh.project_head>
        <cfset assetp_id = get_gelenh.assetp_id>
        <cfset action_date = get_gelenh.action_date>      
        <cfset other_cash_act_value = get_gelenh.other_cash_act_value>
        <cfif get_gelenh.masraf gt 0>
			<cfset masraf = get_gelenh.masraf>
        <cfelse>
			<cfset masraf = ''>
        </cfif>
        <cfset expense_center_id = get_gelenh.expense_center_id>
        <cfset expense_item_id = get_gelenh.expense_item_id>
        <cfset other_cash_act_value = get_gelenh.other_cash_act_value>
        <cfset other_money_order = get_gelenh.other_money>
        <cfset to_amount = get_gelenh.action_value+get_gelenh.masraf>
        <cfset action_detail = get_gelenh.action_detail>
    <cfelse>
        <cfset member_name = "">
        <cfset company_id = "">
        <cfset consumer_id = "">
        <cfset emp_id = "">
        <cfset from_account_id = ''>
        <cfset process_cat = ''>
        <cfset to_branch_id = ''>
        <cfset special_definition_id = ''>
        <cfset acc_department_id = ''>
        <cfset project_id = ''>
        <cfset project_head = ''>
        <cfset assetp_id = ''>
        <cfset action_date = ''>
        <cfset other_cash_act_value = ''>
        <cfset masraf = ''>
        <cfset expense_center_id = ''>
        <cfset expense_item_id = ''>
        <cfset other_cash_act_value = ''>
        <cfset other_money_order = ''>
        <cfset to_amount = ''>
        <cfset action_detail = ''>
    </cfif>
   
    <cfif isdefined("attributes.bank_order_id") and len(attributes.bank_order_id)>
        <cfquery name="GET_BANK_ORDER" datasource="#dsn2#">
            SELECT
                BON.*,
                BB.BANK_NAME,
                BB.BANK_BRANCH_NAME,
                A.ACCOUNT_NO,
                A.ACCOUNT_ORDER_CODE,
                <cfif isdefined("attributes.is_company")>
                    C.FULLNAME
                <cfelseif isdefined("attributes.is_consumer")>
                    C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME
                <cfelseif isdefined("attributes.is_employee")>
                    EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS FULLNAME
                </cfif>
            FROM
                BANK_ORDERS BON,
                #dsn3_alias#.ACCOUNTS AS A,
                #dsn3_alias#.BANK_BRANCH AS BB,
                <cfif isdefined("attributes.is_company")>
                    #dsn_alias#.COMPANY AS C
                <cfelseif isdefined("attributes.is_consumer")>
                    #dsn_alias#.CONSUMER AS C
                <cfelseif isdefined("attributes.is_employee")>
                    #dsn_alias#.EMPLOYEES AS EMP       
                </cfif>
            WHERE                   
                A.ACCOUNT_ID = BON.ACCOUNT_ID AND
                A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND
                BON.BANK_ORDER_ID = #attributes.bank_order_id# AND
                <cfif isdefined("attributes.is_company")>
                    C.COMPANY_ID = BON.COMPANY_ID
                <cfelseif isdefined("attributes.is_consumer")>
                    C.CONSUMER_ID = BON.CONSUMER_ID
                <cfelseif isdefined("attributes.is_employee")>
                    EMP.EMPLOYEE_ID = BON.EMPLOYEE_ID
                </cfif>
        </cfquery>
        <cfif len(get_bank_order.special_definition_id)>
            <cfset special_definition_id=get_bank_order.special_definition_id>
        </cfif>
        <cfset emp_id = get_bank_order.ACTION_FROM_EMPLOYEE_ID>
        <cfif len(get_bank_order.ACTION_FROM_EMPLOYEE_ID)>
                                               <cfif len(get_bank_order.acc_type_id)>
                <cfset emp_id = "#emp_id#_#get_bank_order.acc_type_id#">
                <cfset member_name=get_emp_info(get_action_detail.ACTION_FROM_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)>
            <cfelse>
                <cfset member_name = get_emp_info(get_action_detail.ACTION_FROM_EMPLOYEE_ID,0,0)>
            </cfif>
        </cfif>
    </cfif>
    <cfscript>
        if (isdefined("attributes.bank_order_id") and len(attributes.bank_order_id) and get_bank_order.recordcount)
        {
            bank_order_id = attributes.bank_order_id;
            company_id = get_bank_order.COMPANY_ID;
            consumer_id = get_bank_order.CONSUMER_ID;
            from_account_id = get_bank_order.account_id;
            action_date = get_bank_order.PAYMENT_DATE;
            to_amount = get_bank_order.ACTION_VALUE;
            other_money_order = get_bank_order.OTHER_MONEY;
		   if(not len(get_bank_order.ACTION_FROM_EMPLOYEE_ID))
				member_name = get_bank_order.fullname;
            is_disabled = 1;
            action_detail = GET_BANK_ORDER.action_detail;
            attributes.project_id=get_bank_order.project_id;
            to_branch_id=get_bank_order.to_branch_id;
        }
        else
        {
            bank_order_id = "";
            is_disabled = 0;
        }
    </cfscript>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="get_pro_name" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#attributes.project_id#
        </cfquery>
        <cfset project_id = attributes.project_id>
        <cfset project_head = get_pro_name.project_head>
    </cfif>
<cfelseif attributes.event is 'upd'>
    <cfset attributes.table_name = "BANK_ACTIONS">
    <cfinclude template="../bank/query/get_action_detail.cfm">
    <cfif not get_action_detail.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
	<cfif len(get_action_detail.action_id) and len(get_action_detail.action_type_id)>
        <cfquery name="get_closed" datasource="#dsn2#">
            SELECT
                CCR.CLOSED_ID
            FROM
                CARI_CLOSED CC,
                CARI_CLOSED_ROW CCR
            WHERE
                CC.CLOSED_ID = CCR.CLOSED_ID
                AND CC.IS_CLOSED = 1
                AND CCR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.action_id#">
                AND CCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.action_type_id#">
        </cfquery>
    </cfif>
    <cfset company_id = get_action_detail.ACTION_FROM_COMPANY_ID>
    <cfset consumer_id = get_action_detail.ACTION_FROM_CONSUMER_ID>
    <cfset emp_id = get_action_detail.ACTION_FROM_EMPLOYEE_ID>
    <cfif len(get_action_detail.acc_type_id)>
        <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
    </cfif>
    <cfif len(get_action_detail.ACTION_FROM_COMPANY_ID)>
        <cfset member_name=get_par_info(get_action_detail.ACTION_FROM_COMPANY_ID,1,1,0)>
    <cfelseif len(get_action_detail.ACTION_FROM_CONSUMER_ID)>
        <cfset member_name=get_cons_info(get_action_detail.ACTION_FROM_CONSUMER_ID,0,0)>
    <cfelseif len(get_action_detail.ACTION_FROM_EMPLOYEE_ID)>
        <cfset member_name=get_emp_info(get_action_detail.ACTION_FROM_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)>
    </cfif>
    <cfset bank_order_id = get_action_detail.bank_order_id>
    <cfset process_cat = get_action_detail.process_cat>
    <cfset from_account_id = get_action_detail.action_to_account_id>
    <cfset is_disabled = 0>
    <cfset to_branch_id = get_action_detail.to_branch_id>
    <cfset special_definition_id = get_action_detail.special_definition_id>
    <cfset acc_department_id = get_action_detail.acc_department_id>
    <cfset project_id = get_action_detail.project_id>
    <cfset project_head = get_action_detail.project_head>
    <cfset assetp_id = get_action_detail.assetp_id>
    <cfset paper_num = get_action_detail.paper_no>
    <cfset action_date = get_action_detail.action_date>
    <cfset to_amount = get_action_detail.ACTION_VALUE+get_action_detail.MASRAF>
    <cfset other_cash_act_value = get_action_detail.OTHER_CASH_ACT_VALUE>
    <cfset action_detail = get_action_detail.action_detail>
    <cfif get_action_detail.MASRAF gt 0>
		<cfset masraf = get_action_detail.MASRAF>
    <cfelse>
		<cfset masraf = "">
    </cfif>
    <cfset expense_center_id = get_action_detail.expense_center_id>
    <cfset expense_item_id = get_action_detail.expense_item_id>
<cfelseif attributes.event is "addmulti">
	<cfinclude template="../bank/query/control_bill_no.cfm">
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT MONEY,RATE1,RATE2,ISNULL(RATE3,1) RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR,0 AS IS_SELECTED FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
    <cfif isdefined("attributes.multi_id") and len(attributes.multi_id)><!--- kopyalama --->
        <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
            <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
        </cfif>
        <cfquery name="GET_MONEY" datasource="#DSN2#">
            SELECT MONEY_TYPE AS MONEY,* FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"> ORDER BY ACTION_MONEY_ID
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="GET_MONEY" datasource="#DSN2#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <cfquery name="get_action_detail" datasource="#DSN2#">
            SELECT
                BAM.*,
                BA.ACC_DEPARTMENT_ID,
                BA.ACTION_FROM_COMPANY_ID AS ACTION_COMPANY_ID,
                BA.ACTION_FROM_CONSUMER_ID AS ACTION_CONSUMER_ID,
                BA.ACTION_FROM_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                BA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
                BA.PROJECT_ID,
                BA.PAPER_NO,
               	BA.ACTION_ID,
                BA.ACTION_VALUE,
                BA.ACTION_DETAIL,
                BA.OTHER_MONEY AS ACTION_CURRENCY,
                BA.TO_BRANCH_ID,
                BA.MASRAF,
                BA.EXPENSE_CENTER_ID,
                BA.EXPENSE_ITEM_ID,
                BA.ASSETP_ID,
                BA.SPECIAL_DEFINITION_ID,
                BA.ACC_TYPE_ID
            FROM
                BANK_ACTIONS_MULTI BAM,
                BANK_ACTIONS BA
            WHERE
                BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID AND
                BAM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
                <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
                AND                    
                (
                    BA.ACTION_TYPE_ID NOT IN (21,22,23) AND
                    (BA.FROM_BRANCH_ID = #control_branch_id# OR
                    BA.TO_BRANCH_ID = #control_branch_id#)
                )
                </cfif>
        </cfquery>
        <cfset to_account_id = get_action_detail.to_account_id>
        <cfset to_branch_id = get_action_detail.to_branch_id>
        <cfset to_department_id = get_action_detail.ACC_DEPARTMENT_ID>
    <cfelseif isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)>
        <cfquery name="get_action_detail" datasource="#dsn2#">
            SELECT
                COMPANY_ID AS ACTION_COMPANY_ID,
                CONSUMER_ID AS ACTION_CONSUMER_ID,
                EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                OTHER_MONEY_VALUE AS ACTION_VALUE_OTHER,
                PROJECT_ID AS PROJECT_ID,
                '' PAPER_NO,
                '' ACTION_ID,
                ACTION_VALUE AS ACTION_VALUE,
                '' ACTION_DETAIL,
                OTHER_MONEY AS ACTION_CURRENCY,
                '' TO_BRANCH_ID,
                '' MASRAF,
                '' EXPENSE_CENTER_ID,
                '' EXPENSE_ITEM_ID,
                '' ASSETP_ID,
                SPECIAL_DEFINITION_ID,
                '' ACC_DEPARTMENT_ID,
                '' ACC_TYPE_ID,
                '' MULTI_ACTION_ID,
                '' ACTION_TYPE_ID,
                '' AS TO_ACCOUNT_ID,
                PAYMENT_DATE AS ACTION_DATE,
                #attributes.collacted_process_cat# PROCESS_CAT,
                BANK_ORDER_TYPE_ID,
                BANK_ORDER_ID
            FROM
                BANK_ORDERS
            WHERE
                BANK_ORDER_ID IN (#attributes.collacted_havale_list#)
        </cfquery>
        <cfif len(attributes.collacted_bank_account)><cfset to_account_id = attributes.collacted_bank_account><cfelse><cfset to_account_id = get_action_detail.to_account_id></cfif>
        <cfset to_branch_id = get_action_detail.to_branch_id>
        <cfset to_department_id = get_action_detail.acc_department_id>
        <cfset action_date = get_action_detail.ACTION_DATE>
    <cfelse>
        <cfset to_account_id = ''>
        <cfset to_branch_id = ''>
        <cfset to_department_id = ''>
        <cfset action_date = ''>
    </cfif>
	<cfset action_date = now()>
    <cfif isdefined('get_action_detail')>
        <cfset action_date = get_action_detail.action_date>
        <cfset process_cat = get_action_detail.process_cat>
    </cfif>
    <cfset isDefault = 1>
<cfelseif attributes.event is "updmulti">
    <cfquery name="get_action_detail" datasource="#dsn2#">
        SELECT
            BAM.*,
            BA.ACTION_FROM_COMPANY_ID AS ACTION_COMPANY_ID,
            BA.ACTION_FROM_CONSUMER_ID AS ACTION_CONSUMER_ID,
            BA.ACTION_FROM_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
            BA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
            BA.PROJECT_ID,
            BA.PAPER_NO,
            BA.ACTION_ID,
            BA.ACTION_VALUE,
            BA.ACTION_DETAIL,
            BA.OTHER_MONEY AS ACTION_CURRENCY,
            BAM.UPD_STATUS,
            BA.MASRAF,
            BA.EXPENSE_CENTER_ID,
            BA.EXPENSE_ITEM_ID,
            BA.TO_BRANCH_ID,
            BA.ASSETP_ID,
            BA.SPECIAL_DEFINITION_ID,
            BA.ACC_DEPARTMENT_ID AS DEPARTMENT_ID,
            BA.ACC_TYPE_ID,
            BA.BANK_ORDER_ID
        FROM
            BANK_ACTIONS_MULTI BAM,
            BANK_ACTIONS BA
        WHERE
            BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID
            AND BAM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
    </cfquery>
    <!--- toplu gelen havale ile ilgili kapama isleminin olup olmadigina bakilir --->
    <cfif len(get_action_detail.action_id) and len(get_action_detail.action_type_id)>
        <cfquery name="get_closed" datasource="#dsn2#">
            SELECT
                CARI_CLOSED.CLOSED_ID,
                CARI_CLOSED.IS_DEMAND,
                CARI_CLOSED.IS_ORDER,
                CARI_CLOSED.IS_CLOSED
            FROM
                CARI_CLOSED_ROW,
                CARI_CLOSED
            WHERE
                CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID AND
                CARI_CLOSED.IS_CLOSED = 1 AND
                CARI_CLOSED_ROW.ACTION_ID IN (<cfqueryparam value="#Trim(valueList(get_action_detail.action_id,','))#" list="yes" cfsqltype="cf_sql_integer">) AND
                CARI_CLOSED_ROW.ACTION_TYPE_ID = 24
        </cfquery>
    </cfif>
    <cfif not get_action_detail.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
   
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,*,RATE2 RATE3 FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id# ORDER BY ACTION_MONEY_ID
    </cfquery>
   
    <cfif not GET_MONEY.recordcount>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    <cfset action_date = get_action_detail.action_date>
    <cfset process_cat = get_action_detail.process_cat>
    <cfset isDefault = 0>
    <cfset to_branch_id = get_action_detail.to_branch_id>
    <cfset to_department_id = get_action_detail.department_id>
</cfif>
 
<!--- Sayfaların birleştirilmiş script fonksiyonları. Aynı isme sahip fonksiyonlarda event'a göre kontroller mevcut olur. Farklı isimli fonksiyonları olduğu gibi ekleyebilirsiniz.  --->
<script type="text/javascript">
	<cfif attributes.event is "addmulti" or attributes.event is "updMulti">
	   $( document ).ready(function() {
			change_money_info('add_process','action_date','<cfoutput>#xml_money_type#</cfoutput>');
	   });
	<cfelseif attributes.event is "add" or attributes.event is "upd">
	   <cfoutput>
		   function kontrol()
		   {
			   <cfif attributes.event is 'add'>
					if(!paper_control(incoming_transfer.paper_number,'INCOMING_TRANSFER')) return false;
			   </cfif>
			   if(!chk_process_cat('incoming_transfer')) return false;
			   if(!check_display_files('incoming_transfer')) return false;
			   if(!chk_period(document.getElementById('action_date'), 'İşlem')) return false;
			   <cfif attributes.event is 'upd'>
					if(!acc_control()) return false;
			   </cfif>
			   kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
			   
			   if(document.incoming_transfer.masraf.value != "" && document.incoming_transfer.masraf.value != 0)//masraf tutarı girildiğindeki kontrol
			   {
				  if(document.incoming_transfer.expense_item_id.value == "" || document.incoming_transfer.expense_item_name.value == "")
				  {
					  alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang_main no ='1139.Gider Kalemi'>");
					  return false;
				  }
				  if(document.incoming_transfer.expense_center_id.value == "" || document.incoming_transfer.expense_center_name.value == "")
				  {
					  alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang_main no ='1048.Masraf Merkezi'>");
					  return false;
				  }
			   }
			   <cfif attributes.event is 'add'>
				if(document.getElementById('account_id').disabled == true)
					document.getElementById('account_id').disabled = false;
				return true;
			   <cfelseif attributes.event is 'upd'>
					return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			   </cfif>
		   }
		   <cfif attributes.event is 'upd'>
			   function del_kontrol()
			   {
				  return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
				  if(!chk_period(document.incoming_transfer.ACTION_DATE, 'İşlem')) return false;
					//else return true;
			   }
		   </cfif>
	   </cfoutput>
	</cfif>
</script>
 
<cfscript>
	// Switch //
	WOStruct = StructNew();
   
	WOStruct['#attributes.fuseaction#'] = structNew();
   
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
   
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_actions';
				  
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 24;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
   
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(attributes.event contains 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_action_detail.process_stage;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
   
	if(not attributes.event contains 'multi'){
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'incoming_transfer';
	}
   
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2; // Transaction ve extendedFields icin yapildi.
	
	if(attributes.event is "add" or attributes.event is "upd")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-comp_name','item-action_date','item-ACTION_VALUE']";
	}
	else if(attributes.event is "addmulti" or attributes.event is "updmulti")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addmulti,updmulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-action_date','item-process_cat','item-account_id']";
	}	
   
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_gelenh';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_gelenh&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'incoming_transfer';
   
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate()';
   
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_add_gelenh';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_gelenh&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'incoming_transfer';
   
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();

	if (not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
	   if (xml_is_upd_import_file eq 1 or (xml_is_upd_import_file eq 0 and not(isdefined("get_action_detail.file_import_id") and len(get_action_detail.file_import_id))))
	   {
		   WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		   WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate()';
		   WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
		   WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
		   WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
	   }
	}
	else
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = 'Fatura Kapama İşlemi Yapıldığı İçin Belge Güncellenemez.';
   
	WOStruct['#attributes.fuseaction#']['addmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['addmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addmulti']['fuseaction'] = 'bank.form_add_gelenh';
	WOStruct['#attributes.fuseaction#']['addmulti']['filePath'] = 'bank/form/form_collacted_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['queryPath'] = 'bank/query/add_collacted_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['nextEvent'] = 'bank.form_add_gelenh&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['addmulti']['js'] = "javascript:gizle_goster_ikili('collacted_gelenh','collacted_gelenh_bask')";
	WOStruct['#attributes.fuseaction#']['addmulti']['formName'] = 'add_process';
   
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['saveFunction'] = 'control_form()';
   
	WOStruct['#attributes.fuseaction#']['updmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updmulti']['fuseaction'] = 'bank.form_add_gelenh';
	WOStruct['#attributes.fuseaction#']['updmulti']['filePath'] = 'bank/form/form_collacted_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['queryPath'] = 'bank/query/upd_collacted_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['nextEvent'] = 'bank.form_add_gelenh&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['updmulti']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['js'] = "javascript:gizle_goster_ikili('collacted_gelenh','collacted_gelenh_bask')";
	WOStruct['#attributes.fuseaction#']['updmulti']['formName'] = 'add_process';
	WOStruct['#attributes.fuseaction#']['updmulti']['recordQuery'] = 'get_action_detail';
   
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons'] = structNew();
	if (not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
	   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
	   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'control_form()';
	   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['delete'] = 1;
	   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteFunction'] = 'control_del_form()';
	   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteUrl'] = '#request.self#?fuseaction=bank.form_add_gelenh&event=del';
    }
    <cfsavecontent variable="message">
        <cf_get_lang dictionary_id="52412.Fatura Kapama İşlemi Yapıldığı İçin Belge Güncellenemez.">
    </cfsavecontent>
    <cfsavecontent variable="message2">
        <cf_get_lang dictionary_id="52504.Ödeme Talebi İşlemi Yapıldığı İçin Belge Güncellenemez.">
    </cfsavecontent>
    <cfsavecontent variable="message3">
        <cf_get_lang dictionary_id="52519.Ödeme Emri İşlemi Yapıldığı İçin Belge Güncellenemez.">
    </cfsavecontent>


	if ((session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
	   if (get_closed.is_closed eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = message;
	   else if(get_closed.is_demand eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = message2;
	   else if(get_closed.is_order eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = message3;
	}
   
	if(attributes.event is 'upd' or attributes.event is 'updmulti' or attributes.event is 'del')
	{
	   if(isdefined("attributes.multi_id"))
	   {
		   WOStruct['#attributes.fuseaction#']['del'] = structNew();
		   WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		   if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#';
		   WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_collacted_action.cfm';
		   WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_collacted_action.cfm';
		   WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';                     
	   }
	   else if(isdefined("attributes.id"))
	   {
		   WOStruct['#attributes.fuseaction#']['del'] = structNew();
		   WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		   if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.del_gelenh&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#&active_period=#session.ep.period_id#&paper_number=#paper_num#';
		   WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_gelenh.cfm';
		   WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_gelenh.cfm';
		   WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';      
	   }

	}
	if(attributes.event is 'addmulti')
	{
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][1]['text'] = '#lang_array_main.item[1998]# #lang_array_main.item[280]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][1]['href'] = "#request.self#?fuseaction=bank.form_add_gelenh&event=add";    

	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'updmulti')
	{                             
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_MULTI_ACTION_ID" action_id="#attributes.multi_id#">';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['text'] = '#lang_array_main.item[35]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=240','page','incoming_transfer')";

	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['text'] = '#lang_array_main.item[170]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gelenh&event=addmulti";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['target'] = "_blank";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['href'] = '#request.self#?fuseaction=bank.form_add_gelenh&event=addmulti&multi_id=#attributes.multi_id#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['target'] = "_blank";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['print']['text'] = '#lang_array_main.item[62]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=154&action_id=#attributes.multi_id#&action_type=#get_action_detail.action_type_id#&keyword=multi','page')";
	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_ACTION_ID" action_id="#attributes.id#">';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_gelenh');";
	  
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gelenh";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=bank.form_add_gelenh&ID=#get_action_detail.action_id#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=154&action_type=#get_action_detail.action_type_id#','page')";
	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'add')
	{
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[620]# #lang_array_main.item[280]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_gelenh&event=addmulti";
	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>