<cf_box>
    <table class="ajax_list">
        <cfloop from="1" to="#listlen(kolon_names)#" index="ccc">
            <cfoutput>
            <tr>
                <td width="100"><input type="checkbox" <cfif not listfind(hide_col_list,'kolon_#ccc#')>checked="checked"</cfif> value="1" name="kolon_#ccc#" id="kolon_#ccc#" onclick="show_hide_coloum('#ccc#','0');"/>#ccc# #listgetat(kolon_names,ccc)#</td>
            </tr>
            </cfoutput>
        </cfloop>
    </table>
</cf_box>