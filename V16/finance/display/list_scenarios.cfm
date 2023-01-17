<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
<cfquery name="GET_SCENARIOS" datasource="#DSN#">
	SELECT 
    	SCENARIO_ID, 
        SCENARIO 
    FROM 
    	SETUP_SCENARIO <cfif len(attributes.keyword)>WHERE SCENARIO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
</cfquery>
<cfelse>
	<cfset get_scenarios.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default=#get_scenarios.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=finance.list_scenarios" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0"> 
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword"  placeholder="#getLang('main',48)#​" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('finance',172)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='59321.Senaryo'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none"> 
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_scenarios&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='31179.Senaryo Tanımı Ekle'>" title="<cf_get_lang dictionary_id='31179.Senaryo Tanımı Ekle'>"></i> </a>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_scenarios.recordcount gt 0>
                    <cfoutput query="get_scenarios" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#scenario#</td>
                            <!-- sil --><td width="15"><a href="#request.self#?fuseaction=finance.list_scenarios&event=upd&id=#get_scenarios.scenario_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='54567.Senaryo Tanımı Güncelle'>" alt="<cf_get_lang dictionary_id='54567.Senaryo Tanımı Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>

        <cfset url_str = "finance.list_scenarios">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
