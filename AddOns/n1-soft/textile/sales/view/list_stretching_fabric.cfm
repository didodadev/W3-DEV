<cfparam name="attributes.opp_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.st_id" default="">
<cfparam name="attributes.purchasing_id" default="">

<cfset MODULE_NAME = ""><!--- for test --->

<cfobject name="fabric" component="addons.n1-soft.textile.cfc.fabric">
<cfset lof_fabric = fabric.list_fabric(project_id: attributes.project_id, stretching_test_id: attributes.st_id,purchasing_id:attributes.purchasing_id)>

<table width="100%" class="form_list" id="list_stretching_fabric">
    <thead>
        <tr>
            <th>S.No</th>
            <th>Top No</th>
            <th>Metraj</th>
			<th>Kumaş En</th>
            <th>Boy Cekme</th>
            <th>En Cekme</th>
            <th>Egalize</th>
            <th>Renk</th>
            <th>Renk En</th>
            <th>Renk Boy</th>
            <th>CT Talebi</th>
        </tr>
    </thead>
    <tbody><input type="hidden" name="fabric_count" value="<cfoutput>#lof_fabric.recordcount#</cfoutput>">
        <cfoutput query="lof_fabric">
        <tr>
            <td style="text-align: right;">
                #currentrow#
                <input type="hidden" name="fabric_id#currentrow#" id="fabric id#currentrow#" value="#FABRIC_ID#">
            </td>
            <td style="text-align: right;"><cfif len(ROLL_NR)>#ROLL_NR#<cfelse>#LOT_NO#</cfif></td>
            <td style="text-align: right;"><cfif len(METERING)>#METERING#<cfelse>#amount#</cfif></td>
			<td><input type="number" name="fabric_width#currentrow#" id="fabric_width#currentrow#" value="#FABRIC_WIDTH#" style="width: 100%;" data-rule="numeric"></td>
            <td><input type="number" name="height_shrinkage#currentrow#" id="height_shrinkage#currentrow#" value="#HEIGHT_SHRINKAGE#" style="width: 100%;" data-rule="numeric"></td>
            <td><input type="number" name="width_shrinkage#currentrow#" id="width_shrinkage#currentrow#" value="#WIDTH_SHRINKAGE#" style="width: 100%;" data-rule="numeric"></td>
            <td><input type="number" name="smooth#currentrow#" id="smooth#currentrow#" value="#SMOOTH#" style="width: 100%;" data-rule="numeric"></td>
            <td>
                <select name="color#currentrow#" id="color#currentrow#" style="width: 100%;" data-rule="">
                    <option value="">SECINIZ</option>
                    <option #iif(color eq "SARI", DE("selected"), DE(""))#>SARI</option>
                    <option #iif(color eq "KIRMIZI", DE("selected"), DE(""))#>KIRMIZI</option>
                    <option #iif(color eq "MAVI", DE("selected"), DE(""))#>MAVI</option>
                    <option #iif(color eq "MOR", DE("selected"), DE(""))#>MOR</option>
                    <option #iif(color eq "TURUNCU", DE("selected"), DE(""))#>TURUNCU</option>
                    <option #iif(color eq "YESIL", DE("selected"), DE(""))#>YESIL</option>
                </select>
            </td>
            <td><input type="number" name="height_color#currentrow#" id="height_color#currentrow#" value="#HEIGHT_COLOR#" style="width: 100%;" data-rule="numeric"></td>
            <td><input type="number" name="width_color#currentrow#" id="width_color#currentrow#" value="#WIDTH_COLOR#" style="width: 100%;" data-rule="numeric"></td>
            <td><input type="checkbox" name="is_shrinkage_request#currentrow#" id="is_shrinkage_request#currentrow#" value="1" #iif(IS_SHRINKAGE_REQUEST eq 1, DE("checked"), DE(""))#>
        </tr>
        </cfoutput>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="11">
                <cf_workcube_buttons is_upd='0' type_format="1" add_function="list_stretching_fabric_kontrol()">
            </td>
        </tr>
    </tfoot>
</table>
<script type="text/javascript">
    function list_stretching_fabric_kontrol() {
        var list_stretching_fabric_numerics = document.querySelectorAll('#list_stretching_fabric [data-rule*="numeric"]');
        list_stretching_fabric_numerics.forEach(element => {
            if ( isNaN( element.valueAsNumber ) ) {
                var idx = [].slice.call(element.closest("tr").children).indexOf(element.parentElement);
                var elms = document.querySelector('#list_stretching_fabric thead tr').children;
                alert(elms[idx].innerText + " sayısal değer içermelidir!");
                element.focus();
                return false;
            }
        });
        list_stretching_fabric_requireds = document.querySelectorAll('#list_stretching_fabric [data-rule*="required"]');
        list_stretching_fabric_requireds.forEach(element => {
            if ( element.value == "" ) {
                var idx = [].slice.call(element.closest("tr").children).indexOf(element.parentElement);
                var elms = document.querySelector('#list_stretching_fabric thead tr').children;
                alert(elms[idx].innerText + " boş olamaz!");
                element.focus;
                return false;
            }
        });
        return true;
    }
</script>
