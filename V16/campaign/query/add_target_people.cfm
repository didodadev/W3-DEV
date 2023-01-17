<cfif attributes.member_type is 'partner'>
    <cfloop list="#attributes.par_ids#" index="par_id">
        <cfquery name="control" datasource="#DSN3#">
            SELECT PAR_ID FROM CAMPAIGN_TARGET_PEOPLE WHERE CAMP_ID=#attributes.camp_id# AND PAR_ID=#par_id#
        </cfquery>
		<cfif CONTROL.RECORDCOUNT EQ 0>
            <cfquery name="add_con_par" datasource="#DSN3#">
            INSERT INTO
                CAMPAIGN_TARGET_PEOPLE
            (
                CAMP_ID,
                PAR_ID,
                RECORD_EMP,
                RECORD_DATE
            )
            VALUES
            (
                #attributes.camp_id#,
                #par_id#,
                #SESSION.EP.USERID#,
                #NOW()#
            )
            </cfquery>
        </cfif>
    </cfloop>
<cfelseif attributes.member_type is 'consumer'>
    <cfloop list="#attributes.con_ids#" index="con_id">
        <cfquery name="control1" datasource="#DSN3#">
        	SELECT CON_ID FROM CAMPAIGN_TARGET_PEOPLE WHERE CAMP_ID=#attributes.camp_id# AND CON_ID=#con_id# 
        </cfquery>
		<cfif control1.recordcount eq 0>
            <cfquery name="add_par_con" datasource="#DSN3#">
            INSERT INTO
            	CAMPAIGN_TARGET_PEOPLE
            (
                CAMP_ID,
                CON_ID,
                RECORD_EMP,
                RECORD_DATE
            )
            VALUES
            (
                #attributes.camp_id#,
                #con_id#,
                #SESSION.EP.USERID#,
                #NOW()#
            )
            </cfquery>
        </cfif>
    </cfloop>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
