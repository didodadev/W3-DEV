<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="CHAPTER_GET" datasource="#DSN#">
            SELECT 
                HIERARCHY 
            FROM 
                CONTENT_CHAPTER 
            WHERE 
                CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#">
        </cfquery>
        <cfquery name="CHAPTER_CONTROL" datasource="#DSN#">
            SELECT 
                HIERARCHY 
            FROM 
                CONTENT_CHAPTER 
            WHERE 
                HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#chapter_get.hierarchy#%">
        </cfquery>
        <cfquery name="CONTENT_CONTROL" datasource="#DSN#">
            SELECT 
                CHAPTER_ID 
            FROM 
                CONTENT 
            WHERE 
                CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#">
        </cfquery>
        <cfif chapter_control.recordcount eq 1 and content_control.recordcount eq 0>
            <cfquery name="DEL_CHAPTER" datasource="#DSN#">
                DELETE 
                FROM
                    CONTENT_CHAPTER
                WHERE 
                    CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#">
            </cfquery>
            <script type="text/javascript">
                window.close();
            </script>
            <cf_add_log log_type="-1" action_id="#attributes.chapter_id#" action_name="#attributes.head#" process_type="#attributes.cat#">
        <cfelse>
			<script type="text/javascript">
                alert("<cf_get_lang no ='182.Silmek İstediğiniz Bölüme Ait Alt Bölüm veya Konu Bulunmaktadır Bu İşlemi Gerçekleştiremezsiniz'>!");
                history.back(-1);
            </script>		
            <cfabort>
        </cfif>
	</cftransaction>
</cflock> 
<cflocation url="#request.self#?fuseaction=content.list_chapters" addtoken="no">

