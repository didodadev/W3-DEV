<cfset xfa.del="account.emptypopup_del_inflation">
<cfquery name="get_inf_detail" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		INFLATION 
	WHERE 
		INF_ID = #attributes.INF_ID#
</cfquery>
<cfsavecontent variable="img"><cfoutput><a href="#request.self#?fuseaction=account.popup_form_add_inflation"><img src="/images/plus1.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfoutput></cfsavecontent>
<cfif not isdefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang(27,'Enflasyon tanımları',47289)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_inflation" action="#request.self#?fuseaction=account.emptypopup_upd_inflation" method="post" >
			<input name="inf_id" id="inf_id" type="hidden" value="<cfoutput>#attributes.inf_id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-month">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'> / <cf_get_lang dictionary_id='58455.Yıl'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<select name="month" id="month">
									<cfloop from="1" to="12" index="i">
										<cfoutput>
											<option value="#i#" <cfif get_inf_detail.inf_month eq i>selected</cfif>>#listgetat(ay_list(),i)#</option>
										</cfoutput>
									</cfloop>
								</select>
								<span class="input-group-addon no-bg"></span>
								<select name="year" id="year">
									<cfloop from="2002" to="2049" index="j">
										<cfoutput>
											<option value="#j#" <cfif get_inf_detail.inf_year eq j>selected</cfif>>#j#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-bill2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58456.Oran'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="bill2" id="bill2" value="<cfoutput>#get_inf_detail.INF_RATE#</cfoutput>">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>							
				<cf_record_info 
				query_name="get_inf_detail"
				record_emp="record_emp" 
				record_date="record_date"
				update_emp="update_emp"
				update_date="update_date">							
				<cf_workcube_buttons type_format='1' is_upd='1' add_function='check()' delete_page_url='#request.self#?fuseaction=#xfa.del#&inf_id=#url.inf_id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function check()
{
	if(document.upd_inflation.bill2.value == '')
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='47390.Enflasyon Orani'></cfoutput>"}) 
		return false;
	}
	
	if(document.upd_inflation.bill2.value != "")
	{
		if ((document.upd_inflation.bill2.value< 0.01) || (document.upd_inflation.bill2.value >100))
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47489.Enflasyon 0.01 den büyük, 100 den küçük olmalıdır'></cfoutput>"})
			return false;
		}
	}
	 return document.getElementById("upd_inflation").checkValidity();
    <cfif isdefined("attributes.draggable")>loadPopupBox('upd_inflation' , <cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
  }
</script>
