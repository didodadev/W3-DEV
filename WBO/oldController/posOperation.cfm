<cfif not isDefined('attributes.event') or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="bank.list_pos_operation">
    <cfsetting showdebugoutput="no">
    <cfparam name="attributes.pos_id" default="">
    <cfparam name="attributes.schedule_id" default="">
    <cfparam name="attributes.status" default=1>
    <cfparam name="attributes.is_schedule" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfquery name="GET_POS_ALL" datasource="#DSN3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
    </cfquery>
    <cfquery name="getSchedule" datasource="#dsn#">
        SELECT SCHEDULE_NAME,SCHEDULE_ID FROM SCHEDULE_SETTINGS WHERE ISNULL(IS_POS_OPERATION,0) = 1
    </cfquery>
    <cfif isdefined("attributes.is_form_submitted")>	
        <cfquery name="get_rule_row" datasource="#dsn3#">
            SELECT DISTINCT PO.POS_OPERATION_ID,
                (SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = POS_ID) CARD_NO,
                IS_FLAG,
                ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW WITH (NOLOCK) WHERE POS_OPERATION_ID = PO.POS_OPERATION_ID),0) COUNT_ROW,
                ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ID = PO.POS_OPERATION_ID AND ISNUMERIC(RESPONCE_CODE) = '00' AND IS_PAYMENT = 0),0) COUNT_ROW_REMAIN,
                PO.*
                <cfif len(attributes.is_schedule) or len(attributes.schedule_id)>
                    ,STR.SCHEDULE_ID,
                    STR.ROW_NUMBER
                </cfif>
                ,E1.EMPLOYEE_NAME+' '+E1.EMPLOYEE_SURNAME RECORD_EMP_NAME
                ,E2.EMPLOYEE_NAME+' '+E2.EMPLOYEE_SURNAME UPDATE_EMP_NAME
            FROM 
                POS_OPERATION PO WITH (NOLOCK) 
            LEFT JOIN
                #DSN_ALIAS#.EMPLOYEES E1
            ON
                E1.EMPLOYEE_ID = PO.RECORD_EMP
            LEFT JOIN
                #DSN_ALIAS#.EMPLOYEES E2
            ON
                E2.EMPLOYEE_ID = PO.UPDATE_EMP 
                <cfif len(attributes.is_schedule) or len(attributes.schedule_id)>
                    LEFT JOIN #dsn_alias#.SCHEDULE_SETTINGS_ROW STR ON STR.POS_OPERATION_ID = PO.POS_OPERATION_ID
                </cfif>
            WHERE
                1 = 1
                <cfif isDefined("attributes.status") and len(attributes.status)>
                    AND IS_ACTIVE = #attributes.status# 
                </cfif>
                <cfif isDefined("attributes.pos_id") and len(attributes.pos_id)>
                    AND POS_ID = #attributes.pos_id# 
                </cfif>
                <cfif len(attributes.is_schedule) and attributes.is_schedule eq 1>
                    AND STR.POS_OPERATION_ID IS NOT NULL
                <cfelseif len(attributes.is_schedule) and attributes.is_schedule eq 0>
                    AND STR.POS_OPERATION_ID IS NULL
                </cfif>
                <cfif len(attributes.schedule_id)>
                    AND STR.SCHEDULE_ID = #attributes.schedule_id#
                </cfif>
                <cfif len(attributes.keyword)>
                    AND POS_OPERATION_NAME LIKE '#attributes.keyword#%'
                </cfif>
            ORDER BY
                <cfif len(attributes.schedule_id)>
                    STR.ROW_NUMBER,
                </cfif>
                POS_OPERATION_NAME
        </cfquery>
    <cfelse>
        <cfset get_rule_row.recordcount = 0>
    </cfif>
	<script language="javascript">
        function ajax_load(row_no,pos_operation_id,type)
        {
            eval('pos_operation_td_'+row_no).style.display = 'none';
            if(type == 0)
            {
                eval('pos_operation_td_2_'+row_no).style.display = '';
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_add_pos_operation_action&row_no='+row_no+'&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Çalışıyor');
            }
            else
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_add_pos_operation_action_remain&row_no='+row_no+'&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Çalışıyor');
        }
        function ajax_load_stop(row_no,pos_operation_id)
        {
            eval('pos_operation_td_'+row_no).style.display = 'none';
            eval('pos_operation_td_2_'+row_no).style.display = 'none';
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_stop_pos_operation_action&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Durduruluyor');
        }
    </script>
<cfelse>
	<cf_xml_page_edit fuseact="bank.auto_virtual_pos">
    <cfquery name="GET_POS_ALL" datasource="#DSN3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
    </cfquery>
    <cfquery name="get_bank_names" datasource="#DSN#">
        SELECT BANK_ID,BANK_CODE,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    <cfquery name="getSetupPeriod" datasource="#dsn#">
        SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY RECORD_DATE DESC
    </cfquery>
    <cfif isdefined("attributes.pos_operation_id") and len(attributes.pos_operation_id)>
        <cfquery name="get_pos_operation" datasource="#dsn3#">
            SELECT 
                POS_OPERATION_ID,
                POS_ID,
                PAY_METHOD_IDS,
                BANK_IDS,
                VOLUME,
                IS_ACTIVE,
                PERIOD_ID,
                START_DATE,
                FINISH_DATE,
                RECORD_DATE,
                RECORD_EMP,
                ERROR_CODES,
                UPDATE_DATE,
                UPDATE_EMP,
                POS_OPERATION_NAME,
                IS_FLAG,
                STOPPED_EMP,
                STOPPED_DATE,
                CARD_TYPE
            FROM 
                POS_OPERATION WITH (NOLOCK) 
            WHERE 
                POS_OPERATION_ID = #attributes.pos_operation_id#
        </cfquery>
        <cfquery name="get_pos_operation_row" datasource="#dsn3#">
            SELECT 
                POS_OPERATION_ROW_ID
            FROM 
                POS_OPERATION_ROW WITH (NOLOCK) 
            WHERE 
                POS_OPERATION_ID = #attributes.pos_operation_id#
        </cfquery>
        <cfset pos_id = get_pos_operation.POS_ID>
        <cfset bank_ids = get_pos_operation.BANK_IDS>
        <cfset pay_method_ = get_pos_operation.PAY_METHOD_IDS>
        <cfset volume = get_pos_operation.VOLUME>
        <cfset active = get_pos_operation.IS_ACTIVE>
        <cfset period_id_ = get_pos_operation.PERIOD_ID>
        <cfset start_date = get_pos_operation.START_DATE>
        <cfset finish_date = get_pos_operation.FINISH_DATE>
        <cfset error_code = get_pos_operation.ERROR_CODES>
        <cfset pos_operation_name = get_pos_operation.POS_OPERATION_NAME>
        <cfset card_type = get_pos_operation.CARD_TYPE>
        <cfquery name="getPaymentInstalment" datasource="#dsn3#">
            SELECT ISNULL(NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #pos_id#
        </cfquery>
        <cfquery name="PAYMENT_TYPE_ALL" datasource="#DSN3#">
            SELECT 
                PAYMENT_TYPE_ID,
                CARD_NO 
            FROM 
                CREDITCARD_PAYMENT_TYPE 
            WHERE 
                IS_ACTIVE = 1 AND
                <cfif len(getPaymentInstalment.NUMBER_OF_INSTALMENT)>
                    ISNULL(NUMBER_OF_INSTALMENT,0) = #getPaymentInstalment.NUMBER_OF_INSTALMENT#
                <cfelse>
                    NUMBER_OF_INSTALMENT IS NULL
                </cfif>
        </cfquery>
        <cfset upd_info = 1>
    <cfelse>
		<cfset pos_id = ''>
        <cfset bank_ids = ''>
        <cfset pay_method_ = ''>
        <cfset volume = ''>
        <cfset active = ''>
        <cfset period_id_ = ''>
        <cfset start_date = ''>
        <cfset finish_date = ''>
        <cfset error_code = ''>
        <cfset pos_operation_name = ''>
        <cfset card_type = ''>
        <cfset upd_info = 0>
    </cfif>
	<cfif is_bank_error_code eq 1>
        <cfquery name="get_error_codes" datasource="#dsn#">
            SELECT DISTINCT RESP_CODE,RESP_CODE RESP_NAME FROM COMPANY_CC WHERE RESP_CODE IS NOT NULL AND RESP_CODE <> '' ORDER BY RESP_CODE
        </cfquery>
        <cfif isdefined("attributes.pos_operation_id")>
            <cfscript>
                get_old_codes = QueryNew("RESP_CODE,RESP_NAME","VarChar,VarChar");
                row_of_query = 0;
                if(not listfind(error_code,-1))
                {
                    row_of_query = row_of_query + 1;
                    QueryAddRow(get_old_codes,1);
                    QuerySetCell(get_old_codes,"RESP_CODE","-1",row_of_query);
                    QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
                }
            </cfscript>
            <cfloop list="#error_code#" index="kk">
                <cfscript>
                    row_of_query = row_of_query + 1;
                    QueryAddRow(get_old_codes,1);
                    QuerySetCell(get_old_codes,"RESP_CODE","#kk#",row_of_query);
                    if(kk eq -1)
                        QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
                    else
                        QuerySetCell(get_old_codes,"RESP_NAME","#kk#",row_of_query);
                </cfscript>
            </cfloop>
            <cfquery name="get_error_codes" dbtype="query">
                SELECT RESP_CODE,RESP_NAME FROM get_error_codes
                UNION
                SELECT RESP_CODE,RESP_NAME FROM get_old_codes
            </cfquery>
        <cfelse>
            <cfscript>
                get_old_codes = QueryNew("RESP_CODE,RESP_NAME","VarChar,VarChar");
                row_of_query = 1;
                QueryAddRow(get_old_codes,1);
                QuerySetCell(get_old_codes,"RESP_CODE","-1",row_of_query);
                QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
            </cfscript>
            <cfquery name="get_error_codes" dbtype="query">
                SELECT RESP_CODE,RESP_NAME FROM get_error_codes
                UNION
                SELECT RESP_CODE,RESP_NAME FROM get_old_codes
            </cfquery>
        </cfif>
    </cfif>
	<script type="text/javascript">
        function add_rule()
        {  
            <cfif isdefined("attributes.pos_operation_id") and get_pos_operation_row.recordcount>
                get_flag = wrk_query('SELECT IS_FLAG FROM POS_OPERATION WITH (NOLOCK) WHERE POS_OPERATION_ID = <cfoutput>#attributes.pos_operation_id#</cfoutput>','dsn3');
                if(get_flag.IS_FLAG == 1)
                {
                    alert("Sanal Pos Çekimi Yapıldığı İçin Kuralı Güncelleyemezsiniz !");
                    return false;
                }
            </cfif>
            if (document.getElementById('pos_operation_name').value == '')
            {
                alert('Lütfen Kural Tanımı Giriniz!');
                return false;
            }		
            if (document.getElementById('pos').value == '')
            {
                alert('Lütfen POS Seçimi Yapınız!');
                return false;
            }
            if (document.virtualPos.pay_method.value == '')
            {
                alert('Lütfen En Az Bir Ödeme Yöntemi Seçimi Yapınız!');
                return false;
            }
            if (document.virtualPos.ava_vol.value == '')
            {
                alert('Lütfen Geçirilecek Hacim Tutarı Giriniz!!');
                return false;
            }
            if(document.virtualPos.ava_total != undefined)
            {
                if(parseFloat(filterNum(document.virtualPos.ava_vol.value)) > parseFloat(filterNum(document.virtualPos.ava_total.value)))
                {
                    alert("Geçirilecek Hacim Hesaplanan Hacimden Büyük Olamaz !");
                    return false;
                }
            }
            <cfif isdefined("attributes.pos_operation_id") and get_pos_operation_row.recordcount>
                if(!confirm('İşlemi Güncellediğinizde Operasyon Satırları da Silinecektir. Emin misiniz ?'))
                    return false;
            </cfif>
            document.virtualPos.ava_vol.value = filterNum(document.virtualPos.ava_vol.value);
            if(document.virtualPos.ava_total != undefined)
                document.virtualPos.ava_total.value = filterNum(document.virtualPos.ava_total.value);
            return true;	
        }
        function payMethodType(x)
        {
            document.virtualPos.ava_vol.value = 0;
            if(x != '')
            {
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_get_pos_operation_pay_method&payMethodId_='+x+'','item-pay_method','1');
                document.getElementById('item-pay_method').style.display = "";
            }
            else
                document.getElementById('item-pay_method').style.display = "none";
        }
        function get_total()
        {
            if (document.getElementById('pos').value == '')
            {
                alert('Lütfen POS Seçimi Yapınız!');
                return false;
            }
            if (document.virtualPos.pay_method.value == '')
            {
                alert('Lütfen En Az Bir Ödeme Yöntemi Seçimi Yapınız!');
                return false;
            }
            if (document.virtualPos.period_id.value == '')
            {
                alert('Lütfen Dönem Seçimi Yapınız!');
                return false;
            }
            
            var pay_met_list='';
            for(kk=0;kk<document.virtualPos.pay_method.length; kk++)
            {
                if(virtualPos.pay_method[kk].selected && virtualPos.pay_method.options[kk].value.length!='')
                pay_met_list = pay_met_list + ',' + virtualPos.pay_method.options[kk].value;
            }
            pay_met_list = pay_met_list + ',';
            
            var bank_id_list='';
            for(kk=0;kk<document.virtualPos.bank_names.length; kk++)
            {
                if(virtualPos.bank_names[kk].selected && virtualPos.bank_names.options[kk].value.length!='')
                bank_id_list = bank_id_list + ',' + virtualPos.bank_names.options[kk].value;
            }
            bank_id_list = bank_id_list + ',';
            
            var card_type_list='';
            for(kk=0;kk<document.virtualPos.card_type.length; kk++)
            {
                if(virtualPos.card_type[kk].selected && virtualPos.card_type.options[kk].value.length!='')
                card_type_list = card_type_list + ',' + virtualPos.card_type.options[kk].value;
            }
            card_type_list = card_type_list + ',';
            <cfif is_bank_error_code eq 1>
                var error_codes_list='';
                for(kk=0;kk<document.virtualPos.error_codes.length; kk++)
                {
                    if(virtualPos.error_codes[kk].selected && virtualPos.error_codes.options[kk].value.length!='')
                    error_codes_list = error_codes_list + ',' + virtualPos.error_codes.options[kk].value;
                }
                error_codes_list = error_codes_list + ',';
                <cfif not isdefined("attributes.pos_operation_id")>
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_get_total&error_codes='+error_codes_list+'&finish_date='+document.virtualPos.finish_date.value+'&start_date='+document.virtualPos.start_date.value+'&period_id='+document.virtualPos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'&card_type_list='+card_type_list+'','item-total','1');
                <cfelse>
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.popup_get_total&error_codes='+error_codes_list+'&pos_operation_id=#attributes.pos_operation_id#</cfoutput>&finish_date='+document.virtualPos.finish_date.value+'&start_date='+document.virtualPos.start_date.value+'&period_id='+document.virtualPos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'&card_type_list='+card_type_list+'','item-total','1');
                </cfif>
            <cfelse>
                <cfif not isdefined("attributes.pos_operation_id")>
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_get_total&finish_date='+document.virtualPos.finish_date.value+'&start_date='+document.virtualPos.start_date.value+'&period_id='+document.virtualPos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'','item-total','1');
                <cfelse>
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.popup_get_total&pos_operation_id=#attributes.pos_operation_id#</cfoutput>&finish_date='+document.virtualPos.finish_date.value+'&start_date='+document.virtualPos.start_date.value+'&period_id='+document.virtualPos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'','item-total','1');
                </cfif>
            </cfif>
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.auto_virtual_pos';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/auto_virtual_pos.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/popup_add_rule.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_pos_operation&event=upd&pos_operation_id=';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_upd_auto_virtual_pos';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/auto_virtual_pos.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/popup_add_rule.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_pos_operation&event=upd&pos_operation_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pos_operation_id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pos_operation_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'bank.popup_pos_operation_report';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'bank/display/list_pos_operation_report.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	
	WOStruct['#attributes.fuseaction#']['addrows'] = structNew();
	WOStruct['#attributes.fuseaction#']['addrows']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['addrows']['fuseaction'] = 'bank.emptypopup_add_pos_operation_row';
	WOStruct['#attributes.fuseaction#']['addrows']['filePath'] = 'bank/query/add_pos_operation_row.cfm';
	WOStruct['#attributes.fuseaction#']['addrows']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['addrows']['nextEvent'] = '';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_pos_operation';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_pos_operation.cfm';
	
	if(isDefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_pos_operation&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_wrk_history act_type='4' act_id='#attributes.pos_operation_id#' boxwidth='600' boxheight='500'>";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'posOperation';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'POS_OPERATION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['identityColumn'] = 'POS_OPERATION_ID';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-pos_operation_name','item-pos','item-pay_method','item-period_id','item-ava_vol']";
</cfscript>
