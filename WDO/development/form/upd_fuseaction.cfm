<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat" default="">
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>
<cfset process_type_list = list_wbo.getProcessTypes()>
<cfif not isdefined("attributes.woid")>
    <cfset attributes.woid = list_wbo.getWrkObjectsId('#DSN#','#attributes.fuseact#')>
</cfif>
<cfset GET_WRK_FUSEACTIONS = list_wbo.getWrkFuesactions('#DSN#','#attributes.woid#')>
<cfset RELATED_PROCESS_CAT = list_wbo.getRelatedProcessCat('#DSN#','#attributes.woid#')>
<cfset GET_MODULES = list_wbo.getWbo('#dsn#')>
<cfset wbo_type_list = list_wbo.getWboTypeList('#GET_WRK_FUSEACTIONS.TYPE#','#GET_WRK_FUSEACTIONS.IS_ADD#','#GET_WRK_FUSEACTIONS.IS_UPDATE#','#GET_WRK_FUSEACTIONS.IS_DELETE#')>
<cfset getSolution = list_wbo.getSolution()>
<cfform name="updFuseactionForm" method="post" action="#request.self#?fuseaction=dev.emptypopup_upd_fuseaction">
<div class="row">
	<div class="col col-6 col-xs-12">
        <div class="form-inline">
                <div class="form-group">
                    <label>Status</label>
                    <div class="input-group">
                        <select name="status" id="status">
                            <option value="Analys"<cfif get_wrk_fuseactions.status eq 'Analys'>selected</cfif>>Analys</option>
                            <option value="Deployment"<cfif get_wrk_fuseactions.status eq 'Deployment'>selected</cfif>>Deployment</option>
                            <option value="Design"<cfif get_wrk_fuseactions.status eq 'Design'>selected</cfif>>Design</option>
                            <option value="Development"<cfif get_wrk_fuseactions.status eq 'Development'>selected</cfif>>Development</option>
                            <option value="Testing"<cfif get_wrk_fuseactions.status eq 'Testing'>selected</cfif>>Testing</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Stage</label>
                    <div class="input-group">
                        <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <label>
                            <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_wrk_fuseactions.is_active eq 1>checked="checked"</cfif>>
                            Active
                        </label>
                    </div>
                </div>
		</div>
    </div>
</div>
<div class="row">
    <div class="col col-4 col-xs-12">
        <div class="form-group">
            <label class="col col-2 col-xs-12">Events : </label>
            <div class="col col-9 col-xs-12">
                <label>
                    <input type="checkbox" name="eventAdd" id="eventAdd" value="1" <cfif get_wrk_fuseactions.event_add eq 1>checked="checked"</cfif>>
                    Add
                </label> 
                <label>
                    <input type="checkbox" name="eventUpd" id="eventUpd" value="1" <cfif get_wrk_fuseactions.event_upd eq 1>checked="checked"</cfif>>
                    Upd
                </label> 
                <label>
                    <input type="checkbox" name="eventList" id="eventList" value="1" <cfif get_wrk_fuseactions.event_list eq 1>checked="checked"</cfif>>
                    List
                </label>
                <label>
                    <input type="checkbox" name="eventDetail" id="eventDetail" value="1" <cfif get_wrk_fuseactions.event_detail eq 1>checked="checked"</cfif>>
                    Detail
                </label>
                <label>
                    <input type="checkbox" name="eventDashboard" id="eventDashboard" value="1" <cfif get_wrk_fuseactions.event_dashboard eq 1>checked="checked"</cfif>>
                    Dashboard
                </label>
            </div>
        </div>
    </div>
</div>
<div class="row">
	<div class="col col-8 col-xs-12">        
        <div class="row">
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Head</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="text" name="head" id="head" value="#get_wrk_fuseactions.head#">
                                <input type="hidden" name="dictionary_id"  id="dictionary_id" value="#get_wrk_fuseactions.dictionary_id#">
                                <input type="hidden" name="woid"  id="woid" value="#attributes.woid#">
                                <span class="input-group-addon">
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=upd_faction.dictionary_id&lang_item_name=upd_faction.head','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                </span>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">User Friendly URL</label>
                    <div class="col col-9 col-xs-12">
                        <cfoutput>
                            <input type="text" name="friendly_url" id="friendly_url" value="#get_wrk_fuseactions.friendly_url#" />
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Fuseaction</label>
                    <div class="col col-9 col-xs-12">
                        <cfoutput>
                            <input type="text" name="fuseaction_name" id="fuseaction_name" value="#get_wrk_fuseactions.fuseaction#" maxlength="100">
                            <input type="hidden" name="old_fuseaction" id="old_fuseaction" value="#get_wrk_fuseactions.fuseaction#">
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Author</label>
                    <div class="col col-9 col-xs-12">
						<cfoutput>
                            <input type="hidden" name="author_emp_id" id="author_emp_id" value="#get_wrk_fuseactions.author#">
                            <input type="text" name="author_name" id="author_name" value="#get_wrk_fuseactions.AUTHOR_NAME#">
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Solution</label>
                    <div class="col col-9 col-xs-12">
                        <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')">
                        	<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="getSolution">
                                <option value="#WRK_SOLUTION_ID#" <cfif get_wrk_fuseactions.SOLUTION_ID eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Family</label>
                    <div class="col col-9 col-xs-12">
                        <select id="family" name="family" onchange="loadModules(this.value,'module')">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Module</label>
                    <div class="col col-9 col-xs-12">
                        <select id="module" name="module">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Type</label>
                    <div class="col col-9 col-xs-12">
                        <select id="objectType" name="objectType">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="1" <cfif get_wrk_fuseactions.object_Type eq 1>selected</cfif>>Standart</option>
                            <option value="2" <cfif get_wrk_fuseactions.object_Type eq 2>selected</cfif>>AddOn</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Security</label>
                    <div class="col col-9 col-xs-12">
                        <select name="security" id="security">
                            <option value="HTTP"<cfif get_wrk_fuseactions.security eq 'HTTP'>selected</cfif>>HTTP</option>
                            <option value="HTTPS"<cfif get_wrk_fuseactions.security eq 'HTTPS'>selected</cfif>>HTTPS</option>
                            <option value="FTP"<cfif get_wrk_fuseactions.security eq 'FTP'>selected</cfif>>FTP</option>
                            <option value="FTPS"<cfif get_wrk_fuseactions.security eq 'FTPS'>selected</cfif>>FTPS</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-xs-12">Version</label>
                    <div class="col col-9 col-xs-12">
                        <cfoutput>
                            <input type="text" name="version" id="version" value="#get_wrk_fuseactions.version#">
                        </cfoutput>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col col-3 col-xs-12">
                <div class="form-group">
                    <label class="col col-5 col-xs-12">
                        İşlem Tipi 
                        <input type="checkbox" class="pull-right" name="use_process_cat" id="use_process_cat" value="1" onchange="show_process_cat(this.value,process_cat);" <cfif get_wrk_fuseactions.use_process_cat eq 1>checked="checked"</cfif>>
                    </label>
                   <div class="col col-7 col-xs-12">
                        <cf_multiselect_check
                            name="process_cat"
                            option_name="PROCESS_CAT"
                            option_value="PROCESS_CAT_ID"
                            query_name="process_type_list"
                            value="#valuelist(RELATED_PROCESS_CAT.process_cat)#"
                            >
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12">
                        Süreç Kullan 
                        <input type="checkbox" class="pull-right" name="use_workflow" id="use_workflow" value="1" <cfif get_wrk_fuseactions.use_workflow eq 1>checked="checked"</cfif>>
                    </label>
                    <label class="col col-5 col-xs-12">
                    	Sistem No Kullan 
                        <input type="checkbox" class="pull-right" name="use_system_no" id="use_system_no" value="1" <cfif get_wrk_fuseactions.use_system_no eq 1>checked="checked"</cfif>>
                     </label>
                </div>
            </div>
        </div>
        
        <div class="row" style="width:550px;margin-left:6px;" id="clickme">Detail</div> 
        <input type="hidden" name="detail_old_length" id="detail_old_length" value="<cfoutput>#len(get_wrk_fuseactions.detail)#</cfoutput>">                               
        <div style="width:550px;margin-left:6px;" id="editor_id">
            <cfmodule template="../../fckeditor/fckeditor.cfm"
                toolbarset="Basic"
                basepath="/fckeditor/"
                instancename="work_detail"
                valign="top"
                value="#get_wrk_fuseactions.detail#"
                width="580"
                height="180"> 
        </div>
    </div>
</div>
<div class="row">
    <div class="col pull-right">
        <input type="button" name="Kaydet" value="Kaydet" onclick="OnFormSubmit();"/>
    </div>
</div>
<div id="fuseactionControlDiv" style="display:none;"></div>
</cfform>
<script language="JavaScript">
function loadFamilies(solutionId,target,related,selected)
{
	$('#'+related+" option[value!='']").remove();
	$.ajax({
		  url: '/V16/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
function loadModules(familyId,target,selected)
{
	$.ajax({
		  url: '/V16/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
$(function(){
		showPopupInfo();
		<cfif len(get_wrk_fuseactions.SOLUTION_ID) and len(get_wrk_fuseactions.FAMILY_ID)>
			loadFamilies('<cfoutput>#get_wrk_fuseactions.SOLUTION_ID#</cfoutput>','family','module','<cfoutput>#get_wrk_fuseactions.FAMILY_ID#</cfoutput>');
			loadModules('<cfoutput>#get_wrk_fuseactions.FAMILY_ID#</cfoutput>','module','<cfoutput>#get_wrk_fuseactions.MODULE_NO#</cfoutput>');
		</cfif>
		
		});
function showPopupInfo()
{
	if($("#window_name").val() == 'popup')
	{
		$(".popupInfo").show();
	}
	else
	{
		$(".popupInfo").hide();
		$("#popupInfoType").val('');
	}
}
function OnFormSubmit()
{
	AjaxFormSubmit('updFuseactionForm','fuseactionControlDiv',1,'Güncelleniyor','Güncellendi','','',1);
	return false;
}
</script>
