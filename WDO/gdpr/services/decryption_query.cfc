<!---
    File :          decryption query 
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          13.12.2019
    Description :   Query objesini gdpr a göre decryption yapar
    Notes :         
--->
<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="decrypt" access="public">
        <cfargument name="fuseaction">
        <cfargument name="query">
        <cfargument name="alias" default="">

        <!--- classification bul --->
        <cfquery name="query_gdpr_classification" datasource="#dsn#">
            SELECT * FROM GDPR_CLASSIFICATION WHERE FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.fuseaction#%'>
        </cfquery>

        <!--- gdpr id lerini al --->
        <cfset gdprids = valueList(query_gdpr_classification.CLASSIFICATION_ID)>

        <cfif len(gdprids) eq 0><cfreturn arguments.query></cfif>

        <!--- refcol al --->
        <cfset refcols = valueList( query_gdpr_classification.KEY_COLUMN )>
        <!--- sorgudaki pk ları al --->
        <cfset qids = "">
        <cfloop list="#refcols#" index="refcol_idx">
            <cfset qids = qids & arrayToList( valueArray(arguments.query, refcol_idx) )>
        </cfloop>

        <!--- plevneye sor bakalım varmıymışmış böyle bir kayıt --->
        <cfquery name="query_plevne_dock" datasource="#dsn#">
            SELECT * FROM PLEVNE_DOCK 
            WHERE
                CLASSIFICATION_ID IN (#gdprids#)
                AND RELATION_ID IN (#qids#)
        </cfquery>

        <cfloop query="query_gdpr_classification">
            <cfif query_gdpr_classification.SENSITIVITY_LABEL_ID eq session.ep.DOCKPHONE>
            <cfscript>
                if (findNoCase( query_gdpr_classification.COLUMN_NAME, alias)) {
                    rowalias = listFilter( alias, function (elm) {
                        return findNoCase( query_gdpr_classification.COLUMN_NAME, elm );
                    });
                    colalias = listLast( rowalias, ":" );
                }
                //queryi manuple et ki millet veri görsün
                arguments.query = queryMap( arguments.query, function(row) {
                    if (structKeyExists(row, colalias?:query_gdpr_classification.COLUMN_NAME)) {
                        local.invisible_plevne = duplicate(query_plevne_dock);
                        filtered_plevne = queryFilter(local.invisible_plevne, function(row_plevne) {
                            return row_plevne.RELATION_ID eq row[ row_plevne.KEY_COLUMN ] and row_plevne.COLUMN_NAME eq query_gdpr_classification.COLUMN_NAME;
                        });
                        if (len(trim(filtered_plevne.PLEVNE_DOCK))) {
                            door = createObject("component", "WDO.gdpr.doors.door#filtered_plevne.PLEVNE_DOOR#")
                            row[ colalias?:query_gdpr_classification.COLUMN_NAME ] = door.decrypt( trim(filtered_plevne.PLEVNE_DOCK), "wrk" & row[ filtered_plevne.KEY_COLUMN ] );
                        }
                    }
                    return row;
                });
            </cfscript>
            </cfif>
        </cfloop>
        <cfreturn arguments.query>
    </cffunction>

</cfcomponent>