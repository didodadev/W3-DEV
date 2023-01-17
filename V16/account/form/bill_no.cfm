<cfinclude template="../query/get_bill_no.cfm">
<cf_catalystHeader>
<cfform name="bill_no" action="#request.self#?fuseaction=account.add_bill_no" method="post">
	<cfif GET_BILL_NO.RECORDCOUNT>
		<input type="hidden" name="upd" id="upd" value="1">
	</cfif>
	<div class="row"> 
		<div class="col col-12 uniqueRow"> 		
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='54.Muhasebe Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='534.Fiş No'></cfsavecontent>
								<cfinput type="text" name="bill" required="yes" message="#message#" value="#GET_BILL_NO.BILL_NO#" validate="integer">
							</div>
						</div>
						<div class="form-group" id="item-te_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='55.Tediye Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message1"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='55.Tediye Fiş No'></cfsavecontent>
								<cfinput type="text" name="te_bill" required="yes" message="#message1#" value="#GET_BILL_NO.TEDIYE_BILL_NO#" validate="integer">
							</div>
						</div>
						<div class="form-group" id="item-t_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='56.Tahsil Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message2"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='56.Tahsil Fiş No'></cfsavecontent>
								<cfinput type="text" name="t_bill" required="yes" message="#message2#" value="#GET_BILL_NO.TAHSIL_BILL_NO#" validate="integer">
							</div>
						</div>
						<div class="form-group" id="item-m_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='57.Mahsup Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message3"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='57.Mahsup Fiş No'></cfsavecontent>
								<cfinput type="text" name="m_bill" required="yes" message="#message3#" value="#GET_BILL_NO.MAHSUP_BILL_NO#" validate="integer">
							</div>
						</div>
					</div>
				</div>	
				<div class="row formContentFooter">	
					<div class="col col-12"><cf_workcube_buttons is_upd='0'></div> 
				</div>
			</div>
		</div>
	</div>
</cfform>
