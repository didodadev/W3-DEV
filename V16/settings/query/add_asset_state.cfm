<cfquery name="ADD_ASSET_STATE" datasource="#DSN#">
    INSERT INTO 
        ASSET_STATE
    (
        ASSET_STATE,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#attributes.asset_state#',
        '#attributes.detail#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_state" addtoken="no">
