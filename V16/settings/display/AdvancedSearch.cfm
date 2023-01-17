<cfset DatabaseInfo = CreateObject("component","Utility.DatabaseInfo")>
<cfif isdefined("attributes.type") and attributes.type is 'list'>
	<cfscript>
        column_info = DatabaseInfo.ColumnInfo(
            table_name:'#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#',
			schema_name:'#iif(isdefined("attributes.schema_name"),"attributes.schema_name",DE(""))#'
		);
		table_count = DatabaseInfo.GetCount(
			schema_name: '#iif(isDefined("attributes.schema_name"), "attributes.schema_name", DE(""))#',
			table_name: '#iif(isDefined("attributes.table_name"), "attributes.table_name", DE(""))#'
		);
	</cfscript>
	<cf_box>
		<cf_box_elements>
			<cfoutput>
				<div class="form-group col col-10 col-md-10 col-sm-10 col-xs-12">
					<label class="col col-xs-12"><b><cf_get_lang dictionary_id='33591.Schema'> : </b>#attributes.schema_name# </label>
					<label class="col col-xs-12"><b><cf_get_lang dictionary_id='38752.Table'> : </b>#attributes.table_name#</label>
					<label class="col col-xs-12"><b><cf_get_lang dictionary_id='55072.Total Count'> :</b> #table_count#</label>
				</div>
				<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12 flex-end">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="AjaxPageLoad('#request.self#?fuseaction=settings.emptypopup_AdvancedSearch&type=query&play=SELECT * FROM #attributes.schema_name#.#attributes.table_name#','table_info',1);" title="<cf_get_lang dictionary_id='57911.Çalıştır'>"><i class="fa fa-database"></i></a>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<a class="ui-btn ui-btn-gray" href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=settings.emptypopup_AdvancedSearch&type=script&table=#attributes.schema_name#.#attributes.table_name#', 'table_info', 1);" title="<cf_get_lang dictionary_id='29742.Export'>"><i class="fa fa-download"></i></a> 
					</div>
				</div>
			</cfoutput>
		</cf_box_elements>
		<cf_grid_list id="myTable">	
			<thead>
				<tr>
					<th width="20"><a  href="javascript://"  onclick="DatabaseAddColumn()"><i class="fa fa-plus"></i></a></th>
					<th><cf_get_lang dictionary_id='57631.Name'></th>
					<th><cf_get_lang dictionary_id='36197.Data Type'></th>
					<th><cf_get_lang dictionary_id='45841.Data Length'></th>
					<th><cf_get_lang dictionary_id='36199.Description'></th>
					<th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
					<th width="20"><a href="javascript:void(0)"><i class="fa fa-minus"></i></a></th>
					<th width="20"><a href="javascript:void(0)"><i class="fa fa-connectdevelop"></i></a></th>
				</tr>
			</thead>
			<tbody id="mytbody">
				<cfoutput query="column_info">
					<tr>
						<td style="text-align:center;">#Currentrow#</td>
						<td>
							<cfif isdefined("attributes.column_field")>
								<a href="javascript://" onclick="addColumn('#attributes.table_name#','#column_name#')">#column_name#</a>
							<cfelse>                                    
								#column_name#
							</cfif>
						</td>
						<td>
							<select name="data_type_#Currentrow#" id="data_type_#Currentrow#" onchange="$(this).parent().next().find('input').toggle(hasLength($(this).val()))" style="width:100%">
								<option value="bigint" <cfif data_type eq "bigint">selected</cfif>>BIGINT</option>
								<option value="numeric" <cfif data_type eq "numeric">selected</cfif>>NUMERIC</option>
								<option value="bit" <cfif data_type eq "bit">selected</cfif>>BIT</option>
								<option value="smallint" <cfif data_type eq "smallint">selected</cfif>>SMALLINT</option>
								<option value="decimal" <cfif data_type eq "decimal">selected</cfif>>DECIMAL</option>
								<option value="smallmoney" <cfif data_type eq "smallmoney">selected</cfif>>SMALLMONEY</option>
								<option value="int" <cfif data_type eq "int">selected</cfif>>INT</option>
								<option value="tinyint" <cfif data_type eq "tinyint">selected</cfif>>TINYINT</option>
								<option value="money" <cfif data_type eq "money">selected</cfif>>MONEY</option>
								<option value="float" <cfif data_type eq "float">selected</cfif>>FLOAT</option>
								<option value="real" <cfif data_type eq "real">selected</cfif>>REAL</option>
								<option value="date" <cfif data_type eq "date">selected</cfif>>DATE</option>
								<option value="datetime" <cfif data_type eq "datetime">selected</cfif>>DATETIME</option>
								<option value="datetime2" <cfif data_type eq "datetime2">selected</cfif>>DATETIME2</option>
								<option value="datetimeoffset" <cfif data_type eq "datetimeoffset">selected</cfif>>DATETIMEOFFSET</option>
								<option value="smalldatetime" <cfif data_type eq "smalldatetime">selected</cfif>>SMALLDATETIME</option>
								<option value="time" <cfif data_type eq "time">selected</cfif>>TIME</option>
								<option value="char" <cfif data_type eq "char">selected</cfif>>CHAR</option>
								<option value="varchar" <cfif data_type eq "varchar">selected</cfif>>VARCHAR</option>
								<option value="text" <cfif data_type eq "text">selected</cfif>>TEXT</option>
								<option value="nchar" <cfif data_type eq "nchar">selected</cfif>>NCHAR</option>
								<option value="nvarchar" <cfif data_type eq "nvarchar">selected</cfif>>NVARCHAR</option>
								<option value="ntext" <cfif data_type eq "ntext">selected</cfif>>NTEXT</option>
								<option value="binary" <cfif data_type eq "binary">selected</cfif>>BINARY</option>
								<option value="rowversion" <cfif data_type eq "rowversion">selected</cfif>>ROWVERSION</option>
								<option value="uniqueidentifier" <cfif data_type eq "uniqueidentifier">selected</cfif>>UNIQUEIDENTIFIER</option>
							</select>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="max_length_#Currentrow#" id="max_length_#Currentrow#" value="#maximum_length#" placeHolder="<cf_get_lang dictionary_id='45841.Data Length'>" style="<cfif listFindNoCase('char,varchar,nchar,nvarchar,binary,varbinary',data_type,',')><cfelse>display:none</cfif>" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="description_tr_#Currentrow#" id="description_tr_#Currentrow#" value="#description_tr#" placeHolder="<cf_get_lang dictionary_id='36199.Description'>" />
							</div>
						</td>
						<!---<cfif session.ep.admin>--->
						<td><a href="javascript:void(0)" onclick="UpdColumn('#Currentrow#','#column_name#','#attributes.table_name#','#attributes.schema_name#','#data_type#')"><i class="fa fa-pencil"></i></a></td>
						<td><a href="javascript:void(0)" onclick="DropColumn('#column_name#','#attributes.table_name#','#attributes.schema_name#')" value="Delete" ><i class="fa fa-minus"></i></a></td>
						<td>
							<a href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=settings.popup_classification&table=#attributes.schema_name#.#attributes.table_name#.#column_name#&draggable=1');"><i class="fa fa-connectdevelop"></i></a>
						</td>
						<!---</cfif>--->
					</tr>
				</cfoutput>
				<cfoutput><input type="hidden" name="sayac_kontrol" id="sayac_kontrol" value="#column_info.recordcount#" /></cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
	<script type="text/javascript">
		$('#myTable').on('click', 'a[data-type="delete"]', function () {
			$(this).closest('tr').remove();
		})

		<cfif isdefined("attributes.column_field")>
			function addColumn(tableName,columnName)
			{
				window.opener.<cfoutput>#attributes.column_field#</cfoutput>.value = tableName + '.' + columnName;
				window.close();
			}
		</cfif>

		function DatabaseAddColumn ()
		{
				 var crrow = parseFloat(document.getElementById('sayac_kontrol').value) + 1 ;
				  document.getElementById('sayac_kontrol').value = crrow;
				//   $('#mytbody').append('<tr><td></td><td><input type="text" name="colum_name_'+crrow+'" id="colum_name_'+crrow+'" Placeholder="Column Name" /></td><td><select name="data_type_' + crrow + '" id="data_type_' + crrow + '" onchange="$(this).parent().next().find(\'input\').toggle(hasLength($(this).val()))"><option value="bigint">BIGINT</option><option value="numeric">NUMERIC</option><option value="bit">BIT</option><option value="smallint">SMALLINT</option><option value="decimal">DECIMAL</option><option value="smallmoney">SMALLMONEY</option><option value="int">INT</option><option value="tinyint">TINYINT</option><option value="money">MONEY</option><option value="float">FLOAT</option><option value="real">REAL</option><option value="date">DATE</option><option value="datetime">DATETIME</option><option value="datetime2">DATETIME2</option><option value="datetimeoffset">DATETIMEOFFSET</option><option value="smalldatetime">SMALLDATETIME</option><option value="time">TIME</option><option value="char">CHAR</option><option value="varchar">VARCHAR</option><option value="text">TEXT</option><option value="nchar">NCHAR</option><option value="nvarchar">NVARCHAR</option><option value="ntext">NTEXT</option><option value="binary">BINARY</option><option value="rowversion">ROWVERSION</option><option value="uniqueidentifier">UNIQUEIDENTIFIER</option></select></td><td><input type="text" name="max_len_'+crrow+'" id="max_len_'+crrow+'" Placeholder="Data Length" style="display: none;" /></td><td><input type="text" name="description_tr_'+crrow+'" placeholder="Column Description" id="description_tr_'+crrow+'" value=""/></td><td><cfif session.ep.admin><a href="javascript:void(0);" onclick="SaveColumn('+crrow+')" /><i class="fa fa-save"></i></a> <a href="javascript:void(0)" data-type="delete" value="Delete"><i class="fa fa-trash"></i></a></cfif></td></tr>');
				  $('#mytbody').append('<tr><td></td><td><div class="form-group"><input type="text" name="colum_name_'+crrow+'" id="colum_name_'+crrow+'" Placeholder="Name" /></div></td><td><select name="data_type_' + crrow + '" id="data_type_' + crrow + '" onchange="$(this).parent().next().find(\'input\').toggle(hasLength($(this).val()))" style="width:100%"><option value="bigint">BIGINT</option><option value="numeric">NUMERIC</option><option value="bit">BIT</option><option value="smallint">SMALLINT</option><option value="decimal">DECIMAL</option><option value="smallmoney">SMALLMONEY</option><option value="int">INT</option><option value="tinyint">TINYINT</option><option value="money">MONEY</option><option value="float">FLOAT</option><option value="real">REAL</option><option value="date">DATE</option><option value="datetime">DATETIME</option><option value="datetime2">DATETIME2</option><option value="datetimeoffset">DATETIMEOFFSET</option><option value="smalldatetime">SMALLDATETIME</option><option value="time">TIME</option><option value="char">CHAR</option><option value="varchar">VARCHAR</option><option value="text">TEXT</option><option value="nchar">NCHAR</option><option value="nvarchar">NVARCHAR</option><option value="ntext">NTEXT</option><option value="binary">BINARY</option><option value="rowversion">ROWVERSION</option><option value="uniqueidentifier">UNIQUEIDENTIFIER</option></select></td><td><div class="form-group"><input type="text" name="max_len_'+crrow+'" id="max_len_'+crrow+'" Placeholder="Data Length" style="display: none;" /></div></td><td><div class="form-group"><input type="text" name="description_tr_'+crrow+'" placeholder="Description" id="description_tr_'+crrow+'" value=""/></div></td><td><a href="javascript:void(0)" onclick="SaveColumn('+crrow+')" value="Delete" ><i class="fa fa-pencil"></i></a></td><td><a href="javascript:void(0)" data-type="delete" value="Delete" ><i class="fa fa-minus"></i></a></td><td></td></tr>');
		}

		function hasLength(val) {
			return ['char', 'varchar', 'nchar', 'nvarchar', 'binary', 'varbinary'].indexOf(val) >= 0;
		}

		function SaveColumn(crntrow)
		{
			if (confirm("Are you sure you want to save?") == false) 
			{
         		return;
     		}
			var data = {};
			data["column_name"] =  document.getElementById('colum_name_'+crntrow).value;
			data["data_type"] = document.getElementById('data_type_'+crntrow).value;

			data["max_len"] = document.getElementById('max_len_'+crntrow).value;
			data["description_tr"] = document.getElementById('description_tr_'+crntrow).value;
			data["table_name"] = '<cfoutput>#attributes.table_name#</cfoutput>';
			data["schema_name"] = '<cfoutput>#attributes.schema_name#</cfoutput>';
			
			if(data["column_name"]==='')
			{
				alert("Please fill in the Column Name field");
				return;
			}

			if(data["data_type"]==='')
			{
				alert("Please fill in the Data Type field");
				return;
			}

			if(hasLength(data["data_type"]))
			{
				if(data["max_len"]==='')
				{
					alert("Please fill in the Data Length field");
					return;
				}
			}

			 $.ajax(
        				{
							type: "get",
							url: "/Utility/DatabaseInfo.cfc?method=SaveColumn",
							data: data,
							datatype :"json",
							contentType: "application/json",
            				success: function( objResponse )
							{
								var result=JSON.parse(objResponse);
								if(result.SUCCESS)
								{
									// alert("<cf_get_lang dictionary_id='59069.Tablo Başarıyla Güncellendi'>");
									AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name='+data["schema_name"]+'&table_name='+data["table_name"]+'&type=list','table_info',1);
								}
								else
								{
									alert("There was an error while saving.");
								}
           				 	},
							error: function() 
							{
								alert('Error occured');
							}
        				}
        			);

		}
	
		function UpdColumn (crrow,column_name,table_name,schema_name, data_type)
		{
			if (confirm("Are you sure you want to save?") == false) 
			{
         		return;
     		}
			if(hasLength($("#data_type_"+crrow).val()))
			{
				if($("#max_length_"+crrow).val()=='')
				{
					alert("Please fill in the Data Length field");
					return;
				}
			}
			var data = {};
			data["column_name"] = column_name;
			data["table_name"] = table_name;
			data["schema_name"] = schema_name;
			data["data_type"] = $("#data_type_"+crrow).val();
			if(hasLength($("#data_type_"+crrow).val()))
				data["max_length"] = document.getElementById('max_length_'+crrow).value;
			else
				data["max_length"] = '';
			data["description_tr"] = document.getElementById('description_tr_'+crrow).value;
			console.log(data);
			 $.ajax(
        				{
							type: "get",
							url: "/Utility/DatabaseInfo.cfc?method=UpdColumn",
							data: data,
							datatype :"json",
            				success: function( objResponse )
							{
								AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name='+data["schema_name"]+'&table_name='+data["table_name"]+'&type=list&max_length='+data["max_length"],'table_info',1);
           				 	},
							error: function() 
							{
								alert('Error occured');
							}
        				}
        			);
		}
		function DropColumn (column_name,table_name,schema_name)
		{
			if (confirm("You are deleting the column. Are you sure?") == false) 
			{
         		return;
     		}
			var data = {};
			data["column_name"] = column_name;
			data["table_name"] = table_name;
			data["schema_name"] = schema_name;

			 $.ajax(
        				{
							type: "get",
							url: "/Utility/DatabaseInfo.cfc?method=DropColumn",
							data: data,
							datatype :"json",
            				success: function( objResponse )
							{
								AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name='+data["schema_name"]+'&table_name='+data["table_name"]+'&type=list&max_length='+data["max_length"],'table_info',1);
           				 	},
							error: function() 
							{
								alert('Error occured');
							}
        				}
        			);
		}
	</script>
	
<cfelseif isdefined("attributes.type") and attributes.type is 'add' >
	<script type="text/javascript">
		$('#myTable').on('click', 'a[data-type="delete"]', function () {
			$(this).closest('tr').remove();
		})
		$('p input.add-line').click(function () {
			
			 var crrow = parseFloat(document.getElementById('sayac_kontrol').value) + 1 ;
			 document.getElementById('sayac_kontrol').value = crrow;
			 $('#myTable').append('<tr id="myTableRow'+crrow+'"><td><input type="text" name="colum_name_' + crrow + '" id="colum_name_' + crrow + '" Placeholder="Name" /></td><td><select name="data_type_' + crrow + '" id="data_type_' + crrow + '" onchange="$(this).parent().next().find(\'input\').toggle(hasLength($(this).val()))" style="width:100%"><option value="bigint">BIGINT</option><option value="numeric">NUMERIC</option><option value="bit">BIT</option><option value="smallint">SMALLINT</option><option value="decimal">DECIMAL</option><option value="smallmoney">SMALLMONEY</option><option value="int">INT</option><option value="tinyint">TINYINT</option><option value="money">MONEY</option><option value="float">FLOAT</option><option value="real">REAL</option><option value="date">DATE</option><option value="datetime">DATETIME</option><option value="datetime2">DATETIME2</option><option value="datetimeoffset">DATETIMEOFFSET</option><option value="smalldatetime">SMALLDATETIME</option><option value="time">TIME</option><option value="char">CHAR</option><option value="varchar">VARCHAR</option><option value="text">TEXT</option><option value="nchar">NCHAR</option><option value="nvarchar">NVARCHAR</option><option value="ntext">NTEXT</option><option value="binary">BINARY</option><option value="rowversion">ROWVERSION</option><option value="uniqueidentifier">UNIQUEIDENTIFIER</option></select></td><td><input type="text" name="max_len_' + crrow + '" id="max_len_' + crrow + '" Placeholder="Data Length" style="display: none;" /></td><td><input type="radio" name="primary_key" value="1">PK</td><td><input type="checkbox" name="auto_increment_' + crrow + '" value="1">AI</td><td><input type="text" name="description_tr_' + crrow + '" id="description_tr_' + crrow + '" value="" placeholder="Description"/></td><td><input type="button" value="Delete" onclick="deleteLine(\'myTableRow'+crrow+'\');" /></td></tr>');
		});

		var addRowNum=1;

		function addline()
		{
			var crrow = parseFloat(document.getElementById('sayac_kontrol').value) + 1 ;
			 document.getElementById('sayac_kontrol').value = crrow;
			 $('#myTable').append('<tr id="myTableRow'+crrow+'"><td style="text-align:center">'+crrow+'</td><td><div class="form-group"><input type="text" name="colum_name_' + crrow + '" id="colum_name_' + crrow + '" Placeholder="Name" /></div></td><td><select name="data_type_' + crrow + '" id="data_type_' + crrow + '" onchange="$(this).parent().next().find(\'input\').toggle(hasLength($(this).val()))" style="width:100%"><option value="bigint">BIGINT</option><option value="numeric">NUMERIC</option><option value="bit">BIT</option><option value="smallint">SMALLINT</option><option value="decimal">DECIMAL</option><option value="smallmoney">SMALLMONEY</option><option value="int">INT</option><option value="tinyint">TINYINT</option><option value="money">MONEY</option><option value="float">FLOAT</option><option value="real">REAL</option><option value="date">DATE</option><option value="datetime">DATETIME</option><option value="datetime2">DATETIME2</option><option value="datetimeoffset">DATETIMEOFFSET</option><option value="smalldatetime">SMALLDATETIME</option><option value="time">TIME</option><option value="char">CHAR</option><option value="varchar">VARCHAR</option><option value="text">TEXT</option><option value="nchar">NCHAR</option><option value="nvarchar">NVARCHAR</option><option value="ntext">NTEXT</option><option value="binary">BINARY</option><option value="rowversion">ROWVERSION</option><option value="uniqueidentifier">UNIQUEIDENTIFIER</option></select></td><td><div class="form-group"><input type="text" name="max_len_' + crrow + '" id="max_len_' + crrow + '" Placeholder="Data Length" style="display: none;" /></div></td><td><div class="form-group"><input type="radio" name="primary_key" value="1">PK</div></td><td><div class="form-group"><input type="checkbox" name="auto_increment_' + crrow + '" value="1">AI</div></td><td><div class="form-group"><input type="text" name="description_tr_' + crrow + '" id="description_tr_' + crrow + '" value="" placeholder="Description"/></div></td><td><a href="javascript:void(0)" onclick="deleteLine(\'myTableRow'+crrow+'\');" value="Delete" ><i class="fa fa-minus"></i></a></td></tr>');
		}

		function hasLength(val) {
			return ['char', 'varchar', 'nchar', 'nvarchar', 'binary', 'varbinary'].indexOf(val) >= 0;
		}


		function deleteLine(rowId)
		{
			$('#'+rowId).remove();
		}

		
	</script>
    <form name="theForm" id="theForm">
	<input type="hidden" name="sayac_kontrol" id="sayac_kontrol" value="1" />
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='57516.Tablo Ekle'>
	</cfsavecontent>
	<cf_box title="#head#">
			<cf_box_elements vertical="1">
				<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
					<!--- <label>Schema</label> --->
					<cfset schema_info = DatabaseInfo.SchemaInfo()>
					<select id="schema" name="schema" class="input-group-addon">
						<option value><cf_get_lang dictionary_id='33591.Schema'></option>
						<cfoutput query="schema_info">
							<option>#SCHEMA_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
					<!--- <label>Table</label> --->
					<input type="text" name="table_name" id="table_name" placeholder="<cf_get_lang dictionary_id='36201.Table Name'>" />
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
					<!--- <label>Description</label> --->
					<input type="text" name="table_desc" id="table_desc" placeholder="<cf_get_lang dictionary_id='33590.Table Description'>" />
				</div>
			</cf_box_elements>	
		<!---
		<p style="margin: 6px 0;">
			<input type="button" value="<cf_get_lang dictionary_id='59072.Add Field'>" class="add-line">
		</p>
		--->
				<cf_grid_list id="myTable" >
					<thead>
						<tr>
							<th><a  href="javascript://"  onclick="addline()"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='57631.Name'></th>
							<th><cf_get_lang dictionary_id='36197.Data Type'></th>
							<th><cf_get_lang dictionary_id='45841.Data Length'></th>
							<th colspan="2"><cf_get_lang dictionary_id='59106.Properties'></th>
							<th><cf_get_lang dictionary_id='36199.Description'></th>
							<th style="text-align:center;">#</th>
						</tr>
					</thead>
					<tbody id="mytbody">
					<tr id="trRow1">
						<td style="text-align:center;">1</td>
						<td>
							<div class="form-group">
								<input type="text" name="colum_name_1" id="colum_name_1" Placeholder="<cf_get_lang dictionary_id='57631.Name'>" />
							</div>
						</td>
						<td>
								<select name="data_type_1" id="data_type_1" onchange="$(this).parent().next().find('input').toggle(hasLength($(this).val()))" style="width:100%">
									<option value="bigint">BIGINT</option>
									<option value="numeric">NUMERIC</option>
									<option value="bit">BIT</option>
									<option value="smallint">SMALLINT</option>
									<option value="decimal">DECIMAL</option>
									<option value="smallmoney">SMALLMONEY</option>
									<option value="int">INT</option>
									<option value="tinyint">TINYINT</option>
									<option value="money">MONEY</option>
									<option value="float">FLOAT</option>
									<option value="real">REAL</option>
									<option value="date">DATE</option>
									<option value="datetime">DATETIME</option>
									<option value="datetime2">DATETIME2</option>
									<option value="datetimeoffset">DATETIMEOFFSET</option>
									<option value="smalldatetime">SMALLDATETIME</option>
									<option value="time">TIME</option>
									<option value="char">CHAR</option>
									<option value="varchar">VARCHAR</option>
									<option value="text">TEXT</option>
									<option value="nchar">NCHAR</option>
									<option value="nvarchar">NVARCHAR</option>
									<option value="ntext">NTEXT</option>
									<option value="binary">BINARY</option>
									<option value="rowversion">ROWVERSION</option>
									<option value="uniqueidentifier">UNIQUEIDENTIFIER</option>
								</select>
						</td>
						<td>
							<div class="form-group">
								<input type="text"  name="max_len_1" id="max_len_1" Placeholder="<cf_get_lang dictionary_id='45841.Data Length'>" style="display: none;" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="radio" name="primary_key" value="1">PK
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="checkbox" name="auto_increment_1" value="1">AI
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="description_tr_1" id="description_tr_1" value="" placeholder="<cf_get_lang dictionary_id='36199.Description'>"/>
							</div>
						</td>
						<td>
							<a href="javascript:void(0)" onclick="deleteLine('trRow1');" value="Delete" ><i class="fa fa-minus"></i></a>
							<!--- <input type="button" value="<cf_get_lang dictionary_id='59075.Delete'>" onclick="deleteLine('trRow1');" /> --->
						</td>
					</tr>
					</tbody>
				</cf_grid_list>
			
			<div class="ui-info-bottom flex-end">
				<a class="ui-btn ui-btn-success" href="javascript://" onClick="Send_data();"><cf_get_lang dictionary_id='59076.Create Table'></a>
			</div>
		</cf_box>
    </form>
	
<script type="text/javascript">
		
function Send_data()
{		
	if (confirm("You are creating a table. Are you sure?") == false) {
         return;
     }

	if ($("#table_name").val()==="") {
		alert("Table Name cannot be empty.");
		return;
	}

	var data = {},
	formElements = $('form[name="theForm"]').find('input, select:visible, textarea:visible');
	
	if(formElements.length<=6)
	{
		alert("Please add at least one column.");
		return;
	}

	var sayac=0;
	var pk = null;
	var BreakException = {};
	$.each(formElements,function(){
		
		var attr = $(this).attr('id') || $(this).attr('name'),
			tagName = $(this).prop('tagName').toLowerCase(),
			val;
			
		if (tagName === 'select' ){
			val = $(this).find('option:selected').val();
		} else {
			val = $(this).val();	
			var nameValue=$(this).prop('name').toString();
			if($(this).prop('name').includes('colum_name'))
			{
				if(val==="")
				{
					alert("Column Name cannot be empty.");
					throw BreakException;
				}	
				sayac=sayac+1;
			}
				
			if ($(this).prop('type').toLowerCase() === 'checkbox'){
				val = $(this).prop('checked') ? 1 : 0;
			} else if ($(this).prop('type').toLowerCase() === 'radio') {
				// pk = $(this).prop('checked') ? val : pk;
				pk = $(this).prop('checked') ? 1 : 0;
				data['primary_key_'+sayac]=pk;
				return;
			}
		}

		if($(this).prop('name').includes('max_len'))
		{
			if($(this).prop('style').display!=="none")
			{
				if ($(this).val()==="") {
					alert("Column Length cannot be empty.");
					throw BreakException;
				}
			}	
		}
			
		data[attr] = val;
		
	});
	// if (pk !== null) {
	// 	data['primary_key'] = pk;
	// }

	data['sayac_kontrol'] = sayac;
		console.log(data);
	$.ajax(
		{
			type: "get",
			url: "/Utility/DatabaseInfo.cfc?method=Add",
			data: data,
			dataType: "json",
			success: function( objResponse )
			{
				if (objResponse.SUCCESS)
				{
					alert("Table created successfully.");
					AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name='+data["schema"]+'&table_name='+data["table_name"]+'&type=list','table_info',1);
					// consol.log(objResponse)
				} 
				else 
				{
					alert("Error creating table.");
					// consol.log(objResponse.ERRORS)
				}
			}
		}
	);
}
</script>

<cfelseif isDefined("attributes.type") and attributes.type is 'query'>
	<cfsavecontent  variable="message"><cf_get_lang dictionary_id='59083.Query'></cfsavecontent>
	<cf_box title="#message#" closable="0">
		<div id="codeeditor" style="height: 350px;"></div>
		<div class="ui-info-bottom flex-end">
			<a href="javascript://" onclick="send_query()" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57911.Run'></a>
		</div>
	</cf_box>
	<cfsavecontent  variable="message"><cf_get_lang dictionary_id='59085.Result'></cfsavecontent>
	<cf_box title="#message#" closable="0" uidrop="1" hide_table_column="1" id="query_result"></cf_box>

<script type="text/javascript">
	var aceEditor = ace.edit("codeeditor");
	aceEditor.setTheme("ace/theme/sqlserver");
	aceEditor.session.setMode("ace/mode/sql");
	aceEditor.setFontSize(14);
	aceEditor.session.setUseWrapMode(true);
	<cfif isDefined("attributes.play")>
	aceEditor.setValue('<cfoutput>#attributes.play#</cfoutput>');
	</cfif>

	/*BOX ikonları için eklendi*/

	$('.portHeadLightMenu > ul > li > a').click(function(){
		$('.portHeadLightMenu > ul > li > ul').stop().fadeOut();
		var clas = $(this).parent().find('> ul').attr("class");
		//alert(id);
		if(clas != "table_list_container"){
			if($(this).parent().find('> ul li').length){
				if($(this).parent().find('> ul').css("display") == "block"){
					$(this).parent().find("> ul").stop().fadeOut();
				}
				else{
					$(this).parent().find("> ul").stop().fadeIn();
				}
			}
		}
		else{
			$(this).parent().find("> ul").stop().fadeToggle();
		}
	});

	function send_query() {
		$.ajax(
			{
				type: "post",
				url: "/Utility/DatabaseInfo.cfc?method=Query",
				data: { q: aceEditor.getValue() },
				dataType: "json",
				success: function (objResponse) {
					$("#body_query_result").html(objResponse.responseText);
				},
				error: function (objResponse) {
					$("#body_query_result").html(objResponse.responseText);
				}
			}
		);
	}

	function sendToDBManager( tableSchema, tableName, ColumnName ){
		if(document.querySelectorAll('.primary_column_id:checked').length > 0){

			let uniqueId = [];
			document.querySelectorAll('.primary_column_id:checked').forEach(element => { uniqueId.push(element.value) });

			AjaxPageLoad('index.cfm?fuseaction=settings.emptypopup_AdvancedSearch&type=script&table=' + tableSchema + '.' + tableName + '&condition=' + ColumnName + ' IN('+uniqueId.join(',')+')' , 'table_info', 1);

		}else alert("Please select minimum 1 row");
	}

</script>

<style>
#codeeditor div:after, #codeeditor div:before, .ace_editor .row:after, .ace_editor .row:before, .ace_editor .form-group:after, .ace_editor .form-group:before, .ace_editor div:after, .ace_editor div:before {
	display: none !important;
}
.ace_editor, .ace_editor div {
	font: 12px/normal 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'source-code-pro', monospace !important;
}
</style>

<cfelseif isDefined("attributes.type") and attributes.type is 'script'>
	<form id="formScript" name="formScript" method="POST" >
		<cfsavecontent variable="head"><cf_get_lang dictionary_id='60855.Data Script Export'></cfsavecontent>
		<cf_box title="#head#">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-xs-12">Table Name</label>
						<div class="col col-8 col-xs-12">
							<cfoutput>
								<input type="hidden" name="table" id="table" value="#attributes.table#">
								#attributes.table#
							</cfoutput>
						</div>
					</div>
					<cfif isDefined("attributes.condition")>
						<div class="form-group">
							<label class="col col-4 col-xs-12">Condition</label>
							<div class="col col-8 col-xs-12">
								<cfoutput><textarea name="condition" id="condition">#attributes.condition#</textarea></cfoutput>
							</div>
						</div>
					</cfif>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Best Practise</label>
						<div class="col col-8 col-xs-12">
							<cfquery name="query_bp" datasource="#dsn#">
								SELECT * FROM WRK_BESTPRACTICE
							</cfquery>
							<select name="bestpractice" id="bestpractice">
								<cfoutput query="query_bp">
								<option value="#BESTPRACTICE_ID#">#BESTPRACTICE_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Type*</label>
						<div class="col col-8 col-xs-12">
							<select name="datatype" id="datatype">
								<option value="">Choose</option>
								<option value="dictionary">Dictionary</option>
								<option value="extension">Extension</option>
								<option value="implementation_step">Implementation Step</option>
								<option value="master_data">Master Data</option>
								<option value="menu">Menu</option>
								<option value="module">Module</option>
								<option value="output_template">Output Template</option>
								<option value="page_designer">Page Designer</option>
								<option value="params">Param</option>
								<option value="process_cat">Process Cat</option>
								<option value="process_stage">Process Stage</option>
								<option value="process_template">Process Template</option>
								<option value="wex">Wex</option>
								<option value="widget">Widget</option>
								<option value="wo">Wo</option>
								<option value="xml_setup">Xml Setup</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Head*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="head" id="head" oninput="controlText(this);">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Detail*</label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail" rows="6"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Create Date*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="create_date" type="text" id="create_date">
								<span class="input-group-addon">
									<i class="icon-calendar-o" id="create_date_image" alt="<cf_get_lang dictionary_id='57742.Tarih'>"></i>
								
									<script type="text/javascript" language="JavaScript">
										
										function close_wrk_d_image_create_date()
										{
											if(document.getElementById('create_date').getAttribute("onchange"))
											{
												document.getElementById('create_date').onchange();	
											}		
										}
										
										Calendar.setup({
											animation :false,
											weekNumbers : true,
											inputField     :    "create_date",
											trigger    	   : 	"create_date_image",
											dateFormat     :    "%d/%m/%Y", // format of the input field "%B %e, %Y"
											onSelect	   :	function() {close_wrk_d_image_create_date();this.hide();},
											singleClick    :  true,
											dateInfo : getDateInfo
										});	

									</script>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12">Author id*</label>
						<div class="col col-8 col-xs-12">
							<input type="number" name="author_id" id="author_id">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-xs-12" for="off_identity">Off identity</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="off_identity" id="off_identity" value="1"> (If the checked this checkbox, add 'set identity_insert' to query!)
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12" for="remove_old_file">Remove old file</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="remove_old_file" id="remove_old_file" value="1"> (If the checked this checkbox, old file will delete and will create a new file!)
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12" for="remove_schema_name">Remove Schema Name</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="remove_schema_name" id="remove_schema_name" checked value="1"> (If the checked this checkbox, schema name will delete from query!)
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cfif isDefined("attributes.condition")>
				<cf_seperator id="associate_settings" header="Relational Settings">
				<cf_grid_list id="associate_settings">
					<thead>
						<tr>
							<th>Column name to associate (primary column)</th>
							<th>Datasource Name to associate with</th>
							<th>Table Name to associate with</th>
							<th>Column Name to Contact</th>
							<th>company_id Column Name</th>
							<th>period_id Column Name</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><div class="form-group"><input type="text" name="associate_column" id="associate_column" value="<cfoutput>#listfirst(attributes.condition, ' ')#</cfoutput>"></div></td>
							<td><div class="form-group"><input type="text" name="datasource_type" id="datasource_type"></div></td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="table_name" id="table_name">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_systemPopup&types=dbs', 'wide');"></span>
									</div>
								</div>
							</td>
							<td><div class="form-group"><input type="text" name="column_name" id="column_name"></div></td>
							<td><div class="form-group"><input type="text" name="company_id_column" id="company_id_column"></div></td>
							<td><div class="form-group"><input type="text" name="period_id_column" id="period_id_column"></div></td>
						</tr>
					</tbody>
				</cf_grid_list>
			</cfif>
			<div class="ui-form-list-btn flex-end">
				<div><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success ui-wrk-btn-addon-left" onclick="formScriptSubmit('export')"><i class="fa fa-download" style="color:#fff"></i>Download</a></div>
				<div><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-info ui-wrk-btn-addon-left" onclick="formScriptSubmit('exportFolder')"><i class="fa fa-download" style="color:#fff"></i>Export to WBP Folder</a></div>
			</div>
		</cf_box>
	</form>
	<script type="text/javascript">

		function download(filename, text) {
			var element = document.createElement('a');
			element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
			element.setAttribute('download', filename);

			element.style.display = 'none';
			document.body.appendChild(element);

			element.click();

			document.body.removeChild(element);
		}

		function formScriptSubmit( type ) {

			let associateSettingsJSON = "";

			if( type == 'exportFolder' ){
				if( $('#datatype').val() == ''){
					alert("Please fill in the Type field.");
					return;
				}
				if( $('#bestpractice').val() == ''){
					alert("Please fill in the Best Practice field.");
					return;
				}
				<cfif isDefined("attributes.condition")>
				if( $("#associate_column").val() != '' && $("#datasource_type").val() != '' && $("#table_column").val() != '' && $("#column_name").val() != '' ){
					var associateSettings = {
						associate_column: $("#associate_column").val(),
						datasource_type: $("#datasource_type").val(),
						table_name: $("#table_name").val(),
						column_name: $("#column_name").val(),
						company_id_column: $("#company_id_column").val(),
						period_id_column: $("#period_id_column").val()
					}
					associateSettingsJSON = JSON.stringify( associateSettings );
				}
				</cfif>
			}
			if($('#head').val()==='')
			{
				alert("Please fill in the Head field.");
				return;
			}
			if($('#detail').val()==='')
			{
				alert("Please fill in the Detail field.");
				return;
			}
			if($('#create_date').val()==='')
			{
				alert("Please fill in the Date field.");
				return;
			}
			if($('#author_id').val()==='')
			{
				alert("Please fill in the Author field.");
				return;
			}

			var formScriptData={
				table: $('input:hidden[name=table]').val(),
				bestpractice_id: $('#bestpractice').val(),
				bestpractice: $('#bestpractice option:selected').text(),
				datatype: $('#datatype').val(),
				head: $('#head').val(),
				detail: $('#detail').val(),
				create_date: $('#create_date').val(),
				author_id: $('#author_id').val(),
				off_identity: $('#off_identity').is(':checked') ? 1 : 0,
				remove_old_file: $('#remove_old_file').is(':checked') ? 1 : 0,
				remove_schema_name: $('#remove_schema_name').is(':checked') ? 1 : 0
				<cfif isDefined("attributes.condition")>
				,condition: $('#condition').val()
				,associate_config: associateSettingsJSON
				</cfif>
			};
			
			$.ajax({
				type: "get",
				url: "/Utility/DatabaseInfo.cfc?method=ScriptExportLog&isAjax=1&type=" + type,
				data: formScriptData,
				dataType: "json",
				success: function( objResponse ){

					if (objResponse.SUCCESS){
						var exportData = '';

						if(objResponse.CREATESCRIPT!=="undefined") exportData = exportData.concat(objResponse.CREATESCRIPT);
						if(objResponse.INSERTSCRIPT!=="undefined") exportData = exportData.concat(objResponse.INSERTSCRIPT);

						if(type == 'export') download(formScriptData.head+".txt",exportData);
						else alert('Downloading has been completed successfuly');

					}else alert("Error creating file.");

				}
			});
			// AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name=<cfoutput>#listfirst(attributes.table,".")#</cfoutput>table_name=<cfoutput>#listlast(attributes.table,".")#</cfoutput>&type=script_exec&'+$(frm).serialize(),'table_info',1);
		}

		function controlText( element ) {
			element.value = element.value.replace(' ', '');
		}

		function setFieldValue( values ) {
			$("#datasource_type").val( values.schemaType );
			$("#table_name").val( values.table );
			$("#column_name").val( values.field );
		}

	</script>
<cfelseif isDefined("attributes.type") and attributes.type is 'script_exec'>
	<cfscript>
	column_info = DatabaseInfo.ColumnInfo(
		table_name:listLast(attributes.table, "."),
		schema_name:listFirst(attributes.table, ".")
	);
	strscript = "CREATE TABLE " & listLast(attributes.table, ".") & " ( " & chr(13) & chr(10);
	arrscript = arrayNew(1);
	for (colm in column_info) {
		arrayAppend( arrscript, "[" & colm.COLUMN_NAME & "] " & colm.DATA_TYPE & ( iif( len(colm.MAXIMUM_LENGTH), de("(" & iif( colm.MAXIMUM_LENGTH eq "-1", de("MAX"), de(colm.MAXIMUM_LENGTH) ) & ")"), de("") ) ) & " " & iif( colm.IS_IDENTITY, de("IDENTITY(1,1) "), de("") ) & iif( colm.IS_NULLABLE eq "NO", de("NOT NULL"), de("NULL") ) );
	}
	strscript = strscript & arrayToList( arrscript, "," & chr(13) & chr(10) ) & " )";
	writeDump(strscript);
	</cfscript>
</cfif>