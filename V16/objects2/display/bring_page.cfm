<cfif isDefined('attributes.page_url') and len(attributes.page_url)>
	<cfoutput>
        <div id="bring_page_#this_row_id_#" style="width:#attributes.bring_page_width#px;height:#attributes.bring_page_height#px; z-index:9999;background-color:#colorrow#; border:1px outset cccccc; overflow:auto;">
            <script type="text/javascript">
                AjaxPageLoad('#request.self#?fuseaction=objects2.emptypopup_get_url&my_url=#attributes.page_url#','bring_page_#this_row_id_#');
            </script>
        </div>
    </cfoutput>
</cfif>
