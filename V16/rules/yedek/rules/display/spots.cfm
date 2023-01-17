<cfinclude template="../query/get_spots.cfm">
<table width="180">
	<cfoutput query="get_spots">
        <tr>
            <td width="10"><img src="images/arrow_org.gif"></td>
            <td><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id[1]#" class="txtboldblue">#get_spots.cont_head#</a></td>
        </tr>
        <tr>
            <td></td>
            <td>#get_spots.cont_summary#</td>
        </tr>
    </cfoutput>
</table>

