<cfif isDefined('attributes.model_id') and len(attributes.model_id)>
	<cfquery name="GET_PROPERTY_MODEL" datasource="#DSN1#">
		SELECT
			PATH,
			PATH_SERVER_ID
		FROM
			BRAND_MODEL_PROPERTY
		WHERE
			MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.variation_id0#">	
	</cfquery>
    <cfif isDefined('attributes.model_logo') and len(attributes.model_logo)>
        <cftry>
            <cffile action="UPLOAD"
                filefield="model_logo"
                destination="#upload_folder#product#dir_seperator#"
                mode="777"
                nameconflict="MAKEUNIQUE" accept="image/*">
            <cfset file_name = createUUID()>
            <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
            <cfcatch type="any">
                <script type="text/javascript">
                    alert("Lütfen imaj dosyası giriniz!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry> 
	</cfif>
    
    <cfquery name="GET_BRAND_MODEL_PROPERTY" datasource="#DSN1#">
        SELECT
            PROPERTY_ID,
            BRAND_MODEL_PROP_ID
        FROM
            BRAND_MODEL_PROPERTY
        WHERE
            MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
	</cfquery>
    <cfif get_brand_model_property.recordcount>
        <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>
                <cfset brand_model_prop_list = ValueList(get_brand_model_property.brand_model_prop_id)>
                <cfloop from="1" to="4" index="i">
                    <cfif len(evaluate('attributes.variation_id#i#'))>
                        <cfquery name="UPD_PROPERTY_MODEL" datasource="#DSN1#">
                            UPDATE
                                BRAND_MODEL_PROPERTY
                            SET
                                PROPERTY_ID = #evaluate('attributes.variation_id#i#')#
                                <cfif isDefined('attributes.model_logo') and len(attributes.model_logo)>,PATH = '#file_name#.#cffile.serverfileext#'</cfif>
                            WHERE
                                 BRAND_MODEL_PROP_ID = #listgetat(brand_model_prop_list,i,',')# AND
                                 MODEL_ID = #attributes.variation_id0# 
                        </cfquery>
                    </cfif>
                </cfloop>
            </cftransaction>
        </cflock>
    <cfelse>
        <cfif isDefined('attributes.model_logo') and len(attributes.model_logo) or isDefined('attributes.is_model')>
            <cflock name="#CreateUUID()#" timeout="60">
                <cftransaction>
                    <cfloop from="1" to="4" index="i">
                        <cfif len(evaluate('attributes.variation_id#i#'))>
                            <cfquery name="ADD_PROPERTY_MODEL" datasource="#DSN1#">
                                INSERT INTO
                                    BRAND_MODEL_PROPERTY
                                    (
                                        MODEL_ID,
                                        PROPERTY_ID
                                        ,PATH
                                        ,PATH_SERVER_ID
                                    )
                                    VALUES
                                    (
                                        #attributes.variation_id0#,
                                        #evaluate('attributes.variation_id#i#')#,
                                        <cfif isDefined('attributes.is_model')>'#get_property_model.path#'<cfelse>'#file_name#.#cffile.serverfileext#'</cfif>,
                                        '#fusebox.server_machine#'
                                    )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cftransaction>
            </cflock>
        </cfif>
    </cfif>  
<cfelse>
    <cftry>
        <cffile action="UPLOAD"
            filefield="brand_logo"
            destination="#upload_folder#product#dir_seperator#"
            mode="777"
            nameconflict="MAKEUNIQUE" accept="image/*">
        <cfset file_name = createUUID()>
        <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
        <cfcatch type="any">
            <script type="text/javascript">
                alert("Lütfen imaj dosyası giriniz!");
                history.back();
            </script>
            <cfabort>
        </cfcatch>
    </cftry>
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
    <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
    <cfif listfind(blackList,assetTypeName,',')>
        <cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
        <script type="text/javascript">
            alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
            history.back();
        </script>
        <cfabort>
    </cfif> 
    <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
 
    <cfif (findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
        <cfscript>
            CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
            cffile.serverfileext = "jpg";
        </cfscript>
    </cfif>
    
    <cfquery name="GET_BRAND_MODEL_PROPERTY" datasource="#DSN1#">
        SELECT
            BRAND_ID,
            BRAND_MODEL_PROP_ID
        FROM
            BRAND_MODEL_PROPERTY
        WHERE
            BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
	</cfquery>  
    
    <cfif get_brand_model_property.recordcount>
        <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>
                <cfset brand_model_prop_list = ValueList(get_brand_model_property.brand_id)>
                <cfloop from="1" to="4" index="i">
                    <cfif len(evaluate('attributes.variation_id#i#'))>
                        <cfquery name="UPD_PROPERTY_MODEL" datasource="#DSN1#">
                            UPDATE
                                BRAND_MODEL_PROPERTY
                            SET
                            	BRAND_ID = #attributes.variation_id0#
                                <cfif isDefined('attributes.brand_logo') and len(attributes.brand_logo)>PATH = '#file_name#.#cffile.serverfileext#'</cfif>
                            WHERE
                                 BRAND_MODEL_PROP_ID = #listgetat(brand_model_prop_list,i,',')# AND
                                 BRAND_ID = #attributes.variation_id0# 
                        </cfquery>
                    </cfif>
                </cfloop>
        </cflock>
    <cfelse>
        <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>
                <cfquery name="ADD_PROPERTY_MODEL" datasource="#DSN1#">
                    INSERT INTO
                        BRAND_MODEL_PROPERTY
                        (
                            BRAND_ID,
                            PROPERTY_ID,
                            PATH,
                            PATH_SERVER_ID
                        )
                        VALUES
                        (
                            #attributes.variation_id0#,
                            NULL,
                            <cfif isDefined('attributes.is_model')>'#get_property_model.path#'<cfelse>'#file_name#.#cffile.serverfileext#'</cfif>,
                            '#fusebox.server_machine#'
                        )
                </cfquery>
            </cftransaction>
        </cflock>    
    </cfif>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
