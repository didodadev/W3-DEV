<!--- GÜNCELLEME TARİHİ : 28082019 İLKER ALTINDAL // Grid yapısı değiştirildi --->

<cfparam name="url.isAjax" default="">
<cfparam name="url.ajax_box_page" default="">
<cfparam name="url.EditGrid" default="">
<cfparam name="attributes.right_images" default="">
<cfif url.isAjax neq 1 or ajax_box_page eq 1>
	<link rel="stylesheet" href="css/assets/template/contes/contes.css" type="text/css">
	<link rel="stylesheet" href="/css/assets/template/contes/sass/style.css" type="text/css">
	<script src="JS/assets/plugins/contes/materialize-pagination.js"></script>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<style>
		#EditGrid tbody tr:nth-of-type(odd) {
			background-color: #607d8b08;
		}
	</style>
	<meta charset="UTF-8">		
</cfif>

<cfparam name="attributes.search_header" default="">
<cfparam name="caller.onclick" default="">
<cfparam name="attributes.grid_name" default="wrk_grid">
<cfparam name="attributes.table_type" default="medium_list">
<cfparam name="attributes.left_menu" default="0">
<cfparam name="attributes.search_areas" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_insert" default="1">
<cfparam name="attributes.is_delete" default="0">
<cfparam name="attributes.dictionary_count" default="1">
<cfparam name="url.page" default="1">
<cfif not isdefined("attributes.sort_column")>
	<cfset attributes.sort_column = "#attributes.u_id#">
</cfif>

<cfif thisTag.executionMode eq "start">

<cfelse>

<cfif isdefined("attributes.cfc_name")>
	<cfset getAction = createObject('component','#attributes.cfc_name#')>
	<cfset getGrid = getAction.CreateGrid(#url.page#,25,"","")>
	<!--- <cfset bind_ = "cfc:#attributes.cfc_name#({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection})">--->
<cfelse>
	<!--- <cfset bind_ = "cfc:cfc.wrk_grid_edit.CreateGrid({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection},{grid_data_source},{grid_table_name},{grid_u_id},{grid_search_areas},{search_#attributes.grid_name#},{grid_sort_column})"> --->
	<cfset getAction = createObject('component','cfc.wrk_grid_edit')>
	<cfset getGrid = getAction.CreateGrid(#url.page#,25,"","ASC","#attributes.datasource#","#attributes.table_name#","#attributes.u_id#","#attributes.search_areas#","#attributes.keyword#","#attributes.sort_column#")>
</cfif>
	<cfif url.isAjax neq 1 or ajax_box_page eq 1>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box title="#attributes.search_header#" right_images="#attributes.right_images#">
						<cfform>
							<cfinput type="hidden" name="grid_table_name" id="grid_table_name" value="#attributes.table_name#" />
							<cfinput type="hidden" name="grid_u_id" id="grid_u_id" value="#attributes.u_id#" />
							<cfinput type="hidden" name="grid_data_source" id="grid_data_source" value="#attributes.datasource#" />
							<cfinput type="hidden" name="grid_user_id" id="grid_user_id" value="#session.ep.userid#" />
							<cfinput type="hidden" name="grid_req_list" id="grid_req_list" value="#caller.grid_req_list#" />
							<cfinput type="hidden" name="grid_type_" id="grid_type_" value="#attributes.keyword#" />
							<cfinput type="hidden" name="grid_search_areas" id="grid_search_areas" value="#attributes.search_areas#" />
							<cfinput type="hidden" name="grid_sort_column" id="grid_sort_column" value="#attributes.sort_column#" />
						</cfform>
						<div class="ui-scroll">
							<table class="ui-table-list ui-form"  id="<cfif isDefined("attributes.EditGrid") and len(attributes.EditGrid)><cfoutput>#attributes.EditGrid#</cfoutput><cfelse>EditGrid</cfif>"  data-action="EditGrid" <cfoutput>data-table_name="#attributes.table_name#" data-u_id="#attributes.u_id#" data-data_source="#attributes.datasource#" data-user_id="#session.ep.userid#" data-type_id="#attributes.keyword#" data-req_list="#caller.grid_req_list#"</cfoutput>>	
								<thead>
									<tr>
									<cfloop from="1" to="#listlen(caller.grid_header_list)#" index="thList">
										<cfset header_ = listgetat(caller.grid_header_list,thList)>
										<cfif listgetat(caller.grid_display_list,thList) is 'yes'>
										<th><cfoutput>#header_#</cfoutput></th>
											<cfif listgetat(caller.grid_type_list,thList) eq "string_noCase" or listgetat(caller.grid_type_list,thList) eq "ntext"><cfif listgetat(caller.grid_empty_list,thList) neq 1><th></th></cfif></cfif>
										</cfif>
									</cfloop>
										<th width="20"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
										<th width="20">
											<cfif isDefined("attributes.EditGrid") and len(attributes.EditGrid)>
												<a data-button="add" data-table="<cfoutput>#attributes.EditGrid#</cfoutput>" href="javascript://"><i class="fa fa-plus"></i></a>		
											<cfelse>
												<a data-button="add" data-table="EditGrid" href="javascript://"><i class="fa fa-plus"></i></a>	
											</cfif>	
										</th>
										
									</tr>
								</thead>
								<tbody>
									<tr data-id="0" data-primary="<cfoutput>#attributes.u_id#</cfoutput>">
										<cfloop from="1" to="#listlen(caller.grid_header_list)#" index="thList">
											<cfif listgetat(caller.grid_display_list,thList) is 'yes'>								
											<td <cfif listgetat(caller.grid_type_list,thList) neq 'date'> data-upd="<cfoutput>#listgetat(caller.grid_name_list,thList)#</cfoutput>" data-empty="<cfoutput>#listgetat(caller.grid_empty_list,thList)#</cfoutput>" data-type="<cfoutput>#listgetat(caller.grid_type_list,thList)#</cfoutput>"</cfif> data-options="<cfoutput><cfif listgetat(caller.grid_listsource, thList) neq "-">#evaluate("caller." & listgetat(caller.grid_listsource, thList))#</cfif></cfoutput>" data-options_text="<cfoutput><cfif listgetat(caller.grid_listsource_text, thList) neq "-">#evaluate("caller." & listgetat(caller.grid_listsource_text, thList))#</cfif></cfoutput>"></td>
												<cfif listgetat(caller.grid_type_list,thList) eq "string_noCase" or listgetat(caller.grid_type_list,thList) eq "ntext">
													<td data-empty="<cfoutput>#listgetat(caller.grid_empty_list,thList)#</cfoutput>"></td>
												</cfif>
											</cfif>
										</cfloop>
										<td><a data-button="upd" href="javascript://" title="<cf_get_lang_main no='52.Güncelle'>"><i class="icon-check"></i></a></td>
										<td><a data-button="delete" href="javascript://"><i class="fa fa-minus"></i></a></td>
									</tr>
										<cfloop query="getGrid.query">
											
											<tr data-id="<cfoutput>#getGrid.query[attributes.u_id][currentrow]#</cfoutput>" data-primary="<cfoutput>#attributes.u_id#</cfoutput>">
											<cfloop from="1" to="#listlen(caller.grid_name_list)#" index="data">
												<cfset data_ = listgetat(caller.grid_name_list,data)>
												<cfoutput>
													<cfif listgetat(caller.grid_display_list,data) is 'yes'>
													<cfif listgetat(caller.grid_name_list,data) is 'RECORD_EMP'><cfset GET_EMP_INFO_ = getAction.GET_EMP_INFO_(emp_id:getGrid.query[data_][currentrow])></cfif>
														<td <cfif listgetat(caller.grid_type_list,data) eq 'float' or listgetat(caller.grid_type_list,data) eq 'money'> class="moneybox" </cfif> data-options="<cfoutput><cfif listgetat(caller.grid_listsource, data) neq "-">#evaluate("caller." & listgetat(caller.grid_listsource, data))#</cfif></cfoutput>" data-options_text="<cfoutput><cfif listgetat(caller.grid_listsource_text, data) neq "-">#evaluate("caller." & listgetat(caller.grid_listsource_text, data))#</cfif></cfoutput>" <cfif listgetat(caller.grid_type_list,data) neq 'date'> data-upd="<cfoutput>#listgetat(caller.grid_name_list,data)#</cfoutput>" data-type="<cfoutput>#listgetat(caller.grid_type_list,data)#</cfoutput>" </cfif>> <cfif listgetat(caller.grid_type_list,data) eq 'date'> #dateformat(getGrid.query[data_][currentrow],caller.dateformat_style)#<cfelseif listgetat(caller.grid_type_list,data) eq 'float' or listgetat(caller.grid_type_list,data) eq 'money'> #caller.Tlformat(getGrid.query[data_][currentrow],4)# <cfelseif listgetat(caller.grid_name_list,data) is 'RECORD_EMP'> #GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME# <cfelseif listgetat(caller.grid_type_list,data) eq 'checkbox'><cfif getGrid.query[data_][currentrow] eq 1><i class="icon-check"></i><cfelse>&nbsp;</cfif><cfelseif listgetat(caller.grid_listsource_text, data) neq "-" and listgetat(caller.grid_type_list,data) eq 'select'> <cfoutput><cfif len(getGrid.query[data_][currentrow]) and listgetat(evaluate("caller." & listgetat(caller.grid_listsource_text, data)), listfind(evaluate("caller." & listgetat(caller.grid_listsource, data)), getGrid.query[data_][currentrow])) neq "-">#listgetat(evaluate("caller." & listgetat(caller.grid_listsource_text, data)), listfind(evaluate("caller." & listgetat(caller.grid_listsource, data)), getGrid.query[data_][currentrow]))#</cfif></cfoutput><cfelse>#getGrid.query[data_][currentrow]#</cfif></td>
														<cfif listgetat(caller.grid_type_list,data) eq "string_noCase" or listgetat(caller.grid_type_list,data) eq "ntext">
															<cfif listgetat(caller.grid_select_list,data) neq "no" and listgetat(caller.grid_select_list,data) neq "no">
																<cftry>
																	<cfif listgetat(caller.grid_empty_list,data) neq 1><td>#getGrid.query[data_&"_WRK_GRID_ML"][currentrow]#</td></cfif>
																<cfcatch>
																</cfcatch>
																</cftry>
															<cfelse>
																<td></td>
															</cfif>
														</cfif>
														<cfset type_ = listgetat(caller.grid_type_list,data)>
													</cfif>
												</cfoutput>
											</cfloop>
												<td><a data-button="upd" href="javascript://"><i class="fa fa-pencil"></i></a></td>
												<td><a data-button="cancel" href="javascript://"><i class="fa fa-minus"></i></a></td>	
											</tr>
										</cfloop>			
								</tbody>
						</table>
						</div>
						<div paging class="contes">
							<div class="row">
								<div class="col s12" id="postsPaging"></div>
							</div>
						</div>
				</cf_box>
			</div>	
		
		<script type="text/javascript">
			$(function(){
			if(Math.ceil(<cfoutput>#getGrid.TOTALROWCOUNT#</cfoutput>/25) > 1)
			{
				$('#postsPaging').materializePagination({
					align: 'center',
					lastPage:  Math.ceil(<cfoutput>#getGrid.TOTALROWCOUNT#</cfoutput>/25),
					firstPage:  1,
					useUrlParameter: false,
					onClickCallback: function(requestedPage){			
					},
					CallBackContes: function(callBack){
						/*if(callBack.status=="next" || callBack.status=="prev"){
								$('#postsPaging [data-page="'+callBack.current+'"]').trigger('click');
						}	*/			
					},
				}); 
			}
			var Oldpage = 0;
			var Lastpage = Math.ceil(<cfoutput>#getGrid.TOTALROWCOUNT#</cfoutput>/25);
			
			if (window.wrk_grid_events === undefined) { // Bir sayfada sadece bir kere olay dinleyici eklenmesi için
				window.wrk_grid_events = true;
			$( document ).on( "click", "[data-page]", function() {
				if($(this).data('page') == "prev")  Oldpage = Oldpage-1;
				else if($(this).data('page') == "next") Oldpage = Oldpage+1;
				else Oldpage = $(this).data('page');
				if(Oldpage == -1 || Oldpage == 0) Oldpage = 1; 
				if(Oldpage == Lastpage || Oldpage > Lastpage ) Oldpage = Lastpage;
				
				$('#EditGrid').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');
				$.ajax({                
					url: '',
					data: ({isAjax:1,page: Oldpage}),
					type: "GET",
					success: function (returnData) {
						$('#EditGrid tbody').html(returnData.substr(returnData.indexOf('<tr',1)));
						$('#tableLoading').remove();  
					},							
					error: function () {
						/**/
					}
				});				
			});
			$( document ).on( "click", "[data-button]", function() {
				if($(this).attr('data-button')=='upd'){
					var record = $(this).closest('tr');
					$(record).addClass('selectedWarning');
					record.find('td').each (function() {
						if($(this).data('upd')){
							if($(this).data('type') == 'string_noCase' || $(this).data('type') == 'text'){ // text karşılığı string_noCase olarak geliyor.				
							var input =	$('<input>').attr({
									id:$(this).data('upd'),
									value:trim($(this).html()),
									type:"text",
									required:"yes",
							}).data('old',$(this).html());
							}else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
								var input = $('<input>').attr({
									id:$(this).data('upd'),
									value:trim($(this).html()),
									type:"number",
									required:"yes",
								}).data('old',$(this).text());
							}else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
								var input = $('<input>').attr({
									id:$(this).data('upd'),
									value:trim($(this).html()),
									type:"text",
									required:"yes",
								}).css('text-align','right').data('old',$(this).html());
							}else if($(this).data('type') == 'boolean' || $(this).data('type') == 'checkbox'){ // checkbox karşılığı boolean olarak geliyor.
								if(trim($(this).html())=='YES' || trim($(this).html())== 1 || trim($(this).val())!= "NO")
								{var status = true; var checkbox_label='YES';}else{var status = false;  var checkbox_label='NO';}
								var input =	$('<input>').attr({
										id:$(this).data('upd'),
										type:"checkbox",
										value:$(this).html()
								}).data('old','<i class="icon-check"></i>').prop('checked',status);
								//console.log(status);
							}else if($(this).data('type') == 'select') {
								var options_text = $(this).data("options_text").split(",");
								var input = $('<select>').attr({id: $(this).data('upd')}).html($(this).data("options").split(",").reduce((acc, itm, index) => { return acc + '<option value="' + itm + '"' + (trim($(this).text()) == options_text[index] ? ' selected="selected"' : '') + '>' + (options_text[index] != undefined ? options_text[index] : itm) + '</option>'; }, ""));
							}else if($(this).data('type') == 'threePoint'){
								// geliştirilecek
							}
							var form_group = $('<div></div>');
                            	form_group.attr("class", "form-group");
								form_group.append(input);	
							$(this).empty();
							$(this).append(form_group);
						}
						$(record).find('a[data-button="upd"]').attr({"data-button":"update"<cfif len(caller.onclick)>,"onclick":"<cfoutput>#caller.onclick#</cfoutput>"</cfif>}).empty().html('<i class="icon-check"></i>');
						$(record).find('a[data-button="delete"]').attr("data-button","cancel");
					});
				}//UPDATE Button
				else if($(this).attr('data-button')=='cancel'){
					var record = $(this).closest('tr');
					$(record).removeClass('selectedWarning');
					record.find('td').each (function() {
						if($(this).data('upd')){
							var cellValue = $(this).find('input, select').data('old');
							$(this).empty();
							$(this).append(cellValue);
						}
						$(record).find('a[data-button="update"]').attr("data-button","upd").empty().html('<i class="fa fa-pencil"></i>');
						$(record).find('a[data-button="cancel"]').attr("data-button","delete");
					});
					var sendAction 	= $(this).closest('table').data('action'); //'_'+$(this).attr('data-button');
					var sendData 	= '';
					var sendDataArray = {};
					var record 		= $(this).closest('tr');
					var req_status = true;
					sendData = sendData+$(record).data('primary')+'='+$(record).data('id');
					$.ajax({                
						url: '/cfc/wrk_grid_edit.cfc?method='+sendAction+'&'+sendData,
						type: "GET",
						data: ({
							gridaction: 'D',
							grid_table_name: $(this).closest('table').data('table_name'),
							grid_u_id: $(this).closest('table').data('u_id'),
							grid_data_source: $(this).closest('table').data('data_source'),
							grid_user_id: $(this).closest('table').data('user_id'),
							grid_type_ : $(this).closest('table').data('type_id'),
							grid_req_list: $(this).closest('table').data('req_list'),
							gridrowjson:JSON.stringify(sendDataArray)
						}),
						success: function (returnData) {
							if(returnData==1){
								alert("<cf_get_lang dictionary_id='44108.Silme İşlemi'> <cf_get_lang dictionary_id='55387.Başarılı'>!");
								location.reload();
							} 
						},
						error: function () {
							alert("<cf_get_lang dictionary_id='65017.Kayıt Silinemedi'>!")
						}
					});
					console.log('Cancel')
				}//Update CANCEL Button
				else if($(this).attr('data-button')=='update'){
					$('body').append('<img src="/css/assets/template/contes/loading.gif" id="contesLoading" style="display:block; margin: auto; width: 100px; position: absolute; left: 0; right: 0; top: 42%; ">')
					var sendAction 	= $(this).closest('table').data('action'); //'_'+$(this).attr('data-button');
					var sendData 	= '';
					var sendDataArray = {};
					var record 		= $(this).closest('tr');
					var req_status = true;
					record.find('td').each (function() {
						if($(this).data('upd')){

							var req		= $(this).find('input').attr('required');
							var req_val	= $(this).find('input').val();
							if(req == 'required' && !req_val.length){
								req_status = false;
							}

							if($(this).data('type') == 'text' || $(this).data('type') == 'string_noCase'){	
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'checkbox' || $(this).data('type') == 'boolean'){	
								var did		= $(this).find('input').attr('id');
								if ($(this).find('input').prop('checked')){
									var dval = 1;
								}else{
									var dval = 0;
								}
							}else if($(this).data('type') == 'select'){	
								var did		= $(this).find('select').attr('id');
								var dval	= $(this).find('select').val();
							}
							sendData = sendData+did+'='+dval+'&';
							sendDataArray[did] = dval;
						}		
					});
					sendData = sendData+$(record).data('primary')+'='+$(record).data('id');

					console.log(JSON.stringify(sendDataArray));
					if(req_status) {
					$.ajax({                
						url: '/cfc/wrk_grid_edit.cfc?method='+sendAction+'&'+sendData,
						type: "GET",
						data: ({
							gridaction: 'U',
							grid_table_name: $(this).closest('table').data('table_name'),
							grid_u_id: $(this).closest('table').data('u_id'),
							grid_data_source: $(this).closest('table').data('data_source'),
							grid_user_id: $(this).closest('table').data('user_id'),
							grid_type_ : $(this).closest('table').data('type_id'),
							grid_req_list: $(this).closest('table').data('req_list'),
							gridrowjson:JSON.stringify(sendDataArray)
						}),
						success: function (returnData) {
							if(returnData==1){
								$(record).removeClass('selectedWarning');
								alertObject({type: 'warning',message: '<cf_get_lang dictionary_id='57703.Güncelleme'> <cf_get_lang dictionary_id='50929.Yapıldı'>', closeTime: 5000});
								record.find('td').each (function() {
									if($(this).data('upd')){
										var cellValue = $(this).find('input').val();
										if($(this).data('type') == 'text' || $(this).data('type') == 'string_noCase'){										
											$(this).empty();
											$(this).append(cellValue);
										}else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
											$(this).empty();
											$(this).append(cellValue);
										}else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
											$(this).empty();
											$(this).append(cellValue);
										}
										else if($(this).data('type') == 'checkbox' || $(this).data('type') == 'boolean'){	
											if ($(this).find('input').prop('checked')){
												$(this).empty();
												$(this).append('<i class="icon-check"></i>');
											}else{
												$(this).empty();
												$(this).append('NO');
											}
										}
									}
									$(record).find('a[data-button="update"]').attr("data-button","upd").empty().html('<i class="fa fa-pencil"></i>');
									$(record).find('a[data-button="cancel"]').attr("data-button","delete");
								});
								$('#contesLoading').remove();  
							} 
						},
						error: function () {
						}
					});
					}
					else{alertObject({type: 'danger',message:"<cf_get_lang dictionary_id='52097.Boş alan bırakmayın'>", closeTime: 5000}); $('#contesLoading').remove();};
					console.log('update save');
				}// update-SAVE Button
				else if($(this).attr('data-button')=='add'){					
					var table = $(this).data('table');
					var row = $('#'+table).find('tbody').find('tr').html();
					var primary = $('#'+table).find('tbody').find('tr').data('primary');
					var newRow = $('<tr>').addClass('selectedSuccess').attr('data-primary',primary).append(row);
					newRow.find('td').each (function(index) {

						if(index<=0){$(this).html('#');}
						
						if ($(this).data('empty') == 1 && $(this).data('upd') == undefined) {
								$(this).remove();
							}//boş satır silmek için 
						if($(this).data('upd')){
							$(this).empty();
							if($(this).data('type') == 'text' || $(this).data('type') == 'string_noCase'){					
								var input =	$('<input>').attr({
										id:$(this).data('upd'),
										type:"text",
										required:"true"
								});
								var form_group = $('<div></div>');
                            	form_group.attr("class", "form-group");
								form_group.append(input);
								$(this).append(form_group);
							}
							else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
								var input =	$('<input>').attr({
										id:$(this).data('upd'),
										type:"number",
										required:"true"
								});
								var form_group = $('<div></div>');
                            	form_group.attr("class", "form-group");
								form_group.append(input);
								$(this).append(form_group);
							}
							else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
								var input =	$('<input>').attr({
										id:$(this).data('upd'),
										type:"text",
										required:"true"
								}).css('text-align','right');
								var form_group = $('<div></div>');
                            	form_group.attr("class", "form-group");
								form_group.append(input);
								$(this).append(form_group);
							}
							else if($(this).data('type') == 'checkbox' || $(this).data('type') == 'boolean'){
								var input =	$('<input>').attr({
										id:$(this).data('upd'),
										type:"checkbox",
										value:"1"
								});
								$(this).append(input);
							}else if($(this).data('type') == 'select') {
								var options_text = $(this).data("options_text").split(",");
								var input = $('<select>').attr({id: $(this).data('upd')}).html($(this).data("options").split(",").reduce((acc, itm, index) => { return acc + '<option value="' + itm + '"' + (trim($(this).html()) == itm ? ' selected="selected"' : '') + '>' + (options_text[index] != undefined ? options_text[index] : itm)   + '</option>'; }, ""));
									var form_group = $('<div></div>');
                            	form_group.attr("class", "form-group");
								form_group.append(input);
								$(this).append(form_group);
							}
						}
						$(newRow).find('a[data-button="upd"]').attr("data-button","add_new");
						$(newRow).find('a[data-button="delete"]').attr("data-button","quit");
					});//
				$('#'+table).find('tbody').append(newRow);
				}//yeni kayıt icin bos satir
				else if($(this).attr('data-button')=='add_new'){
					var sendAction 	= $(this).closest('table').data('action'); //+'_'+$(this).attr('data-button');
					var sendData 	= '';
					var sendDataArray = {};
					var record 		= $(this).closest('tr');
					var req_status = true;
					record.find('td').each (function() {
						if($(this).data('upd')){
							
							var req		= $(this).find('input').attr('required');
							var req_val	= $(this).find('input').val();
							if(req == 'required' && !req_val.length){
								req_status = false;
							}

							if($(this).data('type') == 'text' || $(this).data('type') == 'string_noCase'){	
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
								var did		= $(this).find('input').attr('id');
								var dval	= $(this).find('input').val();
							}
							else if($(this).data('type') == 'checkbox' || $(this).data('type') == 'boolean'){	
								var did		= $(this).find('input').attr('id');
								if ($(this).find('input').prop('checked')){
									var dval = 1;
								}else{
									var dval = 0;
								}
							}
							else if($(this).data('type') == 'select'){	
								var did		= $(this).find('select').attr('id');
								var dval	= $(this).find('select').val();
							}
							sendData = sendData+did+'='+dval+'&';
							sendDataArray[did] = dval;
						}		
					});
					sendData = sendData+$(record).data('primary')+'='+$(record).data('id');
					console.log(sendData);
					if(req_status) {
					$.ajax({                
						url: '/cfc/wrk_grid_edit.cfc?method='+sendAction+'&'+sendData,
						type: "GET",
						data: ({
							gridaction: 'I',
							grid_table_name: $(this).closest('table').data('table_name'),
							grid_u_id: $(this).closest('table').data('u_id'),
							grid_data_source: $(this).closest('table').data('data_source'),
							grid_user_id: $(this).closest('table').data('user_id'),
							grid_type_   : $(this).closest('table').data('type_id'),
							grid_req_list: $(this).closest('table').data('req_list'),
							gridrowjson:JSON.stringify(sendDataArray)
						}),
						success: function (returnData) {
							console.log(returnData);
							if(parseInt(returnData.replace('"',''))>=1){
								$(record).removeClass('selectedSuccess');
								alertObject({type: 'success',message: '<cf_get_lang dictionary_id='65018.Yeni kayıt yapıldı'>...', closeTime: 5000});
								record.find('td').each (function() {
									$(record).attr("data-id",parseInt(returnData.replace('"','')));

									if($(this).data('upd')){
										var cellValue = $(this).find('input').val();                                
										if($(this).data('type') == 'text' || $(this).data('type') == 'string_noCase'){	
											$(this).empty();
											$(this).append(cellValue);
										}
										else if($(this).data('type') == 'numeric' || $(this).data('type') == 'number'){
											$(this).empty();
											$(this).append(cellValue);
										}
										else if($(this).data('type') == 'float' || $(this).data('type') == 'money'){
											$(this).empty();
											$(this).append(cellValue);
										}
										else if($(this).data('type') == 'checkbox' || $(this).data('type') == 'boolean'){
											if ($(this).find('input').prop('checked')){
												$(this).empty();
												$(this).append('<i class="icon-check"></i>');
											}else{
												$(this).empty();
												$(this).append('NO');
											}
										}
									}
									
									$(record).find('a[data-button="add_new"]').attr("data-button","upd");
									$(record).find('a[data-button="quit"]').attr("data-button","delete");
									
								});
							}else if(parseInt(returnData.replace('"',''))==0){
								alertObject({type: 'danger',message: "<cf_get_lang dictionary_id='52109.Boş veri'>!<cf_get_lang dictionary_id='52105.Lütfen eksik alan bırakmayınız'>...", closeTime: 5000});
							}
						},
						error: function () {
							/**/
						}
					});
					}
					else{alertObject({type: 'danger',message: "<cf_get_lang dictionary_id='52097.Boş alan bırakmayın'>", closeTime: 5000}); $('#contesLoading').remove();};
					console.log("yeni kayıt");
				}//yeni kayit kaydetme
				else if($(this).attr('data-button')=='quit'){
					$(this).closest('tr').remove();
					console.log("Kayıt vazgeç");
				}//yen kayit vazgec										
				});//data list data-button click
			}
			})
		</script>
	<cfelse>
		<cfloop query="getGrid.query">
			<tr data-id="<cfoutput>#getGrid.query[attributes.u_id][currentrow]#</cfoutput>" data-primary="<cfoutput>#attributes.u_id#</cfoutput>">
			<cfloop from="1" to="#listlen(caller.grid_name_list)#" index="data">
				<cfset data_ = listgetat(caller.grid_name_list,data)>
				<cfoutput>
					<cfif listgetat(caller.grid_display_list,data) is 'yes'>
						<td <cfif listgetat(caller.grid_type_list,data) neq 'date'> data-upd="<cfoutput>#listgetat(caller.grid_name_list,data)#</cfoutput>" data-type="<cfoutput>#listgetat(caller.grid_type_list,data)#</cfoutput>" </cfif> >#getGrid.query[data_][currentrow]#</td>
						<cfif listgetat(caller.grid_type_list,data) eq "string_noCase" or listgetat(caller.grid_type_list,data) eq "ntext">
							<cfif listgetat(caller.grid_select_list,data) neq "no" and listgetat(caller.grid_select_list,data) neq "no">
								<cftry>
									<cfif listgetat(caller.grid_empty_list,data) neq 1><td>#getGrid.query[data_&"_WRK_GRID_ML"][currentrow]#</td></cfif>
								<cfcatch>
								</cfcatch>
								</cftry>
							<cfelse>
								<td></td>
							</cfif>
						</cfif>
						<cfset type_ = listgetat(caller.grid_type_list,data)>
					</cfif>
				</cfoutput>
			</cfloop>
				<td><a data-button="upd" href="javascript://" title="<cf_get_lang_main no='52.Güncelle'>"><i class="fa fa-pencil"></i></a></td>
				<td><a data-button="delete" href="javascript://"><i class="fa fa-minus"></i></a></td>
			</tr>
		</cfloop>
	</cfif>
</cfif>

