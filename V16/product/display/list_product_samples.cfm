<cfparam name="attributes.page" default=1>
<cfparam name="modal_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfscript>
    url_string = '';
    if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
    if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';
    if (isdefined('attributes.field_sample_name')) url_string = '#url_string#&field_sample_name=#attributes.field_sample_name#';
    if (isdefined('attributes.field_sample_id')) url_string = '#url_string#&field_sample_id=#attributes.field_sample_id#';
</cfscript>

<cfif isdefined("attributes.is_form_submitted")>
	<cfset comp    = createObject("component","V16.product.cfc.product_sample") />
    <cfset LIST_PRODUCT_SAMPLE = comp.LIST_PRODUCT_SAMPLE(
        keyword :#attributes.keyword#
    )/>
<cfelse>
	<cfset LIST_PRODUCT_SAMPLE.recordcount = 0>
</cfif>

<cfif LIST_PRODUCT_SAMPLE.recordcount>
	<cfparam name="attributes.totalrecords" default='#LIST_PRODUCT_SAMPLE.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.totalrecords" default=#LIST_PRODUCT_SAMPLE.recordcount#>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Numune','62603')#" popup_box="1">
        <cfform name="search_list" action="#request.self#?fuseaction=product.list_product_samples#url_string#" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_list','#attributes.modal_id#')"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>		
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='62603.Numune'><cf_get_lang dictionary_id='57897.Adı'></th>
                </tr>
            </thead>
            <tbody>
                <cfif LIST_PRODUCT_SAMPLE.recordcount>
				    <cfoutput query="LIST_PRODUCT_SAMPLE">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="javascript://" onClick="send_sample('#PRODUCT_SAMPLE_ID#','#PRODUCT_SAMPLE_NAME#')">#PRODUCT_SAMPLE_NAME#</a></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>	
        <cfif LIST_PRODUCT_SAMPLE.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif isDefined('is_form_submitted') and is_form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>

        <cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="product.list_product_samples#url_string#">
		</cfif>
    </cf_box>
</div>

<script>
    function send_sample(sample_id,sample_name)
    {
    <cfif isdefined("attributes.field_sample_name")>
		document.<cfoutput>#field_sample_name#</cfoutput>.value = sample_name;
	</cfif>
    <cfif isdefined("attributes.field_sample_id")>
		document.<cfoutput>#field_sample_id#</cfoutput>.value = sample_id;
	</cfif>
    closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=lab.test_parameters&is_sample=1&product_sample_id='+sample_id+'','body_test_rows',1);
}
</script>