<cfif len(attributes.PRIZE_DATE)>
	<cf_date tarih="attributes.PRIZE_DATE">
</cfif>
<cfquery name="ADD_PRIZE" datasource="#dsn#">
  INSERT INTO
 	EMPLOYEES_PRIZE
	(
        PRIZE_GIVE_PERSON,
        PRIZE_TYPE_ID,
        <cfif len(attributes.PRIZE_DATE)>
            PRIZE_DATE,
        </cfif>	
        PRIZE_TO,
        PRIZE_HEAD,
        <cfif len(attributes.PRIZE_DETAIL)>
            PRIZE_DETAIL,
        </cfif>	
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE
	)
  VALUES
    (
        #attributes.prize_give_person_id#,
        #attributes.PRIZE_TYPE#,
        <cfif len(attributes.PRIZE_DATE)>
            #attributes.PRIZE_DATE#,
        </cfif>	
        #attributes.PRIZE_TO_ID#,
        '#attributes.PRIZE_HEAD#',
        <cfif len(attributes.PRIZE_DETAIL)>
            '#attributes.PRIZE_DETAIL#',
        </cfif>	
        #SESSION.EP.USERID#,
        '#CGI.REMOTE_ADDR#',
        #NOW()#
	)
</cfquery>
<script type="text/javascript">
    <cfif isDefined("attributes.from_fuseaction") and len(attributes.from_fuseaction)>
        closeBoxDraggable('add_prize_box');
        location.reload();
    <cfelse>
        <cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
    </cfif>
</script>