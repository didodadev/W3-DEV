<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfset url_str = "">
<cfif len(attributes.pcat_id)>
	<cfset url_str = "#url_str#&pcat_id=#attributes.pcat_id#">
</cfif>
<cfif len(attributes.is_ust)>
	<cfset url_str= "#url_str#&is_ust=#attributes.is_ust#">
</cfif>
<cfquery name="get_as_pos" datasource="#dsn#">
	SELECT 
		RELATED_POS_CAT_ID
	FROM 
		EMPLOYEE_CAREER
	WHERE
		POSITION_CAT_ID = #attributes.pcat_id#
</cfquery>
<cfif get_as_pos.recordcount>
	<cfset rel_pos_ids= valuelist(get_as_pos.RELATED_POS_CAT_ID)>
</cfif>
<cfquery name="get_other_pos_cats" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT 
	WHERE 
		POSITION_CAT_ID <> #attributes.pcat_id#
		<cfif isdefined("rel_pos_ids")> 
        	AND POSITION_CAT_ID NOT IN (#rel_pos_ids#)
       	</cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
        	AND POSITION_CAT LIKE '%#attributes.keyword#%'
        </cfif>
	ORDER BY
		POSITION_CAT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_other_pos_cats.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Pozisyon Tipleri','57779')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=hr.popup_list_pos_cats#url_str#" method="post" name="search">
            <cf_box_search>
                    <div class="form-group">
                        <cfinput type="text" placeholder="#getLang('','Filtre','57460')#" name="keyword" value="#attributes.keyword#" maxlength="50">
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
                    </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>	
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_other_pos_cats.recordcount>
                    <cfoutput query="get_other_pos_cats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_add_related_pos_cats&type=#attributes.is_ust#&pcat_id=#attributes.pcat_id#&rel_pos_id=#position_cat_id#&is_ust=#attributes.is_ust#','#attributes.modal_id#')">#POSITION_CAT#</a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="hr.popup_list_pos_cats&#url_str#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
