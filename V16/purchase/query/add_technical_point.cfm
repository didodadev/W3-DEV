<cfset status = true>
<cfif isDefined("attributes.record_count") and len(attributes.record_count)>
    <cftry>
        <cfquery name="add_tech_point" datasource="#dsn3#">
            INSERT INTO
            PURCHASE_TECHNICAL_POINT
            (
                OFFER_ID,
                FOR_OFFER_ID,
                COMPANY_ID,
                PRODUCT_ID,
                TECHNICAL_POINT,
                TECHNICAL_DESCRIPTION,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            <cfloop index="i" from="1" to="#attributes.record_count#">
                <cfif isDefined("attributes.point_number#i#") and len(evaluate("attributes.point_number#i#"))>
                    <cfif i neq 1>,</cfif>
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.for_offer_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.product_id#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.point_number#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.description#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                    )
                </cfif>
            </cfloop>
        </cfquery>
        <cfcatch type="any">
            <cfset status = false>
        </cfcatch>
    </cftry>
</cfif>
<script type="text/javascript">
    <cfif status>
        alert('<cf_get_lang dictionary_id="58838.Kayıt İşleminiz Başarıyla Tamamlanmıştır.">');
        window.jQuery( '#get_tech_avg_point_emp .catalyst-refresh' ).click();
    <cfelse>
        alert('<cf_get_lang dictionary_id="60269.Puanlama Yapmadınız">!');
    </cfif>
    show_hide('technical_point_box');gizle(technical_point_box);
</script>