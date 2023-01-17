<cfparam name="attributes.filter" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
<cfform name="list_upper_cats" action="#request.self#?fuseaction=settings.list_sector_upper" method="post">
    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <cf_box_search more="0">	
        <div class="form-group">
            <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
            <input type="text" id="filter" name="filter" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfoutput>#attributes.filter#</cfoutput>" />
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
<cf_box title="#getLang('','Üst Sektörler',43810)#" uidrop="1" hide_table_column="1">
    <cf_grid_list>
    <thead>
        <tr>
        	<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
            <th width="35"><cf_get_lang dictionary_id="42942.Sektör Kodu"></th>
        	<th><cf_get_lang dictionary_id="57579.Sektör"></th>
            <th width="35" class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_sector_upper"><i class="fa fa-plus" border="0" alt=<cf_get_lang dictionary_id="57582.Ekle"> title='<cf_get_lang dictionary_id="57582.Ekle">'></i></a></cfoutput></th>
	        <th width="35" class="header_icn_none"></th>
        </tr>
    </thead>
    <cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
        <cfquery name="GETUPPERCATS" datasource="#DSN#">
            SELECT
                #dsn#.Get_Dynamic_Language(SECTOR_UPPER_ID,'#session.ep.language#','SETUP_SECTOR_CAT_UPPER','SECTOR_CAT',NULL,NULL,SECTOR_CAT) AS SECTOR_CAT,
                SECTOR_CAT_CODE,
                SECTOR_UPPER_ID
            FROM
                SETUP_SECTOR_CAT_UPPER
        <cfif len(attributes.filter)>
            WHERE
                   SECTOR_CAT LIKE '%#attributes.filter#%' OR 
                SECTOR_CAT_CODE LIKE '%#attributes.filter#%'
        </cfif>       
        </cfquery>
    <cfelse>
        <cfset getUpperCats.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#getUpperCats.recordcount#">
    <tbody>
        <cfif getUpperCats.recordcount>
                <cfoutput query="getUpperCats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#sector_cat_code#</td>
                        <td><a href="#request.self#?fuseaction=settings.form_upd_sector_upper&sector_upper_id=#sector_upper_id#">#sector_cat#</a></td>
                        <td width="15"><a href="#request.self#?fuseaction=settings.form_upd_sector_upper&sector_upper_id=#sector_upper_id#"><i class="fa fa-pencil" alt='<cf_get_lang dictionary_id="57464.Güncelle">' title='<cf_get_lang dictionary_id="57464.Güncelle">'></i></a></td>
                        <td width="15" class="text-center"><cfif len(sector_cat_code)><a href="#request.self#?fuseaction=settings.list_sector_cat&is_form_submitted=1&upper_sector_code=#sector_cat_code#"><img src="/images/graphcontinue.gif" title="<cf_get_lang dictionary_id='54879.Alt Sektörleri Göster'>"  alt="<cf_get_lang dictionary_id='54879.Alt Sektörleri Göster'>" /></a><cfelse>&nbsp;</cfif></td>                        
                    </tr> 
                </cfoutput>   
            </tbody>
        <cfelse>
                <tr>
                    <td colspan="5"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701. Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayit Bulunamadi'>!</cfif></td>
                </tr>
        </cfif>
    </tbody>
    </cf_grid_list>
</cf_box>

    <!--- <thead>
    	<tr>
        	<th width="35">Sıra</th>
            <th width="35">Sektör Kodu</th>
        	<th>Sektör</th>
            <th class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_sector_upper"><img src="/images/plus_list.gif" alt=" Ekle "></a></cfoutput></th>
	        <th class="header_icn_none"></th>
        </tr>
    </thead> --->
<!--- <cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
	<cfquery name="GETUPPERCATS" datasource="#DSN#">
    	SELECT
        	SECTOR_CAT,
            SECTOR_CAT_CODE,
            SECTOR_UPPER_ID
        FROM
        	SETUP_SECTOR_CAT_UPPER
	<cfif len(attributes.filter)>
        WHERE
           	SECTOR_CAT LIKE '%#attributes.filter#%' OR 
            SECTOR_CAT_CODE LIKE '%#attributes.filter#%'
	</cfif>       
    </cfquery>
<cfelse>
	<cfset getUpperCats.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#getUpperCats.recordcount#">
<tbody>
    <cfif getUpperCats.recordcount>
            <cfoutput query="getUpperCats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>#sector_cat_code#</td>
                    <td><a href="#request.self#?fuseaction=settings.form_upd_sector_upper&sector_upper_id=#sector_upper_id#">#sector_cat#</a></td>
                    <td width="15"><a href="#request.self#?fuseaction=settings.form_upd_sector_upper&sector_upper_id=#sector_upper_id#"><img src="/images/update_list.gif" title=" Güncelle " alt=" Güncelle "></a></td>
                    <td width="15" style="text-align:center"><cfif len(sector_cat_code)><a href="#request.self#?fuseaction=settings.list_sector_cat&is_form_submitted=1&upper_sector_code=#sector_cat_code#"><img src="/images/graphcontinue.gif" title=" Alt Sektörleri Göster "  alt=" Alt Sektörleri Göster " /></a><cfelse>&nbsp;</cfif></td>                        
                </tr> 
            </cfoutput>   
        </tbody>
    <cfelse>
            <tr>
                <td colspan="5"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'>!</cfif></td>
            </tr>
    </cfif>
</tbody> --->
<!--- </cf_big_list> --->
<cfset url_str = "&is_form_submitted=1">
<cfif isdefined("attributes.upper_sector_name") and len(attributes.upper_sector_name)>
	<cfset url_str = "#url_str#&upper_sector_name=#attributes.upper_sector_name#">
</cfif>
<cfif isdefined("attributes.upper_sector_code") and len(attributes.upper_sector_code)>
	<cfset url_str = "#url_str#&upper_sector_code=#attributes.upper_sector_code#">
</cfif>
<cf_paging 
page="#attributes.page#"
maxrows="#attributes.maxrows#"
totalrecords="#attributes.totalrecords#"
startrow="#attributes.startrow#"
adres="settings.list_sector_upper#url_str#">
<script type="text/javascript">
    document.getElementById('filter').focus();
</script>
