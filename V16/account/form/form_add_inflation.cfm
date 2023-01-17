<cfset MONTH_ = DATEPART("M",now())>
<cfset YEAR_ = DATEPART("YYYY",now())>
<cfif not isdefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang(27,'Enflasyon tanımları',47289)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_inflation" action="#request.self#?fuseaction=account.emptypopup_add_inflation" method="post">		
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-month">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'> / <cf_get_lang dictionary_id='58455.Yıl'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<select name="month" id="month">
									<cfloop from="1" to="12" index="i">
										<cfoutput>
											<option value="#i#" <cfif MONTH_ EQ I>SELECTED</cfif>>#listgetat(ay_list(),i)#</option>
										</cfoutput>
									</cfloop>
								</select>
								<span class="input-group-addon no-bg"></span>
								<select name="year" id="year">
									<cfloop from="2002" to="2049" index="j">
										<cfoutput>
											<option value="#j#" <cfif YEAR_ EQ J>SELECTED</cfif>>#j#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-bill2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58456.Oran'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="bill2" id="bill2" value="">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='check()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function check()
{
	if (document.add_inflation.bill2.value == "")
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='47390.Enflasyon Orani'></cfoutput>"});
		return false;
	}
	
	if ((document.add_inflation.bill2.value< 0.01) || (document.add_inflation.bill2.value >100))
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47489.Enflasyon 0.01 den büyük, 100 den küçük olmalıdır'></cfoutput>"});
		return false;
	}
	return document.getElementById("add_inflation").checkValidity();
    <cfif isdefined("attributes.draggable")>loadPopupBox('add_inflation' , <cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
}
</script>
