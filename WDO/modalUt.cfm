<cfparam name="attributes.form_submitted" default="0">
<cfparam name="attributes.searchKeyword" default="">
<cfparam name="attributes.searchMaxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.maxrow" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
	<cfif attributes.form_submitted eq 1>
        <cfquery name="getUtilities" datasource="#dsn#">
            SELECT
                UTILITY_ID,
                UTILITY_NAME,
                DETAIL,
                CASE WHEN UTILITY_TYPE = 0 THEN 'ThreePoint'
                WHEN UTILITY_TYPE = 1 THEN 'AutoComplete'
                WHEN UTILITY_TYPE = 2 THEN 'MethodQuery'
                WHEN UTILITY_TYPE = 3 THEN 'Custom Tag'
                END AS TYPES,
                UTILITY_TYPE
            FROM
                UTILITIES
            WHERE
            	1 = 1
                <cfif len(attributes.searchKeyword)>
	            	AND UTILITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.searchKeyword#%">
                </cfif>
        </cfquery>
    <cfelse>
    	<cfset getUtilities.recordcount = 0>
    </cfif>  
    <cfparam name="attributes.totalrecords" default="#getUtilities.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="listUtilities" method="post" action="">
        <input name="form_submitted" id="form_submitted" type="hidden" value="1">
        <cf_box>
			<cfoutput>
                <cf_box_search more="0">
                    <div class="form-group" id="item-keyword">
                        <input type="text" name="searchKeyword" id="searchKeyword" maxlength="50" placeholder="<cf_get_lang_main no='48.Filtre'>" value="#attributes.searchKeyword#">
                    </div>
                    <div class="form-group small" id="item-maxrows">
                        <input type="text" name="maxrow" id="maxrow" value="#attributes.maxrow#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999"  maxlength="3">
                    </div>
                    <div class="form-group" id="item-submit">     
						<cf_wrk_search_button button_type="4">
                    </div>
                </cf_box_search>
            </cfoutput>
        </cf_box>
    </cfform>
    <cf_box title="Utilities" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="20">No</th>
                    <th>Utility Name</th>
                    <th>Description</th>
                    <th><cf_get_lang dictionary_id='32539.Types'></th>
                    <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.utility&type=ut&event=add</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif getUtilities.recordcount>
                    <cfoutput query="getUtilities" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=dev.utility&event=upd&type=ut&utility_id=#UTILITY_ID#">#URLDecode(UTILITY_NAME)#</a></td>
                            <td>#left(URLDecode(DETAIL),250)#</td>
                            <td>#TYPES#</td>
                            <td><a href="#request.self#?fuseaction=dev.utility&event=upd&type=ut&utility_id=#UTILITY_ID#"><i class="fa fa-pencil"></i></a></td>
                        </tr>  
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cfif attributes.form_submitted eq 1><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrow> 
            <cfset adres="dev.utility&form_submitted=1">
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.maxrow)>
                <cfset adres = "#adres#&maxrow=#attributes.maxrow#">
            </cfif>
            <cf_paging
                page="#attributes.page#" 
                maxrows="#attributes.maxrow#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cfif>
    </cf_box>
</div>