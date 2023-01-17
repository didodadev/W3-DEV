<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.nickname = trim(attributes.nickname);
	attributes.name = trim(attributes.name);
	attributes.surname = trim(attributes.surname);
</cfscript>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY.NICKNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
		COMPANY_CAT.COMPANYCAT_TYPE,
		COMPANY_CAT.COMPANYCAT
		,COMPANY_PARTNER.PARTNER_ID
		,COMPANY.COMPANY_FAX									
		,COMPANY.COMPANY_ADDRESS
		,COMPANY.CITY
		,COMPANY.COUNTY
		,COMPANY.COMPANY_EMAIL
		,COMPANY.MEMBER_CODE
		,COMPANY.OZEL_KOD
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		(
			COMPANY.COMPANY_ID IS NULL
			<cfif len(attributes.fullname)>OR COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fullname#%"></cfif>
			<cfif len(attributes.name) or len(attributes.surname)>OR COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' '+ COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.name# #attributes.surname#"></cfif>
			<cfif len(attributes.nickname)>OR NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.nickname#"></cfif>
		)
	ORDER BY
		COMPANY.FULLNAME
</cfquery>

<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:50px;">
	<tr>
		<td class="headbold"><font color="red">Benzer Kriterlerde Kayitlar Bulundu!<br/> Lütfen Kaydetmek İstediğiniz Şirket Sistemde Varsa Tekrar Kayıt Yapmayınız.</font></td>
	</tr>
</table>

<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:98%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:25px;"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" nowrap width="120"><cf_get_lang_main no='338.İşyeri Adı'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='339.Kısa Ad'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="form-title" nowrap style="width:120px;"><cf_get_lang_main no='1311.Adres'></td>
		<td class="form-title" style="width:80px;"><cf_get_lang_main no='340.Vergi No'></td>
		<td class="form-title" nowrap style="width:80px;"><cf_get_lang_main no='87.Telefon'></td>
 	</tr>
	<form name="search_" method="post" action="">
		<cfif get_company.recordcount>
			<cfset county_id_list=''>
            <cfoutput query="get_company">
                <cfif len(county) and not listfind(county_id_list,county)>
                    <cfset county_id_list=listappend(county_id_list,county)>
                </cfif>
            </cfoutput>
            <cfif len(county_id_list)>
                <cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
                <cfquery name="GET_COUNTY_DETAIL" datasource="#DSN#">
                    SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
                </cfquery>
            </cfif>
			<cfoutput query="get_company">
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td>#currentrow#</td>
                    <td nowrap>
                        <a href="://javascript" onclick="control(1,#company_id#);" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a>
                    </td>
                    <td><cfif attributes.nickname eq trim(nickname)><font color="##990000">#nickname#</font><cfelse>#nickname#</cfif></td>
                    <td nowrap>#companycat#</td>
                    <td nowrap>
                        <cfif attributes.name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
                        <cfif attributes.surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif>
                    </td>
                    <td>#company_address#</td>
                    <td>#taxno#</td>
                    <td nowrap>#company_telcode# #company_tel1#</td>
                </tr>
            </cfoutput>
            <tr class="color-row" style="height:35px;">
                <td colspan="10" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value="Varolan Kayıtları Gözardi Et" onclick="control(2,0);"></td>
            </tr>
        <cfelse>
            <tr class="color-row" style="height:20px;">
                <td colspan="8"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
            </tr>
        </cfif>
	</form>
</table>

<script type="text/javascript">
	<cfif not get_company.recordcount>
		opener.document.form_add_member.submit();
		window.close();
	</cfif>
	
	function control(id,value)
	{
		if(id==1)
		{
			opener.window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_member&company_id=</cfoutput>' + value;
			window.close();
		}
		if(id==2)
		{
			opener.document.form_add_member.submit();
			window.close();
		}
	}

	function send_comp_info(comp_id,partner_id,comp_name,member_name,member_surname,member_code,ozel_kod,address,city_id,county,county_id,tel_code,tel_number,faxcode,fax_number,tax_office,tax_num,email)
	{	
		<cfif isdefined("attributes.field_company_id")>
			opener.document.<cfoutput>#attributes.field_company_id#</cfoutput>.value = comp_id;
		</cfif>
		<cfif isdefined("attributes.field_partner_id")>
			opener.document.<cfoutput>#attributes.field_partner_id#</cfoutput>.value = partner_id;
		</cfif>
		<cfif isdefined("attributes.field_consumer_id")>
			opener.document.<cfoutput>#attributes.field_consumer_id#</cfoutput>.value = '' ;  
		</cfif>
		<cfif isdefined("attributes.field_comp_name")>
			opener.document.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = comp_name;
		</cfif>
		<cfif isdefined("attributes.field_member_name")>
			opener.document.<cfoutput>#attributes.field_member_name#</cfoutput>.value = member_name ;
		</cfif>
		<cfif isdefined("attributes.field_member_surname")>
			opener.document.<cfoutput>#attributes.field_member_surname#</cfoutput>.value = member_surname ;
		</cfif>
		<cfif isdefined("attributes.field_member_code")>
			opener.document.<cfoutput>#attributes.field_member_code#</cfoutput>.value = member_code ;
		</cfif>
		<cfif isdefined("attributes.field_ozel_kod")>
			opener.document.<cfoutput>#attributes.field_ozel_kod#</cfoutput>.value = ozel_kod ;
		</cfif>
		<cfif isdefined("attributes.field_address")>
			opener.document.<cfoutput>#attributes.field_address#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_city")>
			opener.document.<cfoutput>#attributes.field_city#</cfoutput>.value = city_id;
		</cfif>	
		<cfif isdefined("attributes.field_county")>
			opener.document.<cfoutput>#attributes.field_county#</cfoutput>.value = county;
		</cfif>	
		<cfif isdefined("attributes.field_county_id")>
			opener.document.<cfoutput>#attributes.field_county_id#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_tel_code")>
			opener.document.<cfoutput>#attributes.field_tel_code#</cfoutput>.value = tel_code;
		</cfif>
		<cfif isdefined("attributes.field_tel_number")>
			opener.document.<cfoutput>#attributes.field_tel_number#</cfoutput>.value = tel_number;
		</cfif>
		<cfif not isdefined("attributes.is_from_sale")>
			<cfif isdefined("attributes.field_faxcode")>
				opener.document.<cfoutput>#attributes.field_faxcode#</cfoutput>.value = faxcode;
			</cfif>
			<cfif isdefined("attributes.field_fax_number")>
				opener.document.<cfoutput>#attributes.field_fax_number#</cfoutput>.value = fax_number;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_tax_office")>
			opener.document.<cfoutput>#attributes.field_tax_office#</cfoutput>.value = tax_office;
		</cfif>
		<cfif isdefined("attributes.field_tax_num")>
			opener.document.<cfoutput>#attributes.field_tax_num#</cfoutput>.value = tax_num;
		</cfif>
		<cfif isdefined("attributes.field_email")>
			opener.document.<cfoutput>#attributes.field_email#</cfoutput>.value = email;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			opener.document.<cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>
		window.close();
	}
</script>
