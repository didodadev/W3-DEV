<cf_get_lang_set module_name="budget">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.template_name" default="">
<cfparam name="attributes.template_id" default="">
<cfparam name="attributes.is_income" default="">
<cfparam name="attributes.is_department" default="">
<cfif IsDefined("attributes.event")>	
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="GET_WORKGROUPS" datasource="#dsn#">
        SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
        SELECT 
        	EXPENSE_ITEM_ID, 
            <cfif attributes.event eq 'add'>
            	REPLACE(REPLACE(EXPENSE_ITEM_NAME,'+',' '),'''',' ') EXPENSE_ITEM_NAME,
            <cfelse>
            	EXPENSE_ITEM_NAME,
            </cfif>
            IS_EXPENSE,
            INCOME_EXPENSE,
            IS_ACTIVE 
        FROM 
        	EXPENSE_ITEMS 
        ORDER BY 
        	EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM_EXPENSE" dbtype="query">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE IS_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM_INCOME" dbtype="query">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE INCOME_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT 
        	EXPENSE_ID, 
            <cfif attributes.event eq 'add'>
            	REPLACE(REPLACE(EXPENSE,'+',' '),'''',' ') EXPENSE
            <cfelse>
            	EXPENSE
            </cfif>
        FROM 
        	EXPENSE_CENTER 
        ORDER BY 
        	EXPENSE
    </cfquery>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="GET_TEMPLATE" datasource="#dsn2#">
            SELECT 
                    TEMPLATE_ID,
                    TEMPLATE_NAME,
                    IS_ACTIVE,
                    IS_INCOME,
                    IS_DEPARTMENT,
                    RECORD_DATE,
                    RECORD_EMP,
                    UPDATE_DATE,
                    UPDATE_EMP
            FROM 
                EXPENSE_PLANS_TEMPLATES 
            WHERE 
                TEMPLATE_ID = #attributes.template_id#
        </cfquery>
        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
            SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT
        </cfquery>
        <cfquery name="GET_ROWS" datasource="#dsn2#">
            SELECT 
                TEMPLATE_ID,
                RATE,
                EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ID,
                PROMOTION_ID,
                EXPENSE_PLANS_TEMPLATES_ROWS.COMPANY_ID,
                EXPENSE_PLANS_TEMPLATES_ROWS.COMPANY_PARTNER_ID,
                ASSET_ID,
                EXPENSE_PLANS_TEMPLATES_ROWS.PROJECT_ID,
                EXPENSE_PLANS_TEMPLATES_ROWS.MEMBER_TYPE,
                EXPENSE_PLANS_TEMPLATES_ROWS.DEPARTMENT_ID,
                EXPENSE_PLANS_TEMPLATES_ROWS.WORKGROUP_ID,
                SC.SUBSCRIPTION_NO,
                EXPENSE_PLANS_TEMPLATES_ROWS.SUBSCRIPTION_ID,
                A.ASSETP_ID,
				A.ASSETP,
                PP.PROJECT_ID,
				PP.PROJECT_HEAD
            FROM 
                EXPENSE_PLANS_TEMPLATES_ROWS 
                    LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = EXPENSE_PLANS_TEMPLATES_ROWS.SUBSCRIPTION_ID
                    LEFT JOIN #dsn_alias#.ASSET_P A ON A.ASSETP_ID = EXPENSE_PLANS_TEMPLATES_ROWS.ASSET_ID
                    LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID=EXPENSE_PLANS_TEMPLATES_ROWS.PROJECT_ID
            WHERE
                TEMPLATE_ID = #attributes.template_id#
        </cfquery>
        <cfset satir_sayi = get_rows.recordcount>
        <script type="text/javascript">
			$( document ).ready(function() {
				row_count=<cfoutput>#satir_sayi#</cfoutput>;
			});
			function add_row()
			{
				row_count++;
				var newRow;
				var newCell;
				var template_type=<cfif GET_TEMPLATE.IS_INCOME eq 1>1<cfelse>0</cfif>;
				if(template_type==0)
				{	
					newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);		
					document.add_costplan.record_num.value=row_count;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="1048.Masraf Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="1139.Gider Kalemi"></option><cfoutput query="get_expense_item_expense"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:150px;"> <a href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="728.İş Grubu"></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"> <a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:70px;"> <a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"/></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:70px;"> <a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
				}
				else
				{
					newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);		
					document.add_costplan.record_num.value=row_count;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="txt" onkeyup="return(FormatCurrency(this,event));">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="760.Gelir Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'"  style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="761.Gelir Kalemi"></option><cfoutput query="GET_EXPENSE_ITEM_INCOME"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"> <a href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="activity_type' + row_count +'" id="activity_type' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="workgroup_id' + row_count +'" id="workgroup_id' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"/></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"> <a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
				}
			}
		</script>
    </cfif>
    <cfif attributes.event eq 'add'>
    	<cfif attributes.is_income eq ''>
    		<cfset attributes.is_income = 0>
    	</cfif>
    	<script type="text/javascript">
			row_count=0;
			function masraf_gelir()
			{
				satir_var = 0;
				for(var rw=1;rw<=row_count;rw++)
				{
					if(document.getElementById("frm_row"+rw).style.display != 'none')
						satir_var = 1;
				}
				if(satir_var == 1)
				{
					if(confirm("<cf_get_lang no='16.Satırları Silmek İstediğinizden Eminmisiniz'>?"))	
					{
						if(document.add_costplan.template_type[0].checked)
						{
							table2.style.display='none';
							table1.style.display='';
						}
						else
						{
							table1.style.display='none';
							table2.style.display='';
						}
					}
					else return false;
				}
				else
				{
					if(document.add_costplan.template_type[0].checked)
					{
						table2.style.display='none';
						table1.style.display='';
					}
					else
					{
						table1.style.display='none';
						table2.style.display='';
					}	
				}
				for(var rw=1;rw<=row_count;rw++)
				{
					var my_element = document.getElementById("row_kontrol"+rw);
					my_element.value = 0;
					var my_element = document.getElementById("frm_row"+rw);
					my_element.style.display = "none";
				}
			}
			function add_row()
			{
				row_count++;
				var newRow;
				var newCell;
				if(document.add_costplan.template_type[0].checked)
				{
					newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);		
					document.add_costplan.record_num.value=row_count;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="text"><option value=""><cf_get_lang_main no="1048.Masraf Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="text"><option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option><cfoutput query="GET_EXPENSE_ITEM_EXPENSE"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"><a href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'"  value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'"  value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				}
				else
				{
					newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);		
					document.add_costplan.record_num.value=row_count;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="txt" onkeyup="return(FormatCurrency(this,event));">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="760.Gelir Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="761.Gelir Kalemi"></option><cfoutput query="GET_EXPENSE_ITEM_INCOME"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"><a href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'"  value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'"  value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'"  value="" class="txt"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				}
			}
		</script>
    </cfif>
    <script type="text/javascript">
		function sil(sy)
		{
			var my_element = document.getElementById("row_kontrol"+sy);
			my_element.value = 0;
			var my_element = document.getElementById("frm_row"+sy);
			my_element.style.display = "none";
		}
		function kontrol_et()
		{
			if(row_count == 0) return false;
			else return true;
		}
		function pencere_ac_asset(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_costplan.asset_id' + no +'&field_name=add_costplan.asset' + no +'&event_id=0&motorized_vehicle=0','list');
		}
		function pencere_ac_department(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_costplan.department_id' + no +'&field_name=add_costplan.department' + no,'list');
		}
		function pencere_ac_project(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no,'list');
		}
		function pencere_ac_subs(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_costplan.subscription_id' + no +'&field_no=add_costplan.subscription_name' + no,'list');
		}
		function auto_subscription(no)
		{
			AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
		}
		function pencere_ac_company(no)
		{
			document.getElementById("member_type"+no).value = '';
			document.getElementById("member_id"+no).value = '';
			document.getElementById("member_code"+no).value = '';
			document.getElementById("company_id"+no).value = '';
			document.getElementById("company"+no).value = '';
			document.getElementById("authorized"+no).value = '';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_costplan.member_code' + no +'&field_id=add_costplan.member_id' + no +'&field_comp_name=add_costplan.company' + no +'&field_name=add_costplan.authorized' + no +'&field_comp_id=add_costplan.company_id' + no + '&field_type=add_costplan.member_type' + no + '&select_list=1,2,3','list');
		}
		function kontrol()
		{ 
			if(document.getElementById("template_name").value == "")
			{
				alert("<cf_get_lang no='77.Lütfen Şablon Adı Giriniz'>!");
			}
			var toplam_satir = 0;	
			var sira_deger = 0;
			var rate_total = 0;
			for (var r=1;r<=row_count;r++)
			{
				if(document.getElementById("row_kontrol"+r).value == 1)
				{
					toplam_satir = toplam_satir + 1;
					rate_value = parseFloat(filterNum(document.getElementById("rate"+r).value));
					rate_total += rate_value;
					
					form_expense_center_id = document.getElementById("expense_center_id"+r);
					form_expense_item_id = document.getElementById("expense_item_id"+r);
					
					sira_deger = sira_deger + 1;
					if(rate_value =="")
					{
						alert("" + sira_deger + ".<cf_get_lang no='73. Satırdaki Oranı Giriniz'>!");
						return false;
					}
					if(rate_value < 0)
					{
						alert("" + sira_deger + ".<cf_get_lang dictionary_id='54520.Satırdaki Oran Negatif Olamaz'>");
						return false;
					}
					if(form_expense_center_id.value =="")
					{
						alert("" + sira_deger + ". <cf_get_lang no='72. Satırdaki Masraf Merkezini Seçiniz'>!");
						return false;
					}
					if(form_expense_item_id.value =="")
					{
						alert("" + sira_deger + ". <cf_get_lang no='71. Satırdaki Gider Kalemini Seçiniz'>!");
						return false;
					}
				}
			}
			if(toplam_satir== 0)
			{
				alert("<cf_get_lang no='76.Lütfen Masraf Şablonuna Satır Ekleyiniz'>!");
				return false;
			}
			if(wrk_round(rate_total) != 100)
			{
				alert("<cf_get_lang_main no='2583.Satır Oranlarının Toplamı %100 Olmalıdır. Lütfen Kontrol Ediniz.'>!");
				return false;
			}
			for (var rc=1;rc<=row_count;rc++)
			{
				if(document.getElementById("row_kontrol"+rc).value == 1)
					document.getElementById("rate"+rc).value = filterNum(document.getElementById("rate"+rc).value);
			}
			return true;
		}
	</script>
</cfif>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.isactive" default="1">
    <cfparam name="attributes.template_type" default="">
    <cfif isdefined("attributes.form_exist")>
        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
            SELECT 
                TEMPLATE_ID,
                TEMPLATE_NAME,
                IS_INCOME,
                RECORD_DATE,
                RECORD_EMP
            FROM
                EXPENSE_PLANS_TEMPLATES
            WHERE
                TEMPLATE_ID IS NOT NULL
                <cfif len(attributes.keyword)>AND TEMPLATE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
                <cfif len(attributes.isactive)>AND IS_ACTIVE = #attributes.isactive#</cfif>
                <cfif attributes.template_type eq 1>
                    AND IS_INCOME = 0
                <cfelseif attributes.template_type eq 0>
                    AND IS_INCOME = 1
                </cfif>
        </cfquery>
        <cfparam name="attributes.totalrecords" default="#get_expense.recordcount#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
        <cfset GET_EXPENSE.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</script>
</cfif>
<cfif isdefined('attributes.event') and attributes.event eq 'upd'>
	<cfset attributes.is_active = get_template.is_active>
	<cfset attributes.template_name = get_template.template_name>
	<cfset attributes.is_income = get_template.is_income>
	<cfset attributes.is_department = get_template.is_department>
	<cfset attributes.template_id = get_template.template_id>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_cost_bill_templates';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_cost_bill_templates.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.form_add_cost_bill_template';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_cost_bill_template.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_cost_bill_template.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_cost_bill_templates&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('cost_bill_template','cost_bill_template_bask')";
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_cost_bill_templates';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/add_cost_bill_template.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_cost_bill_template.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_cost_bill_templates&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'template_id=##attributes.template_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.template_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('cost_bill','cost_bill_bask')";
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_cost_bill_templates&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'costBillemplates';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_PLANS_TEMPLATES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1']"; 
</cfscript>
