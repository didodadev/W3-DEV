<cf_get_lang_set module_name="finance">
<cfparam name="attributes.id" default="">
<cfif not IsDefined("attributes.event") or(IsDefined("attributes.event") and attributes.event eq 'list')>
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.period_type" default="">
    <cfparam name="attributes.recorder" default="">
    <cfparam name="attributes.is_type" default="">
    <cfparam name="attributes.start_date" default="">
    <!---<cfparam name="attributes.form_submitted" default="">
    ---><cfparam name="attributes.finish_date" default="">
    <cfif len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfif fuseaction contains "popup">
        <cfset is_popup=1>
    <cfelse>
        <cfset is_popup=0>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_SCEN_EXPENSE" datasource="#DSN3#">
            SELECT
                S.*,
                SM.RATE1,
                SM.RATE2,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID
            FROM
                SCEN_EXPENSE_PERIOD S
                LEFT JOIN #dsn_alias#.SETUP_MONEY SM ON S.PERIOD_CURRENCY = SM.MONEY 
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON S.RECORD_MEMBER = E.EMPLOYEE_ID 
            WHERE
                
                SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND S.PERIOD_DETAIL LIKE '%#attributes.keyword#%'</cfif>
                 <cfif isDefined("attributes.period_type") and len(attributes.period_type)>AND S.PERIOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_type#"></cfif> 
                <cfif isDefined("attributes.is_type") and len(attributes.is_type)>AND S.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_type#"></cfif>
                <cfif len(attributes.is_active) and attributes.is_active eq 2>AND SCEN_EXPENSE_STATUS = 1
                <cfelseif len(attributes.is_active) and attributes.is_active eq 3>AND SCEN_EXPENSE_STATUS = 0</cfif>
                <cfif len(attributes.start_date)>AND S.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                <cfif len(attributes.finish_date)>AND S.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
            ORDER BY 
                S.START_DATE
        </cfquery>
    <cfelse>
        <cfset get_scen_expense.recordcount=0 >
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_scen_expense.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows) + 1>
    <script type="text/javascript">
		$( document ).ready(function() {
			 document.getElementById('keyword').focus();
		});
       
        function kontrolIncomeExpense()
            {
                if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
                    return false;
                else
                    return true;
            }
    </script>
</cfif>
<cfif IsDefined("attributes.event")>
	<cfquery name="GET_SETUP_SCENARIO" datasource="#DSN#">
        SELECT SCENARIO_ID,SCENARIO FROM SETUP_SCENARIO
    </cfquery>
   
    <cfquery name="GET_MONEY2" datasource="#dsn#">
        SELECT
            MONEY,
            RATE1,
            RATE2
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
            MONEY_STATUS=1 AND 
            MONEY <> '#SESSION.EP.MONEY#'
    </cfquery>
    <cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT
            MONEY,
            RATE1,
            RATE2
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
            MONEY_STATUS=1
    </cfquery>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="DETAIL" datasource="#dsn3#">
        SELECT
            *
        FROM
            SCEN_EXPENSE_PERIOD
        WHERE
            PERIOD_ID=#attributes.ID#
    </cfquery>
    <script type="text/javascript">
		function unformat_fields()
		{
			upd_expense.period_value.value = filterNum(upd_expense.period_value.value);
			upd_expense.repitition.value = filterNum(upd_expense.repitition.value);
			return true;
		}
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<script type="text/javascript">
		
			 var row_count=0;
		
		
		function sil(sy)
		{
			var my_element = document.getElementById("row_kontrol"+sy);
			my_element.value=0;
			var my_element = document.getElementById("frm_row"+sy);
			my_element.style.display="none";
		}
		
		function add_row(expense_date,detail)
		{
			if(expense_date == undefined)expense_date = '';
			if(detail == undefined)detail = '';
			
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById("record_num").value=row_count;	
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol'+ row_count +'" id="row_kontrol'+ row_count +'" value="1"><a style="cursor:pointer" onclick="sil('+ row_count +');"><img src="images/delete_list.gif"></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="extype_'+ row_count +'" id="extype_'+ row_count +'" style="width:100px;"><option value="0"><cf_get_lang_main no='1266.Gider'></option><option value="1"><cf_get_lang_main no='1265.Gelir'></option>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="period_type_'+ row_count +'" id="period_type_'+ row_count +'" style="width:100px;"> <option value="1" selected><cf_get_lang no='166.Her Hafta'></option> <option value="2"><cf_get_lang no='167.Her Ay'></option> <option value="6"><cf_get_lang no='572.Her 2 Ayda Bir'></option> <option value="3"><cf_get_lang no='168.Her 3 Ayda Bir'></option> <option value="4"><cf_get_lang no='169.Her 6 Ayda Bir'></option> <option value="5"><cf_get_lang no='164.Her Sene'></option>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="detail_'+ row_count +'" id="detail_'+ row_count +'" maxlength="50" style="width:100px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","expense_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="expense_date'+ row_count +'" id="expense_date'+ row_count +'" class="text" maxlength="10" style="width:65px;" value="'+ expense_date +'"> ';
			wrk_date_image('expense_date' + row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="repitition'+ row_count +'" id="repitition'+ row_count +'" class="moneybox" maxlength="2" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0));">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="period_'+ row_count +'" id="period_'+ row_count +'" value="0"><input type="text" name="period_value_'+ row_count +'" id="period_value_'+ row_count +'" class="moneybox" style="width:100px;" onkeyup="return(FormatCurrency(this,event));"> <select name="currency_' + row_count +'" id="currency_' + row_count +'" style="width:75px;"><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="scenario_type_'+ row_count +'" id="scenario_type_'+ row_count +'" style="width:100px;"><option value="0"><cf_get_lang_main no ="322.Seçiniz"></option><cfoutput query="GET_SETUP_SCENARIO"><option value="#SCENARIO_ID#">#SCENARIO#</option></cfoutput></select>';
		}
		
		function kontrolAddIncomeExpense()
		{
			for(i=1;i<=add_expense.record_num.value;i++)
			{
				if(document.getElementById("row_kontrol"+i).value==1)
				{
					if (document.getElementById("detail_"+i).value == "")
					{ 
						alert ("<cf_get_lang no ='1.Lütfen Açıklama Giriniz'>!");
						return false;
					}
					if (document.getElementById("expense_date"+i).value == "")
					{ 
						alert ("<cf_get_lang_main no='1091.Lütfen Tarih Giriniz'>!");
						return false;
					}
					if (document.getElementById("repitition"+i).value == "")
					{ 
						alert ("<cf_get_lang no='234.Lütfen Tekrar Giriniz'>!");
						return false;
					}						
					if (document.getElementById("period_value_"+i).value == "")
					{ 
						alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>!");
						return false;
					}						
				}
			}
			return true;
		}
		</script>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_scen_expense';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_scen_expense.cfm';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.form_add_scen_expense';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/form_add_scen_expense.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_scen_expense.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_scen_expense';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_upd_scen_expense';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/form_upd_scen_expense.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_scen_expense.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_scen_expense';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(IsDefined("attributes.event") and(attributes.event eq 'upd' or attributes.event eq 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'finance.emptypopup_upd_scen_expense';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'finance/query/upd_scen_expense.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'finance/query/upd_scen_expense.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_scen_expense';
	}

	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_scen_expense&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
</cfscript>

