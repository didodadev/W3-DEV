<cfquery name="get_subscription_head" datasource="#dsn3#">
	SELECT * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subs_id#
</cfquery>
<cfquery name="get_page_types" datasource="#dsn#">
	SELECT PAGE_TYPE_ID,PAGE_TYPE FROM SETUP_PAGE_TYPES WHERE OUR_COMPANY_IDS LIKE '%,#session.ep.company_id#,%'
</cfquery>
<cfquery name="get_subscription_pages" datasource="#dsn3#">
	SELECT * FROM SUBSCRIPTION_PAGES WHERE PAGE_ID = #attributes.page_id# ORDER BY PAGE_NO
</cfquery>
<cfquery name="get_subscription_pg" datasource="#dsn3#">
	SELECT * FROM SUBSCRIPTION_PAGES WHERE SUBSCRIPTION_ID=#attributes.subs_id#  ORDER BY PAGE_NO
</cfquery>
<cfif isdefined("attributes.page_type")>
	<cfquery name="get_setup_page_detail" datasource="#dsn#">
		SELECT
			*
		FROM
			SETUP_PAGE_TYPES
			<cfif isDefined("attributes.page_type")>		
			WHERE
				PAGE_TYPE_ID = #attributes.page_type#
			</cfif>			
	</cfquery>
	<cfset tr_topic = get_setup_page_detail.page_type_detail>			
<cfelse>
	<cfset tr_topic = get_subscription_pages.page_content>
</cfif>
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_add_subscription_page&subs_id=#attributes.subs_id#</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('sales',138)#: #get_subscription_head.subscription_no#" right_images="#right_#">
<cfform name="upd_page" method="post" action="#request.self#?fuseaction=sales.emptypopup_upd_subscription_page&subs_id=#subs_id#">
	<input type="Hidden" name="page_id" id="page_id" value="<cfoutput>#page_id#</cfoutput>">
	<cfif get_subscription_pg.recordcount>
        <table width="99%" align="center">
            <tr class="color-list" height="22">
                <td><a href="<cfoutput>#request.self#?fuseaction=sales.popup_add_subscription_page&subs_id=#attributes.subs_id#</cfoutput>"><img src="/images/plus_list.gif" align="right" border="0" title="Ekle"></a></td>
                <td class="txtboldblue"><cf_get_lang no='138.Ek Sayfalar'></td>
            </tr>
            <cfoutput query="get_subscription_pg">
                <tr><cfquery name="get_types" datasource="#dsn#">
                        SELECT * FROM SETUP_PAGE_TYPES WHERE PAGE_TYPE_ID=#page_type#
                    </cfquery>
                    <td align="center" width="20" class="txtboldblue">#page_no#</td>
                    <td><a href="#request.self#?fuseaction=sales.popup_upd_subscription_page&page_id=#get_subscription_pg.page_id#&subs_id=#attributes.subs_id#" class="tableyazi">#get_types.page_type# - #page_name#</a></td> 
                </tr>
            </cfoutput>
        </table>
    </cfif>
    <table>
        <tr>
            <td>&nbsp;&nbsp;<cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='75.No'>&nbsp;
                <cfsavecontent variable="message"><cf_get_lang no='188.no girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="page_no" style="width:40px;" required="Yes" validate="integer" message="#message#" value="#get_subscription_pages.page_no#">
                &nbsp;<cf_get_lang_main no='218.tip'>&nbsp;
                <select name="page_type" id="page_type" style="width:150px;" onchange="document.upd_page.action=''; document.upd_page.submit();">
                    <cfoutput query="get_page_types">
                        <option value="#PAGE_TYPE_ID#" <cfif (isDefined("attributes.page_type") and attributes.page_type eq PAGE_TYPE_ID) or (not isDefined("attributes.page_type") and get_subscription_pages.page_type eq PAGE_TYPE_ID)>selected</cfif>>#PAGE_TYPE#</option>
                    </cfoutput>
                </select>
                &nbsp;<cf_get_lang_main no='68.Başlık'>&nbsp;					  
                <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="page_name" style="width:340px;" required="Yes" message="#message#" value="#get_subscription_pages.page_name#">
            </td>
        </tr>
        <tr> 
            <td>
                <cfmodule template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="page_content"
                    value="#tr_topic#"
                    width="700"
                    height="350">
            </td>
        </tr>
    </table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=sales.emptypopup_del_subscription_page&page_id=#page_id#&subs_id=#subs_id#'><!--- add_function='OnFormSubmit()' --->
	</cf_popup_box_footer>  
</cfform>
</cf_popup_box>
