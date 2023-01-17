<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.expression_id" default="0">
<cfparam name="attributes.expression_category" default="">
<cfparam name="attributes.expression_body" default="">
<cfparam name="attributes.status" default="1">

<cfif not len(attributes.expression_category)>
    <script type="text/javascript">
        alert("Eksik bilgi!");
        history.back();
    </script>
</cfif>
<cfif not len(attributes.expression_body)>
    <script type="text/javascript">
        alert("Expression boş olamaz!");
        history.back();
    </script>
</cfif>

<cfobject name="inst_expression" type="component" component="#addonns#.domains.expressions">
<cfset inst_expression.save_expressions(expression_id: attributes.expression_id, expression_body: attributes.expression_body, status: attributes.status)>

<script type="text/javascript">
    window.close();
</script>