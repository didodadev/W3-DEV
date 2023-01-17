<cfset structdelete(session.digital_asset,"emps_status")>
<cfset structdelete(session.digital_asset,"pars_status")>
<cfquery name="UPD_DIG_ASSET_GROUP" datasource="#DSN#">
	UPDATE
		DIGITAL_ASSET_GROUP
	SET
		GROUP_NAME = '#attributes.asset_group#',
		DETAIL = '#detail#',
        <cfif isdefined('attributes.get_content_property') and len(attributes.get_content_property)>CONTENT_PROPERTY_ID = '#attributes.get_content_property#,',<cfelse>CONTENT_PROPERTY_ID = 'NULL',</cfif>
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfquery name="DEL_PERM" datasource="#DSN#">
	DELETE FROM DIGITAL_ASSET_GROUP_PERM WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfscript>
	if(isdefined("attributes.to_par_ids")) s_PARS = ListSort(ListDeleteDuplicates(attributes.to_par_ids),"Numeric", "Desc"); else s_PARS ='';
	if(isdefined("attributes.to_pos_codes")) s_PCODES =ListSort(ListDeleteDuplicates(attributes.to_pos_codes),"Numeric", "Desc") ; else s_PCODES ='';
	if(isdefined("attributes.position_cats")) pos_cats =ListSort(ListDeleteDuplicates(attributes.position_cats),"Numeric", "Desc") ; else pos_cats ='';
</cfscript>
<cfif ListLen(s_PARS)>
	<cfloop list="#s_PARS#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_COMP_PERM" datasource="#DSN#">
            INSERT INTO 
                DIGITAL_ASSET_GROUP_PERM
                (
                    GROUP_ID,
                    PARTNER_ID
                )
            VALUES
                (
                    #URL.ID#,
                    #I#
                )
		</cfquery>
	</cfloop>
</cfif>
<cfif ListLen(s_PCODES)>
	<cfloop list="#s_PCODES#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN#">
			INSERT INTO 
                DIGITAL_ASSET_GROUP_PERM
                (
                    GROUP_ID,
                    POSITION_CODE
                )
			VALUES
                (
                    #URL.ID#,
                    #I#
                )
		</cfquery>	
	</cfloop>
</cfif>
<cfif ListLen(pos_cats)>
	<cfloop list="#pos_cats#" index="I" delimiters=",">
		<cfif (isdefined("attributes.status_#i#") and evaluate("attributes.status_#i#") eq 1) or not isdefined("attributes.status_#i#")>
			<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN#">
				INSERT INTO 
					DIGITAL_ASSET_GROUP_PERM
					(
						GROUP_ID,
						POSITION_CAT
					)
				VALUES
					(
						#URL.ID#,
						#I#
					)
			</cfquery>	
		</cfif>
	</cfloop>
</cfif>
<cfscript>structdelete(session.digital_asset,"joins");</cfscript>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#?fuseaction=settings.list_digital_asset_group&event=upd&id=#attributes.id#</cfoutput>"
</script>  
