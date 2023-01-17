<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="Yes">
<!--- 
Description			: Ekleme, güncelleme ve silme işlemlerine ait bilgileri veri tabanına kaydeder.
Parameters			:
	log_type		: Yapılan işlemin tipi Ekleme=1 Güncelleme=0 Silme=-1 --- required
	action_id		: Üzerinde işlem yapılan kaydın id'si --- required
	action_name		: Üzerinde işlem yapılan kaydın adı veya açıklaması --- required
	process_type	: Varsa işleme ait işlem kategorisi 
	process_stage   : Varsa İşleme Ait Aşama 
	paper_no        : Varsa İşleme Ait İşlem Numarası
	data_source		: Varsa dsn tanimi yapilir. (transaction bloglari icin gerekli olabiliyor.)
Syntax				: <cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.name#" process_type="1">
Created				: SM20061123
Modified			: FBS 20120803 Sessiondan gelen parametrelerin geldigi sayfadan gönderilmesine gerek yok, direkt burada yaziliyor
					  FBS 20120803 fuseaction tanimi . li hale getirildi, Paper_No alani eklendi.
--->
<cfparam name="attributes.data_source" default="#caller.dsn#">
<cfif isdefined("caller.attributes.fuseaction")>
	<cfparam name="attributes.fuseact" default="#caller.attributes.fuseaction#">
<cfelseif isdefined("attributes.fuseact")>
	<cfparam name="attributes.fuseact" default="#attributes.fuseact#">
<cfelse>
	<cfparam name="attributes.fuseact" default="#caller.fusebox.circuit#.#caller.fusebox.fuseaction#">
</cfif>
<cfif isdefined("attributes.dsn_alias")>
	<cfset dsn_alias = attributes.dsn_alias>
<cfelse>
	<cfset dsn_alias = caller.dsn_alias>
</cfif>
<cfquery name="ADD_LOG" datasource="#attributes.data_source#" result="result">
	INSERT INTO
		#dsn_alias#.WRK_LOG
	(
		<cfif isDefined("attributes.process_type") and Len(attributes.process_type)>
			PROCESS_TYPE,
		</cfif>
		 <cfif isDefined("attributes.process_stage") and Len(attributes.process_stage)>
			PROCESS_STAGE,
		</cfif> 
		<cfif isDefined("attributes.paper_no") and len(attributes.paper_no)>
		 	PAPER_NO, 
		</cfif>
		EMPLOYEE_ID,
		LOG_TYPE,
		LOG_DATE,
		FUSEACTION,
		ACTION_ID,
		ACTION_NAME
		<cfif isdefined("session.ep.period_id")>
        ,PERIOD_ID
		</cfif>
    )
	VALUES
	(	
		<cfif isdefined("attributes.process_type") and len(attributes.process_type)>
			#attributes.process_type#,
		</cfif>
		 <cfif isDefined("attributes.process_stage") and Len(attributes.process_stage)>
			#attributes.process_stage#,
		</cfif> 
		<cfif isDefined("attributes.paper_no") and Len(attributes.paper_no)>
			'#attributes.paper_no#',
		</cfif> 
        <cfif isDefined('session.ep.userid')>
            #session.ep.userid#,
        <cfelseif isDefined('session.pda.userid')>
            #session.pda.userid#,        
        </cfif>
		#attributes.log_type#,
		#now()#,
		'#attributes.fuseact#',
		<cfif isdefined("attributes.action_id") and len(attributes.action_id)>'#attributes.action_id#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.action_name") and len(attributes.action_name)>'#left(attributes.action_name,250)#'<cfelse>NULL</cfif>
		<cfif isdefined("session.ep.period_id")>
        ,#session.ep.period_id#
        </cfif>
	)
</cfquery>

<cftry>
	<cfif isDefined("session.ep.userid") and isdefined("attributes.action_id") and len(attributes.action_id) and isdefined("attributes.action_table") and len(attributes.action_table) and isdefined("attributes.action_column") and len(attributes.action_column) and attributes.log_type eq -1>

		<!--- 
			Author: Uğur Hamurpet
			Desc: Önceki süreç kayıtlarını pasife alır, süreç bildirimlerine 'kayıt silindi' kaydı atar.
			Date: 28/02/2021 
		--->
		<cfset get_workcube_process = createObject("component", "CustomTags.cfc.get_workcube_process") />
		<cfset get_workcube_process.Upd_Page_Warnings(
			process_db: "#dsn_alias#.",
			data_source: attributes.data_source,
			our_company_id: session.ep.company_id,
			period_id: session.ep.period_id,
			action_table: attributes.action_table,
			action_column: attributes.action_column,
			action_id: attributes.action_id
		) />
	
		<cfset get_workcube_process.add_Page_Warnings(
			process_db: "#dsn_alias#.",
			module_type: 'e',
			data_source: attributes.data_source,
			action_page: "#request.self#?fuseaction=#attributes.fuseact#",
			warning_head: "#caller.getLang('', 'Kayıt silindi', 62246)#",
			process_row_id: isDefined("attributes.process_stage") and Len(attributes.process_stage) ? attributes.process_stage : '',
			warning_description: "#caller.getLang('', 'Kayıt silindi', 62246)# Log ID: #result.identitycol#",
			warning_date: now(),
			record_date: now(),
			record_member: session.ep.userid,
			sender_position_code: session.ep.position_code,
			our_company_id: session.ep.company_id,
			period_id: session.ep.period_id,
			action_table: attributes.action_table,
			action_column: attributes.action_column,
			action_id: attributes.action_id,
			action_stage: isDefined("attributes.process_stage") and Len(attributes.process_stage) ? attributes.process_stage : '',
			paper_no: isDefined("attributes.paper_no") and Len(attributes.paper_no) ? attributes.paper_no : '',
			wrk_log_id: result.identitycol
		) />
	
	</cfif>
<cfcatch type="any"></cfcatch>
</cftry>

</cfprocessingdirective><cfsetting enablecfoutputonly="no">