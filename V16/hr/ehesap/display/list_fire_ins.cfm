<cfif isdefined("actionid_list") and len(actionid_list)>
	<cfset type = 1>
	<cfset attributes.in_out_ids = actionid_list>
<cfelse>
	<cfset type = 2>
</cfif>
<cfif not isdefined("attributes.in_out_ids")>
	<script>
		alert("<cf_get_lang dictionary_id='45506.Giriş Çıkış Kaydı Seçmelisiniz'>!");
		window.history.go(-2);
	</script>
	<cfabort>
</cfif>

<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>

<cfset getComponent = createObject('component','V16.hr.ehesap.cfc.list_fire_in_out')>
<cfset GET_IN_OUTS = getComponent.GET_EMPLOYEE_IN(in_out_ids :attributes.in_out_ids, type : type)>  

<cfif isdefined("actionid_list") and len(actionid_list)>
	<cfsavecontent variable="message"></cfsavecontent>
	<cfset group_name = 'SSK_SICIL'>
<cfelse>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="45511.SGK Giriş İşlemleri"></cfsavecontent>
	<cfset group_name = 'BRANCH_NAME'>
</cfif>

<cf_box title="#message#">
<CFOUTPUT QUERY="GET_IN_OUTS" GROUP="#group_name#">
	<cfsavecontent variable="xml_icerik_#BRANCH_ID#">
		<?xml version="1.0" encoding="iso-8859-9"?>
		<SGK4AISEGIRIS>			
			<ISYERI ISYERISICIL="#SSK_ISYERI#" ISYERIARACINO="#iif(len(left(SSK_AGENT,3)) eq 3,"#left(SSK_AGENT,3)#","000")#" <cfif isdefined("actionid_list") and len(actionid_list)>NAKILGELDIGIISYERISICIL="#TRANSFER_SSK_SICIL#"</cfif> ISYERIUNVAN="#left(BRANCH_FULLNAME,50)#" ISYERIADRES="#left(BRANCH_ADDRESS,50)#"/>
			<SIGORTALILAR>
				<CFOUTPUT>
					<cfif isdefined("EDU_FINISH") and len(EDU_FINISH)>
						<cfset m_yil_ = YEAR(EDU_FINISH)>
					<cfelse>
						<cfset m_yil_ = 0>
					</cfif>
				<SIGORTALI TCKNO="#TC_IDENTY_NO#" AD="#EMPLOYEE_NAME#" SOYAD="#EMPLOYEE_SURNAME#" 
				ISEGIRISTARIHI="#dateformat(START_DATE,'yyyy-mm-dd')#" 
				SIGORTAKOLU="#SIGORTAKOLU#"
				OZURLUKODU="#OZURLUKODU#" 
				ESKIHUKUMLU="#ESKIHUKUMLU#" 
				OGRENIMKODU="#OGRENIMKODU#" 
				MEZUNIYETYILI="#m_yil_#" 
				MEZUNIYETBOLUMU="#LEFT(EDU_PART_NAME,100)#"  
				CSGBISKOLU="#BRANCH_WORK#" 
				MESLEKKODU="#BUSINESS_CODE#" 
				GOREVKODU="#GOREVKODU#" />
				</CFOUTPUT>
			</SIGORTALILAR>			
		</SGK4AISEGIRIS>
	</cfsavecontent>
	<cffile action="write" file="#upload_folder#reserve_files\#drc_name_#\user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_giris.xml" nameconflict="overwrite" output="#trim(evaluate('xml_icerik_#BRANCH_ID#'))#" charset ="iso-8859-9">
	
	#BRANCH_NAME# <cf_get_lang dictionary_id="45479.için ürettiğiniz xml file"> : <a href="/documents/reserve_files/#drc_name_#/user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_giris.xml" class="tableyazi">user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_giris.xml</a> (<cf_get_lang dictionary_id="45509.Farklı Kaydet Diyebilirsiniz">!) <br><br>
</CFOUTPUT>
	
</cf_box>
