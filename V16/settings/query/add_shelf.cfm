<cfset attributes.control_id = form.shelf_no>
<cfinclude template="get_shelf.cfm">
<cfif get_shelf.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no='711.Seçtiğiniz Raf Kod numarası Mevcut ! Değiştiriniz !'>");
		history.go(-1); 
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_SHELF" datasource="#DSN#">
	INSERT INTO 
	    SHELF
    (
        SHELF_ID,
        SHELF_NAME,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
	VALUES
    (
        #form.shelf_no#,
        '#form.shelf_name#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_shelf" addtoken="no">
