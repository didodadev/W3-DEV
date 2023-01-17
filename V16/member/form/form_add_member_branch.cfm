<cfparam name="attributes.cpid" default="">
<cfparam name="attributes.cid" default="">
<cfparam name="attributes.comp_branch" default="">
<cfparam name="attributes.cat_status" default="">
<cfparam name="attributes.open_date" default="">

<cfquery name="GET_SELECT_BRANCH" datasource="#DSN#"><!--- Listedeki subeler --->
	SELECT
		BRANCH_ID
	FROM
		COMPANY_BRANCH_RELATED
	WHERE
		DEPOT_DAK IS NULL AND
	<cfif isdefined("attributes.cid") and len(attributes.cid)>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	<cfelseif isdefined("attributes.cpid") and len(attributes.cpid)>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	</cfif>
</cfquery>

<cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
	SELECT 
		OUR_COMPANY.NICK_NAME, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID,
		BRANCH.COMPANY_ID
	FROM 
		BRANCH, 
		OUR_COMPANY,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		<cfif get_select_branch.recordcount>BRANCH.BRANCH_ID NOT IN (#valuelist(get_select_branch.branch_id,',')#) AND</cfif><!--- Listedeki subeler selectboxa gelmesin diye eklendi --->
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	ORDER BY 
		OUR_COMPANY.COMPANY_NAME,	
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57895.Şube İlişkisi"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" settings="1">
	<cfform name="prod_company" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_member_branch">
		<cf_box_elements>
            <input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')>#attributes.draggable#</cfif>">
			<cfif isdefined("attributes.cid") and len(attributes.cid)>
				<input type="hidden" name="cid" id="cid" value="<cfoutput>#attributes.cid#</cfoutput>">
			<cfelse>
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
			</cfif>
			
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="row">
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
					<div class="col col-8 col-sm-12">
						<select name="comp_branch" id="comp_branch" style="height:175px;width:330px;" multiple="multiple">
							<cfoutput query="get_branch_all">
								<option value="#company_id#-#branch_id#">#nick_name#- #branch_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57894.Statü'></label>
					<div class="col col-8 col-sm-12">
						<select name="cat_status" id="cat_status" style="width:200px;">
							<option value=""><cf_get_lang dictionary_id='57894.Statü'></option>
							<cfoutput query="get_status">
								<option value="#tr_id#">#tr_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30569.İlişki Başlangıç Tarihi'></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<input type="text" name="open_date" id="open_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:200px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field='open_date'></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('prod_company' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = document.prod_company.comp_branch.selectedIndex;
	if (document.prod_company.comp_branch.value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube adı !'> !");
		prod_company.comp_branch.focus();
		return false;
	}
	return true;
}
</script>
