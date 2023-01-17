<!---
    File :          AddOns\Yazilimsa\Protein\reactor\PMO\datagate.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          27.02.2021
    Description :   workcube button custom tagi ile kullanılır, form datasını cfc methoduna iletir response yapr
    Notes :         
--->
<cfsetting showdebugoutput="no">
<cfif structKeyExists(getHttpRequestData().headers, "protein-data-gate-token")>
    <cfset proteinDataGateToken= #decrypt(getHttpRequestData().headers["protein-data-gate-token"],'protein_3d','CFMX_COMPAT','Hex')#>
    <cfset proteinDataGateTarget =listToArray(proteinDataGateToken,":",false,true)>
    <cfset data_packet = {
        form_data : form,
        cfc:proteinDataGateTarget[1],
        method:proteinDataGateTarget[2]
    }>
<cfelseif getHttpRequestData().headers["content-type"] contains 'multipart/form-data' >
    <cfset data_packet = form>
    <cfset data_packet.form_data = deserializeJson( form.form_data ) />
<cfelse>
    <cfset data_packet = deserializeJSON(getHttpRequestData().content)> 
</cfif>

<cfset funct_instance = createObject("component", "#data_packet.cfc#")>
<cfset funct = evaluate("funct_instance.#data_packet.method#(argumentCollection=data_packet.form_data)")>
<cfheader name="Content-Type" value="application/json">
<cfoutput>#funct#</cfoutput>