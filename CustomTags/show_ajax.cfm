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
<cfparam name="tr_class" default="color-list">
<cfparam name="td_class" default="form-title">
<cfparam name="img_name" default="plus_square">
<cfparam name="img_name2" default="report_square">
<cfparam name="table_class" default="color-header">
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
	<cfset img_name2 = "pod_list_page">
</cfif>
<cfif listlen(attributes.add_buton_url,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url = ListAppend(attributes.add_buton_url,'list',',')></cfif>
<cfif listlen(attributes.add_buton_url2,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url2 = ListAppend(attributes.add_buton_url2,'list',',')></cfif>
<cfif listlen(attributes.add_buton_url3,',')><cfset attributes.td_colspan = attributes.td_colspan+1><cfset attributes.add_buton_url3 = ListAppend(attributes.add_buton_url3,'list',',')></cfif>
<cfoutput>
<table cellspacing="1" cellpadding="2" width="#attributes.table_width#%" border="0" class="#table_class#" <cfif attributes.table_align is 'center'>align="center"</cfif>>
   <tr class="#tr_class#" height="25">
        <td class="#td_class#">
        <cfset on_click = "action_#attributes.tr_id#();">
        <img style="position:absolute;cursor:pointer;<cfif attributes.page_style neq 'on'>display:none;</cfif>" id="hidden_image#attributes.tr_id#" onClick="#on_click#" src="/images/#hide_image#.gif" border="0" alt="<cf_get_lang dictionary_id='58628.Gizle'>">
        <img style="position:absolute;cursor:pointer;<cfif attributes.page_style is 'on'>display:none;</cfif>" id="show_images#attributes.tr_id#" onClick="#on_click#" src="/images/#show_image#.gif" border="0" alt="<cf_get_lang dictionary_id='58596.Göster'>">&nbsp;&nbsp;
        &nbsp;<a href="javascript://" class="#td_class#" onClick="#on_click#"><font class="#td_class#">#trim(attributes.title)#</font></a>
      	</td>
        <cfif len(attributes.add_buton_url3) or len(attributes.add_buton_url2) or len(attributes.add_buton_url)>
       	<td width="1%" nowrap align="right">
			<cfif len(attributes.add_buton_url3)>
                <a href="javascript://" onClick="windowopen('#ListGetAt(attributes.add_buton_url3,1)#','#ListGetAt(attributes.add_buton_url3,2)#');"><img src="/images/report_square.gif" border="0" alt=""></a>
            </cfif>
			<cfif len(attributes.add_buton_url2)>
                <a href="javascript://" onClick="windowopen('#ListGetAt(attributes.add_buton_url2,1)#','#ListGetAt(attributes.add_buton_url2,2)#');"><img src="/images/#img_name2#.gif" border="0" alt="#caller.getLang('main',497)#"></a> <!--- Iliskilendir --->
            </cfif>
            <cfif len(attributes.add_buton_url)>
               <cfif attributes.add_buton_url contains 'popup'>
			   	<a href="javascript://" onClick="windowopen('#ListGetAt(attributes.add_buton_url,1)#','#ListGetAt(attributes.add_buton_url,2)#');"><img src="/images/#img_name#.gif" border="0" alt="#caller.getLang('main',170)#"></a>
           		<cfelse>
				<a href="#ListGetAt(attributes.add_buton_url,1)#"><img src="/images/#img_name#.gif" border="0" alt="#caller.getLang('main',170)#"></a>
				</cfif>
			</cfif>
        </td>
        </cfif>
    </tr>
    <tr class="#body_class#" id="#attributes.tr_id#" style="display:none;">
        <td height="20" colspan="#attributes.td_colspan#">
            <div id="div_#attributes.tr_id#">
            </div>
        </td>
    </tr>
</table>

<script type="text/javascript">
	function action_#attributes.tr_id#()
	{
		gizle_goster(#attributes.tr_id#);
		gizle_goster(document.getElementById('hidden_image#attributes.tr_id#'));
		gizle_goster(document.getElementById('show_images#attributes.tr_id#'));
		AjaxPageLoad('#attributes.page_url#','div_#attributes.tr_id#',#attributes.is_show_error#);
	}
	<cfif attributes.page_style is 'on'>
		goster(#attributes.tr_id#);
		AjaxPageLoad('#attributes.page_url#','div_#attributes.tr_id#',#attributes.is_show_error#);
	</cfif>
</script>
</cfoutput>
<br />
