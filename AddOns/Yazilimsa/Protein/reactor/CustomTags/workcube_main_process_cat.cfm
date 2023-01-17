<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
	<cf_workcube_main_process_cat slct_width="" main_process_cat="#query.main_process_cat#">
		created Aysenur 20050804
	onclick_function: 	Selectbox click icin
	slct_width : selectbox genişliği (optional)
	process_cat : update sayfaları için !!! ZORUNLU !!!
 --->
     <cfset dsn = application.systemParam.systemParam().dsn>
<cfset module_id = 1>
<cfparam name="attributes.slct_width" default='150'>
<cfparam name="attributes.main_process_cat" default="">
<cfparam name="attributes.onclick_function" default="">
<cfparam name="attributes.fuseaction" default="">
<cfquery name="GET_USER_PROCESS_CAT" datasource="#DSN#">
	SELECT
		DISTINCT
		SPC.MAIN_PROCESS_CAT_ID,
		SPC.MAIN_PROCESS_CAT,
		SPC.MAIN_PROCESS_TYPE
	FROM
		SETUP_MAIN_PROCESS_CAT_ROWS AS SPCR,
		SETUP_MAIN_PROCESS_CAT_FUSENAME AS SPCF,
		EMPLOYEE_POSITIONS AS EP,
		SETUP_MAIN_PROCESS_CAT SPC
	WHERE
		SPC.MAIN_PROCESS_CAT_ID = SPCR.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_CAT_ID = SPCF.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_MODULE IN (#module_id#) AND
		SPCF.FUSE_NAME = '#attributes.fuseaction#' AND 
		<cfif isdefined("session.ep.position_code")>
			EP.POSITION_CODE = #session.ep.position_code# AND
        <cfelseif isDefined('session.pp.position_code')>
            EP.POSITION_CODE = #session.pp.position_code# AND
        <cfelseif isdefined("session.cp")>
             EP.POSITION_CODE = #session.cp.position_code# AND
		<cfelseif isdefined("session.pda")>	
			EP.POSITION_CODE = #session.pda.position_code# AND
		</cfif>
		(
			SPCR.MAIN_POSITION_CODE = EP.POSITION_CODE OR
			SPCR.MAIN_POSITION_CAT_ID = EP.POSITION_CAT_ID
		)
	ORDER BY 
      	SPC.MAIN_PROCESS_CAT
</cfquery>
<cfif len(attributes.main_process_cat)>
	<cfquery name="GET_OLD_PROCESS_CAT" dbtype="query">
		SELECT
			MAIN_PROCESS_CAT_ID,
			MAIN_PROCESS_TYPE
		FROM
			GET_USER_PROCESS_CAT
		WHERE
			MAIN_PROCESS_CAT_ID = #attributes.main_process_cat#
	</cfquery>
	<cfoutput>
	<cfif get_old_process_cat.recordcount>
		<input type="hidden" name="old_process_type" id="old_process_type" value="#get_old_process_cat.main_process_type#">
		<input type="hidden" name="old_process_cat_id" id="old_process_cat_id" value="#get_old_process_cat.main_process_cat_id#">
	<cfelse>
		<cfquery name="CHECK_PROCESS_CAT_ID" datasource="#DSN#">
			SELECT MAIN_PROCESS_CAT_ID FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID = #attributes.main_process_cat# AND MAIN_PROCESS_MODULE IN (#module_id#)
		</cfquery>
		<cfif not check_process_cat_id.recordcount>
			<!--- 791.İşlem Kategorisi Ayarlardan Kritik Olarak Değişmiş veya Silinmiş  --->
			<script type="text/javascript">
				alert("<cfoutput>#application.functions.getLang('main',791)#</cfoutput>!");
				history.back();
			</script>		
		<cfelse>
			<!--- 566.Bu İşlem Tipine Yetkiniz Yok ! --->
			<script type="text/javascript">
				alert("<cfoutput>#application.functions.getLang('main',566)#</cfoutput>");
				history.back();
			</script>		
		</cfif>
		<cfabort>
	</cfif>
	</cfoutput>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
<select class="form-control form-control-sm" name="main_process_cat" id="main_process_cat" <cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif>>
	<option value="" selected><cfoutput>#application.functions.getLang('main',322)#</cfoutput></option>	
	<cfoutput query="get_user_process_cat">
	<option value="#main_process_cat_id#" <cfif attributes.main_process_cat eq main_process_cat_id>selected</cfif>>#main_process_cat#</option><!--- fbs 20110208 kaldirdi<cfelseif (not len(attributes.main_process_cat))>selected --->
	</cfoutput>
</select>
<cfoutput query="get_user_process_cat">
	<input type="hidden" name="ct_process_type_#main_process_cat_id#" id="ct_process_type_#main_process_cat_id#" value="#main_process_type#">
</cfoutput>

<script type="text/javascript">
var process_cat_array = new Array();var process_type_array = new Array();
<cfoutput query="get_user_process_cat">process_cat_array[#currentrow#] = process_type_array[#currentrow#] = '#main_process_type#';</cfoutput>
function check_accounts(myForm)
{
	temp_field1 = eval(myForm+'.main_process_cat');
	temp_field2 = eval(myForm+'.member_account_code');
	if ( (process_cat_array[temp_field1.selectedIndex] == 1) && ( (!temp_field2.value.length) || (temp_field2.value == '') || (temp_field2.value == ' ') ) ) /*muhasebeci kontrolü yapılmalı*/
		{
		alert("<cfoutput>#application.functions.getLang('main',2173)#</cfoutput>");
		return false;
		}
	return true;
}
</script>
