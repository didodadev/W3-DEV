<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../product/query/get_rival_list.cfm">
    <cfelse>
        <cfset get_rival_list.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_rival_list.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'> 
    <cfquery name="BRANCHES" datasource="#DSN#">
    	SELECT BRANCH_ID, BRANCH_NAME FROM	BRANCH ORDER BY BRANCH_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfquery name="get_rivals" datasource="#dsn#">
        SELECT
            R_ID,
            RIVAL_NAME,
            STATUS,
            RIVAL_DETAIL,
            IS_GROUP,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM
            SETUP_RIVALS
        WHERE
            R_ID = #attributes.r_id#
    </cfquery>
    <cfquery name="get_branch_zone" datasource="#dsn#">
        SELECT 
            SRB.R_ID, 
            SRB.BRANCH_ID,
            B.BRANCH_NAME
        FROM 
            SETUP_RIVALS_BRANCH SRB,
            BRANCH B
        WHERE 
            SRB.BRANCH_ID = B.BRANCH_ID AND
            SRB.R_ID = #attributes.r_id#  
    </cfquery>
    <cfset row = get_branch_zone.recordcount>
</cfif>  
<cfif isdefined("attributes.event") and attributes.event is 'add'> 
    <script type="text/javascript">
		$(document).ready(function(){	
			row_count=0;	
		});
		
		function sil(sy)
		{
			var my_element=eval("add_rival.row_kontrol"+sy);
			my_element.value=0;
	
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		function kontrol_et()
		{
			if(row_count ==0)
				return false;
			else
				return true;
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
				document.add_rival.record_num.value = row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='51.Sil'>"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="branch_id' +row_count+'"><input name="branch_name' + row_count +'" style="width:290px" readonly="yes"><a href="javascript://" <a href="javascript://" onClick="pencere_ac(' + row_count + ');">&nbsp;<img src="/images/plus_thin.gif" align="absbottom" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a>';
		}
		function pencere_ac2(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=add_rival.sales_zone'+no+'&field_id=add_rival.sales_zone_id'+no,'medium');
			}
			
		function pencere_ac(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=add_rival.branch_name'+no+'&field_branch_id=add_rival.branch_id'+no,'medium');
			}
	</script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<script type="text/javascript">
		$(document).ready(function(){
			row_count=<cfoutput>#row#</cfoutput>;
		});
		function sil(sy)
		{
			var my_element=eval("upd_rival.row_kontrol"+sy);
			my_element.value=0;
	
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		
		function kontrol_et()
		{
			if(row_count ==0)
				return false;
			else
				return true;
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
				document.upd_rival.record_num.value = row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden"  value="1"  name="row_kontrol' +row_count+'"><input name="branch_name' + row_count +'" style="width:270px" readonly="yes"><input type="hidden" name="branch_id' +row_count+'">&nbsp;<a href="javascript://" <a href="javascript://" onClick="pencere_ac(' + row_count + ');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"  align="absmiddle"></a> ';
		}
		
		function pencere_ac2(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=upd_rival.sales_zone'+no+'&field_id=upd_rival.sales_zone_id'+no,'medium');
		}
		
		function pencere_ac(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=upd_rival.branch_name'+no+'&field_branch_id=upd_rival.branch_id'+no,'medium');
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.rivals';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_rivals.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_form_add_rival';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_rival.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_rival.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.rivals';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_rival';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_rival.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_rival.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_unit';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'r_id=##attributes.r_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.r_id##';

	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.rivals&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="" module_id="35" action_section="R_ID" action_id="#attributes.r_id#">';	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'rivalController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_RIVALS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-rival_name']";
	
</cfscript>