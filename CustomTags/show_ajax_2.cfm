<!--- 
Amaç :Tek bir satırda tr ve div id vererek AjaxPageLoad kullanımı kolaylaştırmak
M.ER 20080509
 --->
<cfparam name="attributes.is_show_error" default="1">
<cfparam name="attributes.page_style" default="off">
<cfparam name="attributes.tr_id" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.page_url" default="">
<cfparam name="attributes.td_colspan" default="1">
<cfparam name="attributes.add_buton_url" default="">
<cfparam name="attributes.add_buton_url2" default="">
<cfparam name="attributes.add_buton_url3" default="">
<cfparam name="attributes.class_type" default="1">
<cfparam name="attributes.table_align" default="left">
<cfparam name="attributes.table_width" default="98">
<cfparam name="tr_class" default="color-header">
<cfparam name="td_class" default="form-title">
<cfparam name="img_name" default="plus_square">
<cfparam name="img_name2" default="copy_list_white">
<cfparam name="table_class" default="color-border">
<cfparam name="body_class" default="color-row">
<cfparam name="hide_image" default="listele_down">
<cfparam name="show_image" default="listele">
<cfif attributes.class_type eq 2>
	<cfset tr_class="color-list">
	<cfset td_class="txtboldblue">
    <cfset img_name ="plus_list">
<cfelseif attributes.class_type eq 3>
	<cfset show_image = "pod_right">
    <cfset hide_image = "pod_down">
	<cfset body_class = "body">
	<cfset table_class="pod_box">
	<cfset tr_class="header">
	<cfset td_class="txtboldblue">
    <cfset img_name ="pod_add">
</cfif>
<cfif listlen(attributes.add_buton_url,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url = ListAppend(attributes.add_buton_url,'list',',')></cfif>
<cfif listlen(attributes.add_buton_url2,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url2 = ListAppend(attributes.add_buton_url2,'list',',')></cfif>
<cfif listlen(attributes.add_buton_url3,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url3 = ListAppend(attributes.add_buton_url3,'list',',')></cfif>
<cfoutput>
<table cellspacing="0" cellpadding="0" width="100%" border="0"  <cfif attributes.table_align is 'center'>align="center"</cfif>>

    <tr class="#body_class#" id="#attributes.tr_id#" style="display:none;">
        <td colspan="#attributes.td_colspan#">
            <div id="div_#attributes.tr_id#">
            </div>
        </td>
    </tr>
</table>

<script type="text/javascript">
	function action_#attributes.tr_id#()
	{
	gizle_goster(#attributes.tr_id#);
	gizle_goster(hidden_image#attributes.tr_id#);
	gizle_goster(show_images#attributes.tr_id#);
	AjaxPageLoad('#attributes.page_url#','div_#attributes.tr_id#',#attributes.is_show_error#);
	}
	<cfif attributes.page_style is 'on'>
		goster(#attributes.tr_id#);
		AjaxPageLoad('#attributes.page_url#','div_#attributes.tr_id#',#attributes.is_show_error#);
	</cfif>
</script>
</cfoutput>
<br />
