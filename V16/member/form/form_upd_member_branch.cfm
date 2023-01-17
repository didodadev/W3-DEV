<cfquery name="GET_BRANCH_COMPANY" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_ID BRANCH_ID,
		OUR_COMPANY.COMP_ID COMP_ID, 
		OUR_COMPANY.NICK_NAME NICK_NAME, 
		BRANCH.BRANCH_NAME BRANCH_NAME,
		OUR_COMPANY.COMPANY_NAME COMPANY_NAME
	FROM 
		BRANCH, 
		OUR_COMPANY
	WHERE 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	ORDER BY 
		COMPANY_NAME,	
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES 
</cfquery>
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT 
		RELATED_ID,
		<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
		COMPANY_ID,
		<cfelse>
		CONSUMER_ID,
		</cfif>
		OUR_COMPANY_ID,
		BRANCH_ID,
		MUSTERIDURUM,
		OPEN_DATE,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
	FROM 
		COMPANY_BRANCH_RELATED 
	WHERE 
		RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">
	ORDER BY 
		BRANCH_ID
</cfquery>

<cfparam name="attributes.cat_status" default="">
<cfparam name="attributes.open_date" default="">
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57895.Şube İlişkisi"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" settings="1">
	<cfform name="prod_company" action="#request.self#?fuseaction=member.emptypopup_upd_member_branch">
		<cf_box_elements>
			<input type="hidden" name="related_id" id="related_id" value="<cfoutput>#get_related.related_id#</cfoutput>">
			<input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')>#attributes.draggable#</cfif>">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="row">
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
					<div class="col col-8 col-sm-12">
						<select name="comp_branch" id="comp_branch"  disabled>
							<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
							<cfoutput query="get_branch_company">
								<option value="#comp_id#,#branch_id#" <cfif branch_id eq get_related.branch_id> selected</cfif>>#nick_name#- #branch_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57894.Statü'></label>
					<div class="col col-8 col-sm-12">
						<select name="cat_status" id="cat_status">
							<option value=""><cf_get_lang dictionary_id='57894.Statü'></option>
							<cfoutput query="get_status">
								<option value="#tr_id#" <cfif tr_id eq get_related.musteridurum> selected</cfif>>#tr_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-member_code">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30569.İlişki Başlangıç Tarihi'></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<input type="text" name="open_date" id="open_date" value="<cfoutput>#dateformat(get_related.open_date,dateformat_style)#</cfoutput>">
							<span class="input-group-addon"><cf_wrk_date_image date_field='open_date'></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_related">
			<cf_workcube_buttons is_upd='1' is_delete='1' del_function='deleteControl()' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('prod_company' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function deleteControl(){
	document.prod_company.action = '<cfoutput>#request.self#?fuseaction=member.emptypopup_del_member_branch&id=#related_id#</cfoutput>';
    <cfif isDefined('attributes.draggable')>
		loadPopupBox('prod_company',<cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
	<cfelse>
		return true;
    </cfif>
    }
function kontrol()
{
	x = document.prod_company.comp_branch.selectedIndex;
	if (document.prod_company.comp_branch[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube adı !'> !");
		prod_company.comp_branch.focus();
		return false;
	}
	return true;
}
</script>
