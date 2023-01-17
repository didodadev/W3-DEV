<cfif isdefined("attributes.id")>
    <cfset attributes.company_id = attributes.id>
<cfelse>
    <cfif isdefined("attributes.action_id")>
        <cfset attributes.company_id = attributes.action_id>
    <cfelse>
        <cfset attributes.company_id = listdeleteduplicates(attributes.iid)>
    </cfif>
</cfif>
<cfquery name="Get_Company" datasource="#DSN#">
    SELECT 
        COMPANYCAT_ID,
        COMPANYCAT=(SELECT COMPANY_CAT.COMPANYCAT FROM COMPANY_CAT WHERE COMPANY_CAT.COMPANYCAT_ID=COMPANY.COMPANYCAT_ID),
        COMPANY_ID,
        MEMBER_CODE,
        FULLNAME,
        CITY,
        CITY_NAME=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE  SETUP_CITY.CITY_ID=COMPANY.CITY),
        SEMT,
        <!---DISTRICT_NAME=(SELECT SETUP_DISTRICT.DISTRICT_NAME FROM SETUP_DISTRICT WHERE  SETUP_DISTRICT.DISTRICT_ID=COMPANY.SEMT),--->
        COUNTY,
        COUNTY_NAME=(SELECT SETUP_COUNTY.COUNTY_NAME FROM SETUP_COUNTY WHERE  SETUP_COUNTY.COUNTY_ID=COMPANY.COUNTY),
        MANAGER_PARTNER_ID,
        TAXNO,
        TAXOFFICE,
        COMPANY_EMAIL,
        HOMEPAGE,
        SECTOR_CAT_ID,
        COMPANY_TELCODE,
        COMPANY_TEL1,
        MOBIL_CODE,
        MOBILTEL,
        START_DATE,
        ORG_START_DATE,
        COMPANY_ADDRESS,
        COMPANY_SIZE_CAT_ID,
        COMPANY_SIZE_CAT=(SELECT SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT FROM SETUP_COMPANY_SIZE_CATS WHERE  SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT_ID=COMPANY.COMPANY_SIZE_CAT_ID),
        COMPANY_VALUE_ID,
        CUSTOMER_VALUE=(SELECT SETUP_CUSTOMER_VALUE.CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE SETUP_CUSTOMER_VALUE.CUSTOMER_VALUE_ID=COMPANY.COMPANY_VALUE_ID)
    FROM
         COMPANY
    WHERE
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">       
</cfquery>

<cfquery name="get_sector_name" datasource="#dsn#">
    SELECT 
        SECTOR_CAT
    FROM
       SETUP_SECTOR_CATS LEFT JOIN 
       COMPANY_SECTOR_RELATION ON SETUP_SECTOR_CATS.SECTOR_CAT_ID=COMPANY_SECTOR_RELATION.SECTOR_ID
    WHERE 
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Company.COMPANY_ID#">
</cfquery>

<cfquery name="Get_Bakiye" datasource="#dsn2#">
        SELECT
            BAKIYE,
            COMPANY_ID
        FROM
            COMPANY_REMAINDER
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Company.company_id#"> 
</cfquery>
 
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	    COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		</cfif> 
</cfquery>

<cfquery name="Get_Partner" datasource="#DSN#">
    SELECT
        COMPANY_PARTNER_NAME,
        PARTNER_ID,
        COMPANY_PARTNER_SURNAME,
        COMPANY_ID
    FROM
        COMPANY_PARTNER
        
    WHERE
    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Company.MANAGER_PARTNER_ID#">      
</cfquery>

<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<table style="width:210mm">
    <tr>
        <td>
            <table style="width:100%;">
                <tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='47167.Kurumsal Hesaplar'></td>
                    <td style="text-align:right;">
                        <cfif len(check.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                 </tr>
                </table>
        </td>       
    </tr>
    <tr>
        <td>
            <table style="width:100%;" align="center">
                <cfoutput>
                    <tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57558.Üye No'></b></td>
                        <td style="width:170px">#Get_Company.member_code#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57486.Kategori'></b></td> 
                        <td style="width:170px">#Get_Company.companycat#</td>
                    </tr>               
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57574.Şirket'></b></td>
                        <td>#Get_Company.fullname#</td>
                        <td><b><cf_get_lang dictionary_id='29511.Yönetici'></td>
                        <td>#Get_Partner.company_partner_name# #Get_Partner.company_partner_surname# </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58762.Vergi Dairesi'></b></td>
                        <td>#Get_Company.taxoffice#</td>
                        <td><b><cf_get_lang dictionary_id='56085.Vergi Numarası'></b></td>
                        <td>#Get_Company.taxno#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58552.Müşteri Değeri'></b></td>
                        <td>#Get_Company.customer_value#</td>
                        <td><b><cf_get_lang dictionary_id='46899.Şirket Büyüklüğü'></b></td>
                        <td>#Get_Company.company_size_cat#</td>   
                    </tr>    
                    <tr>                      
                        <td><b><cf_get_lang dictionary_id='30569.İlişki Başlangıç Tarihi'></b></td>
                        <td>#dateformat(Get_Company.start_date,dateformat_style)#</td>
                        <td><b><cf_get_lang dictionary_id='57589.Bakiye'></b></td>
                        <td>#Get_Bakiye.bakıye#0&nbsp<cf_get_lang dictionary_id='37345.TL'></td>
                    </tr>  
                    <tr>   
                        <td><b><cf_get_lang dictionary_id='31109.Mail Adresi'></b></td>
                        <td>#Get_Company.company_email#</td>
                        <td><b><cf_get_lang dictionary_id='34867.Kurum Web Sitesi'></b></td>
                        <td>#Get_Company.homepage#</td>
                    </tr>   
                    <tr>       
                        <td><b><cf_get_lang dictionary_id='41194.Telefon Numarası'></b></td>
                        <td> #Get_Company.company_telcode#&nbsp#Get_Company.company_tel1#</td>
                        <td><b><cf_get_lang dictionary_id='41237.Mobil Telefon'></b></td>
                        <td>#Get_Company.mobil_code#&nbsp#Get_Company.MOBILTEL#</td>                    
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57971.Şehir'></b></td>
                        <td>#Get_Company.CITY_name#</td>
                        <td><b><cf_get_lang dictionary_id='58638.İlçe'>/ <cf_get_lang dictionary_id='58132.Semt'></b></td>
                        <td>#Get_Company.county_name# /#Get_Company.semt#</td>
                    </tr>
                    <tr class="row_border">
                        <td valign="top"><b><cf_get_lang dictionary_id='32689.Şirket Adresi'></b></td>
                        <td valign="top"  rowspan="3">#Get_Company.COMPANY_ADDRESS#</td>
                        <td valign="top"><b><cf_get_lang dictionary_id='57579.Sektör'></b></td>
                            <td><cfloop query="#get_sector_name#">
                                <p> #get_sector_name.sector_cat# </p>
                            </cfloop> </td>
                    </tr>
                    <tr></tr>
                    <tr></tr> 
                </cfoutput>
            </table>
        </td> 
    </tr>
</table>
<br><br>
    <table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
	  </tr>
    </table>