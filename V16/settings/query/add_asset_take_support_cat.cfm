<cfquery name="add_asset_sup_take_cat" datasource="#DSN#">
	INSERT INTO 
        ASSET_TAKE_SUPPORT_CAT
    (
        TAKE_SUP_CAT,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#TAKE_SUP_CAT#',
        '#DETAIL#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_take_support_cat" addtoken="no">
