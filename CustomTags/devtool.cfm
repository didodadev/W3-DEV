<cfoutput>
    <select name="#attributes.name#" id="#attributes.name#" #iif( isDefined( "attributes.onchange" ), DE( 'onchange="' & attributes.onchange & '"' ), DE( "" ) )# #iif( isDefined( "attributes.message" ), DE( 'message="' & attributes.message & '"' ), DE( "" ) )# #iif( isDefined( "attributes.required" ), DE( 'requiured' ), DE( "" ) )# #iif(isdefined("attributes.disabled")&&attributes.disabled,de('disabled="disabled"'),de(''))#>
        <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
        <option value="nocode"#iif( isDefined( "attributes.value" ) and attributes.value eq "nocode", de( ' selected="selected"' ), de( "" ) )#>Nocode</option>
        <option value="code"#iif( isDefined( "attributes.value" ) and attributes.value eq "code", de( ' selected="selected"' ), de( "" ) )#>Code</option>
    </select>
</cfoutput>