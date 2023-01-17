<cfquery name="get_cont" datasource="#dsn_dev#">
	SELECT * FROM GENIUS_GENERAL
</cfquery>
<cfif not get_cont.recordcount>
	<cfquery name="add_" datasource="#dsn_dev#">
    	INSERT INTO GENIUS_GENERAL (MAIN_COMPUTER_IP) VALUES ('')
    </cfquery>
</cfif>

<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	GENIUS_GENERAL
    SET
    	MAIN_COMPUTER_IP = '#attributes.MAIN_COMPUTER_IP#',
        MAIN_FOLDER = '#attributes.MAIN_FOLDER#'
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=retail.genius_general">