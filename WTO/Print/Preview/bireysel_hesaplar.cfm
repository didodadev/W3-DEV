<cfif isdefined("attributes.id")>
    <cfset attributes.consumer_id = attributes.id>
<cfelse>
    <cfif isdefined("attributes.action_id")>
        <cfset attributes.consumer_id = attributes.action_id>
    <cfelse>
        <cfset attributes.consumer_id = listdeleteduplicates(attributes.iid)>
    </cfif>
</cfif>

<cfquery name="Get_Consumer" datasource="#DSN#">
SELECT 
    CONSUMER_STATUS,
    CONSUMER_CAT_ID,
    CONSCAT=(SELECT DISTINCT GET_MY_CONSUMERCAT.CONSCAT FROM GET_MY_CONSUMERCAT WHERE GET_MY_CONSUMERCAT.CONSCAT_ID=CONSUMER.CONSUMER_CAT_ID),
    CONSUMER_ID,
    MEMBER_CODE,
    LEVEL_ID,
    CONSUMER_NAME,
    CONSUMER_SURNAME,
    CONSUMER_EMAIL,
    CONSUMER_USERNAME,
    TC_IDENTY_NO,
    CUSTOMER_VALUE_ID,
    CUSTOMER_VALUE=(SELECT SETUP_CUSTOMER_VALUE.CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WITH (NOLOCK) WHERE SETUP_CUSTOMER_VALUE.CUSTOMER_VALUE_ID=CONSUMER.CUSTOMER_VALUE_ID),
    CONSUMER_CAT_ID,
    RECORD_DATE,
    RESOURCE_ID,
    RESOURCE=(SELECT COMPANY_PARTNER_RESOURCE.RESOURCE FROM COMPANY_PARTNER_RESOURCE WHERE COMPANY_PARTNER_RESOURCE.RESOURCE_ID = CONSUMER.RESOURCE_ID),
    CONSUMER_STAGE,
    CONSUMER_EMAIL,
    CONSUMER_HOMETELCODE,
    CONSUMER_HOMETEL,
    MOBIL_CODE,
    MOBILTEL,
    CONSUMER_WORKTELCODE,
    CONSUMER_WORKTEL,
    BIRTHDATE,
    EDUCATION,
    HOMEADDRESS,
    HOMEPOSTCODE,
    HOME_CITY_ID,
    CITY_NAME=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE  SETUP_CITY.CITY_ID=CONSUMER.HOME_CITY_ID),
    HOME_COUNTY_ID,
    COUNTY_NAME=(SELECT SETUP_COUNTY.COUNTY_NAME FROM SETUP_COUNTY WHERE  SETUP_COUNTY.COUNTY_ID=CONSUMER.HOME_COUNTY_ID),
    CONSUMER_REFERENCE_CODE
FROM
     CONSUMER 
WHERE
    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
</cfquery>

<cfquery name="GET_CONSUMER_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.consumer_list%"> AND
        PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Consumer.CONSUMER_STAGE#">      
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

<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<table style="width:210mm">
    <tr>
        <td>
            <table style="width:100%;">
                <tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='47163.Bireysel Hesaplar'></td>
                    <td style="text-align:right;">
                        <cfif len(check.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                 </tr>
                </table>
    <tr>
        <td>
            <table style="width:100%;" align="center">
                <cfoutput>
                    <tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57487.No'></b></td>
                        <td style="width:170px">#Get_Consumer.member_code#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='58025.TC Kimlik No'></b></td>
                        <td style="width:170px">#Get_Consumer.tc_identy_no#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57570.Ad Soyad'></b></td>
                        <td>#Get_Consumer.consumer_name# #Get_Consumer.consumer_surname#</td>
                        <td><b><cf_get_lang dictionary_id='58552.Müşteri Değeri'></b></td>
                        <td>#Get_Consumer.customer_value# </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57486.Kategori'></b></td>
                        <td>#Get_Consumer.conscat#</td>
                        <td><b><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></b></td>
                        <td>#dateformat(date_add('h',session.ep.time_zone,Get_Consumer.record_date),dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58830.İlişki Şekli'></b></td>
                        <td>#Get_Consumer.resource#</td>
                        <td><b><cf_get_lang dictionary_id='57756.Durum'></b></td>
                        <td>#Get_Consumer_Stage.stage#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='29463.Mail'></b></td>
                        <td>#Get_Consumer.consumer_email#</td>
                        <td><b><cf_get_lang dictionary_id='58482.Mobil Tel'></b></td>
                        <td>#Get_Consumer.mobil_code#&nbsp#Get_Consumer.mobiltel#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58815.İş Telefonu'></b></td>    
                        <td>#Get_Consumer.consumer_worktelcode#&nbsp#Get_Consumer.consumer_worktel#</td>
                        <td><b><cf_get_lang dictionary_id='31261.Ev Tel'></b></td>
                        <td>#Get_Consumer.consumer_hometelcode#&nbsp#Get_Consumer.consumer_hometel#</td>
                    </tr>
                    <tr class="row_border">
                        <td><b><cf_get_lang dictionary_id='41196.İl-İlçe'></b></td>
                        <td>#Get_Consumer.CITY_NAME#- #Get_Consumer.COUNTY_NAME#</td>
                        <td><b><cf_get_lang dictionary_id='30606.Ev Adresi'></b></td>
                        <td rowspan="3">#Get_Consumer.homeaddress#</td>
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
