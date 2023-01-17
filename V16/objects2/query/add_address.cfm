<cfquery name="CHECK_BRANCH" datasource="#DSN#">
	SELECT
		COMPANY_ID
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.compbranch__name)#"> AND 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>

<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1393.Aynı Adlı Adres/Şube Kaydı Var Adres/Şube Adını Değişiniz'> !");
		window.history.go(-1);
	</script>
<cfelse>
	<cfscript>
        if (listfindnocase(partner_url,'#cgi.http_host#',';'))
        {
            attributes.company_id = session.pp.company_id;
        }
        else if (listfindnocase(server_url,'#cgi.http_host#',';') )
        {	
            if(isdefined('session.ww.company_id'))
                attributes.company_id = session.ww.company_id;
            else if(isdefined('session.ww.userid'))
                attributes.consumer_id = session.ww.userid;
        }
    </cfscript>
	<cfquery name="ADD_COMPANY_BRANCH" datasource="#DSN#">
        INSERT INTO
            COMPANY_BRANCH
            (
                COMPBRANCH_STATUS,
                COMPANY_ID,	
                COMPBRANCH__NAME,
                COMPBRANCH__NICKNAME,
                COMPBRANCH_TELCODE,
                COMPBRANCH_TEL1,
                COMPBRANCH_ADDRESS,
                SEMT,
                COMPBRANCH_POSTCODE,
                COUNTY_ID,
                CITY_ID,
                COUNTRY_ID,
                RECORD_DATE,
                <cfif isdefined("attributes.company_id")>
                    RECORD_PAR,
                </cfif>
                RECORD_IP
            )
                VALUES
            (
                1,
                #attributes.company_id#,
                '#attributes.compbranch__name#',
                <cfif isdefined("attributes.compbranch__nickname") and len(attributes.compbranch__nickname)>'#attributes.compbranch__nickname#'<cfelse>NULL</cfif>,
                '#attributes.compbranch_telcode#',
                '#attributes.compbranch_tel1#',
                <cfif isdefined("attributes.compbranch_address") and len(attributes.compbranch_address)>'#attributes.compbranch_address#'<cfelse>NULL</cfif>,
                <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
                <cfif len(attributes.postcode)>'#attributes.postcode#'<cfelse>NULL</cfif>,
                <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
                #now()#,
                <cfif isdefined("attributes.company_id")>
                    #attributes.company_id#,
                </cfif>
                '#cgi.remote_addr#'
            )
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
