<cfquery name="qlists" datasource="#dsn#">
    SELECT DISTINCT GROUPKEY FROM WRK_LISTS
</cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th>Liste</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="qlists">
        <tr>
            <td><a href="javascript:void(0)" onclick="buildFormParams('#GROUPKEY#')">#GROUPKEY#</a></td>
        </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>
<script type="text/javascript">
    function buildFormParams(gk) {
        setValue(gk);
    }
    function setValue(val) {
        window.opener.setFieldValue({
            type: "lists",
            name: "lists",
            groupkey: val,
            value: "LIST=>" + val
        });
        window.close();
    }
</script>