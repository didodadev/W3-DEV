<cf_get_lang_set module_name="ehesap">
<cfif listgetat(attributes.fuseaction,1,'.') is "account">
	<!--- MUHASEBE İÇİN --->
	<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
        <cfif not isdefined("attributes.keyword")>
            <cfset arama_yapilmali = 1>
        <cfelse>
            <cfset arama_yapilmali = 0>
        </cfif>
        <cfquery name="get_xml_control" datasource="#dsn#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.popup_list_period"> AND
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_add_multi_expense_center">
        </cfquery>
        <cfif arama_yapilmali eq 1>
            <cfset GET_IN_OUTS.recordcount = 0>
        <cfelse>
            <cfinclude template="../hr/ehesap/query/get_in_outs.cfm">
            <cfif GET_IN_OUTS.recordcount>
                <cfif get_xml_control.property_value eq 0>
                    <cfquery name="get_expense_center" datasource="#dsn#">
                        SELECT
                            EXPENSE_CENTER_ID,
                            EXPENSE_CODE_NAME,
                            IN_OUT_ID
                         FROM
                            EMPLOYEES_IN_OUT_PERIOD
                         WHERE
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                            IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
                    </cfquery>
                <cfelse>
                    <cfquery name="get_expense_rows" datasource="#dsn2#">
                        SELECT 
                            EC.EXPENSE,
                            PR.RATE,
                            PR.IN_OUT_ID
                        FROM	
                            EXPENSE_CENTER EC INNER JOIN 
                            #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD_ROW PR
                            ON EC.EXPENSE_ID = PR.EXPENSE_CENTER_ID
                        WHERE
                            PR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                            PR.IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
                    </cfquery>
                </cfif>
                <cfquery name="get_account_bill" datasource="#dsn#">
                    SELECT
                        DEFF.DEFINITION,
                        DEFF.PAYROLL_ID,
                        IP.IN_OUT_ID
                    FROM
                        EMPLOYEES_IN_OUT_PERIOD IP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF DEFF
                        ON IP.ACCOUNT_BILL_TYPE = DEFF.PAYROLL_ID 
                    WHERE
                        IP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                        IP.IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
                </cfquery>
            </cfif>
        </cfif>
        <cfscript>
            bu_ay_basi = CreateDate(year(now()),month(now()),1);
            bu_ay_sonu = DaysInMonth(bu_ay_basi);
            
            duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
            QueryAddRow(duty_type,8);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME","#lang_array_main.item[164]#",1);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[194]#',2);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[604]#',3);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[206]#',4);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[232]#',5);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[223]#',6);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[236]#',7);
            QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
            QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[253]#',8);
        </cfscript>
        <cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
        <cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
        <cfparam name="attributes.branch_id" default="">
        <cfparam name="attributes.tc_identy_no" default="">
        <cfparam name="attributes.duty_type" default="">
        <cfparam name="attributes.department_id" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.hierarchy" default="">
        <cfparam name="attributes.inout_statue" default="2">
        <cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default=#get_in_outs.recordcount#>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfif get_in_outs.recordcount>
            <cfset employee_id_list = ''>
            <cfoutput query="get_in_outs" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                <cfif not listfind(employee_id_list,employee_id)>
                    <cfset employee_id_list = listappend(employee_id_list,employee_id)>
                </cfif>
                <cfquery name="GET_POSITIONS" datasource="#dsn#">
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                        SETUP_POSITION_CAT.POSITION_CAT
                    FROM
                        EMPLOYEE_POSITIONS,
                        SETUP_POSITION_CAT
                    WHERE
                        SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
                        EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_id_list#) AND
                        EMPLOYEE_POSITIONS.IS_MASTER = 1
                    ORDER BY
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                </cfquery>
                <cfset employee_id_list = listsort(listdeleteduplicates(valuelist(GET_POSITIONS.EMPLOYEE_ID,',')),'numeric','ASC',',')>
            </cfoutput>    
        </cfif>
    </cfif>
<cfelseif listgetat(attributes.fuseaction,1,'.') is "ehesap">
<!--- E-HESAP İÇİN --->
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "addAccDef")>
    <cf_xml_page_edit fuseact="ehesap.popup_list_period">
    <cfquery name="get_company_periods" datasource="#DSN#">
        SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY PERIOD_YEAR
    </cfquery>
    <cfif not isdefined("attributes.period_id") >
        <cfset attributes.period_id = SESSION.EP.PERIOD_ID>
    </cfif>
    <cfquery name="GET_IN_OUT_PERIODS" datasource="#DSN#">
        SELECT
            ACCOUNT_BILL_TYPE,
            ACCOUNT_CODE,
            EXPENSE_CODE,
            EXPENSE_CENTER_ID,
            EXPENSE_CODE_NAME,
            EXPENSE_ITEM_ID,
            EXPENSE_ITEM_NAME,
            RECORD_DATE,
            RECORD_EMP,
            UPDATE_DATE,
            UPDATE_EMP
        FROM
            EMPLOYEES_IN_OUT_PERIOD
        WHERE
            IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
    </cfquery>
    <cfquery name="get_active_period" dbtype="query">
        SELECT * FROM get_company_periods WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
    </cfquery>
    <cfquery name="get_acc_types" datasource="#dsn#">
        SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID DESC
    </cfquery>
    <cfquery name="get_emp_id" datasource="#dsn#">
        SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
    </cfquery>
    <cfif get_in_out_periods.recordcount>
        <cfquery name="get_rows" datasource="#dsn#">
            SELECT 
                ACC_TYPE_ID,
                ACCOUNT_CODE 
            FROM 
                EMPLOYEES_ACCOUNTS 
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> AND
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
           ORDER BY 
                ACC_TYPE_ID DESC
        </cfquery>
        <cfquery name="get_rows_2" datasource="#dsn2#">
            SELECT 
                PR.EXPENSE_CENTER_ID,
                PR.RATE,
                EC.EXPENSE
             FROM 
                #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD_ROW PR INNER JOIN EXPENSE_CENTER EC
                ON EC.EXPENSE_ID = PR.EXPENSE_CENTER_ID
             WHERE 
                PR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND 
                PR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
        </cfquery>
    <cfelse>
        <cfset get_rows.recordcount = 0>
        <cfset get_rows_2.recordcount = 0>
    </cfif>
    <cfif not isdefined("x_add_multi_expense_center")><cfset x_add_multi_expense_center = 0></cfif>
    <cfinclude template="../hr/ehesap/query/get_code_cat.cfm">
</cfif>
<script type="text/javascript">
	<cfif listgetat(attributes.fuseaction,1,'.') is "account">
		<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
			$(document).ready(function(){
				document.getElementById('keyword').focus();
			});
			function showDepartment(branch_id)	
			{
				var branch_id = document.getElementById('branch_id').value;
				if (branch_id != "")
				{
					var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ajax_list_hr&branch_id="+branch_id;
					AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
				}
			}
			
			function tarih_kontrol(date1,date2)
			{
				date_check
				if(date1<date2)
					{
						alert("tarih hatasi")
						return false;
					}
				else
					return true;
			}
		</cfif>
	</cfif>
	<cfif (isdefined("attributes.event") and attributes.event is "addAccDef")>
		$(document).ready(function(){
			row_count = <cfoutput>#get_rows.recordcount#</cfoutput>;
			row_count2 = <cfoutput>#get_rows_2.recordcount#</cfoutput>;	
		});
		function pencere_ac_exp(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_period.expense_center_id' + no +'&field_name=add_period.expense_center_name' + no,'list');
		}
		function get_account(count)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_period.account_name_'+ count +'&field_id=add_period.account_code_' + count ,'list');
		}
		function sil(sy)
		{
			setDisp('confirm', 'block');
			$('#sil_id').val(sy);
		}
		function sil2(sy)
		{
			var my_element=eval("document.add_period.row_kontrol_2_"+sy);
			my_element.value=0;
			var my_element=eval("my_row_2_"+sy);
			my_element.style.display="none";
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);		
			document.add_period.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><cfif session.ep.ehesap or get_module_power_user(48)><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a></cfif>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML= '<select name="acc_type_id_'+ row_count +'" style="width:150px;"><option value="">Seçiniz</option><cfoutput query="get_acc_types"><option value="#get_acc_types.acc_type_id#">#get_acc_types.acc_type_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="account_code_'+ row_count +'" id="account_code_'+ row_count +'" value="">';
			newCell.innerHTML+= '<input type="text" name="account_name_'+row_count+'" id="account_name_'+ row_count +'" value="" style="width:150px;" onFocus="autocomp_account('+row_count+');">';
			newCell.innerHTML+= ' <a href="javascript://" onClick="get_account(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="top"></a>';
		}
		function add_row_2()
		{
			row_count2++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table2").insertRow(document.getElementById("link_table2").rows.length);	
			newRow.setAttribute("name","my_row_2_" + row_count2);
			newRow.setAttribute("id","my_row_2_" + row_count2);		
			newRow.setAttribute("NAME","my_row_2_" + row_count2);
			newRow.setAttribute("ID","my_row_2_" + row_count2);		
			document.add_period.record_num_2.value=row_count2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="row_kontrol_2_'+ row_count2 +'" value="1" /><a style="cursor:pointer" onclick="sil2(' + row_count2 + ');" ><img src="images/delete_list.gif" border="0"></a>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count2 +'" id="expense_center_id' + row_count2 +'" value=""><input type="text" id="expense_center_name' + row_count2 +'" name="expense_center_name' + row_count2 +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count2 +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count2 +'\',\'add_period\',1);" value="" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count2 +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="rate' + row_count2 +'" id="rate' + row_count2 +'" value="" onkeyup="return(FormatCurrency(this,event,2));" style="width:150px;" class="box">';
		}
		function autocomp_account(no)
		{
			AutoComplete_Create("account_name_"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_NAME,ACCOUNT_CODE","account_name_"+no+",account_code_"+no+"","",3);
		}
		function kontrol()
		{
			acc_type_id_list='';
			for(var j=1;j<=row_count;j++)
			{
				if(eval('document.add_period.row_kontrol_'+j+'.value')==1)
				{
	
					var definition = eval('document.add_period.acc_type_id_'+j+'.value');
					if(definition == '')
					{
						alert("Lütfen Hesap Tipi Seçiniz !");
						return false;
					}
					var muhasebe_kodu = eval('document.add_period.account_code_'+j+'.value');
					if(muhasebe_kodu == '')
					{
						alert("Lütfen Muhasebe Kodunu Seçiniz!");
						return false;
					}
					if(list_find(acc_type_id_list,eval('document.add_period.acc_type_id_'+j+'.value'),','))
					{
						alert("Satırlarda Aynı Hesap Türleri Seçili Olamaz !");
						return false;
					}
					else
					{
						if(list_len(acc_type_id_list,',') == 0)
							acc_type_id_list+=eval('document.add_period.acc_type_id_'+j+'.value');
						else
							acc_type_id_list+=","+eval('document.add_period.acc_type_id_'+j+'.value');
					}
				}
			}
			for(var j=1;j<=row_count2;j++)
			{
				if(eval('document.add_period.row_kontrol_2_'+j+'.value')==1)
				{
					if(eval('document.add_period.expense_center_id'+j+'.value') == '' || eval('document.add_period.expense_center_name'+j+'.value') == '')
					{
						alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1048.Masraf Merkezi">');
						return false;
					}
					if(eval('document.add_period.rate'+j+'.value') == '')
					{
						alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1044.Oran">');
						return false;
					}
				}
			}
			return true;
		}
		function doConfirm(v)
		{
			var b = document.getElementById('btn');
			var sy = document.getElementById('sil_id').value;
			if(v){
				var my_element=eval("document.add_period.row_kontrol_"+sy);
				my_element.value=0;
				var my_element=eval("my_row_"+sy);
				my_element.style.display="none";
			}
			return v;
		}
				
		function setDisp(id, disp)
		{
			document.getElementById(id).style.display = disp;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	if (listgetat(attributes.fuseaction,1,'.') is "account")
	{
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_employee_accounts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_employee_accounts.cfm';
	}
	else if (listgetat(attributes.fuseaction,1,'.') is "ehesap")
	{
		//E-HESAP EVENTS
	}
	if(isdefined("attributes.event") and attributes.event is "addAccDef")
	{
		if (listgetat(attributes.fuseaction,1,'.') is "account")
			nextEvent = 'account.list_employee_accounts&event=addAccDef';
		else if(listgetat(attributes.fuseaction,1,'.') is "ehesap")
			nextEvent = '';
		WOStruct['#attributes.fuseaction#']['addAccDef'] = structNew();
		WOStruct['#attributes.fuseaction#']['addAccDef']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addAccDef']['fuseaction'] = 'ehesap.popup_list_period';
		WOStruct['#attributes.fuseaction#']['addAccDef']['filePath'] = 'hr/ehesap/display/list_periods.cfm';
		WOStruct['#attributes.fuseaction#']['addAccDef']['queryPath'] = 'hr/ehesap/query/add_periods_to_in_out.cfm';
		WOStruct['#attributes.fuseaction#']['addAccDef']['nextEvent'] = '#nextEvent#';
		WOStruct['#attributes.fuseaction#']['addAccDef']['Identity'] = '#get_emp_info(get_emp_id.employee_id,0,0)#';
	}
</cfscript>
