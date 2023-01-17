<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfscript>
		if (isdefined('attributes.is_submit'))
			include "../hr/ehesap/query/get_marching_money_factor.cfm";
		else
			get_marching_money.recordcount = 0;
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.is_submit") and len(attributes.is_submit))
			url_str = "#url_str#&is_submit=#attributes.is_submit#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_marching_money.recordcount#'>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfif isdefined('attributes.money_main_id')>
		<cfinclude template="../hr/ehesap/query/get_marching_money_factor.cfm">
		<cfif get_marching_money.recordcount>
			<cfquery name="get_rows" datasource="#dsn#">
				SELECT
					TBL.*,
					STUFF(
							(SELECT ',' + CONVERT(varchar,A.TITLE_ID) FROM 
								(SELECT TITLE_ID,MARCH_MONEY_ID FROM MARCHING_MONEY_POSITION_CATS) A
								WHERE A.MARCH_MONEY_ID = TBL.MARCH_MONEY_ID FOR XML PATH('')
							),1,1,'') AS TITLE_IDS
				FROM
				(SELECT
					MARCH_MONEY_ID,
					MARCHING_MONEY_MAIN_ID,
					DOMESTIC_FACTOR,
					OVERSEAS_FACTOR
				FROM
					MARCHING_MONEY_FACTORS
				WHERE	
					MARCHING_MONEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_marching_money.marching_money_main_id#">) AS TBL
			</cfquery>
		<cfelse>
			<cfset get_rows.recordcount = 0>
		</cfif>
	</cfif>
	<cfinclude template="../hr/query/get_titles.cfm">
	<cfif isdefined('attributes.money_main_id')>
		<cfset start_ = dateformat(get_marching_money.start_date,'dd/mm/yyyy')>
		<cfset finish_ = dateformat(get_marching_money.finish_date,'dd/mm/yyyy')>
	<cfelse>
		<cfset start_ = ''>
		<cfset finish_ = ''>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		$(document).ready(function() {
			<cfif isdefined("get_rows") and get_rows.recordcount>
				row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
			</cfif>
		});
		function kontrol()
		{
			$('#record_num').val(row_count);
			if(row_count == 0)
			{
				alert("<cf_get_lang dictionary_id='54622.Bir Kayıt Giriniz'>");
				return false;
			}
			for(var j=1;j<=row_count;j++)
			{
				if($('#row_kontrol_'+j).val() == 1)
				{
					var katsayi1 = $('#domestic_factor'+j).val();
					if(katsayi1 == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Katsayı");
						return false;
					}
					var position_cat = $('#title_ids'+j).val();
					if(position_cat == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Ünvan");
						return false;
					}
				}
			}
			return true;
		}	
		function sil(sy)
		{
			$('#row_kontrol_'+sy).val(0);
			$('#my_row_'+sy).css('display','none');
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
			document.add_factor.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" id="row_kontrol_'+ row_count +'" value="1" /><select name="title_ids' + row_count +'" id="title_ids' + row_count +'" multiple="multiple" style="height:300px;"><cfoutput query="titles"><option value="#title_id#">#title#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="domestic_factor' + row_count +'" id="domestic_factor' + row_count +'" type="text" style="width:100px;" class="moneybox">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="overseas_factor' + row_count +'" id="overseas_factor' + row_count +'" type="text" style="width:100px;" class="moneybox">';
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_marching_money_factor';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_marching_money_factor.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_marching_money_factor';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_marching_money_factor.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_marching_money_factor.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_marching_money_factor&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_add_marching_money_factor';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/add_marching_money_factor.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/add_marching_money_factor.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_marching_money_factor&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'money_main_id=##attributes.money_main_id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapMarchingMoneyFactor.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'MARCHING_MONEY_MAIN';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate']";
</cfscript>
