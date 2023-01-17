<cffunction name="createListPage" access="public" returntype="string">
    <cfargument name="filterStruct" type="struct">
    <cfargument name="listStruct" type="struct">
    <cfargument name="maxrows" type="numeric" default="#session.ep.maxrows#">
    
	<script type="text/javascript" src="JS/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="JS/jquery.json-2.4.min.js"></script>
    <cfset filterList = ListSort(StructKeyList(arguments.filterStruct),'numeric')>
    <cfform name="form" method="post" action="">
        <input name="form_submitted" id="form_submitted" type="hidden" value="1">
        <cf_big_list_search title="#lang_array_main.item[112]#">
            <cf_big_list_search_area>
            	<cfoutput>
                    <table>
                        <tr>
                            <cfloop list="#filterList#" index="currentFilterObject">
                                <td>
                                	<cfswitch expression = "#arguments['filterStruct'][currentFilterObject]['type']#">
                                    	<cfcase value="label">
                                        	#arguments['filterStruct'][currentFilterObject]['value']#
                                        </cfcase>
                                    	<cfcase value="text">
                                        	<input type="text" id="#arguments['filterStruct'][currentFilterObject]['id']#" name="#arguments['filterStruct'][currentFilterObject]['id']#" value="#arguments['filterStruct'][currentFilterObject]['value']#">
                                        </cfcase>
                                    	<cfcase value="select">
                                        	<select name="#arguments['filterStruct'][currentFilterObject]['id']#" id="#arguments['filterStruct'][currentFilterObject]['id']#">
                                            	<option value="">#arguments['filterStruct'][currentFilterObject]['value']#</option>
                                                <cfloop query="#arguments['filterStruct'][currentFilterObject]['source']#">
                                                	<option value="#arguments['filterStruct'][currentFilterObject]['source']['value'][currentrow]#">#arguments['filterStruct'][currentFilterObject]['source']['item'][currentrow]#</option>
                                                </cfloop>
                                            </select>
                                        </cfcase>
                                    </cfswitch>
                                </td>
                            </cfloop>
                            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </td>
                            <td><cf_wrk_search_button></td>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </tr>
                    </table>
                </cfoutput>
            </cf_big_list_search_area>
        </cf_big_list_search>
    </cfform>
    <div id="reportBase">
    
    </div>
    <cfset jsonData = SerializeJSON(arguments['listStruct']['query'])>
    <cfif left(jsonData, 2) is "//"><cfset jsonData = mid(jsonData, 3, len(jsonData) - 2)></cfif>
    <cfset jsonData = URLEncodedFormat(jsonData, "utf-8")>
    
    <script type="text/javascript">
		var jsonData = $.evalJSON(decodeURIComponent("<cfoutput>#jsonData#</cfoutput>"));
		var maxRowsPerPage = "<cfoutput>#arguments.maxrows#</cfoutput>";
		
		gotoPage(1);
		
		function gotoPage(pageNum)
		{
			$("#pageNew").remove();
			
			var divNew = document.createElement('div');
			divNew.id = 'pageNew';
			$(divNew).css({							
				'padding':'12px',							
				});
			var tableNew = document.createElement('table');
				$(tableNew).css({
				'margin':'auto',
				'width':'98%'							
				});
			
			$(tableNew).addClass("basket_list"); <!--- galiba koca fonksiyonda workcube'e özel tek yapı bu. --->
			
			var totalPages = Math.ceil(jsonData.DATA.length/maxRowsPerPage);
			
			var startRow = 0 + (pageNum - 1) * maxRowsPerPage;
			var maxRows = pageNum * maxRowsPerPage;
			
			if(maxRows > jsonData.DATA.length)
				maxRows = jsonData.DATA.length;
			
			var divNav = document.createElement('div'); <!--- divNav, navigasyon butonlarımı tutuyor. ileri-geri vs. --->
			divNav.id = 'navigation';
			$(divNav).css({
				'margin':'auto',
				'width':'130px'							
				});
			
			var buttonNew = document.createElement('div');
			buttonNew.className = "pages_button";
			buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage(1)">&laquo;</a>';
			$(divNav).append(buttonNew);					
			if(pageNum == 1)
				buttonNew.innerHTML = '&laquo;';
			
			var buttonNew = document.createElement('div');
			buttonNew.className = "pages_button";
			buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(pageNum-1)+')">&lsaquo;</a>';
			$(divNav).append(buttonNew);
			if(pageNum == 1)
				buttonNew.innerHTML = '&lsaquo;';
			
			var buttonNew = document.createElement('div');
			buttonNew.className = "pages_button";
			$(buttonNew).css({
				'margin' : '5px'
											
			});				
			buttonNew.innerHTML = '<input type="text" style="width:50px; text-align:center;" min="1" max="'+parseInt(totalPages) +'" name="pagesearch" id = "pagesearch" value="'+parseInt(pageNum)+'" onkeyup="isNumber(this);" onkeydown="javascript: if (event.keyCode == 13) gotoPage( $(this).val())" onblur="gotoPage( $(this).val())">';
			$(divNav).append(buttonNew);
			
			var buttonNew = document.createElement('div');
			buttonNew.className = "pages_button";
			buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(pageNum+1)+')">&rsaquo;</a>';
			$(divNav).append(buttonNew);
			if(pageNum == totalPages)
				buttonNew.innerHTML = '&rsaquo;';

			var buttonNew = document.createElement('div');
			buttonNew.className = "pages_button";
			buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(totalPages) +')">&raquo;</a>';
			$(divNav).append(buttonNew);
			if(pageNum == totalPages)
				buttonNew.innerHTML = '&raquo;';
			
			$(divNav).clone().appendTo(divNew); <!--- divNav'ın aynısından en alta da atıyorum, lazım olur. --->
			
			$("#report").append(divNew);
			
			<cfset jsonHead = SerializeJSON(ListToArray(arguments.listStruct.head))>
			<cfif left(jsonHead, 2) is "//"><cfset jsonHead = mid(jsonHead, 3, len(jsonHead) - 2)></cfif>
			<cfset jsonHead = URLEncodedFormat(jsonHead, "utf-8")>
			var jsonHead = $.evalJSON(decodeURIComponent("<cfoutput>#jsonHead#</cfoutput>"));
			
			var trNew = document.createElement('tr');
			trNew.id = 'head';
			for(j=0;j<jsonHead.length;j++) {
				var tdNew = document.createElement('td');
				tdNew.innerHTML = jsonHead[j];
				$(trNew).append(tdNew);
			}
			$(tableNew).append(trNew);
			
			for(i=parseInt(startRow);i<parseInt(maxRows);i++) <!--- SATIRLARI DÖNDÜRÜYORUM --->
			{
				var trNew = document.createElement('tr');
				trNew.id = 'rowNum'+parseInt(parseInt(i)+1);
				
				for(j=0;j<jsonData.COLUMNS.length;j++) <!--- KOLONLARI DÖNDÜRÜYORUM --->
				{
					var tdNew = document.createElement('td');
					
					tdNew.innerHTML = jsonData.DATA[i][j];
					$(trNew).append(tdNew);
				}
				$(tableNew).append(trNew);
			}

			$(divNew).append(tableNew);
			$(divNav).clone().appendTo(divNew);
		$("#reportBase").append(divNew);
		}
	</script>
    <cfreturn 1>
</cffunction>
<cfscript>
	param name = "attributes.keyword" default = "";
	param name = "attributes.search_company" default = "";
	param name = "attributes.search_year" default = "";
	param name = "attributes.process_stage_type" default = "";
	param name = "attributes.keyword" default = "";
	
	budget = createObject("component","budget.cfc.budget");
	budget.dsn = dsn;
	
	getAllBudgets = budget.getBudget(
		keyword : attributes.keyword,
		company : attributes.search_company,
		year : attributes.search_year,
		stage : attributes.process_stage_type
	);
	
	ourCompanies = budget.ourCompanies();
	years = budget.ourCompanies();
	stages = budget.stages();
	
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_budgets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_budgets.cfm';
	
	WOStruct['#attributes.fuseaction#']['view'] = structNew();
	WOStruct['#attributes.fuseaction#']['view']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['view']['fuseaction'] = 'budget.detail_budget';
	WOStruct['#attributes.fuseaction#']['view']['filePath'] = 'budget/display/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['view']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['view']['nextEvent'] = 'budget.detail_budget&event=view';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.popup_add_budget';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.detail_budget&event=add';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.popup_upd_budget';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/upd_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.popup_upd_budget&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'budget_id=##attributes.budget_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.budget_id##';
</cfscript>
