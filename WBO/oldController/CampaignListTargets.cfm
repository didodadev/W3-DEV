<cf_get_lang_set module_name="campaign">
<cfset attributes.start_date = CreateDate(dateformat(now(),'YYYY'),1,1)>
<cfset attributes.finish_date= CreateDate(date_add('Y',1,dateformat(now(),'YYYY')),1,1)>
<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT
		CAMP_ID,
		PROJECT_ID,
		CAMP_HEAD,
		COMPANY_CAT,
		IS_EXTRANET,
		CONSUMER_CAT,
		IS_INTERNET,
		CAMP_STATUS,
		CAMP_NO,
		CAMP_TYPE,
		CAMP_CAT_ID,
		PROCESS_STAGE,
		CAMP_STARTDATE,
		CAMP_FINISHDATE,
		CAMP_OBJECTIVE,
		LEADER_EMPLOYEE_ID,
		RECORD_EMP,
		UPDATE_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		CAMP_STAGE_ID,
		PART_TIME
	FROM
		CAMPAIGNS   
	WHERE
		1=1    
		<cfif isDefined("camp_id") and len(camp_id)>
			AND	CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
		</cfif>
		<cfif isdefined('attributes.start_date')>
			AND	CAMP_STARTDATE > #attributes.start_date#
		</cfif>
		<cfif isdefined('attributes.finish_date')>
			AND	CAMP_FINISHDATE < #attributes.finish_date#
		</cfif>
	ORDER BY 
		CAMP_STARTDATE
</cfquery>
<cfquery name="get_target_cat" datasource="#dsn#">
	SELECT TARGETCAT_ID,TARGETCAT_NAME FROM TARGET_CAT
</cfquery>
<cfset camp_id_list = ValueList(CAMPAIGN.CAMP_ID,',')>
<cfquery name="get_target_select" datasource="#dsn#">
   SELECT 
		TARGETCAT_ID,
		TARGET_HEAD
	FROM
		TARGET 
	WHERE
		CAMP_ID IS NOT NULL
	GROUP BY 
		TARGETCAT_ID,
		TARGET_HEAD
</cfquery>
<cfsavecontent variable="option_target_values"><cfoutput query="get_target_cat"><option value="#TARGETCAT_ID#">#TARGETCAT_NAME#</option></cfoutput></cfsavecontent>
<cfsavecontent variable="calculation_type_values"><option value="1"> + (<cf_get_lang no ='364.Artis Hedefi'>)</option><option value="2">- (<cf_get_lang no ='365.Düsüs Hedefi'>)</option><option value="3">+% (<cf_get_lang no ='366.Yüzde Artis Hedefi'>)</option><option value="4"> -% (<cf_get_lang no ='367.Yüzde Düsüs Hedefi'>)</option><option value="5"> = (<cf_get_lang no ='368.Hedeflenen Rakam'>)</option></cfsavecontent>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.targets';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'campaign/form/targets.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'campaign/query/add_multiple_targets.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.targets&event=add';
	
	//WOStruct['#attributes.fuseaction#']['upd'] = structNew();
//	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
//	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.targets';
//	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'campaign/form/targets.cfm';
//	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'campaign/query/add_multiple_targets.cfm';
//	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.targets&event=upd';
//	WOStruct['#attributes.fuseaction#']['upd']['identity'] = '#get_target_select.TARGET_HEAD#';
//	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '';
	

</cfscript>

<cfoutput>   
	<script type="text/javascript">
	//$( document ).ready(function() {
//		add_row();
//	});
	
	var row_count = #get_target_select.recordcount#;
	function sil(sy){
		var my_element=eval("multiple_targets.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row(){
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			document.multiple_targets.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  id="row_kontrol'  + row_count +'"  name="row_kontrol'  + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"  ><img src="/images/delete_list.gif" alt="Si" border="0" align="absmiddle"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.width='120px';
			newCell.innerHTML = '<select name="target_cats'+row_count+'" id="target_cats'+row_count+'" style="width:120px;"><option value="">Seçiniz</option><cfoutput>#option_target_values#</cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.width='120px';
			newCell.innerHTML = '<input type="text" name="detail'+row_count+'" style="width:120px;">';
			<cfloop query="CAMPAIGN">
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.width='192px';
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input type="text" id="target_number" name="target_number_#CAMP_ID#_'+row_count+'" style="width:50px;" onkeyup="FormatCurrency(this,event);"> <select name="calculation_type_#CAMP_ID#_'+row_count+'" style="width:142px"><cfoutput>#calculation_type_values#</cfoutput></select>';
			</cfloop>
		}
	function kontrol()
	{
		var target_cats_select_list='0';
		for(i=1;i<=row_count;i++)
		{
			if(document.getElementById('row_kontrol'+i).value == 1)
			{   //Satir Silinmemis ise!
				if(document.getElementById('target_cats'+i).value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
					 return false;
				}
				if(list_find(target_cats_select_list,document.getElementById('target_cats'+i).value)==0)//kategori daha önce seçilmemis ise seçilen kategoriler listesine al.
					target_cats_select_list +=','+document.getElementById('target_cats'+i).value;
				else
				{
					alert("<cf_get_lang_main no='13.uyari'>:<cf_get_lang_main no='74.kategori'> <cf_get_lang no ='781.tekrari'>!");
					return false;
				}					
			}
		}
		for(il=0;il<=document.getElementsByName('target_number').length-1;il++)
			document.getElementsByName('target_number')[il].value = filterNum(document.getElementsByName('target_number')[il].value);
		return true;
			
	}
	</script>
</cfoutput>
