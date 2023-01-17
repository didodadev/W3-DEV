<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact ="bank.popup_add_autopayment_export">
<cfparam name="attributes.bank" default="">
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
    </cfif>
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
    </cfif>
    <cfparam name="attributes.source" default="1">
    <cfparam name="attributes.bank_name" default="">
    
    <cfif isdefined("attributes.is_submitted")>
        <cfquery name="GET_AUTOPAYM" datasource="#DSN2#">
            SELECT
                FILE_NAME,
                TARGET_SYSTEM,
                FILE_EXPORTS.RECORD_DATE,
                FILE_EXPORTS.RECORD_EMP,
                IS_IPTAL,
                E_ID,
                FILE_EXPORT_TYPE,
                IS_DBS,
                EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME,
                BANK_NAME
            FROM
                FILE_EXPORTS
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = FILE_EXPORTS.RECORD_EMP
                LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON BANK_ID = TARGET_SYSTEM
            WHERE
                PROCESS_TYPE = -11 AND
                FILE_EXPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
                <cfif attributes.source eq 2>
                    AND IS_DBS = 1 
                    <cfif len(attributes.bank)>
                        AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
                    </cfif>
                <cfelseif attributes.source eq 1>
                    AND 
                    (IS_DBS = 0 OR IS_DBS IS NULL) 
                    <cfif len(attributes.bank_name)>
                        AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
                    </cfif>
                </cfif>
            ORDER BY
                E_ID DESC
        </cfquery>
    <cfelse>
        <cfset get_autopaym.recordcount = 0>
    </cfif>
    <cfquery name="get_bank_names" datasource="#dsn#">
        SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_autopaym.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is "add">
    <cfparam name="attributes.start_date" default="01/01/#session.ep.period_year#">
    <cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.bank_name" default="">
    <cfparam name="attributes.open_form" default="0">
    <cfparam name="attributes.pay_method" default="">
    <cfparam name="attributes.card_pay_method" default="">
    <cfparam name="attributes.prov_period" default="#session.ep.period_year#;#session.ep.company_id#;#session.ep.period_id#">
    <!--- fatura ödeme planı için oluşturuldu. --->
    <cfparam name="attributes.source" default="1">
    <cfparam name="attributes.document_status" default="0">
    <cfparam name="attributes.money_type" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfif attributes.open_form eq 0><cfset attributes.status = 1></cfif>
    <cfquery name="get_bank_names" datasource="#dsn#">
        SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    <cfquery name="GET_S_PAY_METHOD" datasource="#DSN#">
        SELECT 
            SP.PAYMETHOD,
            SP.PAYMETHOD_ID 
        FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfquery name="GET_PERIODS" datasource="#DSN#">
        SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID,PERIOD FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
    </cfquery>
</cfif>
<cfif is_file_from_manuelpaper eq 1>
	<cfset queryPath = "bank/query/add_autopayment_export.cfm">
<cfelse>
	<cfset queryPath = "bank/form/add_autopayment_export.cfm">
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
		function kontrol()
		{
			if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;	
		}
		function display_()
		{
			if (document.getElementById('source').value == 1)
			{
				gizle(bank_2);
				goster(pos_2);
			}
			else
			{
				goster(bank_2);
				gizle(pos_2);
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is "add">
		function check_all(deger)
		{
			<cfif isdefined("get_payment_plan") and get_payment_plan.recordcount>
				if(provision_rows.hepsi.checked)
				{
					for (var i=1; i <= <cfoutput>#get_payment_plan.recordcount#</cfoutput>; i++)
					{
						var form_field = eval("document.provision_rows.payment_row" + i);
						form_field.checked = true;
						eval('provision_rows.payment_row'+i).focus();
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#get_payment_plan.recordcount#</cfoutput>; i++)
					{
						form_field = eval("document.provision_rows.payment_row" + i);
						form_field.checked = false;
						eval('provision_rows.payment_row'+i).focus();
					}				
				}
			</cfif>
		}
		function kontrol()
		{
			if(document.getElementById('source').value == 1)
			{
				if(add_autopaym.bank_name.value=="")
				{
					alert("<cf_get_lang no ='302.Pos Tipi Seçiniz'>");
					return false;
				}
				var pay_method_list='';
				var card_pay_method_list='';
				
				for(kk=0;kk<document.add_autopaym.pay_method.length; kk++)
				{
					if(add_autopaym.pay_method[kk].selected && add_autopaym.pay_method.options[kk].value.length!='')
						pay_method_list= pay_method_list + ',' + add_autopaym.pay_method.options[kk].value;
				}
				for(jj=0;jj<add_autopaym.card_pay_method.length; jj++)
				{
					if(add_autopaym.card_pay_method[jj].selected && add_autopaym.card_pay_method.options[jj].value.length!='')
						card_pay_method_list = card_pay_method_list + ',' + add_autopaym.card_pay_method.options[jj].value;
				}
				if(pay_method_list=="" && card_pay_method_list=="")
				{
					alert("<cf_get_lang dictionary_id='52525.Ödeme Yöntemi veya Kredi Kartı Ödeme Yöntemi Seçmelisiniz'>!");
					return false;
				}
			}
			else
			{
				if(document.getElementById('bank').value == '')
				{
					alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'>!");
					return false;
				}
				var pay_method_list='';
				for(kk=0;kk<document.add_autopaym.pay_method.length; kk++)
				{
					if(add_autopaym.pay_method[kk].selected && add_autopaym.pay_method.options[kk].value.length!='')
						pay_method_list= pay_method_list + ',' + add_autopaym.pay_method.options[kk].value;
				}
				if(pay_method_list=="")
				{
					alert("<cf_get_lang dictionary_id='50457.Ödeme Yöntemi Seçmelisiniz'>!");
					return false;
				}
			}
			document.add_autopaym.open_form.value = 1;
			return true;
		}
		function input_control()
		{
			<cfif is_due_date eq 1 and attributes.source eq 1>
				if(document.all.due_date.value=="")
				{
					alert("<cf_get_lang dictionary_id='52526.Vade Tarihi Seçiniz'>");
					return false;
				}
				due_date_ = document.getElementById('due_date').value.substr(6,4) +document.getElementById('due_date').value.substr(3,2) + document.getElementById('due_date').value.substr(0,2);
				today_date_ = new Date();
				today_date_ = today_date_.getYear()+''+(today_date_.getMonth()+1)+''+today_date_.getDate();
				if(today_date_ > due_date_)
				{
					alert("<cf_get_lang dictionary_id='52598.Vade tarihi bugünden önce olamaz'>");
					return false;
				}
			</cfif>
			<cfif is_encrypt_file eq 1 and attributes.source eq 1>
				if(document.all.key_type.value == "")
				{
					alert("<cf_get_lang no ='303.Anahtar Giriniz'>");
					return false;
				}
			</cfif>
			<cfif is_process_check eq 1>
				var checked_info = false;
				var toplam = document.provision_rows.all_records.value;
				for(var i=1; i<=toplam; i++)
				{
					if(eval('provision_rows.payment_row'+i).checked){
						checked_info = true;
						i = toplam+1;
					}
				}
				if(!checked_info)
				{
					alert("<cf_get_lang no ='304.Seçim Yapmadınız'>!");
					return false;
				}
			</cfif>
			return true;
		}
		/* Kaynak: Sistem Odeme Plani veya Fatura Odeme Plani */
		function display_()
		{
			if (document.getElementById('source').value == 1)
			{
				set_paymethod();
				gizle(bank_);
				gizle(bank_2);
				gizle(money_);
				gizle(money_2);
				gizle(status_);
				gizle(document_);
				gizle(document_2);
				gizle(cari_);
				gizle(cari_2);
				goster(pos_);
				goster(pos_2);
				goster(credit_card_);
				goster(credit_card_2);
				<cfif is_show_related_inv_period eq 1>
					goster(inv_period_);
					goster(inv_period_2);
				</cfif>
			}
			else
			{
				set_paymethod_default();
				if(document.getElementById('bank') != undefined && document.getElementById('bank').value != '')
					set_bank_paymethod(document.getElementById('bank').value);	
				goster(bank_);
				goster(bank_2);
				goster(money_);
				goster(money_2);
				goster(status_);
				goster(document_);
				goster(document_2);
				goster(cari_);
				goster(cari_2);
				gizle(pos_);
				gizle(pos_2);
				gizle(credit_card_);
				gizle(credit_card_2);
				<cfif is_show_related_inv_period eq 1>
					gizle(inv_period_);
					gizle(inv_period_2);
				</cfif>
			}
		}
		/* Sistem odeme planina bagli odeme yontemlerinin tamamini getirir */
		function set_paymethod()
		{
			var system_paymethods = wrk_safe_query('bnk_get_paymethod_2',"dsn",0);
			
			var option_count = document.getElementById('pay_method').options.length; 
			for(x=option_count;x>=0;x--)
				document.getElementById('pay_method').options[x] = null;
			
			if(system_paymethods.recordcount != 0)
			{	
				document.getElementById('pay_method').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
				for(var xx=0;xx<system_paymethods.recordcount;xx++)
					document.getElementById('pay_method').options[xx+1]=new Option(system_paymethods.PAYMETHOD[xx],system_paymethods.PAYMETHOD_ID[xx]);
			}
			else
				document.getElementById('pay_method').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');	
		}
		/* Fatura odeme planinda optionlari sifirlar */
		function set_paymethod_default()
		{
			var option_count = document.getElementById('pay_method').options.length; 
			for(x=option_count;x>=0;x--)
				document.getElementById('pay_method').options[x] = null;
			document.getElementById('pay_method').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
		}
		/* Fatura odeme planinda bankaya gore odeme yontemlerini getirir */
		function set_bank_paymethod(xyz)
		{
			var bank_paymethods = wrk_safe_query('bnk_get_paymethod',"dsn",0,xyz);
			
			var option_count = document.getElementById('pay_method').options.length; 
			for(x=option_count;x>=0;x--)
				document.getElementById('pay_method').options[x] = null;
			
			if(bank_paymethods.recordcount != 0)
			{	
				document.getElementById('pay_method').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
				for(var xx=0;xx<bank_paymethods.recordcount;xx++)
					document.getElementById('pay_method').options[xx+1]=new Option(bank_paymethods.PAYMETHOD[xx],bank_paymethods.PAYMETHOD_ID[xx]);
			}
			else
				document.getElementById('pay_method').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
		}
	</cfif> 
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_autopayment_export';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_bank_autopayment_export.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.list_bank_autopayment_export';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/add_autopayment_export.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '#queryPath#';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_bank_autopayment_export';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_form','add_form_row')";
	
	WOStruct['#attributes.fuseaction#']['add_rows'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_rows']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_rows']['fuseaction'] = 'bank.list_bank_autopayment_export';
	WOStruct['#attributes.fuseaction#']['add_rows']['filePath'] = 'bank/form/add_autopayment_export.cfm';
	WOStruct['#attributes.fuseaction#']['add_rows']['queryPath'] = 'bank/query/add_autopayment_export.cfm';
	WOStruct['#attributes.fuseaction#']['add_rows']['nextEvent'] = 'bank.list_bank_autopayment_export';

</cfscript>
