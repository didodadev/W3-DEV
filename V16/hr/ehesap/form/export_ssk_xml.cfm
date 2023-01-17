<cf_xml_page_edit fuseact="ehesap.popup_form_export_ssk_xml">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfinclude template="../query/get_branch.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53844.SGK E-Bildirge XML Dosyası Oluşturma"></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="cari" action="#request.self#?fuseaction=ehesap.emptypopup_form_export_ssk_xml" method="post">
	<input type="hidden" name="counter" id="counter">
	<input type="hidden" name="is_sgk_office_no" value="<cfif isdefined('x_ssk_office_no')><cfoutput>#x_ssk_office_no#</cfoutput><cfelse>0</cfif>">
	<cf_box_elements>
		<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang dictionary_id ='53806.İşyeri'></label>
			</div>			
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
				<select name="ssk_office" id="ssk_office">
					<cfoutput query="get_branch">
						<cfif len("#ssk_office##ssk_no#")>
							<cfif isdefined('x_ssk_office_no') and x_ssk_office_no eq 1> 
								<option value="#SSK_M##SSK_JOB##SSK_BRANCH##SSK_BRANCH_OLD##SSK_NO##SSK_CITY##SSK_COUNTRY##SSK_CD##SSK_AGENT#">#branch_name#-#ssk_office#-#ssk_no#</option>
							<cfelse>
								<option value="#branch_id#">#branch_name#-#ssk_office#-#ssk_no#</option>
							</cfif>
						</cfif>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang dictionary_id ='53808.Yıl Ay'></label>
			</div>			
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<select name="sal_year" id="sal_year">
					<cfloop from="-5" to="5" index="i">
						<cfoutput><option value="#session.ep.period_year + i#"<cfif attributes.sal_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
					</cfloop>
				</select>
				-
				<select name="sal_mon" id="sal_mon">
					<cfloop from="1" to="12" index="i">
						<cfoutput><option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#i#</option></cfoutput>
					</cfloop>
				</select>
			</div>
		</div>
		<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang dictionary_id="58587.Belge Mahiyeti"></label>
			</div>			
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<select name="doc_nat" id="doc_nat" style="width:100px;">
					<option value="A" selected><cf_get_lang dictionary_id ='53847.Asıl'></option>
					<option value="E"><cf_get_lang dictionary_id ='53841.Ek'></option>
					<option value="T"><cf_get_lang dictionary_id ="59588.Toplu Sözleşme"></option>
				</select>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer><cf_workcube_buttons is_upd='0'></cf_box_footer>
	</cfform>
</cf_box>
