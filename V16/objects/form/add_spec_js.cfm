<script type="text/javascript" src="../../JS/js_functions_money.js"></script>
<script type="text/javascript" src="../../JS/js_functions_money_tr.js"></script>
<script type="text/javascript">
<cfset new_spect_var_name = reReplace(new_spect_var_name, chr(10),"", "all" )> 
<cfset new_spect_var_name = reReplace(new_spect_var_name, chr(13),"", "all" )> 
<cfset new_spect_var_name = reReplace(new_spect_var_name, chr(9),"", "all" )> 
<cfoutput>
<!--- Bu blok üretim emrinde spect değişimi için. --->
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfif not isDefined("attributes.draggable")>opener.</cfif>document.all.#attributes.field_id#.value='#listgetat(specer_return_value_list,2,',')#';
	<cfif not isDefined("attributes.draggable")>opener.</cfif>document.all.#attributes.field_name#.value='#new_spect_var_name#';
</cfif>
<cfif isdefined("attributes.field_main_id") and len(attributes.field_main_id)>
	<cfif not isDefined("attributes.draggable")>opener.</cfif>document.all.#attributes.field_main_id#.value='#listgetat(specer_return_value_list,1,',')#';
</cfif>
<!--- //Bu blok üretim emrinde spect değişimi için. --->
<cfif isdefined("attributes.row_id")>
	<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
		var satir = <cfoutput>#attributes.row_id#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isDefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
	{
		<cfif not isDefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, 
		{ 
			SPECT_ID: '#listgetat(specer_return_value_list,2,',')#', 
			SPECT_NAME: '#new_spect_var_name#' 
			<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
				,PRICE: <cfif listgetat(specer_return_value_list,4,',') gt 0>#listgetat(specer_return_value_list,4,',')#<cfelse>0</cfif>
				,PRICE_OTHER: <cfif listgetat(specer_return_value_list,5,',') gt 0>#listgetat(specer_return_value_list,5,',')#<cfelse>0</cfif>
				,OTHER_MONEY: '<cfif len(listgetat(specer_return_value_list,6,','))>#listgetat(specer_return_value_list,6,',')#<cfelse>#session.ep.money#</cfif>'
				,NET_MALIYET: #listgetat(specer_return_value_list,9,',')#
			</cfif>  
		}); 
		<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
			<cfif not isDefined("attributes.draggable")>opener.</cfif>hesapla_('Price',#attributes.row_id#);
		</cfif>
	}
	<cfif isDefined("attributes.draggable") and attributes.modal_id>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>window.close()</cfif>;
</cfif>
<cfif not isdefined("attributes.row_id") and not (isdefined("attributes.field_main_id") and len(attributes.field_main_id)) and not isDefined("attributes.from_product_config")>
	<cfif isDefined("attributes.draggable")>
		openBoxDraggable("#request.self#?fuseaction=objects.emptypopup_main_to_add_spect<cfif isdefined("attributes.field_id") and len(attributes.field_id)>&field_id=#attributes.field_id#&field_name=#attributes.field_name#</cfif><cfif isdefined("attributes.field_main_id")>&field_main_id=#attributes.field_main_id#</cfif>&create_main_spect_and_add_new_spect_id=1&spect_main_id=#listgetat(specer_return_value_list,1,',')#&spect_type=1");
	<cfelse>
		window.location.href="#request.self#?fuseaction=objects.emptypopup_main_to_add_spect<cfif isdefined("attributes.field_id") and len(attributes.field_id)>&field_id=#attributes.field_id#&field_name=#attributes.field_name#</cfif><cfif isdefined("attributes.field_main_id")>&field_main_id=#attributes.field_main_id#</cfif>&create_main_spect_and_add_new_spect_id=1&spect_main_id=#listgetat(specer_return_value_list,1,',')#&spect_type=1";
	</cfif>
</cfif>
</cfoutput>
<cfif isDefined("attributes.draggable") and isDefined("attributes.modal_id")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>window.close()</cfif>;
</script>