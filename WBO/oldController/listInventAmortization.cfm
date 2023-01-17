<cf_get_lang_set module_name="invent">
<cfif not IsDefined("attributes.event") or attributes.event eq 'list'>
	<cf_xml_page_edit fuseact="invent.list_invent_amortization">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<cfif isdefined("attributes.form_exist")>
	<cfquery name="get_invent_main" datasource="#DSN3#">
		SELECT 
			INVENTORY_AMORTIZATION_MAIN.*,
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME
	    FROM 
			INVENTORY_AMORTIZATION_MAIN
				LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = INVENTORY_AMORTIZATION_MAIN.RECORD_EMP
		WHERE
			INV_AMORT_MAIN_ID IS NOT NULL
	   <cfif len(attributes.start_date)>
		    AND INVENTORY_AMORTIZATION_MAIN.RECORD_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
		    AND INVENTORY_AMORTIZATION_MAIN.RECORD_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isDefined("attributes.invent_no") and len(attributes.invent_no)>
			AND INV_AMORT_MAIN_ID IN
			(
				SELECT 
					IA.INV_AMORT_MAIN_ID
				FROM
					INVENTORY_AMORTIZATON IA,
					INVENTORY I
				WHERE
					IA.INVENTORY_ID = I.INVENTORY_ID
					AND I.INVENTORY_NUMBER = '#attributes.invent_no#'
			) 			
		</cfif>  
		ORDER BY RECORD_DATE
	</cfquery>
<cfelse>
	<cfset get_invent_main.recordcount=0>	
</cfif>


</cfif>

<cfif  IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'addOther')>
	<cf_xml_page_edit fuseact="invent.popup_add_invent_amortization">
    <cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.asset_type" default="">
    <cfparam name="attributes.invent_acc_id" default="">
    <cfparam name="attributes.period" default="">
    <cfparam name="attributes.invent_acc_name" default="">
    <cfparam name="attributes.open_form" default="0">
    <cfparam name="attributes.amor_method" default="">
    <cfparam name="attributes.last_amortization_year" default="">
    <cfparam name="attributes.inventory_type" default="1,2,3">
    <cfparam name="attributes.process_date" default="">
    <cfparam name="attributes.account_period_list" default="">
    <cfquery name="get_acc_period" datasource="#dsn3#">
        SELECT DISTINCT ACCOUNT_PERIOD FROM INVENTORY ORDER BY ACCOUNT_PERIOD
    </cfquery>
    
    <cfif is_list_inventory eq 0>
        <cfset new_action = "#request.self#?fuseaction=invent.emptypopup_add_invent_amortization">
    <cfelse>
        <cfset new_action = "">
    </cfif>
    <cfif attributes.open_form eq 1 and is_list_inventory eq 1>
        
        <cfquery name="GET_INVENT" datasource="#dsn3#">
            SELECT DISTINCT
                <cfif len(attributes.last_amortization_year)>
                    INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
                </cfif>
                (SELECT SUM(ISNULL(INVENTORY_ROW3.STOCK_IN,0)-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID AND INVENTORY_ROW3.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#) AS MIKTAR,
                I.INVENTORY_ID,
                I.ACCOUNT_ID,
                I.INVENTORY_NAME,
                I.INVENTORY_NUMBER,
                I.PROCESS_CAT,
                I.QUANTITY,
                ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE) AMORTIZATON_ESTIMATE,
                I.AMORTIZATON_METHOD,
                I.AMOUNT,
                I.ENTRY_DATE,
                I.COMP_ID,
                I.COMP_PARTNER_ID,
                I.LAST_INVENTORY_VALUE,
                ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) ACCOUNT_ID,
                ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID) CLAIM_ACCOUNT_ID,
                ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID) DEBT_ACCOUNT_ID,
                ISNULL(ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION),0) INVENTORY_DURATION,
                I.ACCOUNT_PERIOD,
                ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID) EXPENSE_ITEM_ID,
                ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID) EXPENSE_CENTER_ID,
                ISNULL(INVENTORY_HISTORY.PROJECT_ID,I.PROJECT_ID) PROJECT_ID,
                I.AMORTIZATION_COUNT,
                I.AMORT_LAST_VALUE,
                I.AMORTIZATION_TYPE,
                (SELECT 
                    COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
                FROM 
                    INVENTORY_AMORTIZATON IA,
                    INVENTORY_AMORTIZATION_MAIN IAM
                WHERE 
                    I.INVENTORY_ID = IA.INVENTORY_ID
                    AND IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
                    AND YEAR(IAM.ACTION_DATE) = #year(attributes.process_date)#) INV_COUNT,
                (SELECT TOP 1
                    ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
                FROM 
                    INVENTORY_AMORTIZATON IA2
                WHERE 
                    I.INVENTORY_ID = IA2.INVENTORY_ID
                ORDER BY 
                    AMORTIZATION_ID DESC) PARTIAL_AMORTIZATION_VALUE,
                ISNULL(I.PARTIAL_AMORTIZATION_VALUE,
                (SELECT TOP 1
                    ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
                FROM 
                    INVENTORY_AMORTIZATON IA2
                WHERE 
                    I.INVENTORY_ID = IA2.INVENTORY_ID AND
                    IA2.AMORTIZATON_YEAR = YEAR(I.ENTRY_DATE)
                ORDER BY 
                    AMORTIZATION_ID DESC)) FIRST_PARTIAL_AMORTIZATION_VALUE
            FROM
                INVENTORY I 
                LEFT JOIN INVENTORY_HISTORY ON INVENTORY_HISTORY.INVENTORY_ID=I.INVENTORY_ID AND INVENTORY_HISTORY.ACTION_DATE<=#attributes.process_date# AND INVENTORY_HISTORY_ID=(SELECT TOP 1 IH.INVENTORY_HISTORY_ID FROM INVENTORY_HISTORY IH WHERE IH.INVENTORY_ID = I.INVENTORY_ID AND IH.ACTION_DATE<=#attributes.process_date# ORDER BY IH.ACTION_DATE DESC,IH.RECORD_DATE DESC),
                INVENTORY_ROW,
                INVENTORY_ROW INVENTORY_ROW_2
                <cfif len(attributes.last_amortization_year)>
                    ,INVENTORY_AMORTIZATON
                </cfif>
            WHERE
                INVENTORY_ROW.INVENTORY_ID = I.INVENTORY_ID AND
                INVENTORY_ROW_2.INVENTORY_ID = I.INVENTORY_ID AND
                INVENTORY_ROW.STOCK_IN >= 0 AND 
                I.ENTRY_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND 
                I.ENTRY_DATE <= #attributes.process_date# AND 
                INVENTORY_ROW_2.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
                <cfif isDefined("attributes.invent_acc_id") and len(attributes.invent_acc_id) and len(attributes.invent_acc_name)>
                    AND ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) = '#attributes.invent_acc_id#'
                </cfif>
                <cfif len(attributes.last_amortization_year)>
                    AND I.INVENTORY_ID = INVENTORY_AMORTIZATON.INVENTORY_ID
                    AND INVENTORY_AMORTIZATON.AMORTIZATION_ID = (SELECT TOP 1 INVV.AMORTIZATION_ID FROM INVENTORY_AMORTIZATON INVV,INVENTORY_AMORTIZATION_MAIN INVV_MAIN WHERE INVV.INVENTORY_ID = I.INVENTORY_ID AND INVV.INV_AMORT_MAIN_ID = INVV_MAIN.INV_AMORT_MAIN_ID ORDER BY INVV_MAIN.RECORD_DATE DESC)
                    AND INVENTORY_AMORTIZATON.AMORTIZATON_YEAR = #Year(attributes.last_amortization_year)#
                </cfif>
                <cfif isDefined("attributes.amor_method") and len(attributes.amor_method)>
                    AND I.AMORTIZATON_METHOD = #attributes.amor_method#
                </cfif>
                <cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
                    AND I.INVENTORY_TYPE IN(#attributes.inventory_type#)
                </cfif>
                <cfif isDefined("attributes.account_period_list") and len(attributes.account_period_list)>
                    AND I.ACCOUNT_PERIOD = #attributes.account_period_list#
                </cfif>
                AND I.LAST_INVENTORY_VALUE > 0
                AND I.AMORTIZATON_ESTIMATE > 0
            GROUP BY
                <cfif len(attributes.last_amortization_year)>
                    INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
                </cfif>
                I.INVENTORY_ID,
                I.INVENTORY_NAME,
                I.INVENTORY_NUMBER,
                I.PROCESS_CAT,
                I.QUANTITY,
                ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE),
                I.AMORTIZATON_METHOD,
                I.AMOUNT,
                I.ENTRY_DATE,
                I.COMP_ID,
                I.COMP_PARTNER_ID,
                I.LAST_INVENTORY_VALUE,
                ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) ,
                ACCOUNT_ID,
                ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID),
                ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID),
                ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION),
                I.ACCOUNT_PERIOD,
                ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID),
                ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID),
                ISNULL(INVENTORY_HISTORY.PROJECT_ID,I.PROJECT_ID),
                I.AMORTIZATION_COUNT,
                I.AMORT_LAST_VALUE,
                I.AMORTIZATION_TYPE,
                I.PARTIAL_AMORTIZATION_VALUE
            HAVING
                SUM(ISNULL(INVENTORY_ROW_2.STOCK_IN, 0) - ISNULL(INVENTORY_ROW_2.STOCK_OUT, 0)) > 0
        </cfquery>
        <script type="text/javascript">
		function check_all(deger)
		{
			<cfif GET_INVENT.recordcount>
				if(invent_rows.hepsi.checked)
				{
					for (var i=1; i <= <cfoutput>#GET_INVENT.recordcount#</cfoutput>; i++)
					{
						if(eval('invent_rows.invent_row'+i) != undefined)
						{
							var form_field = eval("document.invent_rows.invent_row" + i);
							form_field.checked = true;
							eval('invent_rows.invent_row'+i).focus();
						}
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#GET_INVENT.recordcount#</cfoutput>; i++)
					{
						if(eval('invent_rows.invent_row'+i) != undefined)
						{						
							form_field = eval("document.invent_rows.invent_row" + i);
							form_field.checked = false;
							eval('invent_rows.invent_row'+i).focus();
						}
					}				
				}
			</cfif>
		}
		function period_hesapla(no)
		{    
			period_kontrol(no);
			deger=eval("document.invent_rows.diff_value" + no).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger1=eval("document.invent_rows.period" + no).value;
			deger1=filterNum(deger1);			
			deger1=parseFloat(deger1);
			deger2=eval("document.invent_rows.last_value" + no).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			quantity = eval("document.invent_rows.quantity" + no).value;
			eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger/deger1*quantity);
			eval("document.invent_rows.period_diff_value" + no).value=commaSplit(deger/deger1);
			eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger/deger1);
			eval("document.invent_rows.new_inventory_value" + no).value=commaSplit(deger2-deger/deger1);
			return true;	
		}
		function hesapla(no)
		{    
			deger=eval("document.invent_rows.period_diff_value" + no).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger2=eval("document.invent_rows.last_value" + no).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			quantity = eval("document.invent_rows.quantity" + no).value;
			eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger*quantity);
			eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger);
			return true;	
		}
		function  period_kontrol(no)
		{
			deger1= eval("document.invent_rows.hd_period"+no);
			deger = eval("document.invent_rows.period"+no);
			if ((filterNum(deger.value) <1) || (deger.value==""))
			{ 
				alert ("<cf_get_lang no='66.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
				deger.value=deger1.value;
				return false;
			}
		}
	</script>
     </cfif>
     <script type="text/javascript">
	function kontrol()
	{
		if(document.add_amortization.inventory_type.value == '')
		{
			alert("Demirbaş Tipi Seçmelisiniz !");
			return false;
		}
		if(document.add_amortization.account_period_list.value == '')
		{
			alert("<cf_get_lang no='111.Hesaplama Dönemi Seçmelisiniz'>!");
			return false;
		}
		var document_id = document.add_amortization.inventory_type.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.add_amortization.inventory_type.options[i].selected && document_name.length==0)
				document_name = document_name + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
			else if(document.add_amortization.inventory_type.options[i].selected && ! list_find(document_name,list_getat(document.add_amortization.inventory_type.options[i].value,1,'-'),','))
				document_name = document_name + ',' + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
		}
		if(list_find(document_name,4) &&  list_len(document_name) != 1)
		{
			alert("İrsaliyeden Kaydedilen Demirbaşları Ayrı Değerlemelisiniz !");
			return false;
		}
		document.add_amortization.open_form.value = 1
		return true;
	}
	function input_control()
	{
		if (!chk_process_cat('invent_rows')) return false;
		if(!check_display_files('invent_rows')) return false;
		var checked_info = false;
		var toplam = document.invent_rows.all_records.value;
		for(var i=1; i<=toplam; i++)
		{
			if(eval('invent_rows.invent_row'+i).checked)
			{
				checked_info = true;
				i = toplam+1;
			}
		}
		<cfif isdefined("is_set_zero_value") and is_set_zero_value eq 1>
			if(confirm('Eksiye Düşen Demirbaşların Amortisman Tutarları Yeniden Hesaplanacak! Emin misiniz?'))
			{
				for(var t=1; t<=toplam; t++)
				{
					if(eval('invent_rows.invent_row'+t).checked)
					{
						if(filterNum(eval("document.invent_rows.new_value" + t).value) < 0)
						{
							deger1=eval("document.invent_rows.period" + t).value;
							deger1=filterNum(deger1);	
							last_value = parseFloat(filterNum(eval("document.invent_rows.period_diff_value" + t).value)) - Math.abs(parseFloat(filterNum(eval("document.invent_rows.new_value" + t).value)));
							eval("document.invent_rows.diff_value" + t).value = commaSplit(parseFloat(last_value)*parseFloat(deger1));
							period_hesapla(t);
						}
					}
				}
			}
		</cfif>
		for(var t=1; t<=toplam; t++)
		{
			if(eval('invent_rows.invent_row'+t).checked)
			{
				if(eval("document.invent_rows.diff_value" + t).value == "")
				{
					alert("<cf_get_lang no='55.Amortisman Tutarı Giriniz'>!");
					return false;
				}
				<cfif isdefined("is_zero_kontrol") and is_zero_kontrol eq 1>
					if(filterNum(eval("document.invent_rows.new_value" + t).value) < 0)
					{
						alert("Amortisman Değeri Sıfırdan Küçük Olamaz !");
						return false;
					}
				</cfif>
				if((eval("document.invent_rows.debt_acc" + t).value =="") || (eval("document.invent_rows.claim_acc" + t).value == ""))
				{
					if(invent_rows.amort_debt_acc_id.value=="" || invent_rows.amort_claim_acc_id.value=="")
					{
						alert("<cf_get_lang no='56.Amortisman Hesabı Seçiniz'>!");
						return false;
					}
				}
			}
		}
		if(!checked_info)
		{
			alert("<cf_get_lang no='54.Seçim Yapmadınız'>!");
			return false;
		}
		else
		return true;
	}
	<cfif attributes.open_form eq 1 and is_list_inventory eq 1>
	function all_discount()
	{	
		if (document.invent_rows.disc_all.value == "")
			document.invent_rows.disc_all.value = 0;
			deger = eval("document.invent_rows.disc_all");
			if ((filterNum(deger.value) <1) || (deger.value==""))
			{ 
				alert ("<cf_get_lang no='66.Hesaplama Dönemi 1den Küçük Olamaz'>!");
				deger.value =1;
			}
			else
			{	
			discount_yeni= document.invent_rows.disc_all.value;
			<cfif get_invent.recordcount>
			for(var i=1; i<=<cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
				  eval('invent_rows.period'+i).value=discount_yeni;
				}
			</cfif>
		}
		for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
		{
			deger=eval("document.invent_rows.diff_value" + i).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger1=eval("document.invent_rows.period" + i).value;
			deger1=filterNum(deger1);			
			deger1=parseFloat(deger1);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			deger2=eval("document.invent_rows.last_value" + i).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			eval("document.invent_rows.new_value" + i).value=commaSplit(deger2-deger/deger1);
			eval("document.invent_rows.new_inventory_value" + i).value=commaSplit(deger2-deger/deger1);
			hesapla(i);
		}
		return true;
	}
	</cfif>
	function kontrol_all_form()
	{
		if(document.add_amortization.inventory_type.value == '')
		{
			alert("<cf_get_lang no='112.Demirbaş Tipi Seçmelisiniz'>!");
			return false;
		}
		if(document.add_amortization.account_period_list.value == '')
		{
			alert("<cf_get_lang no='11.Hesaplama Dönemi Seçmelisiniz'>!");
			return false;
		}
		var document_id = document.add_amortization.inventory_type.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.add_amortization.inventory_type.options[i].selected && document_name.length==0)
				document_name = document_name + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
			else if(document.add_amortization.inventory_type.options[i].selected && ! list_find(document_name,list_getat(document.add_amortization.inventory_type.options[i].value,1,'-'),','))
				document_name = document_name + ',' + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
		}
		if(list_find(document_name,4) &&  list_len(document_name) != 1)
		{
			alert("İrsaliyeden Kaydedilen Demirbaşları Ayrı Değerlemelisiniz !");
			return false;
		}
		if (!chk_process_cat('add_amortization')) return false;
		if(!check_display_files('add_amortization')) return false;
		if(add_amortization.amort_debt_acc_id.value=="" || add_amortization.amort_claim_acc_id.value=="")
		{
			alert("<cf_get_lang no='56.Amortisman Hesabı Seçiniz'>!");
			return false;
		}
		if(!confirm('Filtrelere Uygun Tüm Demirbaşlar İçin Değerleme İşlemi Yapılacaktır.Emin misiniz?'))
			return false;
	}
</script>
</cfif>

<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfparam name="attributes.last_amortization_year" default="">
    <cfparam name="attributes.old_value" default=0>
    <cfquery name="GET_DETAIL" datasource="#dsn3#">
        SELECT
            DETAIL,
            PROCESS_TYPE,
            ACTION_DATE,
            PROCESS_CAT,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM
            INVENTORY_AMORTIZATION_MAIN
        WHERE
            INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_id#">		
    </cfquery>
    <cfquery name="GET_INVENT" datasource="#dsn3#">
        SELECT
            DISTINCT
            INVENTORY_AMORTIZATON.*,
            INVENTORY.LAST_INVENTORY_VALUE,
            INVENTORY.ACCOUNT_ID,
            INVENTORY.INVENTORY_NUMBER,
            INVENTORY.INVENTORY_NAME,
            INVENTORY.PROJECT_ID,
            INVENTORY.EXPENSE_ITEM_ID,
            INVENTORY.EXPENSE_CENTER_ID,
            ISNULL(INVENTORY_AMORTIZATON.INV_QUANTITY,INVENTORY.QUANTITY) QUANTITY,
            INVENTORY.AMOUNT,
            INVENTORY_ROW.STOCK_IN,
            INVENTORY.ACCOUNT_ID,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.ACCOUNT_CODE,
            EXPENSE_CENTER.EXPENSE,
            EXPENSE_CENTER.EXPENSE_ID
        FROM
            INVENTORY
            LEFT JOIN INVENTORY_ROW ON INVENTORY.INVENTORY_ID=INVENTORY_ROW.INVENTORY_ID  
            LEFT JOIN INVENTORY_AMORTIZATON ON INVENTORY.INVENTORY_ID=INVENTORY_AMORTIZATON.INVENTORY_ID 
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = INVENTORY.EXPENSE_CENTER_ID
        WHERE
            INVENTORY_ROW.STOCK_IN > 0 AND 
            INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_id#">		
    </cfquery>
    <cfset inv_list = valuelist(get_invent.inventory_id)>
    <cfquery name="get_amortization" datasource="#dsn3#">
        SELECT 
            IA.INV_AMORT_MAIN_ID
        FROM 
            INVENTORY_AMORTIZATON IA,
            INVENTORY_AMORTIZATION_MAIN IAM
        WHERE 
            IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
            AND IA.INVENTORY_ID IN(#inv_list#)
            AND IAM.RECORD_DATE > #createodbcdatetime(get_detail.record_date)#
    </cfquery>
    
    <script type="text/javascript">
	function check_all(deger)
	{
		<cfif get_invent.recordcount>
			if(invent_rows.hepsi.checked)
			{
				for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.invent_rows.invent_row" + i);
					form_field.checked = true;
					eval('invent_rows.invent_row'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
					form_field = eval("document.invent_rows.invent_row" + i);
					form_field.checked = false;
					eval('invent_rows.invent_row'+i).focus();
				}				
			}
		</cfif>
		return true;
	}
	function all_discount()
	{	
		if (document.invent_rows.disc_all.value == "")
			document.invent_rows.disc_all.value = 0;
			deger = eval("document.invent_rows.disc_all");
			if ((filterNum(deger.value) <1) || (deger.value==""))
			{ 
				alert ("<cf_get_lang no='66.Hesaplama Dönemi 1den Küçük Olamaz'>!");
				deger.value =1;
			}
			else
			{	
			discount_yeni= document.invent_rows.disc_all.value;
			<cfif get_invent.recordcount>
			for(var i=1; i<=<cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
				  eval('invent_rows.period'+i).value=discount_yeni;
				}
			</cfif>
		}
		for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
		{
			deger=eval("document.invent_rows.diff_value" + i).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger1=eval("document.invent_rows.period" + i).value;
			deger1=filterNum(deger1);			
			deger1=parseFloat(deger1);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			deger2=eval("document.invent_rows.last_value" + i).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			eval("document.invent_rows.new_value" + i).value=commaSplit(deger2-deger/deger1);
			eval("document.invent_rows.new_inventory_value" + i).value=commaSplit(deger2-deger/deger1);
			hesapla(i);
		}
		return true;
	}
	function period_hesapla(no)
	{    
		period_kontrol(no);
		deger=eval("document.invent_rows.diff_value" + no).value;
		deger=filterNum(deger);			
		deger=parseFloat(deger);
		deger1=eval("document.invent_rows.period" + no).value;
		deger1=filterNum(deger1);			
		deger1=parseFloat(deger1);
		deger2=eval("document.invent_rows.last_value" + no).value;
		deger2=filterNum(deger2);			
		deger2=parseFloat(deger2);
		quantity = eval("document.invent_rows.quantity" + no).value;
		eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger/deger1*quantity);
		eval("document.invent_rows.period_diff_value" + no).value=commaSplit(deger/deger1);
		eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger/deger1);
		eval("document.invent_rows.new_inventory_value" + no).value=commaSplit(deger2-deger/deger1);
		return true;	
	}
	function hesapla(no)
	{    
		deger=eval("document.invent_rows.period_diff_value" + no).value;
		deger=filterNum(deger);			
		deger=parseFloat(deger);
		deger2=eval("document.invent_rows.last_value" + no).value;
		deger2=filterNum(deger2);			
		deger2=parseFloat(deger2);
		quantity = eval("document.invent_rows.quantity" + no).value;
		eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger*quantity);
		eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger);
		return true;	
	}
	function  period_kontrol(no)
	{
		deger1= eval("document.invent_rows.hd_period"+no);
		deger = eval("document.invent_rows.period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang no='66.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value=deger1.value;
			return false;
		}
		return true;
	}
	function input_control()
	{  
		if(!chk_process_cat('invent_rows')) return false;
		if(!check_display_files('invent_rows')) return false;
		var checked_info = false;
		var toplam = document.invent_rows.all_records.value;
		for(var i=1; i<=toplam; i++)
		{
			if(eval('invent_rows.invent_row'+i).checked)
			{
				checked_info = true;
				i = toplam+1;
			}
		}
		for(var t=1; t<=toplam; t++)
		{
			if(eval('invent_rows.invent_row'+t).checked)
			{
				if(eval("document.invent_rows.diff_value" + t).value == '')
				{
					alert("<cf_get_lang no='55.Amortisman Tutarı Giriniz'>!");
					return false;
				}
				if((eval("document.invent_rows.debt_acc" + t).value == '') || (eval("document.invent_rows.claim_acc" + t).value == ''))
				{
					if(invent_rows.amort_debt_acc_id.value=="" || invent_rows.amort_claim_acc_id.value=="")
					{
						alert("<cf_get_lang no='56.Amortisman Hesabı Seçiniz'>!");
						return false;
					}
				}
			}
		}
		if(!checked_info)
		{
			alert("<cf_get_lang no='54.Seçim Yapmadınız'>!");
			return false;
		}
		else
			return true;
	}
</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.list_invent_amortization';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'inventory/display/list_invent_amortization.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.popup_upd_invent_amortization';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/upd_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/upd_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.list_invent_amortization';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'inv_id=##attributes.inv_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.inv_id##';
	
	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invent.emptypopup_del_invent_amortization&inv_main_id=#attributes.inv_id#&old_process_type=18&is_from_list=1';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_invent_amortization.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_invent_amortization.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_invent_amortization';
	}
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invent.list_invent_amortization';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'inventory/query/get_excel_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'inventory/query/get_excel_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'invent.list_invent_amortization';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'inv_id=##attributes.inv_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.inv_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.popup_add_invent_amortization';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.list_invent_amortization';
	
	WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = 'invent.list_invent_amortization';
	WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'inventory/form/add_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'inventory/query/add_invent_amortization.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = 'invent.list_invent_amortization';
	
	 if(IsDefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.inv_id#&process_cat=#get_detail.process_type#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=invent.list_invent_amortization&event=add','longpage')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=invent.popup_print_invent_amortization&action_id=#attributes.inv_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listInventAmortization';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVENTORY_AMORTIZATON';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item10','item11','item12']"; 
	/*
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
</cfscript>
