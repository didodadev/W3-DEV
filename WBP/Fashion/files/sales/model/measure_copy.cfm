<cfparam name="attributes.ot" default="">
<cfparam name="attributes.target_id" default="">
<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.pid" default="">
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfif len(attributes.ot)>
    <cfset ot_id = listLast( attributes.ot, "-" )>
    <cfif query_ot.recordCount gt 0>
        <cfset new_header_id = measure.copy_measure_header( ot_id, attributes.target_id, attributes.req_id )>
        <cfset measure.copy_measure_items( ot_id, new_header_id, attributes.req_id )>
        <script type="text/javascript">
            window.location.href = <cfoutput>"#request.self#?fuseaction=textile.stretching_test&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#&mh_id=#new_header_id#"</cfoutput>
        </script>
    <cfelse>
        <script type="text/javascript">
            window.location.href = <cfoutput>"#replace(CGI.HTTP_REFERER,"&copyerr=notfound","")#&copyerr=notfound"</cfoutput>
        </script>
    </cfif>
<cfelse>
    <script type="text/javascript">
        window.location.href = <cfoutput>"#replace(CGI.HTTP_REFERER,"&copyerr=idempty","")#&copyerr=idempty"</cfoutput>
    </script>
</cfif>