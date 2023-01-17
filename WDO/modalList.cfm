<div class="row">
    <div class="col col-12 formDesignerButtons">
        <label>
            List Name 
            <input type="text" name="modelFormName" id="modelFormName" />
        </label>
        <label>
            Author
            <input type="text" name="componentAuthor" id="componentAuthor" />
        </label>
        <label>
            <span class="btn btn-small green-haze"  onclick="saveControl()">Save</span>
        </label>
    </div>
</div>
<div class="row">
    <div class="col col-12 col-xs-12">
        <div id="rowsContent" class="connectedRow">
            <div id="rowid" onclick="rowActive(this);" class="border-2 dashed border-green-jungle formRowActive">
                <div class="row connectedCol mainRow ui-sortable">
                    <div Base class="col col-4 col-xs-12 padding-5">
                        <div class="sorterHead">
                            <label>List</label>
                        </div>
                        <div class="row">
                            <div class="connectedElementSortable connectedList border-2 dashed border-blue-sharp" style="min-height:30px;">
                            	<cfquery name="GET_LIST_OBJECT" datasource="#DSN#">
                                	SELECT 
                                        MR.ELEMENTNAME,
                                        MR.ELEMENTTYPE,
                                        MR.ELEMENTDATATYPE,
										M.MODELID  
                                    FROM 
                                        MODEL AS M
                                        LEFT JOIN MODELROW AS MR ON MR.MODELID = M.MODELID
                                    WHERE 
                                        M.MODELUSERFRIENDLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.userFriendly#">
                                        AND MR.ELEMENTLIST = 1
                                </cfquery>
                                <cfoutput query="GET_LIST_OBJECT">
                                    <div class="form-group">
                                        <label class="col col-3 col-xs-12"><input type="checkbox" name="elementCheckbox" checked="checked"/><input type="hidden" name="modelId" value="#MODELID#"/><span>#ELEMENTNAME#</span></label>
                                        <div class="col col-9 col-xs-12">
                                            <cfswitch expression="#ELEMENTTYPE#">
                                                <cfcase value="1">
                                                    <cfif ELEMENTDATATYPE eq 3>
                                                        <div class="input-group">
                                                            <input type="text" />
                                                            <span class="input-group-addon icon-calendar-o"></span>
                                                        </div>
                                                    <cfelse>
                                                        <input type="text" />
                                                    </cfif>
                                                </cfcase>
                                                <cfcase value="2">Hidden</cfcase>
                                                <cfcase value="3"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="4"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="5"><textarea></textarea></cfcase>
                                                <cfcase value="6"><input type="radio" /></cfcase>
                                                <cfcase value="7"><input type="checkbox" /></cfcase>
                                                <cfcase value="8">Upload</cfcase>
                                                <cfcase value="9">Image</cfcase>
                                                <cfcase value="10">Button</cfcase>
                                                <cfcase value="11">Text</cfcase>
                                                <cfcase value="12">Custom Tag</cfcase>
                                                <cfdefaultcase><input type="text" /></cfdefaultcase>
                                            </cfswitch>
                                        </div>
                                    </div>
                                </cfoutput>
                            </div> 
                        </div>
                    </div>
                    <div Base class="col col-4 col-xs-12 padding-5">
                        <div class="sorterHead">
                            <label>Search</label>
                        </div>
                        <div class="row">
                            <div class="connectedElementSortable connectedSearch border-2 dashed border-blue-sharp" style="min-height:30px;">
                                <cfquery name="GET_SEARCH_OBJECT" datasource="#DSN#">
                                	SELECT 
                                        MR.ELEMENTNAME,
                                        MR.ELEMENTTYPE,
                                        MR.ELEMENTDATATYPE,
										M.MODELID  
                                    FROM 
                                        MODEL AS M
                                        LEFT JOIN MODELROW AS MR ON MR.MODELID = M.MODELID
                                    WHERE 
                                        M.MODELUSERFRIENDLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.userFriendly#">
                                        AND MR.ELEMENTSEARCH = 1
                                </cfquery>
                                <cfoutput query="GET_SEARCH_OBJECT">
                                    <div class="form-group">
                                        <label class="col col-3 col-xs-12"><input type="checkbox" name="elementCheckbox" checked="checked"/><input type="hidden" name="modelId" value="#MODELID#"/><span>#ELEMENTNAME#</span></label>
                                        <div class="col col-9 col-xs-12">
                                            <cfswitch expression="#ELEMENTTYPE#">
                                                <cfcase value="1">
                                                    <cfif ELEMENTDATATYPE eq 3>
                                                        <div class="input-group">
                                                            <input type="text" />
                                                            <span class="input-group-addon icon-calendar-o"></span>
                                                        </div>
                                                    <cfelse>
                                                        <input type="text" />
                                                    </cfif>
                                                </cfcase>
                                                <cfcase value="2">Hidden</cfcase>
                                                <cfcase value="3"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="4"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="5"><textarea></textarea></cfcase>
                                                <cfcase value="6"><input type="radio" /></cfcase>
                                                <cfcase value="7"><input type="checkbox" /></cfcase>
                                                <cfcase value="8">Upload</cfcase>
                                                <cfcase value="9">Image</cfcase>
                                                <cfcase value="10">Button</cfcase>
                                                <cfcase value="11">Text</cfcase>
                                                <cfcase value="12">Custom Tag</cfcase>
                                                <cfdefaultcase><input type="text" /></cfdefaultcase>
                                            </cfswitch>
                                        </div>
                                    </div>
                                </cfoutput>
                            </div> 
                        </div>
                    </div>
                    <div Base class="col col-4 col-xs-12 padding-5">
                        <div class="sorterHead">
                        	<label>Filter</label>
                        </div>
                        <div class="row">
                            <div class="connectedElementSortable connectedFilter border-2 dashed border-blue-sharp" style="min-height:30px;">
                            	<cfquery name="GET_FILTER_OBJECT" datasource="#DSN#">
                                	SELECT 
                                        MR.ELEMENTNAME,
                                        MR.ELEMENTTYPE,
                                        MR.ELEMENTDATATYPE,
										M.MODELID 
                                    FROM 
                                        MODEL AS M
                                        LEFT JOIN MODELROW AS MR ON MR.MODELID = M.MODELID
                                    WHERE 
                                        M.MODELUSERFRIENDLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.userFriendly#">
                                        AND MR.ELEMENTFILTER = 1
                                </cfquery>
                                <cfoutput query="GET_FILTER_OBJECT">
                                    <div class="form-group">
                                        <label class="col col-3 col-xs-12"><input type="checkbox" name="elementCheckbox" checked="checked"/><input type="hidden" name="modelId" value="#MODELID#"/><span>#ELEMENTNAME#</span></label>
										<div class="col col-9 col-xs-12">
                                            <cfswitch expression="#ELEMENTTYPE#">
                                                <cfcase value="1">
                                                    <cfif ELEMENTDATATYPE eq 3>
                                                        <div class="input-group">
                                                            <input type="text" />
                                                            <span class="input-group-addon icon-calendar-o"></span>
                                                        </div>
                                                    <cfelse>
                                                        <input type="text" />
                                                    </cfif>
                                                </cfcase>
                                                <cfcase value="2">Hidden</cfcase>
                                                <cfcase value="3"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="4"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                                <cfcase value="5"><textarea></textarea></cfcase>
                                                <cfcase value="6"><input type="radio" /></cfcase>
                                                <cfcase value="7"><input type="checkbox" /></cfcase>
                                                <cfcase value="8">Upload</cfcase>
                                                <cfcase value="9">Image</cfcase>
                                                <cfcase value="10">Button</cfcase>
                                                <cfcase value="11">Text</cfcase>
                                                <cfcase value="12">Custom Tag</cfcase>
                                                <cfdefaultcase><input type="text" /></cfdefaultcase>
                                            </cfswitch>
                                        </div>
                                    </div>
                                </cfoutput>
                            </div> 
                        </div>
                    </div>
                </div>
            </div>
        </div>        
    </div> 
</div>
<!--- Js --->
<script type="text/javascript">
var sortableSettings = {	  
	element	: {
		connectWith		: '.connectedList',
		cursor			: 'move',
		opacity			: '0.6',
		placeholder		: 'elementSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());}
		  },
	elementSearch	: {
		connectWith		: '.connectedSearch',
		cursor			: 'move',
		opacity			: '0.6',
		placeholder		: 'elementSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());}
		  },
	elementFilter	: {
		connectWith		: '.connectedFilter',
		cursor			: 'move',
		opacity			: '0.6',
		placeholder		: 'elementSortArea',
		revert			: 300,
		start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());}
		  }
		}; // sortableSettings 		items:'div[type="columnSort"]', handle:'.handle',


	function setConnectSort(){
		
		$(".connectedList").sortable(sortableSettings.element);
		$(".connectedSearch").sortable(sortableSettings.elementSearch);
		$(".connectedFilter").sortable(sortableSettings.elementFilter);
	}
	
	$( window ).resize(function() {
		var h =$( window ).height()-65+"px"
		$(".elementCol").css("max-height",h)
	});//element listesi scroll icin gerekli height tı belirler
	
	$(function() {		
		setConnectSort()
		var h =$( window ).height()-65+"px"
		$(".elementCol").css("max-height",h)//element listesi scroll icin gerekli height tı belirler
	});//ready
	
	
function saveControl()
	{
		var pageSettingsModal = new Object();
		var counterRow = 0;
		var counterCol = 0;
		var counterDiv = 0;
		$("#rowsContent").find('div').each(function(indexRow,elementRow){
			if($(elementRow).hasClass("mainRow"))
			{
				pageSettingsModal[counterRow] = new Object();
				counterCol = 0;
				$(elementRow).find('div[Base]').each(function(indexCol,elementCol){
					if($(elementCol).find('div.form-group').length != 0)
					{
						pageSettingsModal[counterRow][counterCol] = new Object();
						pageSettingsModal[counterRow][counterCol]['items'] = new Object();
						
						pageSettingsModal[counterRow][counterCol]['size'] = $(elementCol).find('#colSelect').val();
						counterDiv = 0;
						$(elementCol).find('div.form-group').each(function(indexDiv,elementDiv){
							if($(elementDiv).find('input[type=checkbox]').prop('checked'))
							{
								pageSettingsModal[counterRow][counterCol]['items'][counterDiv] = $(elementDiv).find("label").text();
								counterDiv = counterDiv + 1;
							}
						})
						counterCol = counterCol + 1;
					}
				})
				counterRow = counterRow + 1;
			}
		})
		
		//console.log(pageSettingsModal);
		modelListName = $("#modelFormName").val();
		componentAuthor = $("#componentAuthor").val();
		$.ajax({
			async: false,
			url: '<cfoutput>#request.self#?fuseaction=objects.saveResult&ajax=1&xmlhttp=1&userFriendly=#userFriendly#&modelFormName='+modelListName+'&componentAuthor='+componentAuthor+'&_cf_nodebug=true&fromList=1&data=</cfoutput>'+encodeURIComponent(JSON.stringify(pageSettingsModal)),
			type: "POST",
			success: function(responseData, status, jqXHR)
			{ 
				console.log(responseData)
			},
			error: function(xhr, opt, err)
			{
				// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
				ajax_request_script(xhr.responseText.replace(/\u200B/g,''));
			},
			dataType: "json",
			contentType: "application/json"
		});
	}	
</script>