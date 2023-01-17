<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined('attributes.field_code') and len(attributes.field_code)>
	<cfset url_str = "#url_str#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined('attributes.horeca') and len(attributes.horeca)>
	<cfset url_str = "#url_str#&horeca=#attributes.horeca#">
</cfif>
<cfquery name="GET_ASSETP_SPACE" datasource="#DSN#">
	SELECT * FROM ASSET_P_SPACE 
	WHERE 1 = 1
	<cfif isdefined('attributes.horeca') and len(attributes.horeca)> AND IS_HORECA=1</cfif>
	<cfif len(attributes.keyword)>AND SPACE_NAME LIKE '%#attributes.keyword#%' OR SPACE_CODE LIKE '%#attributes.keyword#%'</cfif>
	ORDER BY SPACE_NAME
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_assetp_space.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Mekan Tanımları',60367)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="search_brand_type_cat" method="post" action="#request.self#?fuseaction=objects.popup_list_assetp_space&#url_str#"> 
		<cf_box_search more="0">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" maxlength="50" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" maxlength="3" onKeyUp="isNumber(this)">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_brand_type_cat' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
    </cfform>
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58585.Kod"></th>
                <th><cf_get_lang dictionary_id="60371.Mekan"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_assetp_space.recordcount and form_varmi eq 1>
            <cfoutput query="get_assetp_space" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td><a href="javascript://" onClick="add_assetp_space('#ASSET_P_SPACE_ID#','#SPACE_NAME#','#SPACE_CODE#');">#SPACE_CODE#</a>		
                    </td>
                    <td>#SPACE_NAME#</td>
                </tr>
            </cfoutput>
            <cfelse>
            <tr>
                <td colspan="3"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
            </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>	
        <cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_assetp_space#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
</cf_box>

<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
	function add_assetp_space(field_id,field_name,field_code)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif not isdefined("attributes.draggable")>opener.document.all.</cfif><cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif not isdefined("attributes.draggable")>opener.document.all.</cfif><cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
        </cfif>
        <cfif isdefined("attributes.field_code")>
			<cfif not isdefined("attributes.draggable")>opener.document.all.</cfif><cfoutput>#attributes.field_code#</cfoutput>.value = field_code;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
