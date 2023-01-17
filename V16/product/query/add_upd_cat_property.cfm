<!--- Ekleme ve Guncelleme Sayfalari Ayni Oldugundan Ortak Hale Getirildi FBS 20100624 --->
<cftransaction>
	<cfquery name="DEL_PRODUCT_CAT_RELATED_PROPERTY" datasource="#DSN1#">
		DELETE FROM PRODUCT_CAT_PROPERTY WHERE PRODUCT_CAT_ID = #attributes.product_cat_id#
	</cfquery> 
        <cfquery name="DEL_PRODUCT_CAT_PROPERTY" datasource="#DSN1#">
            DELETE FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_DT_PROPERTY_ID IN (    
            SELECT PRODUCT_DT_PROPERTY_ID PRODUCT_ID FROM PRODUCT_DT_PROPERTIES PD,PRODUCT P WHERE PD.PRODUCT_ID=P.PRODUCT_ID AND P.PRODUCT_CATID = #attributes.product_cat_id# AND IS_FLAG=1
            )
        </cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#I#") neq 0>
			<cfif len(evaluate("attributes.property_id#i#")) and len(evaluate("attributes.property#i#"))>
				<cfquery name="ADD_PRODUCT_CAT_RELATED_PROPERTY" datasource="#dsn1#">
					INSERT INTO
						PRODUCT_CAT_PROPERTY
					(
						PRODUCT_CAT_ID, 
						PROPERTY_ID,
						LINE_VALUE,
						IS_WORTH,
						IS_OPTIONAL,
						IS_AMOUNT,
						IS_INTERNET,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#attributes.product_cat_id#,
						#evaluate("attributes.property_id#i#")#,
						<cfif isDefined("attributes.line_row#i#") and len(evaluate("attributes.line_row#i#"))>#evaluate("attributes.line_row#i#")#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.worth#i#")>1<cfelse>0</cfif>,
						<cfif isDefined("attributes.optional#i#")>1<cfelse>0</cfif>,
						<cfif isDefined("attributes.amount#i#")>1<cfelse>0</cfif>,
						<cfif isDefined("attributes.is_internet#i#")>1<cfelse>0</cfif>,
						#session.ep.userid#, 
						#now()#,
						'#REMOTE_ADDR#'
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
    <cfquery name="ADD_PROPERTY" datasource="#DSN1#">
        INSERT INTO
            PRODUCT_DT_PROPERTIES
        (
            PRODUCT_ID,
            PROPERTY_ID,                
            LINE_VALUE,               
            IS_OPTIONAL,              
            IS_INTERNET,
            IS_FLAG,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        )
               SELECT 
                    PRODUCT_ID,
                    PROPERTY_ID,
                    LINE_VALUE ,
                    PC.IS_OPTIONAL IS_OPTIONAL,
                    PC.IS_INTERNET IS_INTERNET,
                    1,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.REMOTE_ADDR#'
                FROM 
                    PRODUCT_CAT_PROPERTY PC,
                    PRODUCT P  
                WHERE 
                    PRODUCT_CAT_ID = P.PRODUCT_CATID 
                    AND PRODUCT_CAT_ID = #attributes.product_cat_id#
    </cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=product.list_product_cat&event=upd&id=#attributes.product_cat_id#" addtoken="no">
