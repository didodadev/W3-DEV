<cfsetting showdebugoutput="no">
<cfparam name="attributes.pages" default="">
<cfquery name="GET_PAGES" datasource="#dsn#">
	SELECT
    	W.FULL_FUSEACTION,
        W.CONTROLLER_FILE_PATH,
        SLT.ITEM_#session.ep.language# AS ITEM
    FROM
    	WRK_OBJECTS AS W
        LEFT JOIN SETUP_LANGUAGE_TR AS SLT ON SLT.ITEM_ID = W.DICTIONARY_ID AND SLT.MODULE_ID = 'main'
    WHERE
    	W.CONTROLLER_FILE_PATH IS NOT NULL
		AND W.FULL_FUSEACTION <> 'dev.pageDesigner'
</cfquery>
<cfform name="pageDesigner" method="post" action="#request.self#?fuseaction=dev.pageDesigner">
	<input type="hidden" name="formSubmitted" value="1" />
    <cf_big_list_search> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>Sayfa Seçiniz</td>
                    <td>
                        <select name="pages" id="pages">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="GET_PAGES">
                                <option value="#FULL_FUSEACTION#;#CONTROLLER_FILE_PATH#" <cfif '#FULL_FUSEACTION#;#CONTROLLER_FILE_PATH#' is attributes.pages>selected</cfif>>#ITEM#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
    	<tr>
        	<th>Sayfa</th>
            <th class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=dev.pageDesigner&event=add&page=#attributes.pages#</cfoutput>"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
        </tr>
    </thead>
    <tbody>
    	<tr>
        	<td></td>
            <td></td>
        </tr>
    </tbody>
</cf_big_list>
