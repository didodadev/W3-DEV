<cfset cmp = createObject("component","V16.hr.cfc.setupDecisionmedicine") />
<cfset get_Decisionmedicine = cmp.getDecisionmedicine(decision_medicine_id:attributes.decision_medicine_id)>
<cfsavecontent  variable="title_"><cf_get_lang dictionary_id='55882.İlaç ve Tıbbi Malzemeler'>
</cfsavecontent>
<cf_box closable="0" collapsable="0" title="#title_# : #attributes.decision_medicine_id#" add_href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_decisionmedicine">
	<cfform name="upd_decision_medicine" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_decisionmedicine">
		<input name="decision_medicine_id" id="decision_medicine_id" value="<cfoutput>#attributes.decision_medicine_id#</cfoutput>" type="hidden">
		<cf_box_elements>
            <div class="col col-6">
				<div class="form-group" id="item-complaint_status">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57493.Aktif'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Checkbox" name="medicine_status" id="medicine_status" value="1" <cfif get_Decisionmedicine.is_default eq 1> checked</cfif>>
                    </div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="barcode" maxlength="50" value="#get_Decisionmedicine.barcode#"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55884.İlaç'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="Text" name="decision_medicine" id="decision_medicine" value="#get_Decisionmedicine.DRUG_MEDICINE_NEW#">
							<span class="input-group-addon">
								<cf_language_info	
								table_name="SETUP_DECISIONMEDICINE"
								column_name="DRUG_MEDICINE" 
								column_id_value="#attributes.decision_medicine_id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="DRUG_ID" 
								control_type="0">
							</span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="code" maxlength="50" value="#get_Decisionmedicine.code#"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55883.Etken Madde'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="Text" name="active_ingredient" value="#get_Decisionmedicine.active_ingredient#">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_Decisionmedicine">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
		</cf_box_footer>
	</cfform>
</cf_box>

<!--- <table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
		<td align="left" class="headbold"><cf_get_lang dictionary_id='55882.İlaç ve Tıbbi Malzemeler'></td>
		<td width="100" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_decisionmedicine"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table> --->
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("decision_medicine").value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='42099.İlaç'>!");
		return false;
	}
	return true;
}
</script>
