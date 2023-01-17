<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfquery name="GET_SHIP_METHODS" datasource="#DSN#">
	SELECT * FROM SHIP_METHOD <cfif len(attributes.keyword)>WHERE SHIP_METHOD LIKE '%#attributes.keyword#%'</cfif> ORDER BY SHIP_METHOD
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default="#get_ship_methods.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Sevk Yöntemi',29500)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_brand_type_cat" method="post" action="#request.self#?fuseaction=objects.popup_list_ship_methods&#url_str#"> 
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" maxlength="50" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_brand_type_cat', #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<tbody>
				<cfif get_ship_methods.recordcount and form_varmi eq 1>
				<cfoutput query="get_ship_methods" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td><a href="javascript://" onClick="add_ship_method('#ship_method_id#','#ship_method#');" class="tableyazi">#ship_method#</a>		
						<cfif is_opposite eq 1> - <cf_get_lang dictionary_id='43007.Karşı Ödemeli'></cfif>
						</td>
					</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="3"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif></td>
				</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.call_function") and len(attributes.keyword)>
				<cfset url_str = "#url_str#&call_function=#attributes.call_function#">
			</cfif>
			<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
				<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
			</cfif>	
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
			</cfif>	
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_ship_methods#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
				
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
	function add_ship_method(field_id,field_name)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
