<cfquery name = "get_widget" datasource = "#dsn#">
    SELECT WIDGETID,WIDGET_TITLE,WIDGET_TITLE_DICTIONARY_ID,WIDGET_FILE_PATH,WIDGET_TOOL FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.widget_load#'>
</cfquery>
<cfset attributes.param_1 = attributes.widget_load>
<cfparam  name="attributes.isbox" default="0">
<cfparam  name="attributes.style" default="standart">
<cfparam  name="attributes.title" default="standart">
<cfif get_widget.recordcount>
    <cfif get_widget.WIDGET_TOOL eq 'code'>
        <cfif attributes.isbox eq 1>
            <cf_box class="#attributes.style#" title="#len(attributes.title) ? attributes.title : getLang('','',get_widget.WIDGET_TITLE_DICTIONARY_ID)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" id="box_#get_widget.WIDGETID#" modal_id="#iif(isdefined("attributes.modal_id"),attributes.modal_id,'')#">
                <div class="container-fluid">
                    <cfinclude  template="/#get_widget.WIDGET_FILE_PATH#">
                </div>
            </cf_box>              
        <cfelse>
            <cfinclude  template="/#get_widget.WIDGET_FILE_PATH#">
        </cfif>
    <cfelse>
        NOCODE
    </cfif>
</cfif>