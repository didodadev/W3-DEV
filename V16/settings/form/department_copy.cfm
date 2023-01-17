<cfquery name="get_branches" datasource="#dsn#">
    SELECT
		BRANCH_NAME,
		BRANCH_ID	
	FROM
		BRANCH
	ORDER BY
		BRANCH_NAME	
</cfquery>
<div class="col col-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='42716.Şube Kopyala'></cfsavecontent>
	<cf_box title="#title#">
		<cfform name="form" action="#request.self#?fuseaction=settings.emptypopup_department_copy" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41669.Kaynak'><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="BRANCHES_1" id="BRANCHES_1">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_branches">
									<option value="#BRANCH_ID#">#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57951.Hedef'><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="BRANCHES_2" id="BRANCHES_2">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_branches">
									<option value="#BRANCH_ID#">#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-7 col-md-4 col-sm-4 col-xs-12">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='57433.Yardım'><br/></label>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62984.Kaynak şubedeki departmanları hedef şubedeki departman olarak kaydeder.'><br/></label>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons add_function='kontrol()' is_upd='0' is_cancel='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if (document.form.BRANCHES_1.value == "")
	{
		alert("<cf_get_lang dictionary_id='42912.Departmanları Aktarılacak Şubeyi Seçiniz !'>");
		return false;
	}	
		if (document.form.BRANCHES_2.value == "")
	{
		alert("<cf_get_lang dictionary_id='42913.Departmanların Aktarılcağı Şubeyi Seçiniz !'>");
		return false;
	}	
		if (document.form.BRANCHES_1.value == document.form.BRANCHES_2.value)
	{
		alert("<cf_get_lang dictionary_id='42977.Birbirinden Farklı Şube Seçiniz !'>");
		return false;
	}	
}
</script>
