<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.form_submit")>
	<cfquery name="GET_PRODUCT_MODEL" datasource="#DSN1#">
    	SELECT 
			* 
		FROM 
			PRODUCT_BRANDS_MODEL
		WHERE
			MODEL_ID IS NOT NULL
			<cfif len(attributes.keyword)>
			AND MODEL_NAME LIKE '%#attributes.keyword#%'
			</cfif>
    </cfquery>
<cfelse>
	<cfset get_product_model.recordcount=0>    
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_product_model.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("attributes.model_id")>
	<cfset url_string="#url_string#&model_id=#attributes.model_id#">
</cfif>
<cfif isdefined("attributes.model_name")>
	<cfset url_string="#url_string#&model_name=#attributes.model_name#">
</cfif>
<cfset url_string = "#url_string#&form_submit=1">

<cf_box title="#getLang('','Model',58225)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_model" method="post" action="#request.self#?fuseaction=objects.popup_list_product_model">
		<input name="form_submit" id="form_submit" type="hidden" value="1">
		<cf_box_search more="0">
			<cfif isdefined("attributes.model_id")>
				<input name="model_id" id="model_id" type="hidden" value="<cfoutput>#attributes.model_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.model_name")>
				<input name="model_name" id="model_name" type="hidden" value="<cfoutput>#attributes.model_name#</cfoutput>">
			</cfif> 
			<div class="form-group" id="keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" onkeyup="return(FormatCurrency(this,event,0));">
			</div> 
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_model' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
			<th><cf_get_lang dictionary_id="58225.Model"></th>
		</thead>
		<tbody>
			<cfif get_product_model.recordcount>
				<cfoutput query="get_product_model" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="gonder('#model_id#','#model_name#');" class="tableyazi">#model_name#</a></td> 
					</tr>    
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
		</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_string="#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_product_model#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
$(document).ready(function(){

    $( "#keyword" ).focus();

});
function gonder(model_id,model_name)
{
	<cfoutput>
		<cfif isdefined("attributes.model_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.model_id#.value = model_id;
		</cfif>
		<cfif isdefined("attributes.model_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.model_name#.value = model_name;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</cfoutput>
}	
</script>
