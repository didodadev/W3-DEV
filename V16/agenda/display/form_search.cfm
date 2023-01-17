<!---E.A 17.07.2012 select ifadeleri düzenlendi--->
<cfquery name="get_process_types" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%agenda.form_add_event%">
</cfquery>
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.event_id" default="">
<cfparam name="attributes.event_result_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfinclude template="../query/get_event_cats.cfm">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT ORDER BY DEPARTMENT_ID
</cfquery>
<cfform name="search" method="post" action="#request.self#?fuseaction=agenda.search">
<input type="hidden" name="form_varmi" id="form_varmi" value="1">
<cf_box_search plus="0"> 
	<div class="form-group">
		<cfinput type="text" name="keyword" value="#attributes.keyword#" message="#getLang('','Geçerlilik',40906)#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
	</div>
	<div class="form-group medium">
		<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
		<div class="input-group">
        <input type="text" name="project_head" id="project_head" placeholder="<cf_get_lang_main no='4.Proje'>" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head")><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','130');" autocomplete="off">
		<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
		</div>
	</div>
	<div class="form-group medium">
		<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
			<option value="all"><cf_get_lang_main no='41.Şube'></option>
			<cfoutput query="get_branches" group="NICK_NAME">
				<optgroup label="#NICK_NAME#"></optgroup>
				<cfoutput>
					<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
				</cfoutput>
			</cfoutput>
		</select>	
	</div>
	<div class="form-group">
		<div style="width:150px;" id="department_place">
			<select name="department" id="department" style="width:150px;">
				<option value="all"><cf_get_lang_main no='160.Departman'></option>
				<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
					<cfquery name="get_departmant" datasource="#dsn#">
						SELECT 
							DEPARTMENT_STATUS, 
							BRANCH_ID, 
							DEPARTMENT_ID, 
							DEPARTMENT_HEAD, 
							HIERARCHY, 
							RECORD_DATE, 
							RECORD_EMP, 
							RECORD_IP, 
							UPDATE_DATE, 
							UPDATE_EMP, 
							UPDATE_IP, 
							OUR_COMPANY_ID
						FROM 
							DEPARTMENT 
						WHERE 
							DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
					</cfquery>
					<cfoutput query="get_departmant">
						<option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.department_id)>selected</cfif>>#department_head#</option>
					</cfoutput>
				</cfif>
			</select>
	   </div>
	</div>
	<div class="form-group">	
		<select name="process_stage" id="process_stage" style="width:130px">
		<option value=""><cf_get_lang_main no='1447.Süreç'></option>
		<cfoutput query="GET_PROCESS_TYPES">
			<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and attributes.process_stage eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
		</cfoutput>
	  </select>
    </div>
	<div class="form-group small"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
	</div>
	<div class="form-group">
		<cf_wrk_search_button button_type="4">
	</div>
	</cf_box_search> 
<cf_box_search_detail>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort=true>
			<div class="form-group" id="item-member_name">
				<label class="col col-12"><cf_get_lang_main no='1983.Katılımcı'></label>
				<div class="col col-12">
					<div class="input-group">
						<cfoutput>
							<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
							<input type="hidden" name="par_id" id="par_id" value="#attributes.par_id#">
							<input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
							<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
							<input type="text" name="member_name" id="member_name" value="#attributes.member_name#" style="width:130px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','par_id,cons_id,emp_id,member_type','','3','225');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search.emp_id&field_name=search.member_name&field_type=search.member_type&field_partner=search.par_id&field_consumer=search.cons_id&select_list=1,7,8','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1983.Katılımcı'>"></span>
							</cfoutput>
					</div>
				</div>
			</div>			
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort=true>
		<div class="form-group" id="item-member_name">
			<label class="col col-12">Tutanak</label>
			<div class="col col-12">
				<div class="input-group">
					<select name="is_event_result" id="is_event_result" style="width:130px;">                            	
						<option selected value=""><cf_get_lang_main no ='296.Tümü'></option>
						<option value="1" <cfif isDefined('attributes.is_event_result') and attributes.is_event_result eq 1> selected</cfif>>Tutanak Girilmiş</option>
						<option value="0" <cfif isdefined('attributes.is_event_result') and attributes.is_event_result eq 0>selected</cfif>>Tutanak Girilmemiş</option>
					</select>
				</div>
			</div>
		</div>
	    </div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort=true>
			<div class="form-group" id="item-eventcat_id">
				<label class="col col-12"><cfoutput>#getLang('agenda',26,'Olay Kategorisi')#</cfoutput></label>
				<div class="col col-12">
					<div class="input-group">
						<cf_multiselect_check
						name="eventcat_id"
						width="130"
						query_name="get_event_cats"
						option_name="eventcat"
						option_value="eventcat_id"
						value="#attributes.eventcat_id#">
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort=true>
			<div class="form-group" id="item-date">
				<label class="col col-12"><cf_get_lang_main no='243.Başlangıç Tarihi'></label>
				<div class="col col-12">
					<div class="col col-6">
						<div class="input-group" id="item-startdate1">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç tarihini yazınız !'></cfsavecontent>
								<cfif isdefined("attributes.startdate1") and isdate(attributes.startdate1)>
									<cfinput type="text" name="startdate1" id="startdate1" value="#dateformat(attributes.startdate1,dateformat_style)#" maxlength="10" onChange="CDate(1)" message="#message#" validate="#validate_style#" style="width:65px;">
								<cfelse>
									<cfinput type="text" name="startdate1" id="startdate1" value="" style="width:65px;" onChange="CDate(1)" validate="#validate_style#" maxlength="10" message="#message#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate1"></span>
						</div>
					</div>
					<div class="col col-6">
						<div class="input-group" id="item-startdate2">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç tarihini yazınız !'></cfsavecontent>
								<cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>
									<cfinput type="text" name="startdate2" id="startdate2" value="#dateformat(attributes.startdate2,dateformat_style)#" maxlength="10" onChange="CDate(1)"  message="#message#" validate="#validate_style#" style="width:65px;">
								<cfelse>
									<cfinput type="text" name="startdate2" id="startdate2" value="" style="width:65px;" validate="#validate_style#" onChange="CDate(1)" maxlength="10" message="#message#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate2"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-finishdate1">
				<label class="col col-12"><cf_get_lang_main no='288.Bitiş Tarihi'></label>
				<div class="col col-12">
					<div class="col col-6">
						<div class="input-group">
							<cfsavecontent variable="message1"><cf_get_lang_main no='327.Bitiş tarihini yazınız !'></cfsavecontent>
								<cfif isdefined("attributes.finishdate1") and isdate(attributes.finishdate1)>
									<cfinput type="text" name="finishdate1" id="finishdate1" value="#dateformat(attributes.finishdate1,dateformat_style)#" onChange="CDate(2)" maxlength="10" message="#message1#" validate="#validate_style#" style="width:65px;">
								<cfelse>
									<cfinput type="text" name="finishdate1" id="finishdate1" value="" style="width:65px;" validate="#validate_style#" onChange="CDate(2)" maxlength="10" message="#message1#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate1"></span>	
						</div>
					</div>
					<div class="col col-6">
						<div class="input-group">
							<cfsavecontent variable="message1"><cf_get_lang_main no='327.Bitiş tarihini yazınız !'></cfsavecontent>
								<cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>
									<cfinput type="text" name="finishdate2" id="finishdate2" value="#dateformat(attributes.finishdate2,dateformat_style)#" onChange="CDate(2)" maxlength="10" message="#message1#" validate="#validate_style#" style="width:65px;">
								<cfelse>
									<cfinput type="text" name="finishdate2" id="finishdate2" value="" style="width:65px;" validate="#validate_style#" onChange="CDate(2)" maxlength="10" message="#message1#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate2"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</cf_box_search_detail>
</cfform>
<script type="text/javascript">
document.getElementById('keyword').focus();
$(function(){
	$(".grey-cascade").hide();
});
function showDepartment(branch_id)	
{
	var branch_id = document.search.branch_id.value;
	if (branch_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_hr&branch_id="+branch_id;
		AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
	}
}

function CDate(type)
{
	if(type==1)
	{
		if(document.getElementById('startdate1').value!='' && document.getElementById('startdate2').value!='')
		{
			if(datediff(document.getElementById('startdate1').value,document.getElementById('startdate2').value,0)<0)
			{
				alert("<cf_get_lang_main no='1450.Başlangıç tarihi Bitiş tarihinden önce olamaz'>");
				document.getElementById('startdate1').value='';
				document.getElementById('startdate2').value='';
			}
		}
	}
	else
	{
		if(document.getElementById('finishdate1').value!='' && document.getElementById('finishdate2').value!='')
		{
			if(datediff(document.getElementById('finishdate1').value,document.getElementById('finishdate2').value,0)<0)
			{
				alert("<cf_get_lang_main no='1450.Başlangıç tarihi Bitiş tarihinden önce olamaz'>");
				document.getElementById('finishdate1').value='';
				document.getElementById('finishdate2').value='';
			}
		}
	}
}
</script>
