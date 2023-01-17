<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfset cmp = createObject("component","V16.worknet.cfc.watalogy_general")>
    <cfset get_categories = cmp.get_watalogy_google_product_cats(
        keyword : attributes.keyword
    )>
<cfelse> 
	<cfset get_categories.recordcount = 0>
</cfif> 
<cfparam name="attributes.totalrecords" default='#get_categories.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="list_categories" id="list_categories" method="post" action="">
    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_box id="list_categories_search" closable="0" collapsable="0">
        <cf_box_search plus="0">
            <div class="form-group">
                <cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;" placeholder="#getLang('main',48)#">
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>
    </cf_box>
</cfform>

<cfsavecontent  variable="title"><cf_get_lang dictionary_id='61452.Watalogy Ürün Kategorileri'></cfsavecontent>
<cf_box id="category_cat_list" closable="0" collapsable="0" title="#title#"> 
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58527.ID'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>1</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>2</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>3</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>4</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>5</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>6</th>
                <th><cf_get_lang dictionary_id='57486.Kategori'>7</th>
            </tr>       
        </thead>
        <tbody>
            <cfif get_categories.recordcount>
                <cfoutput query="get_categories" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#GOOGLE_PRODUCT_CAT_ID#</td>
                        <td>#CATEGORY1#</td>
                        <td>#CATEGORY2#</td>
                        <td>#CATEGORY3#</td>
                        <td>#CATEGORY4#</td>
                        <td>#CATEGORY5#</td>
                        <td>#CATEGORY6#</td>
                        <td>#CATEGORY7#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>

    <cfset url_str = "#attributes.fuseaction#">
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">
</cf_box>