<cfif not len(attributes.CLASS_ID)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='514.Önce İlişkili Eğitim Seçmelisiniz'>!");
		history.back();
	</script>
<cfelse>
	<cfif isdefined('attributes.member_type') and attributes.member_type is 'partner'>
		<cfif not isdefined('par_ids')>
			<cfset par_ids=attributes.PAR_IDS>
		</cfif>
		<cfloop list="#par_ids#" index="par_id">
			<cfquery name="GET_CLASS_ANNOUNCE_ATTS" datasource="#dsn#">
				SELECT 
					PAR_ID 
				FROM 
					TRAINING_CLASS_ANNOUNCE_ATTS 
				WHERE 
					CLASS_ID = #attributes.CLASS_ID# AND 
					PAR_ID = #par_id# AND 
					ANNOUNCE_ID = #attributes.announce_id#
			</cfquery>
			<cfif NOT GET_CLASS_ANNOUNCE_ATTS.RECORDCOUNT>
				<cfquery name="ADD_CLASS_ANNOUNCE_ATTS" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS_ANNOUNCE_ATTS
						(
						CLASS_ID,
						PAR_ID,
						ANNOUNCE_ID	
						)
					VALUES
						(
						#attributes.CLASS_ID#,
						#par_id#,
						#attributes.announce_id#
						)
				</cfquery>
			</cfif>
		</cfloop>
	<cfelseif isdefined('attributes.member_type') and attributes.member_type is 'consumer'>
		<cfif not isdefined('con_ids')>
			<cfset con_ids=attributes.CON_IDS>
		</cfif>
		<cfloop list="#con_ids#" index="con_id">
			<cfquery name="GET_CLASS_ANNOUNCE_ATTS" datasource="#dsn#">
				SELECT CONS_ID FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE <cfif isdefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>CLASS_ID = #attributes.CLASS_ID# AND</cfif> CONS_ID = #con_id# AND ANNOUNCE_ID = #attributes.announce_id#
			</cfquery>
			<cfif NOT GET_CLASS_ANNOUNCE_ATTS.RECORDCOUNT>
				<cfquery name="ADD_CLASS_ANNOUNCE_ATTS" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS_ANNOUNCE_ATTS
						(
						CLASS_ID,
						CONS_ID,
						ANNOUNCE_ID	
						)
					VALUES
						(
						#attributes.CLASS_ID#,
						#con_id#,
						#attributes.announce_id#
						)
				</cfquery>
			</cfif>
		</cfloop>
	<cfelse>
		<cfif not isdefined('emp_ids')>
			<cfset emp_ids=attributes.EMPLOYEE_IDS>
		</cfif>
		<cfloop list="#emp_ids#" index="emp_id">
			<cfquery name="GET_CLASS_ANNOUNCE_ATTS" datasource="#dsn#">
				SELECT EMPLOYEE_ID FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE <cfif isdefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>CLASS_ID = #attributes.CLASS_ID# AND</cfif> EMPLOYEE_ID = #emp_id# AND ANNOUNCE_ID = #attributes.announce_id#
			</cfquery>
			<cfif NOT GET_CLASS_ANNOUNCE_ATTS.RECORDCOUNT>
				<cfquery name="ADDCLASS_ANNOUNCE_ATTS" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS_ANNOUNCE_ATTS
						(
						CLASS_ID,
						EMPLOYEE_ID,
						ANNOUNCE_ID	
						)
					VALUES
						(
						#attributes.CLASS_ID#,
						#emp_id#,
						#attributes.announce_id#
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
<!--- Eğitime potansiyel Katılımcı ekleme sayfası Çalışan,Bireysel,Kurumsal üyeye ve Group a göre düzenlendi...Senay 20061102 --->
<!--- <cfif IsDefined("attributes.EMPLOYEE_IDS")>
	<cfloop list="#ListSort(attributes.EMPLOYEE_IDS,'numeric')#" index="employee">
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#dsn#">
			SELECT
				EMP_ID
			FROM
				TRAINING_CLASS_ATTENDER
			WHERE
				CLASS_ID=#attributes.CLASS_ID#
				AND EMP_ID=#employee#
		</cfquery>
		<cfif NOT GET_CLASS_POTENTIAL_ATTENDER.RECORDCOUNT>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#dsn#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
					CLASS_ID,
					EMP_ID		
					)
				VALUES
					(
					#attributes.CLASS_ID#,
					#employee#
					)
			</cfquery>
		</cfif>
	</cfloop>
</cfif> --->
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
</cfif>
