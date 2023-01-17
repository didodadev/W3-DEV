<cfparam  name="attributes.asset_id" default="">
<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT 
		ASSET_FILE_REAL_NAME,
		ASSET_FILE_NAME,
		RECORD_EMP,
		EMBEDCODE_URL
	FROM 
		ASSET 
	WHERE 
		ASSET_ID = '#attributes.asset_id#'
</cfquery>

<cfif isdefined("attributes.file_control") and attributes.file_control is 'asset.form_upd_asset'>
	<cfset link_ = 'asset.form_upd_asset&asset_id=#attributes.asset_id#&assetcat_id=#attributes.assetcat_id#'>
	<cfquery name="GET_PAGE_LOCK" datasource="#DSN#">
		SELECT
			DENIED_PAGE,
			POSITION_CODE,
			DENIED_TYPE
		FROM
			DENIED_PAGES_LOCK
		WHERE
			DENIED_PAGE = '#trim(link_)#'
	</cfquery>

	<cfquery name="GET_MY_IZINLILER" dbtype="query">
		SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE POSITION_CODE = #session.ep.position_code# AND DENIED_TYPE = 1
	</cfquery>
	<cfif not get_my_izinliler.recordcount>
		<cfquery name="GET_MY_YASAK_1" dbtype="query">
			SELECT DISTINCT DENIED_PAGE FROM GET_PAGE_LOCK WHERE DENIED_TYPE = 1
		</cfquery>
		<cfif get_my_yasak_1.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='60039.Bu Dosyayı Görüntülemeye İzinli Değilsiniz'>! <cf_get_lang dictionary_id='58585.Kod'> : <cf_get_lang dictionary_id='60040.İzinli Olmayan Sayfa.'>");
				history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfquery name="GET_MY_YASAK_2" dbtype="query">
				SELECT DISTINCT DENIED_PAGE FROM GET_PAGE_LOCK WHERE POSITION_CODE = #session.ep.position_code# AND DENIED_TYPE = 0
			</cfquery>
			<cfif get_my_yasak_2.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='48537.Bu Dosyayı Görüntülemeye İzinli Değilsiniz! Kod : Yasaklı Sayfa'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
	<cfquery name="GET_ASSET_REL" datasource="#DSN#">
        SELECT 
            ASSET_ID,
            USER_GROUP_ID,
            COMPANY_CAT_ID,
            CONSUMER_CAT_ID,
            POSITION_CAT_ID,
       	 	DIGITAL_ASSET_GROUP_ID,
            ALL_EMPLOYEE,
            ALL_CAREER,
            ALL_INTERNET,
            ALL_PEOPLE
        FROM 
            ASSET_RELATED 
        WHERE 
            ASSET_ID = #attributes.asset_id#
	</cfquery>
	<cfif get_asset_rel.recordcount>
		<cfquery name="GET_EMP_ALL" dbtype="query">
			SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1
		</cfquery>
		<cfif not get_emp_all.recordcount>
			<cfquery name="GET_USER_CAT" datasource="#DSN#">
				SELECT USER_GROUP_ID,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
			</cfquery>
            <cfquery name="GET_DIGITAL_GROUP" datasource="#DSN#"><!--- Dijital varlık grubuna göre LS --->
                SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = #session.ep.position_code# OR POSITION_CAT = (SELECT EP.POSITION_CAT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.ep.position_code#)
            </cfquery>
			<cfquery name="CONTROL_USER_CAT" dbtype="query">
				SELECT 
					ASSET_ID 
				FROM 
					GET_ASSET_REL
				WHERE
                 <cfif get_digital_group.recordcount>DIGITAL_ASSET_GROUP_ID IN (#ValueList(get_digital_group.group_id)#) OR</cfif>  
				<cfif len(get_user_cat.user_group_id)>
					USER_GROUP_ID = #get_user_cat.user_group_id# OR
				</cfif> 
					POSITION_CAT_ID = #get_user_cat.position_cat_id#
			</cfquery>
            <!--- BK 20100927 belgeyi kaydeden kişi detayina ulasabilir --->
			<cfif not control_user_cat.recordcount  and session.ep.userid neq get_asset.record_emp>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='48537.Bu Dosyayı Görüntülemeye İzinli Değilsiniz! Kod : Yasaklı Sayfa'>");
					<cfif fuseaction contains 'popup'>
						window.close();
					</cfif>
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<!--- ayni dosyadan objects2 de de var --->
<cfif not isdefined("attributes.urlembcode")>
<cfif get_asset.recordcount and len(get_asset.asset_file_real_name)>
	<cfset dosyam = get_asset.asset_file_real_name>
	<cfif listlen(get_asset.asset_file_name,'.') gt 1 and listlen(get_asset.asset_file_real_name,'.') eq 1 and  get_asset.asset_file_real_name neq get_asset.asset_file_name>
		<cfset d_ext_ = listlast(get_asset.asset_file_name,'.')>
		<cfset dosyam = dosyam & '.' & d_ext_>
	</cfif>
<cfelse>
	<cfset dosyam = listlast(attributes.file_name,'/')>
</cfif>

<cfset dosyam = tr2eng(dosyam)>
</cfif>

<cfif isdefined("attributes.urlembcode") and attributes.urlembcode eq 1>
	<div class="col col-12" style="margin-top:12%;text-align:center">
	<cfoutput>#GET_ASSET.EMBEDCODE_URL#</cfoutput>
	</div>
	<cfabort>
</cfif>

<cfif not isdefined("attributes.urlembcode")>
<cfif left(attributes.file_name,11) is '/documents/'>
	<cfset dosya_ = mid(attributes.file_name,2,len(attributes.file_name)-1)>
	<cfif not FileExists("#download_folder##dosya_#")>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='32942.Belirtilen Adreste İlgili Dosya Bulunamadı'>! \n<cf_get_lang dictionary_id='60041.Lütfen sistem yöneticinize ulaşınız.'>");
			<cfif isdefined("attributes.direct_show") and attributes.direct_show eq 1>
				self.close();
			<cfelse>
				history.back();
			</cfif>
		</script>
	<cfelse>
		<cfif isdefined("attributes.direct_show") and attributes.direct_show eq 1>
			<cflocation url="#attributes.file_name#" addtoken="no">
		<cfelse>
			<cfheader name="Content-Disposition" value="attachment;filename=#dosyam#">
			<cfcontent file="#download_folder##attributes.file_name#" type="application/octet-stream" deletefile="no">
		</cfif>
	</cfif>
<cfelse>
	<cfif not FileExists("#download_folder#documents#dir_seperator##replace(attributes.file_name,'\','/','all')#")>
		<script type="text/javascript">
		<cfoutput>		
				alert("<cf_get_lang dictionary_id='32942.Belirtilen Adreste İlgili Dosya Bulunamadı'>! \n<cf_get_lang dictionary_id='60041.Lütfen sistem yöneticinize ulaşınız.'>");
		</cfoutput>	
			<cfif isdefined("attributes.direct_show") and attributes.direct_show eq 1>
				self.close();
			<cfelse>
				history.back();
			</cfif>
		</script>
	<cfelse>
		<cfif isdefined("attributes.direct_show") and attributes.direct_show eq 1>
			<cflocation url="/documents/#attributes.file_name#" addtoken="no">
		<cfelse>
			<cfheader name="Content-Disposition" value="attachment;filename=#dosyam#">
			<cfcontent file="#download_folder#documents#dir_seperator##replace(attributes.file_name,'\','/','all')#" type="application/octet-stream" deletefile="no"> 
		</cfif>
	</cfif>
</cfif>
</cfif>
