<!--- <cfif not isdefined("attributes.upper")>	
    <cfquery name="GETCOMPUTERINFO" datasource="#dsn#">
        SELECT 
            STT1.*,
            STT2.TRANSPORT_TYPE AS UPPER_TYPE 
        FROM 
            SETUP_TRANSPORT_TYPES STT1,
            SETUP_TRANSPORT_TYPES STT2
        WHERE
            STT1.UPPER_TRANSPORT_TYPE_ID = STT2.TRANSPORT_TYPE_ID
        ORDER BY 
            STT2.TRANSPORT_TYPE,
            STT1.TRANSPORT_TYPE
    </cfquery>
<cfelse>
    <cfquery name="GETCOMPUTERINFO" datasource="#dsn#">
        SELECT 
            *,
            TRANSPORT_TYPE AS UPPER_TYPE 
        FROM 
            SETUP_TRANSPORT_TYPES
        WHERE
            UPPER_TRANSPORT_TYPE_ID IS NULL
        ORDER BY 
            TRANSPORT_TYPE
    </cfquery>
</cfif> --->
<cfquery name="get_uppers" datasource="#DSN#">
    SELECT 
        TRANSPORT_TYPE_ID,
        #dsn#.Get_Dynamic_Language(TRANSPORT_TYPE_ID,'#session.ep.language#','SETUP_TRANSPORT_TYPES','TRANSPORT_TYPE',NULL,NULL,TRANSPORT_TYPE) AS TRANSPORT_TYPE
    FROM 
        SETUP_TRANSPORT_TYPES
    ORDER BY
        TRANSPORT_TYPE 
</cfquery>
<table>
<cfif get_uppers.recordcount>
    <cfoutput query="get_uppers">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_transport_type&ID=#transport_type_id#<cfif isdefined("attributes.upper")>&upper=1</cfif>" class="tableyazi">#transport_type#</a></td>
            </tr>
    </cfoutput>
<cfelse>
    <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
        <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
    </tr>
</cfif>
</table>