<cfparam name="attributes.ot" default="">
<cfparam name="attributes.target_id" default="">
<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.pid" default="">
<cfobject name="measure" component="addons.n1-soft.textile.cfc.measure">
<cfif len(attributes.ot)>
    <cfset ot_id = listLast( attributes.ot, "-" )>
    <cfquery name="query_ot" datasource="#dsn3#">
    SELECT *
    FROM #dsn3#.TEXTILE_MEASUREMENT_HEADER
    WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#ot_id#'>
    </cfquery>
    <cfif query_ot.recordCount gt 0>
        <cfset new_header_id = measure.copy_measure_header( ot_id, attributes.target_id, query_ot.REQUEST_ID )>
        <cfset measure.copy_measure_items( ot_id, new_header_id )>
        <script type="text/javascript">
            window.location.href = <cfoutput>"#request.self#?fuseaction=textile.stretching_test&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#&mh_id=#new_header_id#"</cfoutput>
        </script>
    <cfelse>
        <script type="text/javascript">
            window.location.href = <cfoutput>"#CGI.HTTP_REFERER#&copyerr=notfound"</cfoutput>
        </script>
    </cfif>
<cfelse>
    <script type="text/javascript">
        window.location.href = <cfoutput>"#CGI.HTTP_REFERER#&copyerr=idempty"</cfoutput>
    </script>
</cfif>