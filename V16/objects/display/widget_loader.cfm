
<cfset dsn = application.systemParam.systemParam().dsn>
<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.cp")>
    <cfset session_base = evaluate('session.cp')>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
</cfif>

<!--- <cfinclude template="../cfc/functions.cfc"> --->
<cfquery name = "get_widget" datasource = "#dsn#">
    SELECT WIDGETID,WIDGET_TITLE,WIDGET_FILE_PATH,WIDGET_TOOL FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.widget_load#'>
</cfquery>
<cfparam  name="attributes.isbox" default="0">
<cfparam  name="attributes.style" default="standart">
<cfif get_widget.recordcount>
    <cfif get_widget.WIDGET_TOOL eq 'code'>
        <cfif attributes.isbox eq 1>
            <cf_box class="#attributes.style#" title="#get_widget.WIDGET_TITLE#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" id="box_#get_widget.WIDGETID#" modal_id="#iif(isdefined("attributes.modal_id"),attributes.modal_id,'')#">
                <cfinclude  template="/#get_widget.WIDGET_FILE_PATH#">
            </cf_box>              
        <cfelse>
            <cfinclude  template="/#get_widget.WIDGET_FILE_PATH#">
        </cfif>
    <cfelse>
        NOCODE
    </cfif>
</cfif>