<cf_get_lang_set module_name="ehesap">
<div class="color-list" id="color_list"></div>
<div class="color-border" id="color_border"></div>
<script src="/js/jquery-1_7_1_min.js" type="text/javascript"></script>
<script type="text/javascript">
    function getCSSColors()
    {
		try
		{
			var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
			var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
			var flashObj = document.offtime_graph ? document.offtime_graph: document.getElementById("offtime_graph");
			if (flashObj) flashObj.applyCSS(bg_color, border_color);
		} catch (e) { }
    }
	
	function rgbToHex(value)
	{
		if (value.search("rgb") == -1)
            return value;
        else {
            value = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
            function hex(x) {
                return ("0" + parseInt(x).toString(16)).slice(-2);
            }
            return "#" + hex(value[1]) + hex(value[2]) + hex(value[3]);
        }
	}
</script>
<cfparam name="attributes.izin_type" default="0">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.parent_position_code" default="#session.ep.position_code#">
<cfparam name="attributes.display_mode" default="1">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.off_validate" default="0">
<cfparam name="attributes.startdate" default="#dateformat((date_add("m",-1,CreateDate(year(now()),month(now()),1))))#">
<cfparam name="attributes.finishdate" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#"> 
<cfif isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfinclude template="../query/get_offtime_cats.cfm">
<cfform name="filter_offtime" action="#request.self#?fuseaction=#fusebox.circuit#.offtime_graph" method="post">
<input type="hidden" name="parent_position_code" id="parent_position_code" value="<cfif isdefined("attributes.parent_position_code")><cfoutput>#attributes.parent_position_code#</cfoutput><cfelseif fusebox.circuit is 'myhome'><cfoutput>#session.ep.position_code#</cfoutput></cfif>">
<input type="hidden" name="display_mode" id="display_mode" value="<cfif isdefined("attributes.display_mode")><cfoutput>#attributes.display_mode#</cfoutput><cfelseif fusebox.circuit is 'myhome'>1</cfif>">
<input type="hidden" name="form_submit" id="form_submit" value="1">
<input type="hidden" name="valid" id="valid" value="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53025.İzin Çizelgesi"></cfsavecontent>
<cf_big_list_search title="#message#">
	<cf_big_list_search_area>
		<div class="row"> 
            <div class="col col-12 form-inline">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
						<input type="text" name="employee_name" id="employee_name" style="width:100px;" value="<cfoutput>#attributes.employee_name#</cfoutput>" placeholder="<cfoutput>#message#</cfoutput>">
						<cfif fusebox.circuit eq 'myhome'>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=filter_offtime.employee_id&field_name=filter_offtime.employee_name&call_function=change_upper_pos_codes()&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1','list');"></span>
						<cfelse>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emps&conf_=1&field_id=filter_offtime.employee_id&field_name=filter_offtime.employee_name','list');"></span>
						</cfif>						
					</div>						
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
						<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
							<cfinput type="text" name="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
                </div>
				<div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
						<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
							<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
                </div>
				
				<div class="form-group">
                    <cf_wrk_search_button search_function='change_action()' is_excel="0">
                </div>
            </div>
        </div>
	</cf_big_list_search_area>
	<cfif fusebox.circuit neq 'myhome'>
	<cf_big_list_search_detail_area>
		<div class="row" type="row">
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group">
                    <label class="col col-12"><cf_get_lang dictionary_id="54109.İzin Kategorisi"></label>
                    <div class="col col-12">
						<select name="izin_type" id="izin_type">
							<option value="0" <cfif attributes.izin_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'></option>
							<option value="1" <cfif attributes.izin_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='53991.İzin Talepleri'></option>
							<option value="2" <cfif attributes.izin_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='53992.İK İzinler'></option>
						</select>
                    </div>
                </div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group">
                    <label class="col col-12"><cf_get_lang dictionary_id="53991.İzin Talepleri"></label>
                    <div class="col col-12"> 
						<select name="offtimecat_id" id="offtimecat_id" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
							<cfoutput query="get_offtime_cats">
								<option value="#offtimecat_id#"<cfif isdefined('attributes.offtimecat_id') and (attributes.offtimecat_id eq offtimecat_id)> selected</cfif>>#offtimecat#</option>
							</cfoutput>
						</select>
                    </div>
                </div>
            </div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group">
                    <label class="col col-12"><cf_get_lang dictionary_id="53042.Onay Durumu"></label>
                    <div class="col col-12">
						<select name="off_validate" id="off_validate">
							<option value="0" <cfif attributes.off_validate eq 0>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'></option>
							<option value="1" <cfif attributes.off_validate eq 1>selected</cfif>><cf_get_lang dictionary_id ='58699.Onaylandı'></option>
							<option value="2" <cfif attributes.off_validate eq 2>selected</cfif>><cf_get_lang dictionary_id ='57617.Reddedildi'></option>
							<option value="3" <cfif attributes.off_validate eq 3>selected</cfif>><cf_get_lang dictionary_id ='53993.Onay Bekleyen'></option>
						</select>
                    </div>
                </div>
			</div>
			<cfif fusebox.circuit neq 'myhome'>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id="57453.Şube"></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" style="width:150px;" onchange="showDepartment(this.value)">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_our_comp_and_branchs" group="branch_id">
									<option value="#branch_id#"<cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="DEPARTMENT_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
						<div class="col col-12">
							<select name="department" id="department" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
									<cfquery name="get_department" datasource="#dsn#">
										SELECT 
											DEPARTMENT_STATUS,
											IS_PRODUCTION,
											IS_STORE,
											BRANCH_ID,
											DEPARTMENT_ID,
											DEPARTMENT_HEAD,
											DEPARTMENT_DETAIL,
											ADMIN1_POSITION_CODE,
											ADMIN2_POSITION_CODE,
											HIERARCHY_DEP_ID,
											HIERARCHY, 
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP,
											UPDATE_DATE, 
											UPDATE_EMP,
											UPDATE_IP,
											IS_ORGANIZATION, 
											HEADQUARTERS_ID,
											OUR_COMPANY_ID,
											ZONE_ID,
											X_COORDINATE,
											Y_COORDINATE,
											Z_COORDINATE,
											WIDTH,
											HEIGHT,
											DEPTH 
										FROM 
											DEPARTMENT 
										WHERE 
											BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS = 1 <!--- AND IS_STORE <>1 ---> 
										ORDER BY 
											DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_department">
										<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
			</cfif>
        </div>
	</cf_big_list_search_detail_area>
    </cfif>
</cf_big_list_search>
</cfform>
<table width="99%" height="90%" align="center">
	<tr valign="top">	
		<td>  
		<div style="position:absolute;top: 170px;left: 60px;right: 13px;bottom:0px;"> 
		<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&recordEmpID=#session.ep.userid#&language=#session.ep.language#">
		<cfif len(attributes.izin_type)><cfset flash_variables = "#flash_variables#&offtimeType=#attributes.izin_type#"></cfif>
		<cfif isDefined("attributes.offtimecat_id") and len(attributes.offtimecat_id)><cfset flash_variables = "#flash_variables#&categoryID=#attributes.offtimecat_id#"></cfif>
		<cfif len(attributes.branch_id)><cfset flash_variables = "#flash_variables#&branchID=#attributes.branch_id#"></cfif>
		<cfif len(attributes.department)><cfset flash_variables = "#flash_variables#&departmentID=#attributes.department#"></cfif>
		<cfif len(attributes.keyword)><cfset flash_variables = "#flash_variables#&keyword=#attributes.keyword#"></cfif>
		<cfif len(attributes.employee_id)><cfset flash_variables = "#flash_variables#&employeeID=#attributes.employee_id#"></cfif>
		<cfif len(attributes.employee_name)><cfset flash_variables = "#flash_variables#&employeeName=#attributes.employee_name#"></cfif>
		<cfif len(attributes.off_validate)><cfset flash_variables = "#flash_variables#&validation=#attributes.off_validate#"></cfif>
		<cfif len(attributes.startdate)><cfset flash_variables = "#flash_variables#&startDate=#dateformat(attributes.startdate,dateformat_style)#"></cfif>
		<cfif len(attributes.finishdate)><cfset flash_variables = "#flash_variables#&finishDate=#dateformat(attributes.finishdate,dateformat_style)#"></cfif>
		<cfif fusebox.circuit is 'myhome' and isDefined("attributes.parent_position_code") and len(attributes.parent_position_code)><cfset flash_variables = "#flash_variables#&parentPositionCode=#attributes.parent_position_code#"></cfif>
		<cfif fusebox.circuit is 'myhome' and isDefined("attributes.display_mode") and attributes.display_mode is "1"><cfset flash_variables = "#flash_variables#&displayMode=1"></cfif>
		<script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
		<script type="text/javascript">
		AC_FL_RunContent
			( 
				'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0',
				'width','100%',
				'height','95%',
				'src','/V16/com_mx/offtime_graph',
				'quality','high',
				'wmode','opaque',
				'pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash',
				'movie','/V16/com_mx/offtime_graph',
				'id', 'offtime_graph',
				'name', 'offtime_graph',
				'flashvars',
				"<cfoutput>#flash_variables#</cfoutput>", 
				'allowScriptAccess','always'
			); //end AC code
		</script>
		<noscript>
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="95%" id="offtime_graph" name="offtime_graph">
			<param name="movie" value="/V16/com_mx/offtime_graph.swf" />
			<param name="quality" value="high" />
			<param name="wmode" value="opaque" />
			<param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
			<param name="allowScriptAccess" value="always"/>
			<embed src="/V16/com_mx/offtime_graph.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="95%" flashvars="<cfoutput>#flash_variables#</cfoutput>"></embed>
			</object>
		</noscript>
        </div>
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
document.getElementById('keyword').focus();
function showDepartment(branch_id)	
{
	var branch_id = document.filter_offtime.branch_id.value;
	if (branch_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
}

function offtime_valid(valid_type_,offtime_id_)
{
	div_id = 'offtime_valid'+offtime_id_;
	var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.emptypopup_ajax_offtime_valid&valid_type='+ valid_type_ +'&offtime_id='+offtime_id_;
	AjaxPageLoad(send_address,div_id,1);
}
function change_action()
{
	filter_offtime.action='<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.offtime_graph</cfoutput>';
	filter_offtime.target='';
	return true;
}
function send_pdf_print()
{
	windowopen('','page','print_window');
	filter_offtime.action='<cfoutput>#request.self#?fuseaction=ehesap.popup_offtimes_pdf_print</cfoutput>';
	filter_offtime.target='print_window';
	filter_offtime.submit();
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
