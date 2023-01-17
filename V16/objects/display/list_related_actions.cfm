<cfsavecontent variable="message"><cf_get_lang dictionary_id='29763.İlişkili Belge ve Notlar'></cfsavecontent>
<cf_box title="#getLang('','İlişkili Belge ve Notlar',29763)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_get_workcube_asset no_border="1" company_id="#session.ep.company_id#" period_id="#attributes.period_id#" module_name_info='#attributes.module_name_info#' asset_cat_id="#attributes.asset_cat_id#" module_id='#attributes.module_id#' action_section='#attributes.action_section#' action_id='#attributes.action_id#' is_special="#attributes.is_special#" is_add="#attributes.is_add#" design_id="#attributes.design_id#" style="#attributes.style#" is_image="#attributes.is_image#" action_type="#attributes.action_type#">
			<cf_get_workcube_note no_border="1" company_id="#session.ep.company_id#" period_id="#session.ep.period_id#" asset_cat_id="#attributes.asset_cat_id#" module_id='#attributes.module_id#' action_section='#attributes.action_section#' action_id='#attributes.action_id#' is_special="#attributes.is_special#" is_add="#attributes.is_add#" design_id="#attributes.design_id#" style="#attributes.style#" is_image="#attributes.is_image#" action_type="#attributes.action_type#" >
</cf_box>









