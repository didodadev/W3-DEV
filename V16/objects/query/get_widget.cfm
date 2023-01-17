<cfif not isdefined("attributes.panelName")><!--- panelName parametresi güncelleme sayfasından geliyor. Hem ekleme hem güncellemeyi tek yerden yapmak için eklendi. EY 20120111 --->
    <cfquery name="GET_WIDGET_POS" datasource="#DSN#">
        SELECT 
            COLUMN_INDEX,SEQUENCE_INDEX
        FROM
            MY_SETTINGS_POSITIONS
        WHERE
            PANEL_NAME = 'homebox_widget' AND
            EMP_ID = #session.ep.userid#
    </cfquery>
<cfelse>
    <cfquery name="GET_WIDGET_POS_UPD" datasource="#DSN#">
        SELECT 
            MENU_POSITION_ID,WIDGET_HEAD,URL,WIDGET_SHOW_IMAGE,WIDGET_SCRIPT,WIDGET_RECORD_COUNT
        FROM
            MY_SETTINGS_POSITIONS
        WHERE
            PANEL_NAME = '#attributes.panelName#' AND
            EMP_ID = #session.ep.userid#
    </cfquery>
</cfif>
