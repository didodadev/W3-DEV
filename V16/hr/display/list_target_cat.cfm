<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_TARGETS_CAT" datasource="#dsn#">
		SELECT 
			TARGETCAT_ID,
			#dsn#.Get_Dynamic_Language(TARGETCAT_ID,'#session.ep.language#','TARGET_CAT','TARGETCAT_NAME',NULL,NULL,TARGETCAT_NAME) AS TARGETCAT_NAME,
			RECORD_EMP
		FROM
			TARGET_CAT
		WHERE
			1=1
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND TARGETCAT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_targets_cat.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_TARGETS_CAT.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_target" method="post" action="#request.self#?fuseaction=hr.list_target_cat">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <input placeHolder="<cf_get_lang dictionary_id='57460.Filtre'>" type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50"/>
                    </div>
                </div>
                <div class="form-group x-4_5">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56304.Hedef Kategorileri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57486.kategori'></th>
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_target_cat&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif GET_TARGETS_CAT.recordcount>
                    <cfoutput query="GET_TARGETS_CAT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td height="35">#currentrow#</td>
                            <td>#targetcat_name#</td>
                            <!-- sil --><td style="text-align:center;"><a href="#request.self#?fuseaction=hr.list_target_cat&event=upd&targetcat_id=#TARGETCAT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.list_target_cat#url_str#">
    </cf_box>
</div>
<script language="javascript">
	document.getElementById('keyword').focus();
</script>	
