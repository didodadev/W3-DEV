<cfquery name="GET_FILE" datasource="#dsn#">
	SELECT
		ASSET_ID,
		ASSET_FILE_NAME,
		RECORD_EMP,
		ASSET_FILE_SERVER_ID,
		ASSET_NO,
        ASSET_STAGE
	FROM
		ASSET
	WHERE
		ASSET_ID = #attributes.ASSET_ID#
</cfquery>

<cfquery name="control_" datasource="#dsn#">
	SELECT
		ASSET_ID
	FROM
		ASSET
	WHERE
		ASSET_ID <> #attributes.ASSET_ID# AND
		ASSET_FILE_NAME = '#GET_FILE.ASSET_FILE_NAME#'
</cfquery>

<cfquery name="GET_ASSET_REL" datasource="#DSN#">
	SELECT * FROM ASSET_RELATED WHERE ASSET_ID = #attributes.asset_id#
</cfquery>
<cfif get_asset_rel.recordcount>
	<cfquery name="GET_EMP_ALL" dbtype="query">
		SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1
	</cfquery>
	<cfif not get_emp_all.recordcount>
		<cfquery name="GET_USER_CAT" datasource="#DSN#">
			SELECT USER_GROUP_ID,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
		</cfquery>
		<cfquery name="GET_DIGITAL_GROUP" datasource="#DSN#">
			SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = #session.ep.position_code# OR POSITION_CAT = (SELECT EP.POSITION_CAT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.ep.position_code#)
		</cfquery>
		<cfquery name="CONTROL_USER_CAT" dbtype="query">
			SELECT 
				ASSET_ID 
			FROM 
				GET_ASSET_REL
			WHERE 
			<cfif len(get_user_cat.user_group_id)>
				(
				USER_GROUP_ID = #get_user_cat.user_group_id# OR
			</cfif> 
				POSITION_CAT_ID = #get_user_cat.position_cat_id#
			<cfif len(get_user_cat.user_group_id)>
				 )
			</cfif> 
			<cfif len(get_digital_group.group_id)>
				OR DIGITAL_ASSET_GROUP_ID = #get_digital_group.group_id#
			</cfif>
		</cfquery>
		<cfif not control_user_cat.recordcount and session.ep.userid neq GET_FILE.record_emp>
			<script type="text/javascript">
				alert('Bu Dosyayı Silmeye İzinli Değilsiniz! Kod : Yasaklı Kullanıcı');
				window.close();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfquery name="DEL_FILES" datasource="#dsn#">
	DELETE FROM
		ASSET
	WHERE 
		ASSET_ID = #attributes.asset_id#
</cfquery>

<cfif control_.recordcount>
	<!--- sadece database silinir ... aynı dosya başka bir kayıtta da kullanılıyor... --->
<cfelse>
	<cf_del_server_file output_file="#attributes.module#/#attributes.file_name#" output_server="#attributes.file_server_id#" PAPER_NO="GET_FILE.ASSET_NO">
</cfif>

<cf_add_log  log_type="-1" action_id="#attributes.asset_id#" action_name="Belge Silindi.#GET_FILE.ASSET_FILE_NAME#" paper_no="#GET_FILE.asset_no#" process_stage="#get_file.ASSET_STAGE#">
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
