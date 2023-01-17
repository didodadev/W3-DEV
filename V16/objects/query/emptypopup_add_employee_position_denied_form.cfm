<cfif attributes.update_table_ eq 1>
	<cfquery name="del_related_action" datasource="#dsn#">
    	DELETE FROM 
        	EMPLOYEE_POSITIONS_DENIED_FORM 
        WHERE 
        	FORM_DEFINE = '#attributes.form_define#' 
            AND DENIED_PAGE = '#attributes.fusename#' 
            AND COMPANY_ID = #attributes.our_company_id#
			<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	AND TYPE_ID = #attributes.type_id#
            </cfif>
    </cfquery>
</cfif>
<cfif isdefined("attributes.is_view_") and listFind(attributes.is_view_,0) and isdefined("attributes.is_update_") and listFind(attributes.is_update_,0)>
<!--- Bu alan position_cat_id'nin 0 geldigi yani hi�kimsenin yetkisi olmadigi durumlarda �alisan alan. Kosul buraya giriyorsa diger secilen pozisyonlar etkisiz hale gelir. --->
<!--- Hem hi�kimse g�rmesin hem hi� kimse g�ncellemesin --->
    <cfquery name="add_employee_position_denied" datasource="#dsn#">
        INSERT INTO
            EMPLOYEE_POSITIONS_DENIED_FORM
        (
            DENIED_PAGE,
            FORM_DEFINE,
            COMPANY_ID,
            POSITION_CAT_ID,
            IS_VIEW,
            IS_UPDATE,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,TYPE_ID
            </cfif>
        )
        VALUES
        (
            '#attributes.fusename#',
            '#attributes.form_define#',
            <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
            0,
            1,
            1,
            #session.ep.userid#,
            #now()#,
            '#cgi.remote_addr#'
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,#attributes.type_id#
            </cfif>
        )
    </cfquery>
<cfelseif isdefined("attributes.is_view_") and listFind(attributes.is_view_,0)>
<!--- Hi�kimse g�rmesin --->
    <cfquery name="add_employee_position_denied" datasource="#dsn#">
        INSERT INTO
            EMPLOYEE_POSITIONS_DENIED_FORM
        (
            DENIED_PAGE,
            FORM_DEFINE,
            COMPANY_ID,
            POSITION_CAT_ID,
            IS_VIEW,
            IS_UPDATE,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,TYPE_ID
            </cfif>
        )
        VALUES
        (
            '#attributes.fusename#',
            '#attributes.form_define#',
            <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
            0,
            1,
            0,
            #session.ep.userid#,
            #now()#,
            '#cgi.remote_addr#'
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,#attributes.type_id#
            </cfif>
        )
    </cfquery>
<cfelseif isdefined("attributes.is_update_") and listFind(attributes.is_update_,0)>
<!--- Hi�kimse guncellemesin --->
    <cfquery name="add_employee_position_denied" datasource="#dsn#">
        INSERT INTO
            EMPLOYEE_POSITIONS_DENIED_FORM
        (
            DENIED_PAGE,
            FORM_DEFINE,
            COMPANY_ID,
            POSITION_CAT_ID,
            IS_VIEW,
            IS_UPDATE,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,TYPE_ID
            </cfif>
        )
        VALUES
        (
            '#attributes.fusename#',
            '#attributes.form_define#',
            <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
            0,
            0,
            1,
            #session.ep.userid#,
            #now()#,
            '#cgi.remote_addr#'
            <cfif isdefined("attributes.type_id") and len(attributes.type_id)>
            	,#attributes.type_id#
            </cfif>
        )
    </cfquery>
</cfif>
 <!--- Bu alan position_cat_id'nin 0 gelmedigi durumlarda �alisan alan --->
<cfif isdefined("attributes.is_view_") and isdefined("attributes.is_update_")>
	<cfset toplam_kayit = listlen(attributes.is_view_) + listlen(attributes.is_update_)>
	<cfset kontrol = 0>
	<cfset yeni_liste = ''>
	<cfloop index="aa" from="1" to="#toplam_kayit#">
		<cftry>
		<cfif ListFindNoCase(attributes.is_update_,listGetAt(attributes.is_view_,aa))>
			<cfset kontrol = kontrol + 1>
		</cfif>
		<cfcatch></cfcatch>
		</cftry>
	</cfloop>
	<cfset toplam_kayit = toplam_kayit - kontrol>
	<cfset yeni_liste = listAppend(yeni_liste,attributes.is_view_)>
	<cfset yeni_liste = listAppend(yeni_liste,attributes.is_update_)>
	<cfset yeni_liste = ListDeleteDuplicates(yeni_liste)>
	<cfloop index="aa" from="1" to="#toplam_kayit#">
		<cfif listGetAt(yeni_liste,aa) neq 0>
            <cfquery name="add_employee_position_denied" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEE_POSITIONS_DENIED_FORM
                (
                    DENIED_PAGE,
                    FORM_DEFINE,
                    COMPANY_ID,
                    POSITION_CAT_ID,
                    IS_VIEW,
                    IS_UPDATE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,TYPE_ID
                    </cfif>
               )
                VALUES
                (
                    '#attributes.fusename#',
                    '#attributes.form_define#',
                    <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
                    #listGetAt(yeni_liste,aa)#,
                    <cfif ListFindNoCase(attributes.is_view_,listGetAt(yeni_liste,aa)) and ListFindNoCase(attributes.is_update_,listGetAt(yeni_liste,aa))>
                        1,
                        1
                    <cfelseif ListFindNoCase(attributes.is_view_,listGetAt(yeni_liste,aa))>
                        1,
                        0
                    <cfelse>
                        1,
                        1
                    </cfif>,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,#attributes.type_id#
                    </cfif>
                )
            </cfquery>
        </cfif>
	</cfloop>
<cfelseif isdefined("attributes.is_view_") and not isdefined("attributes.is_update_")>
	<cfloop index="aa" from="1" to="#listlen(attributes.is_view_)#">
    	<cfif listGetAt(attributes.is_view_,aa) neq 0>
            <cfquery name="add_employee_position_denied" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEE_POSITIONS_DENIED_FORM
                (
                    DENIED_PAGE,
                    FORM_DEFINE,
                    COMPANY_ID,
                    POSITION_CAT_ID,
                    IS_VIEW,
                    IS_UPDATE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,TYPE_ID
                    </cfif>
                )
                VALUES
                (
                    '#attributes.fusename#',
                    '#attributes.form_define#',
                    <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
                    #listGetAt(attributes.is_view_,aa)#,
                    1,
                    0,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,#attributes.type_id#
                    </cfif>
                )
            </cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined("attributes.is_update_") and not isdefined("attributes.is_view_")>
	<cfloop index="aa" from="1" to="#listlen(attributes.is_update_)#">
		<cfif listGetAt(attributes.is_update_,aa) neq 0>
            <cfquery name="add_employee_position_denied" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEE_POSITIONS_DENIED_FORM
                (
                    DENIED_PAGE,
                    FORM_DEFINE,
                    COMPANY_ID,
                    POSITION_CAT_ID,
                    IS_VIEW,
                    IS_UPDATE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,TYPE_ID
                    </cfif>
                )
                VALUES
                (
                    '#attributes.fusename#',
                    '#attributes.form_define#',
                    <cfif isdefined("attributes.OUR_COMPANY_ID")>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
                    #listGetAt(attributes.is_update_,aa)#,
                    1,
                    1,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
					<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
                        ,#attributes.type_id#
                    </cfif>
                )
            </cfquery>
		</cfif>
	</cfloop>
<cfelse>
</cfif>
<script type="text/javascript">
	history.back();
</script>
