<cf_date tarih = "attributes.startdate">
<cfset attributes.startdate = dateadd("h",attributes.start_clock,attributes.startdate)>
<cfset attributes.startdate = dateadd("n",attributes.start_minute,attributes.startdate)>

<cf_date tarih = "attributes.finishdate">
<cfset attributes.finishdate = dateadd("h",attributes.finish_clock,attributes.finishdate)>
<cfset attributes.finishdate = dateadd("n",attributes.finish_minute,attributes.finishdate)>

<cfquery name="add_" datasource="#dsn_dev#" result="sonuc">
	INSERT INTO
    	MARKET_PROMOTIONS
        (
        PROMOTION_HEAD,
        PROMOTION_STATUS,
        STARTDATE,
        FINISHDATE,
        PROMOTION_DAYS,
        PROMOTION_TYPE,
        RECORD_EMP,
        RECORD_DATE
        )
        VALUES
        (
        '#attributes.promotion_head#',
        <cfif isdefined("attributes.promotion_status")>1<cfelse>0</cfif>,
        #attributes.startdate#,
        #attributes.finishdate#,
        <cfif isdefined("attributes.promotion_days")>'#attributes.promotion_days#'<cfelse>NULL</cfif>,
        #attributes.promotion_type#,
        #session.ep.userid#,
        #now()#
        )
</cfquery>

<cfif isdefined("attributes.department_id")>
	<cfloop list="#attributes.department_id#" index="ccc">
        <cfquery name="add_" datasource="#dsn_dev#">
            INSERT INTO
                MARKET_PROMOTIONS_DEPARTMENTS
                (
                PROMOTION_ID,
                DEPARTMENT_ID
                )
                VALUES
                (
                #sonuc.identitycol#,
                #ccc#
                )
        </cfquery>
    </cfloop>
</cfif>

<cfif isdefined("attributes.card_type")>
	<cfloop list="#attributes.card_type#" index="ccc">
        <cfquery name="add_" datasource="#dsn_dev#">
            INSERT INTO
                MARKET_PROMOTIONS_MEMBER_TYPES
                (
                PROMOTION_ID,
                MEMBER_TYPE_ID
                )
                VALUES
                (
                #sonuc.identitycol#,
                #ccc#
                )
        </cfquery>
    </cfloop>
</cfif>

<script type="text/javascript">
    window.location.href='<cfoutput>#request.self#?fuseaction=retail.list_promotions&event=upd&promotion_id=#sonuc.identitycol#</cfoutput>';
</script>
