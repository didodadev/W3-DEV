<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT DISTINCT 
		COMPANY_BRANCH_RELATED.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM  
		COMPANY_BRANCH_RELATED,
		BRANCH 
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND		
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Eylem Planı','51560')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_notes" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_action_plan">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
			<input type="hidden" name="issearch" id="issearch" value="1">
			<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-subject">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="subject" id="subject" value="" maxlength="150">
						</div>
					</div>
					<div class="form-group" id="item-get_branch">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfoutput query="get_branch">
									<option value="#branch_id#">#branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-workcube_process">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='280' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea style="width:280px;height:110px;" name="detail" id="detail"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.add_notes.subject.value=="")
	{
		alert("<cf_get_lang dictionary_id='51929.Lütfen Konu Giriniz'>!");
		return false;
	}
	
	if(document.add_notes.detail.value=="")
	{
		alert("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>!");
		return false;
	}
	t = (200 - document.add_notes.detail.value.length);
	if ( t < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'> "+ ((-1) * t) +" <cf_get_lang dictionary_id='51706.Karekter Uzun'>!");
		return false;
	}
	x = document.add_notes.branch_id.selectedIndex;
	if (document.add_notes.branch_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
		return false;
	}
	return process_cat_control();
}
</script>
