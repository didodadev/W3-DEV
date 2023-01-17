<cfparam name="attributes.modal_id" default="">


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="add_bes" title="#iif(isDefined("attributes.draggable"),"getLang('','Otomatik BES Tanımı',59344)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_bes" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_bes">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-is_active">
						<label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8">
							<input type="checkbox" name="is_active" id="is_active" value="1" checked>
						</div>
					</div>
					<div class="form-group" id="item-comment">
						<label class="col col-4"><cf_get_lang dictionary_id='58233.Tanım'></label>
						<div class="col col-8">
							<input type="text" name="comment" id="comment" value="" >
						</div>
					</div>
					<div class="form-group" id="item-amount">
						<label class="col col-4"><cf_get_lang dictionary_id="45126.BES Oranı"></label>
						<div class="col col-8">
							<cfinput required="yes" type="text" name="amount"  value="" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="item-start_sal_mon">
						<label class="col col-4"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
						<div class="col col-8">
							<cfoutput>
								<select name="start_sal_mon" id="start_sal_mon" >
									<cfloop from="1" to="12" index="j">
										<option value="#j#">#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</cfoutput> 
						</div>
					</div>
					<div class="form-group" id="item-end_sal_mon">
						<label class="col col-4"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						<div class="col col-8">
							<cfoutput>
								<select name="end_sal_mon" id="end_sal_mon" >
									<cfloop from="1" to="12" index="j">
										<option value="#j#">#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</cfoutput>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='form_chk()' button_type="1">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function form_chk()
	{
		add_bes.amount.value = filterNum(add_bes.amount.value);
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_bes' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
</script>