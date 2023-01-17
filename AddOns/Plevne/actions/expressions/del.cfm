<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.expression_id" default="0">

<cfobject name="inst_expression" type="component" component="#addonns#.domains.expressions">
<cfset inst_expression.delete_expression(expression_id: attributes.expression_id)>

<script type="text/javascript">
    window.close();
</script>