
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
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
<cfif not isdefined("url.id")>
	<cfset attributes.brand_id = listdeleteduplicates(attributes.iid)>
<cfelse>
	<cfset attributes.brand_id = url.id>
</cfif>
<cfquery name="get_brand" datasource="#dsn1#">
	SELECT 
    	BRAND_ID,
        BRAND_CODE,
        BRAND_NAME,
        DETAIL,
        IS_ACTIVE,
        IS_INTERNET,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP 
	FROM 
		PRODUCT_BRANDS 
	WHERE 
    <cfif not isDefined("attributes.brand_id")>
		BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
    </cfif>
</cfquery>
<cfquery name="get_brand_comps" datasource="#dsn1#">
	SELECT * FROM PRODUCT_BRANDS_OUR_COMPANY WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_brand.brand_id#">
</cfquery>
<cfset our_comp_list = valuelist(get_brand_comps.our_company_id)>

<cfquery name="get_our_companies" datasource="#DSN#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
        where COMP_ID=#get_brand_comps.OUR_COMPANY_ID#
	
</cfquery>

<cfoutput query="get_brand">
    <table style="width:210mm">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td class="print-head">
                            <table style="width:100%;">
                                <tr>
                                    <td class="print_title"><cf_get_lang dictionary_id='58847.Marka'></td>
                                    <td style="text-right;">
                                        <cfif len(check.asset_file_name2)>
                                        <cfset attributes.type = 1>
                                            <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr class="row_border"class="row_border">
		    <td>
				<table>
					<tr>
						<td style="width:100px"><b><cf_get_lang dictionary_id='58847.Marka'></b></td>
						<td style="width:100px"> #brand_name# </td>
					</tr>
                    <tr>
                        <td style="width:100px;"><b><cf_get_lang dictionary_id='58585.Kod'></b></td>
                        <td  style="width:100px"><cfif len(get_brand.brand_id)>#brand_code#<cfelse>&nbsp;</cfif></td>
                    </tr>   
                    <tr>
                        <td style="width:100px;"><b><cf_get_lang dictionary_id='36199.Açıklama'></b></td>
                        <td  style="width:100px"><cfif len(get_brand.brand_id)>#detail#<cfelse>&nbsp;</cfif></td>
                    </tr>  
                  
                    <tr>
                        <td style="width:100px;"><b><cf_get_lang dictionary_id ='58017.İlişkili Şirketler'></b></td>
                        <td><cfif get_brand_comps.BRAND_ID eq get_brand.brand_id >#get_our_companies.nick_name#</cfif></td>
                    </tr>
                </table>
               
			</td>
		</tr>
         
    </table>
    <br></br>
    <table>
        <tr class="fixed">
         <td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
        </tr>
    </table>
</cfoutput>
