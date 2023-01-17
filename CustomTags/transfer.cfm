<cfinclude template="../JS/jqwidgets/specialLocalization.cfm">
<style>
	.red {
		background-color: red;
	}
</style>
<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="transfer_#round(rand()*10000000)#">
<cfparam name="attributes.columnList" default="">
<cfparam name="attributes.formAction" default="">
<cfparam name="attributes.requiredList" default="">
<cfparam name="attributes.numericList" default="">
<cfparam name="attributes.queryPath" default="">
<cfset columnLength = listlen(attributes.columnList,';')>

<cfset requiredInputsForSubmit = ''>
<cfloop index="index" from="1" to="#listlen(attributes.columnList,';')#">
	<cfif listGetAt(attributes.requiredList,index,',') eq 1>
    	<cfset requiredInputsForSubmit = listAppend(requiredInputsForSubmit,'column#index#',',')>
    </cfif>
</cfloop>

<cfif thisTag.executionMode eq "start">
     <script type="text/javascript">
		function createJQXSpreeadSheet(type,url) // type parametresi gelmiyorsa sayfaya dökülür. Geliyorsa csv import tıklanmıştır.
		{
			if(type)
			{
				$("div").remove( "#jqxgrid" );
				$('<div>').attr('id','jqxgrid').appendTo($('#jqxWidget'));
			}
				
			var columnList = '<cfoutput>#attributes.columnList#</cfoutput>';
			var columnLength = '<cfoutput>#columnLength#</cfoutput>';
			var requiredList = '<cfoutput>#attributes.requiredList#</cfoutput>';
			var numericList = '<cfoutput>#attributes.numericList#</cfoutput>';
			
			var numberrenderer = function (row, column, value) {
				return '<div style="text-align: center; margin-top: 5px;">' + (1 + value) + '</div>';
			}
			
			var highlightedRow = 1;
			
			
            var cellclass = function (row, columnfield, value) {
                var id = $('#jqxgrid').jqxGrid('getrowid', row);
                if (id == highlightedRow) {
                    return 'red';
                }
            }
					 
			// create Grid datafields and columns arrays.
			var datafields = [];
			var columns = [];
			for (var i = 1; i <= columnLength; i++)
			{
				if (i == 1) {
					var cssclass = 'jqx-widget-header';
					columns[columns.length] = {pinned: true, exportable: false, text: "", filterable:false, columntype: 'number', cellclassname: cssclass, cellsrenderer: numberrenderer };
					pinned = true;
				}
				else
					pinned = false;

				if(list_getat(requiredList,i,',') == 1)
					var cellclass = 'jqx-fill-state-normal';
				else
					var cellclass = '';
					
				if(list_getat(numericList,i,',') == 1)
				{
					filterType = 'number';
					filterColumnType = 'number';
				}
				else
				{
					filterType = 'string';
					filterColumnType = 'input';
				}
				
				datafields[datafields.length] = { name: 'column'+i, type:filterType};
				columns[columns.length] = { text: list_getat(columnList,i,';'),pinned:pinned,filtertype:filterColumnType,columntype: 'textbox', datafield: 'column'+i, width: 100, cellclassname: cellclass, align: 'center' };
			}
			
			if(!type)
			{
				var source =
				{
					unboundmode: true,
					totalrecords: 10,
					datafields: datafields
				};
			}
			else
			{
				var source =
				{
					datatype: "csv",
					unboundmode: true,
					totalrecords: 10,
					datafields: datafields,
					url: url
				};
			}

			var dataAdapter = new $.jqx.dataAdapter(source);

			$("#jqxgrid").jqxGrid(
			{
				width: 1000,
                height: 500,
				pageable:true,
				source: dataAdapter,
				pagesizeoptions: ['10', '20', '30', '40', '50','100','250'],
				autoheight: true,
				altrows: true,
				enabletooltips: true,
				editable: true,
				selectionmode: 'multiplecellsextended',
				columnsresize: true,
				columns: columns,
				enabletooltips: true,
				filterable:true,
				showfilterrow: true,
				ready: function()
				{
                   $("#jqxgrid").jqxGrid('localizestrings', localizationobj);
                }
				,showtoolbar : true
				,rendertoolbar: function (toolbar) {
					var me = this;
					toolbar.html('');
					var container = $("<a id='jqxgridaddRow' href='javascript://' style='margin: 5px; float:right'><i class='icon-pluss fa-2x'></i></a>");
					toolbar.append(container);
					$("#jqxgridaddRow").click(function () {
						$("#jqxgrid").jqxGrid("addrow", null, {}, "last");
						$("#jqxgridaddRow").attr('disable','disable');
						
						// Son sayfaya gitmek için eklendi.
						var rows = $('#jqxgrid').jqxGrid('getrows');
						pageSize = $('#jqxgrid').jqxGrid('getpaginginformation').pagesize;
						$('#jqxgrid').jqxGrid('gotopage', Math.ceil(parseFloat(rows.length-1)/pageSize));
					});
				}
			});
		}
         $(document).ready(function () {			 
			 createJQXSpreeadSheet();
		 });

		function getAllData()
		{
			$(document).ready(function () {

				get_wrk_message_div("<cfoutput>#caller.getLang('main',1932)#</cfoutput>","<cfoutput>#caller.getLang('main',1933)#</cfoutput>");<!--- İşleminiz yapılıyor lütfen bekleyiniz --->
				formDataString = '';
				$("#formElem").find("input,select,textarea").each(function(index,element)
				{
					if($(element).is("input") && $(element).attr("type") == "checkbox")
					{
						if($(element).is(":checked")) 
						{
							if(formDataString.length>0)
								formDataString = formDataString + ',"'+$(element).attr("name")+'":"1"';
							else
								formDataString = formDataString + ',"'+$(element).attr("name")+'":"1"';
						}
					}
					else if($(element).is("input") && $(element).attr("type") == "radio")
					{
						if ($(element).is(":checked")) 
						{
							if(formDataString.length>0)
								formDataString = formDataString + ',"'+$(element).attr("name")+'":"'+$(element).val()+'"';
							else
								formDataString = formDataString + '"'+$(element).attr("name")+'":"'+$(element).val()+'"';
						}
					}
					else
					{
						if($(element).attr('type') != 'file')
						{
							if(formDataString.length>0)
								formDataString = formDataString + ',"'+$(element).attr("name")+'":"'+$(element).val()+'"';
							else
								formDataString = formDataString + '"'+$(element).attr("name")+'":"'+$(element).val()+'"';
						}
					}
				})
				//console.log(formDataString);
                callTransferURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_transferConverter&ajax=1&xmlhttp=1&_cf_nodebug=true&type=1</cfoutput>",handlerTransferPostForSubmit,{ formElements: encodeURIComponent('{<cfoutput>"queryPath":"#attributes.queryPath#","requiredInputsForSubmit":"#requiredInputsForSubmit#","columnCount":"#columnLength#"</cfoutput>,"columns":'+$.toJSON($('#jqxgrid').jqxGrid('getrows'))+','+formDataString+'}') });
				})
		}
		function csvImportFunc(type,url)
		{
			if(!url)
				url = 'eminImport.txt';
			if(!type)
				createJQXSpreeadSheet(1,url);
			else if (type == 2)
				createJQXSpreeadSheet(1,url);
			else
				createJQXSpreeadSheet();
		}
		
		function callTransferURL(url, callback, data, target, async)
		{   
			var method = (data != null) ? "POST": "GET";
			if(url.indexOf("type=0") != -1)
			{
				$.ajax( {
						url: url,
						type: method,
						data: data,
						processData: false,
						contentType: false,
						success: function(responseData, status, jqXHR)
						{ 
							callback(target, responseData, status, jqXHR); 
						}
					} );
			}
			else
			{
				$.ajax({
					async: async != null ? async: true,
					url: url,
					type: method,
					data: data,
					success: function(responseData, status, jqXHR)
					{ 
						callback(target, responseData, status, jqXHR); 
					}
				});
			}
		}
		
		function handlerTransferPostForSubmit(target, responseData, status, jqXHR){
			responseData = $.trim(responseData);
		
			if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
		
			ajax_request_script(responseData);
			
			var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
			while (SCRIPT_REGEX.test(responseData)) {
				responseData = responseData.replace(SCRIPT_REGEX, "");
			}
			responseData = responseData.replace(/<!-- sil -->/g, '');
			responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
		}
    </script>
    
    <div id='jqxWidget'>
        <div id="jqxgrid"></div>
    </div>   
</cfif>