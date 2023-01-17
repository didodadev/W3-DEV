<cfparam name="attributes.upper_sector_code" default="" >
<cfparam name="attributes.sector_code" default="" >
<cfparam name="attributes.filter" default="" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
    <cfform name="list_cats" action="#request.self#?fuseaction=settings.list_sector_cat" method="post">
        <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
        <cf_box_search more="0">	
            <div class="form-group">
                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <input type="text" id="filter" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" name="filter" value="<cfoutput>#attributes.filter#</cfoutput>" />
            </div>	
            <div class="form-group">
                <cfsavecontent variable="place"><cf_get_lang dictionary_id="42942.Sektör Kodu"></cfsavecontent>
                <input type="text" id="sector_code" name="sector_code" value="<cfoutput>#attributes.sector_code#</cfoutput>"placeholder="<cf_get_lang dictionary_id='42942.Sektör Kodu'>" />
            </div>	
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>

</cfform>
</cf_box>
<cf_box title="#getLang('','Sektör Kategorileri',43585)#" uidrop="1" hide_table_column="1">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
                <th nowrap="nowrap" width="65"><cf_get_lang dictionary_id="42942.Sektör Kodu"></th>
                <th><cf_get_lang dictionary_id="43647.Üst Sektör"></th>
                <th><cf_get_lang dictionary_id="57579.Sektör"> </th>
                <th width="35" class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_sector_cat" ><i class="fa fa-plus" border="0" alt=<cf_get_lang dictionary_id="57582.Ekle"> title='<cf_get_lang dictionary_id="57582.Ekle">'></i></a></cfoutput></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
                <cfquery name="getCats" datasource="#dsn#">
                   SELECT 
                        *
                   FROM
                   (
                        SELECT 
                            SECTOR_CAT_ID, 
                            SCC.SECTOR_UPPER_ID, 
                            #dsn#.Get_Dynamic_Language(SECTOR_CAT_ID,'#session.ep.language#','SETUP_SECTOR_CATS','SECTOR_CAT',NULL,NULL,SCC.SECTOR_CAT) AS SECTOR_CAT,
                            SCC.SECTOR_CAT_CODE,
                            SSCU.SECTOR_CAT_CODE AS SECTOR_UPPER_CODE,
                            #dsn#.Get_Dynamic_Language(SSCU.SECTOR_UPPER_ID,'#session.ep.language#','SETUP_SECTOR_CAT_UPPER','SECTOR_CAT',NULL,NULL,SSCU.SECTOR_CAT) AS SECTOR_UPPER,
                            CASE WHEN SSCU.SECTOR_CAT_CODE IS NOT NULL THEN (SSCU.SECTOR_CAT_CODE) ELSE ('') END + '-' +
                            CASE WHEN SCC.SECTOR_CAT_CODE IS NOT NULL THEN (SCC.SECTOR_CAT_CODE) ELSE ('') END AS SECTOR_CODE
                        FROM 
                            SETUP_SECTOR_CATS SCC 
                        LEFT JOIN SETUP_SECTOR_CAT_UPPER SSCU ON SCC.SECTOR_UPPER_ID = SSCU.SECTOR_UPPER_ID 
                        WHERE
                            1=1
                            <cfif len (attributes.upper_sector_code)>AND SSCU.SECTOR_CAT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upper_sector_code#"></cfif> 
                            <cfif len (attributes.filter)>
                                AND SCC.SECTOR_CAT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.filter#%">
                                OR SCC.SECTOR_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.filter#%">
                                OR SSCU.SECTOR_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.filter#%">
                            </cfif>
                    ) AS SECTOR_CATS
                    <cfif len (attributes.sector_code)>WHERE SECTOR_CATS.SECTOR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.sector_code#%"></cfif>
                    ORDER BY 
                        CASE 
                            WHEN ISNUMERIC(SECTOR_UPPER_CODE) = 1 THEN CONVERT(INT, SECTOR_UPPER_CODE) 
                            ELSE 99999999 
                        END ASC,
                        CASE 
                            WHEN ISNUMERIC(SECTOR_CAT_CODE) = 1 THEN CONVERT(INT, SECTOR_CAT_CODE) 
                            ELSE 99999999 
                        END ASC, 
                        SECTOR_CAT ASC
                </cfquery>
            <cfelse>
                <cfset getCats.recordcount = 0>
            </cfif>
            <cfparam name="attributes.totalrecords" default="#getCats.recordcount#">
            <cfif getCats.recordcount>
                <cfoutput query="getCats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td width="35"><strong>#sector_upper_code#</strong> #IIf(len(sector_upper_code) and len(sector_cat_code), DE("-"), DE(""))# #sector_cat_code#</td>
                        <td><a href="#request.self#?fuseaction=settings.form_upd_sector_upper&sector_upper_id=#sector_upper_id#" class="tableyazi">#sector_upper#</a></td>
                        <td style="max-width:500px; overflow:hidden"><a href="#request.self#?fuseaction=settings.form_upd_sector_cat&sector_cat_id=#sector_cat_id#">#sector_cat#</a></td>
                        <td width="15"><a href="#request.self#?fuseaction=settings.form_upd_sector_cat&sector_cat_id=#sector_cat_id#"><i class="fa fa-pencil" alt='<cf_get_lang dictionary_id="57464.Güncelle">' title='<cf_get_lang dictionary_id="57464.Güncelle">'></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701. Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayit Bulunamadi'>!</cfif></td>
                </tr>
            </cfif> 
        </tbody>

    </cf_grid_list>
</cf_box>

<cfset url_str = "&is_form_submitted=1">
<cfif isdefined("attributes.upper_sector_code") and len(attributes.upper_sector_code)>
	<cfset url_str = "#url_str#&upper_sector_code=#attributes.upper_sector_code#">
</cfif>
<cfif isdefined("attributes.filter") and len(attributes.filter)>
	<cfset url_str = "#url_str#&filtere=#attributes.filter#">
</cfif>
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="settings.list_sector_cat#url_str#">
<script type="text/javascript">
	document.getElementById('filter').focus();
</script>
