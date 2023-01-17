<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfparam name="attributes.no_border" default="0">
<cfset dsn = caller.dsn>
<cfset maxi = ( attributes.no_border eq 1 ) ? "Maxi" : "">
<cfif attributes.type eq 'product'>
    <cfscript>
        get_product_list_action = createObject("component", "V16.product.cfc.get_product");
        get_product_list_action.dsn1 = caller.dsn1;
		get_product_list_action.dsn_alias = caller.dsn_alias;
        GET_PRODUCT = get_product_list_action.get_product_(pid : attributes.pid);
    </cfscript>
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="product">
    <cfset id_name = "imgs_get">
    <cfset id = "pid=#attributes.pid#">
    <cfset add_id = "id=#attributes.pid#">    
    <cfset infoHref = "#request.self#?fuseaction=objects.popup_get_archive&id=#attributes.pid#&module=product&module_id=5&action_id=#attributes.pid#&type=#image_type#">
    <cfinclude template="../V16/product/display/dsp_product_images.cfm">
    <cfset imageDetail = "#URLDecode(URLEncodedFormat(image_detail))#">
    <cfset copyHref = "#request.self#?fuseaction=product.add_popup_multi_image&id=#attributes.pid#&type=#image_type#&detail=#imageDetail#">
<cfelseif attributes.type eq 'content'>
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="content">
    <cfset id_name = "_content_related_images_">
    <cfset id = "contentId=#attributes.contentId#">
    <cfset add_id = "contentId=#attributes.contentId#">
    <cfset infoHref = "#request.self#?fuseaction=objects.popup_get_Archive&id=#attributes.contentId#&module=content">
    <cfset copyHref = "">
    <cfset imageDetail = "">
<cfelseif attributes.type eq 'training'>
    <cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
    <cfparam name="attributes.class_id" default="">
    <cfset GET_CLASS_F = cmp.GET_CLASS_F(class_id : attributes.class_id)>   
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="training">
    <cfset id_name = "training_related_images">
    <cfset id = "class_id=#attributes.class_id#">
    <cfset add_id = "class_id=#attributes.class_id#">
    <cfset infoHref = "">
    <cfset copyHref = "">
    <cfset imageDetail = "">
<cfelseif attributes.type eq 'train_subject'>
    <cfset cmp = createObject("component","V16.training_management.cfc.trainingcat")>
    <cfparam name="attributes.train_id" default="">
    <cfset GET_TRAINING_SUBJECT = cmp.GET_TRAINING_SUBJECT(train_id : attributes.train_id)>   
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="train_subject">
    <cfset id_name = "train_subject_related_images">
    <cfset id = "train_id=#attributes.train_id#">
    <cfset add_id = "train_id=#attributes.train_id#">
    <cfset infoHref = "">
    <cfset copyHref = "">
    <cfset imageDetail = "">
<cfelseif attributes.type eq 'train_group'>
    <cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
    <cfparam name="attributes.train_group_id" default="">
    <cfset get_groups = groups.Select()>   
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="train_group">
    <cfset id_name = "train_group_related_images">
    <cfset id = "train_group_id=#get_groups.train_group_id#">
    <cfset add_id = "train_group_id=#get_groups.train_group_id#">
    <cfset infoHref = "">
    <cfset copyHref = "">
    <cfset imageDetail = "">
<cfelseif attributes.type eq 'sample'>
  
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37089.Imajlar'></cfsavecontent>
    <cfset image_type="sample">
    <cfset id_name = "product_sample_id_">
    <cfset id = "product_sample_id=#attributes.product_sample_id#">
    <cfset add_id = "product_sample_id=#attributes.product_sample_id#">
    <cfset infoHref = "#request.self#?fuseaction=objects.popup_get_Archive&id=#attributes.product_sample_id#&module=SAMPLE">
    <cfset copyHref = "">
    <cfset imageDetail = "">
</cfif>
<div style="display:none;z-index:999;" id="add"></div>
<div style="display:none;z-index:999;" id="copy"></div>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='62726.Çoklu İmaj Ekle'></cfsavecontent>
<cfif len(copyHref)>
    <cfset copyrowhref1 = "javascript:open_box('#copyHref#','copy')">
<cfelse>
    <cfset copyrowhref1 = "">
</cfif>
<cf_box id="#id_name#" 
    title="#text#"
    class="#maxi#"
    closable="0" 
    style="width:99%;"
    box_page="#request.self#?fuseaction=objects.related_images_ajax&#id#&type=#image_type#"
    add_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.form_add_popup_image&#add_id#&type=#image_type#&detail=#imageDetail#')"
    add_href_size="medium"
    info_href="#infoHref#"
    info_href_id="info_link"
    copyrow_href="#copyrowhref1#"
    copyrow_title="#message#"
    copyrow_size="small">
</cf_box>
<script type="text/javascript">
    function open_box(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('left','20%');
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>