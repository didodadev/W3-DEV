<cfsetting showdebugoutput="no">

<cfset attributes.fullname = trim(attributes.fullname)>
<cfset attributes.nickname = trim(attributes.nickname)>
<cfset attributes.tel_code = trim(attributes.tel_code)>
<cfset attributes.telephone = trim(attributes.telephone)>
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 	
		COMPANY_ID,
        FULLNAME, 
        NICKNAME, 
        COMPANY_TELCODE, 
        COMPANY_TEL1, 
        MEMBER_CODE
	FROM 
		COMPANY 
	WHERE 
		<cfif isdefined('attributes.company_id')>
			(COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">) AND		
		</cfif>
		(
			FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#"> OR
			NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#"> 
		)
</cfquery>
<cf_box title="Aynı Kayıtlı Üyeler" body_style="overflow-y:scroll;height:100px;" call_function='gizle(kontrol_prerecord_div);'>
    <table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
      	<tr class="color-border">
        	<td>
          		<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
                    <tr class="color-header" style="height:22px;">		
                        <td class="form-title" style="width:30px;">No</td>
                        <td class="form-title">Şirket Unvanı</td>
                        <td class="form-title">Kısa Ad</td>
                        <td class="form-title">Telefon</td>
                    </tr>
					<cfif get_comp.recordcount>
                        <cfoutput query="get_comp">		
                            <tr class="color-row" style="height:20px;">
                                <td>#member_code#</td>
                                <td>#fullname#</td>
                                <td>#nickname#</td>
                                <td>#company_telcode# #company_tel1#</td>
                            </tr>		
                        </cfoutput>
                    <cfelse>
                        <tr class="color-row" style="height:20px;">
                            <td colspan="4">Kayıt Bulunamadı !</td>
                        </tr>
                    </cfif>
          		</table>
        	</td>
      	</tr>
    </table>
</cf_box>
<script type="text/javascript">
	function submit_save()
	{
		gizle(control_prerecord_div);
		document.form_add_company.submit();	
	}
	function dont_submit()
	{
		///alert('qqq');
		return false;
	}
 	<cfif not get_comp.recordcount>		
		submit_save();
	<cfelse>		
		dont_submit();		
	</cfif>
</script> 

