<cfsetting showdebugoutput="no">
<cfif attributes.type eq 1>
    <cfquery name="get_contact" datasource="#dsn#">
        SELECT FOLLOW_MEMBER_ID FROM MEMBER_FOLLOW WHERE FOLLOW_MEMBER_ID = #attributes.partner_id# AND MY_MEMBER_ID = #session.pp.userid#
    </cfquery>
    <cfif get_contact.recordcount eq 0>
        <cfquery name="add_contact" datasource="#dsn#">
            INSERT INTO MEMBER_FOLLOW
                   (
                    MY_MEMBER_ID
                   ,MY_MEMBER_TYPE
                   ,FOLLOW_MEMBER_ID
                   ,FOLLOW_MEMBER_TYPE
                   ,FOLLOW_TYPE)
             VALUES
                   (#session.pp.userid#
                   ,'PARTNER'
                   ,#attributes.partner_id#
                   ,'PARTNER'
                   ,1)
        </cfquery>
    </cfif>
<cfelse>
	<cfquery name="del_contact" datasource="#dsn#">
        DELETE FROM MEMBER_FOLLOW WHERE FOLLOW_MEMBER_ID = #attributes.partner_id# AND MY_MEMBER_ID = #session.pp.userid#
    </cfquery>
</cfif>
<cfabort>
