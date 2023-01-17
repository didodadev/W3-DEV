<cfif attributes.ilk eq 0>
	<cfif isdefined("attributes.COEFFICIENT") and isdefined("attributes.REQ_TYPE_ID")>
		<cfset LEN_TYPE_ID = LISTLEN(attributes.REQ_TYPE_ID)>
        <cfset LEN_COEF = LISTLEN(attributes.COEFFICIENT)>
		<cfif LEN_TYPE_ID NEQ LEN_COEF>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1740.oran girmediniz'> !");
				history.back();
            </script>
            <cfabort>
        </cfif>
    <cfelseif not isdefined("attributes.COEFFICIENT") and isdefined("attributes.REQ_TYPE_ID")>
		<script type="text/javascript">
            alert("<cf_get_lang no ='1740.oran girmediniz'>!");
            history.back();
        </script>
    	<cfabort>
    </cfif>
</cfif> 
<cfif isdefined("attributes.REQ_TYPE_ID")>
    <cfquery name="control" datasource="#dsn#">
    	SELECT 
        	REQ_ID, 
            POSITION_ID, 
            REQ_TYPE_ID, 
            COEFFICIENT, 
            POSITION_CAT_ID
        FROM 
    	    POSITION_REQUIREMENTS 
        WHERE 
	        POSITION_CAT_ID = #attributes.POSITION_CAT_ID#  
    </cfquery>
    <cfif (control.recordcount) and isdefined("attributes.ilk") and (attributes.ilk eq 1) > 
		<cfset counter1 = 1>
        <cfset control_list = VALUELIST(control.REQ_TYPE_ID)>
   		<cfloop list="#control_list#" index="i">
			<cfif listcontains(attributes.REQ_TYPE_ID,i)>
                <cfset attributes.REQ_TYPE_ID = listdeleteat(attributes.REQ_TYPE_ID,counter1)>
            </cfif>
            <cfset counter1 = counter1 + 1>
        </cfloop>
    </cfif>
    <cfif (control.recordcount) and isdefined("attributes.ilk") and (attributes.ilk eq 0) >
        <cfquery name="DEL_ALL" datasource="#DSN#">
        	DELETE FROM POSITION_REQUIREMENTS WHERE POSITION_CAT_ID = #attributes.POSITION_CAT_ID# 
        </cfquery>
    </cfif>
    <cfset COUNTER = 1>
    <cfloop list="#attributes.REQ_TYPE_ID#" index="i">
		<cfif isDefined("FORM.COEFFICIENT") and len(FORM.COEFFICIENT)>
        	<cfset COEFFICIENT_ = LISTGETAT(FORM.COEFFICIENT,COUNTER)>
        </cfif>
        <cfquery name="add_req" datasource="#dsn#">
            INSERT INTO 
                POSITION_REQUIREMENTS
                (
                    POSITION_CAT_ID,
                    REQ_TYPE_ID
                    <cfif isDefined("COEFFICIENT_") and len(COEFFICIENT_)>
                    	,COEFFICIENT
                    </cfif>
                )
            VALUES
            (
                #attributes.POSITION_CAT_ID#,
                #i#
                <cfif isDefined("COEFFICIENT_") and len(COEFFICIENT_)>
                	,#COEFFICIENT_#
                </cfif>
            )
        </cfquery>
        <cfset COUNTER = COUNTER + 1>
    </cfloop>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
        wrk_opener_reload();
	    window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_box_add_pos_requirement' );
    </cfif>
</script>
