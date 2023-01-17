
<cfquery name="ADD_PRO_COMP" datasource="#DSN#" result="MAX_ID">
    INSERT INTO
        DIGITAL_ASSET_GROUP
	(
		GROUP_NAME,
		DETAIL,
		CONTENT_PROPERTY_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.asset_group#',
		'#attributes.detail#',
		<cfif isdefined('attributes.get_content_property') and len(attributes.get_content_property)>'#attributes.get_content_property#,'<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
	)
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
				#MAX_ID.IDENTITYCOL#,
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
				#MAX_ID.IDENTITYCOL#,
				#I#
			)
		</cfquery>	
	</cfloop>
</cfif>
<cfif ListLen(pos_cats)>
	<cfloop list="#pos_cats#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN#">
			INSERT INTO 
                DIGITAL_ASSET_GROUP_PERM
			(
				GROUP_ID,
				POSITION_CAT
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				#I#
			)
		</cfquery>	
	</cfloop>
</cfif>
<script type="text/javascript">
	location.href=document.referrer;
</script>

