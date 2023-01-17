<cf_get_lang_set module_name="account">
<cfif not IsDefined("attributes.event") or(IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = ''>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = ''>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_reescounts" datasource="#dsn2#">
            SELECT
                REESCOUNT_ID,
                DUE_DATE,
                ACTION_DATE,
                TOTAL_VALUE,
                TOTAL_REESCOUNT_VALUE
            FROM
                REESCOUNT
            WHERE
                1 = 1
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND ACTION_DATE >= #attributes.start_date#
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND ACTION_DATE <= #attributes.finish_date#
                <cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
                    AND ACTION_DATE >= #attributes.start_date#
                    AND ACTION_DATE <= #attributes.finish_date#
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_reescounts.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_reescounts.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
	<cfparam name="attributes.due_date" default="31/12/#session.ep.period_year#">

	<cfif isdefined("attributes.form_submitted")>
        <cfif len(attributes.due_date)>
            <cf_date tarih="attributes.due_date">
        </cfif>
        <cfif isDefined("attributes.is_cheque")>
            <cfquery name="get_cheque_voucher" datasource="#dsn2#">
                SELECT 
                    CHEQUE_ID,
                    CHEQUE_NO DOC_NO,
                    CHEQUE_DUEDATE DUE_DATE,
                    CHEQUE_VALUE TOTAL_VALUE,
                    CURRENCY_ID,
                    CHEQUE_STATUS_ID STATUS_ID
                FROM 
                    CHEQUE
                WHERE
                    CHEQUE_DUEDATE > '2012-12-31 00:00:00.0'
                    AND CHEQUE_ID NOT IN (SELECT CHEQUE_ID FROM REESCOUNT_ROWS WHERE CHEQUE_ID IS NOT NULL)
                    <cfif isdefined("attributes.money_type") and len(attributes.money_type)>
                        AND CURRENCY_ID = '#attributes.money_type#'
                    </cfif>
                    <cfif isdefined("attributes.status") and len(attributes.status)>
                        AND CHEQUE_STATUS_ID IN (#attributes.status#)
                    </cfif>
                ORDER BY
                    CHEQUE_DUEDATE
            </cfquery>
        <cfelse>
            <cfquery name="get_cheque_voucher" datasource="#dsn2#">
                SELECT 
                    VOUCHER_ID,
                    VOUCHER_NO DOC_NO,
                    VOUCHER_DUEDATE DUE_DATE,
                    VOUCHER_VALUE TOTAL_VALUE,
                    CURRENCY_ID,
                    VOUCHER_STATUS_ID STATUS_ID
                FROM 
                    VOUCHER
                WHERE
                    VOUCHER_DUEDATE > '2012-12-31 00:00:00.0'
                    AND VOUCHER_ID NOT IN (SELECT VOUCHER_ID FROM REESCOUNT_ROWS WHERE VOUCHER_ID IS NOT NULL)
                    <cfif isdefined("attributes.money_type") and len(attributes.money_type)>
                        AND CURRENCY_ID = '#attributes.money_type#'
                    </cfif>
                    <cfif isdefined("attributes.status") and len(attributes.status)>
                        AND VOUCHER_STATUS_ID IN (#attributes.status#)
                    </cfif>
                ORDER BY
                    VOUCHER_DUEDATE
            </cfquery>
        </cfif>
        <cfquery name="get_process_cat_" datasource="#dsn3#">
            SELECT PROCESS_TYPE, PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(13,14) ORDER BY PROCESS_CAT
        </cfquery>
        <cfelse>
            <cfset get_member.recordcount = 0>
        </cfif>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT
            MONEY,
            RATE2,
            RATE1
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #session.ep.period_id# AND
            MONEY_STATUS = 1
        ORDER BY 
            MONEY_ID
    </cfquery>
    <script type="text/javascript">
		$( document ).ready(function() {
			<cfif isdefined("attributes.form_submitted") and get_cheque_voucher.recordcount>
				document.getElementById('all_check').checked = true;
				check_all();
			</cfif>
		});
		
		function control()
		{
			if ((document.getElementById('is_cheque').checked == true && document.getElementById('is_voucher').checked == true) || (document.getElementById('is_cheque').checked == false && document.getElementById('is_voucher').checked == false))
			{
				alert('Çek veya Senet Seçeneklerinden Birini Seçmelisiniz!');
				return false;
			}
			if (document.getElementById('reeskont_rate').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>: Reeskont Oranı");
				return false;
			}
			if (document.getElementById('due_date').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='469.Vade Tarihi'>");
				return false;
			}
			if (document.getElementById('duty_claim').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no ='175.Borç'>/<cf_get_lang_main no ='176.Alacak'>");
				return false;
			}
		}
		function check_all()
		{
			<cfif isdefined("get_cheque_voucher") and get_cheque_voucher.recordcount >
				if(document.getElementById('all_check').checked)
				{
					for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
					{
						var form_field = document.getElementById('row_check' + i);
						form_field.checked = true;
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
					{
						form_field = document.getElementById('row_check' + i);
						form_field.checked = false;
					}				
				}
			</cfif>
			total_amount();
		}
		function total_amount()
		{
			var total_value = 0;
			var total_reescount_value = 0;
			var total_discount_value = 0;
			var total_carpan_new = 0;
			var avg_duedate_new = 0;
			<cfif isdefined("get_cheque_voucher")>
				for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
				{		
					if(document.getElementById('row_check' +i).checked)	
					{
						total_value += parseFloat(filterNum(document.getElementById('cheq_voucher_value'+i).value));
						total_reescount_value += parseFloat(filterNum(document.getElementById('reescount_value'+i).value));
						total_discount_value += parseFloat(filterNum(document.getElementById('discount_value'+i).value));
						total_carpan_new = parseFloat(total_carpan_new) + parseFloat(filterNum(document.getElementById('cheq_voucher_value'+i).value)*document.getElementById('duedate_diff'+i).value);
					}
				}
				// hesaplanan toplam degerler set ediliyor
				document.getElementById('total_value').value = commaSplit(total_value);							//toplam cek/senet tutari
				document.getElementById('total_reescount_value').value = commaSplit(total_reescount_value);		//toplam reeskont tutari
				document.getElementById('total_discount_value').value = commaSplit(total_discount_value); 		//indirgenmis deger
				if (total_value != 0)																			
					avg_duedate_new = parseInt(total_carpan_new / total_value);
				avg_duedate_new = date_add('d',avg_duedate_new,document.getElementById('due_date').value);
				document.getElementById('average_due_date').value = avg_duedate_new;							//ortalama Vade
			</cfif>
		}
		function save_reescount()
		{ debugger;
			if (!chk_process_cat('form_reeskont')) return false;
			if (document.getElementById('receipt_type').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:Fiş Türü");
				return false;
			} 
			if (document.getElementById('action_date').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:İşlem Tarihi");
				return false;
			}
			if (document.getElementById('reeskont_acc_code').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:Reeskont Muhasebe Kodu");
				return false;
			}
			if (document.getElementById('equivalent_acc_code').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:Çek/Senet Karşılık Muhasebe Kodu");
				return false;
			}
			unformat_fields();
			document.getElementById('form_reeskont').action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_reescount&event=addOther';
			return true;
		}
		function unformat_fields()
		{
			for(var i=1; i<=document.getElementById('record_num').value; i++)
			{
				document.getElementById('cheq_voucher_value'+i).value = filterNum(document.getElementById('cheq_voucher_value'+i).value);
				document.getElementById('discount_value'+i).value = filterNum(document.getElementById('discount_value'+i).value);
				document.getElementById('reescount_value'+i).value = filterNum(document.getElementById('reescount_value'+i).value);
			}
			document.getElementById('reeskont_rate').value = filterNum(document.getElementById('reeskont_rate').value);
			document.getElementById('total_value').value = filterNum(document.getElementById('total_value').value);
			document.getElementById('total_discount_value').value = filterNum(document.getElementById('total_discount_value').value);
			document.getElementById('total_reescount_value').value = filterNum(document.getElementById('total_reescount_value').value);
		}	
	</script>

</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
    <cfquery name="get_reescount" datasource="#dsn2#">
        SELECT 
            ACTION_DATE,
            DUE_DATE,
            DETAIL,
            PROCESS_CAT,
            RECORD_DATE,
            RECORD_EMP,
            UPDATE_DATE,
            UPDATE_EMP
        FROM 
            REESCOUNT
        WHERE 
            REESCOUNT_ID = #attributes.reescount_id# 
    </cfquery>
    <cfquery name="get_reescount_rows" datasource="#dsn2#">
        SELECT 
            V.VOUCHER_NO,
            C.CHEQUE_NO,
            RR.VOUCHER_ID,
            RR.CHEQUE_ID,
            RR.NET_VALUE,
            RR.REESCOUNT_VALUE,
            RR.CURRENCY_ID,
            RR.CHEQ_VOUCHER_DUE_DATE,
            RR.DUEDATE_DIFF
        FROM 
            REESCOUNT_ROWS RR
            LEFT JOIN CHEQUE C ON RR.CHEQUE_ID = C.CHEQUE_ID
            LEFT JOIN VOUCHER V ON RR.VOUCHER_ID = V.VOUCHER_ID
        WHERE 
            REESCOUNT_ID = #attributes.reescount_id# 
    </cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_reescount';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_reescount.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.list_reescount';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/form/add_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_reescount&event=add';
	
	
	WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = 'account.list_reescount';
	WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'account/form/add_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'account/query/add_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = 'account.list_reescount';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'account.list_reescount';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'account/form/upd_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'account/form/upd_reescount.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'account.list_reescount';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'reescount_id=##attributes.reescount_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.reescount_id##';
	
	if(IsDefined("attributes.event") and(attributes.event eq 'det' or attributes.event eq 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'account.list_reescount';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'account/query/del_reescount.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'account/query/del_reescount.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_reescount';
	}
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.reescount_id#&process_cat=#get_reescount.process_cat#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.list_reescount&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>

