<cfscript>
    getObj = CreateObject("component","cfc.system");
</cfscript>
<cfif isdefined('attributes.saveForm')>
	<cffile action="write" file="#download_folder#/#attributes.controllerFilePath#" output="#attributes.dosya_icerik#" charset="utf-16">
    
    <script type="text/javascript">
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=controller&userFriendly=#attributes.userFriendly#</cfoutput>','workDev-page-content');
	</script>
</cfif>

<cfscript>
	getObjController = getObj.GET_CONTROLLERNAME(userFriendly : attributes.userFriendly,WoFuseaction : attributes.fuseact);
</cfscript>

<cftry>
	<cfif len(getObjController.ADDOPTIONS_CONTROLLER_FILE_PATH)>
	    <cffile action="read" variable="icerik" file="#download_folder#/#getObjController.ADDOPTIONS_CONTROLLER_FILE_PATH#">
        <textarea style="width:100%;height:600px; font-size:14px;" name="controller_icerik" id="controller_icerik"><cfoutput>#icerik#</cfoutput></textarea>
    <cfelse>
    	<cffile action="read" variable="icerik" file="#download_folder#/#getObjController.CONTROLLER_FILE_PATH#">
        <textarea disabled="disabled" style="width:100%;height:600px; font-size:14px;" name="controller_icerik" id="controller_icerik"><cfoutput>#icerik#</cfoutput></textarea>
    </cfif>
    <cfcatch type="any">Dosya Görüntüleme Hatası!</cfcatch>
</cftry> 

<form name="upd_files" method="post" action="">
    <div class="hide">
		<input type="hidden" name="userFriendly" id="userFriendly" value="<cfoutput>#attributes.userFriendly#</cfoutput>">
		<cfif len(getObjController.ADDOPTIONS_CONTROLLER_FILE_PATH)>
           <input type="hidden" name="controllerFilePath" id="controllerFilePath" value="<cfoutput>#getObjController.ADDOPTIONS_CONTROLLER_FILE_PATH#</cfoutput>">
        <cfelse>
           <input type="hidden" name="controllerFilePath" id="controllerFilePath" value="<cfoutput>#getObjController.CONTROLLER_FILE_PATH#</cfoutput>">
        </cfif>
        <textarea name="dosya_icerik" id="dosya_icerik"></textarea>
    </div>
    <cfif len(getObjController.ADDOPTIONS_CONTROLLER_FILE_PATH)>
        <input type="button" onclick="ajaxSubmit(this)" value="SAVE">
    </cfif>
</form>

<script type="text/javascript">
	function ajaxSubmit(obj) {
		document.getElementById('dosya_icerik').value = document.getElementById('controller_icerik').value;
		
		var parameterString = '';
		data = new FormData($(obj).closest('form')[0]);
		
		var method = (data != null) ? "POST": "GET";
		$.ajax( {
			url: '<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=controller</cfoutput>&saveForm=1',
			type: method,
			data: data,
			processData: false,
			contentType: false,
			success: function(responseData, status, jqXHR)
			{ 
				//console.log(responseData);
				ajax_request_script(responseData.replace(/\u200B/g,''))
			},
			error: function(xhr, opt, err)
			{
				// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
				//console.log(xhr)
				ajax_request_script(xhr.responseText.replace(/\u200B/g,''))
			},
		} );	
	}
</script>

<!---
<cfscript>
	GET_WRK_FUSEACTIONS_data = getObj.GET_WRK_FUSEACTIONS(userFriendly : attributes.userFriendly);
	GET_FORMS = getObj.GET_COMPONENTS(userFriendly : attributes.userFriendly, keyword : '');
</cfscript>


<div class="row">	
	<div class="col col-12">		
		<div id="tab-container" class="tabWorkdev">
			<div id="tab-head">
				<label class="tabNavHead">EVENT:</label>
				<ul class="tabNav pull-left">					
						<cfif GET_WRK_FUSEACTIONS_data.event_add eq 1>						
							<li class="active"><a href="#add">Add</a></li>
						</cfif>
						<cfif GET_WRK_FUSEACTIONS_data.event_upd eq 1>
							<li><a href="#upd">Upd</a></li>
						</cfif>
						<cfif GET_WRK_FUSEACTIONS_data.event_list eq 1>
							<li><a href="#list">List</a></li>
						</cfif>
						<cfif GET_WRK_FUSEACTIONS_data.event_detail eq 1>
							<li><a href="#detail">Detail</a></li>
						</cfif>
						<cfif GET_WRK_FUSEACTIONS_data.event_dashboard eq 1>
							<li><a href="#dashboard">Dasboard</a></li>
						</cfif>		
					<li><a href="#tab">Tabs</a></li>
				</ul>
			</div>
			<div style="clear:both;"></div>
			<div id="tab-content"> 
				<cfif GET_WRK_FUSEACTIONS_data.event_add eq 1>	
					<div class="row content" id="add">
						<div class="col col-4 col-xs-12">	
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Components
										</span>
									</div>                 
									<div class="portBody connectedElementSortable" style="display: block;"> 
										<cfoutput query="GET_FORMS">
											<div class="form-group">
												<label>#COMPONENTNAME#</label>
											</div>
										</cfoutput>
									</div> 
								</div>
							</div>
							<div class="row">					
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Other Components
										</span>
										<span class="btnPointer pull-right">
											<input type="text" name="keywordController" id="keywordController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasAdd','keywordController');}"/><i class="icon-search" onclick="ajaxController('areasAdd','keywordController');"></i>
										</span>
									</div>
									<div id="areasAdd" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Includes
										</span>
										<span class="btnPointer pull-right">
											<input type="text" name="keywordIncludeController" id="keywordIncludeController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasAddInclude','keywordIncludeController');}"/><i class="icon-search" onclick="ajaxController('areasAddInclude','keywordIncludeController');"></i>
										</span>
									</div>
                                    <div id="areasAddInclude" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
						</div>	
						<div class="col col-8 col-xs-12">
							<div class="row">
								<div class="col col-12 formDesignerButtons">
									<span class="btn green-jungle" onclick="rowAdd('addRowsContent');">Satır Ekle</span>
									<span class="btn blue-sharp" onclick="colAdd();">Sütun Ekle</span>
								</div>
							</div>
							<div id="addRowsContent" class="connectedRow"></div>					
						</div>
					</div>				
				</cfif>
				<cfif GET_WRK_FUSEACTIONS_data.event_upd eq 1>
					<div class="row content" id="upd">
						<div class="col col-4 col-xs-12">
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Components
										</span>
									</div>                 
									<div class="portBody connectedElementSortable" style="display: block;"> 
										<cfoutput query="GET_FORMS">
											<div class="form-group">
												<label>#COMPONENTNAME#</label>
											</div>
										</cfoutput>
									</div> 
								</div>
							</div>
							<div class="row">					
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Other Components
										</span>
										<span class="btnPointer pull-right">
											<input type="text" name="keywordController" id="keywordController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasUpd','keywordController');}"/><i class="icon-search" onclick="ajaxController('areasUpd','keywordController');"></i>
										</span>
									</div>
									<div id="areasUpd" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Includes
										</span>
										<span class="btnPointer pull-right">
											<input type="text" name="keywordIncludeController" id="keywordIncludeController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasUpdInclude','keywordIncludeController');}"/><i class="icon-search" onclick="ajaxController('areasUpdInclude','keywordIncludeController');"></i>
										</span>
									</div>
                                    <div id="areasUpdInclude" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div>
								</div>
							</div>
						</div>	
						<div class="col col-8 col-xs-12">
							<div class="row">
								<div class="col col-12 formDesignerButtons">
									<span class="btn green-jungle" onclick="rowAdd('updRowsContent');">Satır Ekle</span>
									<span class="btn blue-sharp" onclick="colAdd();">Sütun Ekle</span>
								</div>
							</div>
							<div id="updRowsContent" class="connectedRow"></div>					
						</div>
					</div>	
				</cfif>
				<cfif GET_WRK_FUSEACTIONS_data.event_list eq 1>
					<div class="row content" id="list">
						<div class="col col-4 col-xs-12">
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Components
										</span>
									</div>                 
									<div class="portBody connectedElementSortable" style="display: block;"> 
										<cfoutput query="GET_FORMS">
											<div class="form-group">
												<label>#COMPONENTNAME#</label>
											</div>
										</cfoutput>
									</div> 
								</div>
							</div>
							<div class="row">					
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Other Components
										</span>
                                        <span class="btnPointer pull-right">
											<input type="text" name="keywordController" id="keywordController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasList','keywordController');}"/><i class="icon-search" onclick="ajaxController('areasList','keywordController');"></i>
										</span>
									</div>               
									<div id="areasList" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Includes
										</span>
                                        <span class="btnPointer pull-right">
											<input type="text" name="keywordIncludeController" id="keywordIncludeController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasListInclude','keywordIncludeController');}"/><i class="icon-search" onclick="ajaxController('areasListInclude','keywordIncludeController');"></i>
										</span>
									</div>
                                    <div id="areasListInclude" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div>
								</div>
							</div>
						</div>	
						<div class="col col-8 col-xs-12">
							<div class="row">
								<div class="col col-12 formDesignerButtons">
									<span class="btn green-jungle" onclick="rowAdd('listRowsContent');">Satır Ekle</span>
									<span class="btn blue-sharp" onclick="colAdd();">Sütun Ekle</span>
								</div>
							</div>
							<div id="listRowsContent" class="connectedRow"></div>					
						</div>
					</div>					
				</cfif>
				<cfif GET_WRK_FUSEACTIONS_data.event_detail eq 1>
					<div class="row content" id="detail">
						<div class="col col-4 col-xs-12">
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Components
										</span>
									</div>                 
									<div class="portBody connectedElementSortable" style="display: block;"> 
										<cfoutput query="GET_FORMS">
											<div class="form-group">
												<label>#COMPONENTNAME#</label>
											</div>
										</cfoutput>
									</div> 
								</div>
							</div>
							<div class="row">					
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Other Components
										</span>
                                        <span class="btnPointer pull-right">
											<input type="text" name="keywordController" id="keywordController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasDet','keywordController');}"/><i class="icon-search" onclick="ajaxController('areasDet','keywordController');"></i>
										</span>
									</div>
									<div id="areasDet" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Includes
										</span>
                                        <span class="btnPointer pull-right">
											<input type="text" name="keywordIncludeController" id="keywordIncludeController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController'areasDetInclude','keywordIncludeController');}"/><i class="icon-search" onclick="ajaxController('areasDetInclude','keywordIncludeController'));"></i>
										</span>
									</div>
                                    <div id="areasDetInclude" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div>
								</div>
							</div>
						</div>	
						<div class="col col-8 col-xs-12">
							<div class="row">
								<div class="col col-12 formDesignerButtons">
									<span class="btn green-jungle" onclick="rowAdd('detailRowsContent');">Satır Ekle</span>
									<span class="btn blue-sharp" onclick="colAdd();">Sütun Ekle</span>
								</div>
							</div>
							<div id="detailRowsContent" class="connectedRow"></div>					
						</div>
					</div>					
				</cfif>
				<cfif GET_WRK_FUSEACTIONS_data.event_dashboard eq 1>
					<div class="row content" id="dashboard">
						<div class="col col-4 col-xs-12">
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Components
										</span>
									</div>                 
									<div class="portBody connectedElementSortable" style="display: block;"> 
										<cfoutput query="GET_FORMS">
											<div class="form-group">
												<label>#COMPONENTNAME#</label>
											</div>
										</cfoutput>
									</div> 
								</div>
							</div>
							<div class="row">					
								<div class="portBox">
									<div class="workdevList-heading togglePort">
										<span class="btnPointer">
											<i class="icon-angle-down"></i>Other Components
										</span>
									</div>    
									<div class="workdevList-heading">
										<span class="btnPointer">
											<input type="text" name="keywordController" id="keywordController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasDash','keywordController');}"/><i class="icon-search" onclick="ajaxController('areasDash','keywordController');"></i>
										</span>
									</div>             
									<div id="areasDash" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div> 
								</div>
							</div>
							<div class="row">
								<div class="portBox">
									<div class="workdevList-heading">
										<span class="btnPointer togglePort">
											<i class="icon-angle-down"></i>Includes
										</span>
                                        <span class="btnPointer pull-right">
											<input type="text" name="keywordIncludeController" id="keywordIncludeController" placeHolder="Keyword" onKeyDown="if(event.keyCode == 13) {ajaxController('areasDashInclude','keywordIncludeController');}"/><i class="icon-search" onclick="ajaxController('areasDashInclude','keywordIncludeController');"></i>
										</span>
									</div>
                                    <div id="areasDashInclude" class="portBody connectedElementSortable scrollContent scroll-x2" style="display: block;"></div>
								</div>
							</div>
						</div>	
						<div class="col col-8 col-xs-12">
							<div class="row">
								<div class="col col-12 formDesignerButtons">
									<span class="btn green-jungle" onclick="rowAdd('detailRowsContent');">Satır Ekle</span>
									<span class="btn blue-sharp" onclick="colAdd();">Sütun Ekle</span>
								</div>
							</div>
							<div id="detailRowsContent" class="connectedRow"></div>					
						</div>
					</div>					
				</cfif>	
				<div class="row content" id="tab">
					<div class="col col-12 col-xs-12">
						<ul class="tabSorterList" tabSorterHeader>
							<li>
								<i class="icon-pluss font-green-haze" onclick="addTap();"></i>
								<div class="eName">
									Name
								</div>
								<div class="eType">
									TYPE
								</div>
								<div class="ePath">PATH / FILE</div>
							</li>
						</ul>
						<ul class="tabSorterList number" id="tabSorterArea">
							<li>
								<i class="icon-minus font-red-mint" onclick="delTap(this);"></i>
								<div class="eName">
									<div class="input-group">
										<input type="text" />
										<span class="input-group-addon btnPointer icon-ellipsis"></span>
									</div>
								</div>
								<div class="eType">
									<select>
										<option>Popup</option>
										<option>Link</option>
										<option>Modal</option>
										<option>İnclude</option>
									</select>
								</div>
								<div class="ePath"><input type="text" /></div>
								<i class="icon-sort"></i>
							</li>
						</ul>												
					</div>
				</div>					
			</div>
		</div>
	</div>
</div>
<div class="modal-footer"> <span class="btn green-haze pull-right">Save</span></div>
<!------------------------------------------ BASE COL  ------------------------------------------>
<div  id="baseDiv" style="display:none;">
    <div Base class="col col-3 col-xs-12 padding-5">
        <div class="sorterHead">
            <div class="pull-right colNumber">
                <select name="colSelect" id="colSelect" onchange="setColSettings(this);">
                    <cfoutput>
                        <cfloop index="ind" from="1" to="12">
                            <option value="col-#ind#" <cfif ind eq 3>selected</cfif>>col-#ind#</option>
                        </cfloop>
                    </cfoutput>
                </select>
            </div>
        </div>
        <div class="row">
        	<div class="connectedElementSortable border-2 dashed border-blue-sharp" style="min-height:30px;"></div> 
        </div>
	</div>
</div>
<!--- ---------------------------------------------------------------------------------------  --->


<!--- Js --->
<script type="text/javascript">
var sortableSettings = {						
	column	: {	
		connectWith		: '.connectedCol',
		cursor			: 'move',
		opacity			: '0.6',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());ui.placeholder.width(ui.helper.outerWidth());}
	},
		
	row		: {
		connectWith		: '.connectedRow',
		cursor			: 'move',
		opacity			: '0.6',
		placeholder		: 'rowSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());}
		  },	
		  
	element	: {
		connectWith		: '.connectedElementSortable',
		cursor			: 'move',
		opacity			: '0.6',
		placeholder		: 'elementSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());}
		  },
		  
	tab	: {	
		connectWith		: '#tabSorterArea',
		cursor			: 'move',
		handle			: '.icon-sort',
		opacity			: '0.6',
		placeholder		: 'elementSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());ui.placeholder.width(ui.helper.outerWidth());}
		}	
		  		
	}; // sort setting

	function setConnectSort(){
		
		$(".connectedRow").sortable(sortableSettings.row);	
		
		$(".connectedCol").sortable(sortableSettings.column);
		
		$(".connectedElementSortable").sortable(sortableSettings.element);
		
		$("#tabSorterArea").sortable(sortableSettings.tab);	
		
	}

	function rowActive(e){
		$( ".connectedRow>div" ).removeClass("formRowActive");
		$(e).addClass("formRowActive");	
	}//kolon eklemek icin akrif rowu secer
	
	function rowAdd(content){
		$( '#'+content+'>div').removeClass("formRowActive");
		$('<div>')
			.attr({id:'rowid',onclick:'rowActive(this);'})
			.addClass('border-2 dashed border-green-jungle formRowActive')
			.append(					
					$('<div>')
					.addClass("row connectedCol mainRow")
			)
			.appendTo('#'+content);	
			setConnectSort();		
	}//yeni row ekler
	
	function colAdd(){	
		$('.connectedRow .formRowActive .connectedCol').append($("#baseDiv").html());		
		setConnectSort();					
	}//aktif row icine yeni kolon ekler

	function setColSettings(element)
	{
		$($(element).closest('div[Base]').removeClass().addClass('padding-5 col col-xs-12 '+$(element).val()));
	}// kolonun genisligini belirler

	function addTap(){
				
		$('<li>')
			.append(
				$('<i>')
					.addClass('icon-minus font-red-mint').attr({onclick:'delTap(this);'}),
				$('<div>')
					.addClass('eName')
					.append(
						$('<div>')
						.addClass('input-group')
						.append(
							$('<input>').attr({type:'text',id:'filepath'}),
							$('<span>').addClass('input-group-addon btnPointer icon-ellipsis')
						)	
					),
				$('<div>')
					.addClass('eType')
					.append(
						$('<select>')
							.attr({id:'selecttype',name:'etype'})
							.append(
								$('<option>').attr({value:'1'}).append('Popup'),
								$('<option>').attr({value:'2'}).append('Link'),
								$('<option>').attr({value:'3'}).append('Modal'),
								$('<option>').attr({value:'4'}).append('İnclude')
							)
					),
				$('<div>')
					.addClass('ePath')
					.append(
						$('<input>').attr({type:'text',id:'filepath'})
					),
				$('<i>').addClass('icon-sort')				
			).appendTo('#tabSorterArea');
			
		setConnectSort()
		
	}//Yeni tab nesnesi ekler
	
	$(".togglePort").click(function() {
		console.log();
		if($(this).parent().hasClass('workdevList-heading'))
			eventNew = $(this).parent();
		else
			eventNew = $(this);
		$(eventNew).next('.portBody').slideToggle(500);
		var arrow = $(eventNew).find('i');
		if(arrow.hasClass("icon-angle-down"))
			{
				$(arrow).removeClass("icon-angle-down");
				$(arrow).addClass("icon-angle-right");
			}else{
				$(arrow).removeClass("icon-angle-right");
				$(arrow).addClass("icon-angle-down");				
			}				
	});//baslıgina tiklanana boxın body sinin gizler, akordion

	
	function delTap(e){
		var tab = $(e).parent();
		tab.remove();
		setConnectSort()
	}//Tabı Siler

	$(function() {		
		setConnectSort()		
	});//ready
	
	function ajaxController(divId,keyword)
	{
		getKeyWord = $("#"+divId).parent('div').find("input#"+keyword).val();
		if(keyword == 'keywordController')
			method = 'GET_COMPONENTS_JSON';
		else
			method = 'GET_COMPONENT_OBJECT_JSON';

		$.ajax({ 
		url :'cfc/system.cfc?method='+method, data : {userFriendly : '<cfoutput>#attributes.userFriendly#</cfoutput>',other :1, keyword : getKeyWord}, 
		async:false,
		success : function(res){ 
									if ( res ) 
									{ 
										data = res; 
										$("#"+divId).html('');
										newData = $.parseJSON(data);
										for(i=0;i<newData.DATA.length;i++)
											$("<label>").html(newData.DATA[i][0]+ '/ ' + newData.DATA[i][2]).appendTo($("<div>").attr({class : 'form-group'}).appendTo($("#"+divId)));
										if($("#"+divId).css('display') == 'none')
											$("#"+divId).css('display','block');
									}
								} 
			
		});
	}
</script>
--->