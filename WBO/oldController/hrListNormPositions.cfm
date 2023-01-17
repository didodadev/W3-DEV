<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.norm_year" default="#year('#now()#')#">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.company_id" default="">
	
	<cfscript>
		attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
		if (fuseaction contains "popup")
			is_popup = 1;
		else
			is_popup = 0;
		
		if (not isdefined("attributes.ay"))
			attributes.ay = month(now());
		
		cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
		cmp_pos_cat.dsn = dsn;
		get_position_cats = cmp_pos_cat.get_position_cat(
			position_cat: attributes.keyword
		);
		
		cmp_company = createObject("component","hr.cfc.get_our_company");
		cmp_company.dsn = dsn;
		get_company_name = cmp_company.get_company();
		
		if (isdefined("form_submitted"))
		{
			cmp_norm_pos = createObject("component","hr.cfc.get_norm_positions");
			cmp_norm_pos.dsn = dsn;
			get_norm_pos = cmp_norm_pos.get_norm_pos(
				keyword: attributes.keyword,
				company_id: attributes.company_id,
				branch_id: '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
				norm_year: attributes.norm_year,
				position_cat_id: attributes.position_cat_id,
				maxrows: attributes.maxrows,
				startrow: attributes.startrow
			);
		}
		else
			get_norm_pos.query_count = 0;
			
		url_str = '';
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = '#url_str#&keyword=#attributes.keyword#';
		if (isdefined("attributes.ay") and len(attributes.ay))
			url_str = '#url_str#&ay=#attributes.ay#';
		if (isdefined("attributes.company_id") and len(attributes.company_id))
			url_str = '#url_str#&company_id=#attributes.company_id#';
		if (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id))
			url_str = '#url_str#&position_cat_id=#attributes.position_cat_id#';
		if (isdefined("attributes.norm_year") and len(attributes.norm_year))
			url_str = '#url_str#&norm_year=#attributes.norm_year#';
		if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
			url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_norm_pos.query_count#'>
<cfelseif isdefined("attributes.event") and listfind('add,upd,det',attributes.event)>
	<cfinclude template="../hr/query/get_setup_moneys.cfm">
	<cfif listfind('add,upd',attributes.event)>
		<cfinclude template="../hr/query/get_norm_branches.cfm">
		<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			<cfquery name="get_norm" datasource="#DSN#">
				SELECT 
					* 
				FROM 
					EMPLOYEE_NORM_POSITIONS 
				WHERE 
					BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND
					NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.norm_year#">
			</cfquery>
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
		<cfset buay=month(now())>
		<cfquery name="get_norm" datasource="#DSN#">
			SELECT 
				EMPLOYEE_NORM_POSITIONS.*,
				ZONE.ZONE_NAME,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_ID,
				OUR_COMPANY.NICK_NAME,
				DEPARTMENT.DEPARTMENT_HEAD,
				SETUP_POSITION_CAT.POSITION_CAT
			FROM 
				EMPLOYEE_NORM_POSITIONS
				INNER JOIN BRANCH ON BRANCH.BRANCH_ID=EMPLOYEE_NORM_POSITIONS.BRANCH_ID
				INNER JOIN ZONE ON ZONE.ZONE_ID = BRANCH.ZONE_ID
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
				LEFT JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_NORM_POSITIONS.DEPARTMENT_ID
				LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_NORM_POSITIONS.POSITION_CAT_ID
			WHERE	
				EMPLOYEE_NORM_POSITIONS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND	
				ZONE.ZONE_STATUS = 1 AND
				BRANCH.BRANCH_STATUS = 1 AND
				EMPLOYEE_NORM_POSITIONS.NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.norm_year#">		
		</cfquery>
		<cfinclude template="../hr/query/get_emp_norm_count_with_func.cfm">
		<!--- toplamlar icin ilk deger atamalari yapiliyor --->
		<cfloop from="0" to="11" index="i">
		  <cfset "toplam_#i#"=0>
		  <cfset "toplam_#i#_sal"=0>
		  <cfset "toplam_gercek_#i#"=0>
		  <cfset "toplam_gercek_#i#_sal"=0>
		</cfloop>
		<cfset toplam_yan=0>
		<cfset toplam_yan_gercek=0>
		<cfset toplam_salary=0>
		<cfset salary=0>
		<!--- //toplamlar icin ilk deger atamalari yapiliyor --->
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		function sil(sy)
		{
			var my_element=eval("document.getElementById('row_kontrol" + sy + "')");
			my_element.value=0;
	
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		
		function kontrol_et()
		{
			if(row_count ==0)
				return false;
			else
			{
				UnformatFields();
				return true;
			}
		}
		
		function pencere_ac(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_departments&field_id=add_norm.department_id' + no + '&field_name=add_norm.department_name' + no + '&branch_id=' + <cfoutput>#attributes.branch_id#</cfoutput>,'list');	
		}
		
		function pencere_pos(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_norm.position_cat_id' + no + '&field_cat=add_norm.position_cat' + no,'list');
		}
		
		function UnformatFields()
		{
			for(yerel_i=0 ; yerel_i <= row_count ; yerel_i++)
			{
				try{
					var str_me=eval("document.getElementById('salary" + yerel_i + "')");
					if(str_me != null)
						str_me.value = filterNum(str_me.value);
				}
				catch(e){}
			}
		}
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			
			document.getElementById('record_num').value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="javascript://" onclick="sil(' + row_count + ');"><i class="icon-trash-o"></i></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" id="department_id' + row_count +'" name="department_id' + row_count +'"><input type="text" id="department_name' + row_count + '" name="department_name' + row_count + '" style="width:100px;"> <a href="javascript://" onClick="pencere_ac(' + row_count + ');"><i class="icon-ellipsis"></i></a> ';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" id="position_cat_id' + row_count +'" name="position_cat_id' + row_count +'"><input type="text" id="position_cat' + row_count + '" name="position_cat' + row_count + '" style="width:100px;"> <a href="javascript://" onClick="pencere_pos(' + row_count + ');"><i class="icon-ellipsis"></i></a> ';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" id="salary' + row_count + '" name="salary' + row_count + '" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="MONEY' + row_count + '" id="MONEY' + row_count + '" style="width:40px;"><cfoutput query="get_moneys"><option value="#MONEY#" <cfif get_moneys.MONEY eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';

			for(k=0;k<=11;k++)
			{
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input id="count_'+ row_count + '_' +  k + '" name="count_'+ row_count + '_' +  k + '" onkeyup="isNumber(this);" onblur="isNumber(this);set_other_salaries(row_count);" type="text" style="width:48px; text-align:right;" maxlength="4">';
			}
		}
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			row_count=0;
			function set_other_salaries(satir)
			{
				ilk_deger_ = '0';
				for(yerel_i=0;yerel_i<=11;yerel_i++)
				{
					var deger_ = eval("document.add_norm.count_"+satir+"_"+yerel_i)
					if(deger_.value == '' && ilk_deger_ != '')
					{
						deger_.value = ilk_deger_;
					}		
					else
					{
						ilk_deger_ = deger_.value;
					}
				}
			}	
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			row_count=<cfoutput>#get_norm.recordcount#</cfoutput>;
		</cfif>
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_norm_positions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_norm_positions.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_norm_positions';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_norm_positions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_norm_positions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_norm_positions&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_norm_positions';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_norm_positions.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_norm_positions.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_norm_positions&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'branch_id=##attributes.branch_id##&norm_year=##attributes.norm_year##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_branches.nick_name##\##get_branches.branch_name##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.popup_dsp_norm_staff';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/display/dsp_norm_staff.cfm';
	if (isdefined('get_norm') and get_norm.recordcount)
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##get_norm.nick_name## - ##get_norm.branch_name##';
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=hr.list_norm_positions&event=add&branch_id=#attributes.branch_id#&norm_year=#attributes.norm_year#','page');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
