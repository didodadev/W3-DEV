<!--- ücret kartına ait çıkış yapılan tarihten ileri tarihli olan kesintileri listeler--->
<cfif not isdefined("get_kesintis_")>
    <cfscript>
            get_kesintis = createObject("component","V16.hr.ehesap.cfc.get_salaryparam_get");
            get_kesintis.dsn = dsn;
            get_kesintis_ = get_kesintis.get_salary_get(
                in_out_id : this_in_out_,
                term : attributes.sal_year,
                sal_mon_ : attributes.sal_mon
            );
    </cfscript>  
</cfif>
<cfif get_kesintis_.recordcount> 
<table>
    <tr>
        <td class="formbold"><cf_get_lang dictionary_id='38977.Kesintiler'></td>
    </tr>
	<cfoutput query="get_kesintis_">
       <tr>
            <td>#term#</td>
            <td>#listgetat(ay_list(),START_SAL_MON,',')#</td>
            <td>#listgetat(ay_list(),END_SAL_MON,',')#</td>
            <td>#comment_get#</td>
            <td style="text-align:right">#amount_get# #MONEY#</td>
        </tr>
    </cfoutput>
</table>
</cfif>

