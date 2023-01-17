<!--- 
<cf_box>
    <cfinclude template="../../settings/form/exceptions.cfm">
</cf_box> --->
<cfparam name="attributes.modal_id" default="">
<cfsavecontent  variable="message"><cf_get_lang dictionary_id="60107.İstisnalar"></cfsavecontent>
    <cfquery name="GET_EXCEPTIONS" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            VAT_EXCEPTION
    </cfquery>
    <script type="text/javascript">
        function add_exc(exc_id,exc_code,exc_article)
        {   
            <cfif isDefined("attributes.field_exc_id")>
                <cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.<cfoutput>#attributes.field_exc_id#</cfoutput>.value = exc_id;
            </cfif>
            <cfif isDefined("attributes.field_exc_code")>
                <cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.<cfoutput>#attributes.field_exc_code#</cfoutput>.value = exc_code;
            </cfif>
            <cfif isDefined("attributes.field_exc_article")>
                <cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.<cfoutput>#attributes.field_exc_article#</cfoutput>.value = exc_article;
            </cfif>
            <cfif isdefined("attributes.call_function")>
                try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
                    catch(e){};
            </cfif>
            <cfif isdefined("attributes.draggable")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');<cfelse>window.close();</cfif>
        }
    </script>
  <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58585.Kod"></th>
                <th><cf_get_lang dictionary_id="60108.madde"></th>
                <th><cf_get_lang dictionary_id="36199.aciklama"></th>
            </tr>
        </thead>
        <tbody>
            <cfif GET_EXCEPTIONS.recordcount>
                <cfoutput query="GET_EXCEPTIONS">
                    <tr>
                        <td><a href="javascript:add_exc('#VAT_EXCEPTION_ID#','#VAT_EXCEPTION_CODE#','#VAT_EXCEPTION_ARTICLE#');" class="tableyazi">#VAT_EXCEPTION_CODE#</a></td>
                        <td>#VAT_EXCEPTION_ARTICLE#</td>
                        <td>#VAT_EXCEPTION_DETAIL#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang_main no='72.Kayit Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>
    