<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif not isdefined("attributes.sal_mon") and month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelseif not isdefined("attributes.sal_mon")>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfinclude template="../ehesap/query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="employee" method="post" action="">
			<input type="hidden" value="1" name="is_submitted" id="is_submitted" />
			<cf_box_search more="0" id="sube_puantaj">
				<div class="form-group">
					<select name="ssk_office" id="ssk_office">
						<cfoutput query="GET_SSK_OFFICES">
						<cfif len(SSK_OFFICE) and len(SSK_NO)>
							<option value="#branch_id#"<cfif attributes.ssk_office is branch_id> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
						</cfif>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<input type="text" name="sal_year"  id="sal_year" value="<cfoutput>#session.ep.period_year#</cfoutput>" readonly size="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div> 
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0">
				</div>
				<div class="form-group">
					<a href="javascript://" onClick="run_form_ajax();" class="ui-btn ui-btn-gray2"><i class="fa fa-expand"></i></a>
				</div>
				<!--- uidroptan geldiği için yoruma alındı. --->
				<!--- <div class="form-group">
					<a href="javascript://" onClick="send_adres_info();"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.yazıcıya gönder'>"></a>
				</div> --->
				<div class="form-group" id="menu_puantaj_1">
					
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='55095.Vardiya Hesapla'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_basket id="puantaj_list_layer">
			<cfif isdefined("attributes.is_submitted")>
				<cfinclude template="view_shift.cfm">
			</cfif>
		</cf_basket>
	</cf_box>
</div>
<script type="text/javascript">
	function run_form_ajax()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_ajax_run_shift</cfoutput>';
		sal_year_ = document.getElementById('sal_year').value;
		sal_mon_ = document.getElementById('sal_mon').value;
		ssk_office_ = document.getElementById('ssk_office').value;
		maxrows = document.getElementById('maxrows').value;
		adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + ssk_office_ + '&maxrows='+maxrows;
		AjaxPageLoad(adres_,'menu_puantaj_1','1',"Hesaplanıyor");
	}
</script>
